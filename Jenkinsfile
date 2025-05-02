pipeline {
    agent any
    triggers {
        githubPush()
    }
    environmet{
        buildConfiguration = 'Release'
        projectPath = 'SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj'
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
    }
}