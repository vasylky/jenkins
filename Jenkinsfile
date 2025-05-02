pipeline {
    agent any
    triggers {
        githubPush()
    }
    environment{
        buildConfiguration = 'Release'
        projectPath = 'SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj'
        dockerHubUsername = 'qqvky'
        dockerImageName = 'aspnetapp'
    }
    tools {
        dotnetsdk 'dotnet'
        dockerTool 'docker'
    }

    stages {
        stage('checkout scm'){
            steps {
                checkout scm
            }
        }
        stage('сheck version of sdk'){
            steps{
                sh 'dotnet --version'
            }
        }
        stage('build and test'){
            steps{
                sh "dotnet restore ${projectPath}"
                sh "dotnet publish --configuration ${buildConfiguration} --no-restore"
                sh "dotnet test **/*Tests.csproj --configuration ${buildConfiguration} --no-build || true"

            }
        }

        stage('build and push docker'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub-conn', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker build -t ${dockerHubUsername}/${dockerImageName}:${BUILD_ID} -t ${dockerHubUsername}/${dockerImageName}:latest .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${dockerHubUsername}/${dockerImageName}:${BUILD_ID}
                        docker push ${dockerHubUsername}/${dockerImageName}:latest
                    """
            }
        }

    }
}
}