pipeline {
    agent { label 'ansible-controller' }

    environment {
        IMAGE = "myapp${BUILD_NUMBER}"
        DOCKER_IMAGE = 'devopsbah/myrepo1'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t "$IMAGE" .'
                sh 'docker tag "$IMAGE" "${DOCKER_IMAGE}:${DOCKER_TAG}"'
            }
        }

        // Reconstructed: this section was not visible in the screenshots.
        stage('Login to Docker Hub') {
            steps {
                sh '''
                    set +x
                    printf '%s' "$DOCKER_CREDS_PSW" | docker login \
                        --username "$DOCKER_CREDS_USR" --password-stdin
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push "${DOCKER_IMAGE}:${DOCKER_TAG}"'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f myapp || true
                    docker run -d \
                        --name myapp \
                        -p 8080:80 \
                        "${DOCKER_IMAGE}:${DOCKER_TAG}"
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment successful and Docker image pushed!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            sh 'docker logout || true'
            // Prunes unused Docker data on the Jenkins agent, as in the screenshots.
            sh 'docker system prune -f'
        }
    }
}
