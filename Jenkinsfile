pipeline {
    agent any
    triggers {
        githubPush()
    }
    tools {
        dotnetsdk 'dotnet'
    }

    stages {
        stage('checkout scm'){
            steps {
                checkout scm
            }
        }
        stage('download .net sdk'){
            steps{
                sh 'dotnet --version '
            }
        }
    }
}