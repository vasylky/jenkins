pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('checkout scm'){
            steps {
                checkout scm
            }
        }
        stage('download .net sdk'){
            steps{
                sh 'dotnet --list-sdks || true'
                sh 'wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh'
                sh 'chmod +x dotnet-install.sh'
                sh './dotnet-install.sh --version 7.0.100'
            }
        }
    }
}