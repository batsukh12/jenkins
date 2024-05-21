pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'batsukh/jenkins-app'
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
                    def customImage = docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS_ID) {
                        docker.image("${env.DOCKER_IMAGE}:${env.BUILD_ID}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh """
                    docker stop jenkins-app-container || true
                    docker rm jenkins-app-container || true
                    docker run -d --name jenkins-app-container -p 80:80 ${env.DOCKER_IMAGE}:${env.BUILD_ID}
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -af'
        }
    }
}

