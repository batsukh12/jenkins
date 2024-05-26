pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'batsukh/nodejs-app'
        DOCKER_REGISTRY_CREDENTIALS_ID = '123'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/batsukh12/jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        def customImage = docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
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
                        docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS_ID) {
                            docker.image("${env.DOCKER_IMAGE}:${env.BUILD_ID}").push()
                        }
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
                        sh """
                        docker stop nodejs-app-container || true
                        docker rm nodejs-app-container || true
                        docker run -d --name nodejs-app-container -p 3000:3000 ${env.DOCKER_IMAGE}:${env.BUILD_ID}
                        """
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
                    sh 'docker system prune -af'
                } catch (Exception e) {
                    echo "Error during Docker system prune: ${e.getMessage()}"
                }
            }
        }
    }
}

