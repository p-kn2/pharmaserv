pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-1'
        EKS_CLUSTER    = 'pharmaserv-eks-cluster'
        IMAGE_NAME     = 'pharmaserv-api'
        IMAGE_TAG      = "${BUILD_NUMBER}"
        SONAR_HOST     = 'https://sonarqube.company.com'
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                // Checkout latest source code from GitHub
                git branch: 'main', credentialsId: 'github-cred-id', url: 'https://github.com/your-org/pharmaserv.git'
            }
        }

        stage('2. SonarQube SAST Scan') {
            steps {
                script {
                    // Execute SonarScanner for C# code static analysis
                    withSonarQubeEnv('SonarQubeServer') {
                        sh 'dotnet sonarscanner begin /k:"pharmaserv-api" /d:sonar.host.url="${SONAR_HOST}"'
                        sh 'dotnet build app/PharmaServApi/PharmaServApi.csproj'
                        sh 'dotnet sonarscanner end'
                    }
                }
            }
        }

        stage('3. SonarQube Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    // Abort pipeline if SonarQube Quality Gate fails (e.g., security hotspots, coverage drops)
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('4. Docker Multi-Stage Build') {
            steps {
                script {
                    // Build container image using the multi-stage Dockerfile
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./app/PharmaServApi"
                }
            }
        }

        stage('5. Trivy Container Vulnerability Scan') {
            steps {
                script {
                    // Scan container image for OS & package vulnerabilities
                    // --exit-code 1 fails the pipeline if CRITICAL CVEs are detected
                    sh "trivy image --severity HIGH,CRITICAL --exit-code 1 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('6. Deploy to AWS EKS') {
            steps {
                script {
                    // Authenticate to AWS EKS Cluster using AWS CLI
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER}"
                    
                    // Apply Kubernetes manifests and update image tag
                    sh "kubectl apply -f k8s/"
                    sh "kubectl set image deployment/pharmaserv-deployment pharmaserv-api=${IMAGE_NAME}:${IMAGE_TAG} -n production"
                    
                    // Verify zero-downtime deployment rollout
                    sh "kubectl rollout status deployment/pharmaserv-deployment -n production"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully! Application deployed to AWS EKS."
        }
        failure {
            echo "Pipeline failed security or deployment checks. Check Jenkins logs."
        }
    }
}