pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        buildConfiguration = 'Release'
        projectPath         = 'SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj'
        dockerHubUsername   = 'qqvky'
        dockerImageName     = 'aspnetapp'
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    tools {
        dotnetsdk 'dotnet'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Check .NET SDK Version') {
            steps {
                sh 'dotnet --version'
            }
        }

        stage('Build and Test') {
            steps {
                sh "dotnet restore ${projectPath}"
                sh "dotnet build ${projectPath} --configuration ${buildConfiguration} --no-restore"
                sh "dotnet test **/*Tests.csproj --configuration ${buildConfiguration} --no-build || true"
            }
        }

        stage('Build and Push Docker') {
            steps {
                withCredentials([usernamePassword(
                credentialsId: 'dockerhub-conn',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    /usr/local/bin/docker build \
                    -t ${dockerHubUsername}/${dockerImageName}:${BUILD_ID} \
                    -t ${dockerHubUsername}/${dockerImageName}:latest .
                    
                    export DOCKER_CONFIG=$(mktemp -d)
                    echo "$DOCKER_PASS" | /usr/local/bin/docker login \
                    -u "$DOCKER_USER" --password-stdin

                    /usr/local/bin/docker push \
                    ${dockerHubUsername}/${dockerImageName}:${BUILD_ID}

                    /usr/local/bin/docker push \
                    ${dockerHubUsername}/${dockerImageName}:latest
                    '''
                }
            }
        }

        stage('Login to Azure') {
            steps {
                sh '''
                echo $ARM_CLIENT_SECRET | /opt/homebrew/bin/az login --service-principal \
                --username $ARM_CLIENT_ID \
                --password $(< /dev/stdin) \
                --tenant $ARM_TENANT_ID
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '/opt/homebrew/bin/terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh '/opt/homebrew/bin/terraform validate'
                }
            }
        }

        stage('Terraform Plan (for PR)') {
            when {
                branch 'PR-*'  
            }
            steps {
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    dir('terraform') {
                        sh "/opt/homebrew/bin/terraform plan -var-file=$TFVARS_FILE"
                    }
                }
            }
        }

        stage('Terraform Apply (for main)') {
            when {
                branch 'main'  
            }
            steps {
                input message: "Do you want to apply Terraform changes?"
                withCredentials([file(credentialsId: 'tfvars-file', variable: 'TFVARS_FILE')]) {
                    dir('terraform') {
                        sh "/opt/homebrew/bin/terraform apply -var-file=$TFVARS_FILE -auto-approve"
                    }
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
