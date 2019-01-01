pipeline {
    agent any
    options {
        skipDefaultCheckout()
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                bat './gradlew clean build -x test'
            }
        }
        stage('Test') {
            steps {
                bat './gradlew check'
            }
            post {
                always {
                    junit 'build/test-results/**/*.xml'
                }
            }
        }
        stage('Additional tests') {
            parallel {
                stage('Frontend') {
                    when {
                        changeset "src/main/webapp/**/*"
                    }
                    steps {
                        bat './scripts/frontEndTests.bat'
                    }
                }
                stage('Performance') {
                    when {
                        branch 'master'
                    }
                    steps {
                        bat './scripts/performanceTests.bat'
                    }
                }
            }
        }
        //create docker image
        stage('Archive artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
            }
            //push to docker registry as well
        }
        stage('Deploy - Staging') {
            steps {
                bat './scripts/deployStaging.bat'
                bat './scripts/smokeTests.bat'
            }
        }
        stage('Sanity check') {
            steps {
                timeout(1) {
                    input "Does the staging environment look ok?"
                }
            }
        }
        stage('Deploy - Production') {
            steps {
                bat './scripts/deployProduction.bat'
            }
        }
    }

    post {
        success {
            slackSend channel: '#jenkins-integration',
                      color: 'good',
                      message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
        }
        failure {
            slackSend channel: '#jenkins-integration',
                      color: 'danger',
                      message: "The pipeline ${currentBuild.fullDisplayName} completed with error."
        }
    }
}