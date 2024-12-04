pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nginx-t16'    
        DOCKER_TAG = 'latest'          
        REGISTRY = 'cr.yandex/crpvem9c0799ctn25n8t' 

        CONTAINER_NAME = 'nginx'

        APACHE_IP = '158.160.73.86'
        APACHE_PORT = '8085'

        NGINX_IP = '89.169.165.207'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: '5993ba5d-138a-4314-a8ca-507961cd0286', url: 'git@github.com:SaiTeR/nginx-image-task16.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    sh 'docker tag nginx-t16 cr.yandex/crpvem9c0799ctn25n8t/nginx:latest'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push cr.yandex/crpvem9c0799ctn25n8t/nginx:latest'
                }
            }
        }


        stage('Deploy to VM') {
            steps {
                script {
                    sshagent(['5993ba5d-138a-4314-a8ca-507961cd0286']) {
                        sh """
                        ssh ubuntu@${env.NGINX_IP} << EOF

                        echo "Stopping and removing old container..."
                        docker stop ${env.NGINX} || true
                        docker rm ${env.CONTAINER_NAME} || true

                        echo "Removing old image..."
                        docker rmi ${env.REGISTRY}/nginx:latest || true

                        echo "Pulling new image..."
                        docker pull ${env.REGISTRY}/nginx:latest

                        echo "Running new container..."
                        docker run -d --name ${env.CONTAINER_NAME} -p 80:80 -p 443:443 -e APACHE_IP=${env.APACHE_IP} -e APACHE_PORT=${env.APACHE_PORT} ${env.REGISTRY}/apache:latest
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Очистка рабочей директории после сборки
        }
    }
}
