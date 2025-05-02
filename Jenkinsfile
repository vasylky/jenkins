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

    }
}
