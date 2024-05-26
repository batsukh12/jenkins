pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'batsukh12/archilgaa'
        DOCKER_TAG = '1.0'
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        DOCKER_REGISTRY_CREDENTIALS_ID = 'dockerHub'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Checking out the repository..."
                    git branch: 'main', url: 'https://github.com/batsukh12/jenkins.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        def customImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        echo "Docker image ${DOCKER_IMAGE}:${DOCKER_TAG} built successfully."
                    } catch (Exception e) {
                        echo "Error during Docker build: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        error("Build failed")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        echo "Pushing Docker image to registry..."
                        withCredentials([usernamePassword(credentialsId: env.DOCKER_REGISTRY_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                            sh "docker logout ${DOCKER_REGISTRY}"
                        }
                        echo "Docker image pushed successfully."
                    } catch (Exception e) {
                        echo "Error during Docker push: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        error("Push failed")
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    try {
                        echo "Deploying Docker container..."
                        sh """
                        docker stop nodejs-app-container || true
                        docker rm nodejs-app-container || true
                        docker run -d --name nodejs-app-container -p 3000:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                        echo "Docker container deployed successfully."
                    } catch (Exception e) {
                        echo "Error during Docker deploy: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        error("Deploy failed")
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                try {
                    echo "Cleaning up Docker system..."
                    sh 'docker system prune -af'
                    echo "Docker system cleanup completed."
                } catch (Exception e) {
                    echo "Error during Docker system prune: ${e.getMessage()}"
                }
            }
        }
    }
}

