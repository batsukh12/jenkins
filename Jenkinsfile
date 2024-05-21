pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'batsukh/jenkins'
        DOCKER_REGISTRY_CREDENTIALS_ID = '123'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository
                git branch: 'main', url: 'https://github.com/batsukh12/jenkins.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS_ID) {
                        // Push the Docker image
                        docker.image("${env.DOCKER_IMAGE}:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        
        stage('Deploy Docker Container') {
            steps {
                script {
                    // Deploy the Docker container
                    sh """
                    docker stop your_container_name || true
                    docker rm your_container_name || true
                    docker run -d --name your_container_name -p 80:80 ${env.DOCKER_IMAGE}:${env.BUILD_ID}
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up old Docker images and containers
            sh 'docker system prune -af'
        }
    }
}

