pipeline {
    agent any

    environment {
        IMAGE_NAME = "ghcr.io/sure-b/nginx-custom"  // Replace with your image name
        GITHUB_CREDENTIALS_ID = "github-Cred"  // This is the ID of the GitHub credentials in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Nginx Docker image
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Login to GitHub Container Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${GITHUB_CREDENTIALS_ID}", usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_PAT')]) {
                    sh """
                    echo "${GITHUB_PAT}" | docker login ghcr.io -u "${GITHUB_USER}" --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image to GHCR') {
            steps {
                script {
                    // Push the image to GHCR
                    docker.image("${IMAGE_NAME}:latest").push()
                }
            }
        }
    }

    post {
        success {
            echo "Docker image pushed to GitHub Container Registry successfully."
        }
        failure {
            echo "Pipeline failed. Check the logs for errors."
        }
    }
}
