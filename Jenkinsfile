pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat './gradlew clean build'
            }
        }
        stage('Test') {
            steps {
                bat './gradlew check'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
            junit 'build/test-results/**/*.xml'
        }
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