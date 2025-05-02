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
    }

    tools {
        dotnetsdk 'dotnet'
        dockerTool 'docker'
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
                sh "dotnet build   ${projectPath} --configuration ${buildConfiguration} --no-restore"
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
                    sh """
                        docker build -t ${dockerHubUsername}/${dockerImageName}:${BUILD_ID} \\
                                     -t ${dockerHubUsername}/${dockerImageName}:latest .
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${dockerHubUsername}/${dockerImageName}:${BUILD_ID}
                        docker push ${dockerHubUsername}/${dockerImageName}:latest
                    """
                }
            }
        }
    }
}
