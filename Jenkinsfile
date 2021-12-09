pipeline {
    environment{
        registryCredential = 'dockercred'
        greenDockerImage = '' 
        blueDockerImage = ''
    }
    agent any 
    stages {

        stage('Install Requirements'){
            steps{
				sh "pip install -r requirements.txt"
            }
        }

        stage('Lint Code'){
            steps {
                sh "bash ./run_pylint.sh"
            }
        }



        stage('Build Docker Image') {
            steps {
                sh 'sudo docker build -t omarmaher2909/flask-app .'
            }
        }

        stage('Upload Image to Docker-Hub'){
            steps {
                  withDockerRegistry([url: "", credentialsId: "dockercred"]) {
                      sh 'docker push omarmaher2909/flask-app'
                  }
              }
        }


        stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'awscred', region: 'us-west-2') {
                      sh "aws eks --region us-west-2 update-kubeconfig --name udacity-capstone"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:260190463902:cluster/udacity-capstone"
                      sh "kubectl apply -f capstone-deploy.yaml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/capstone-flask-app-service"
                  }
              }
        }

        stage('Checking rollout') {
              steps{
                  echo 'Checking rollout...'
                  withAWS(credentials: 'awscred', region: 'us-west-2') {
                     sh "kubectl rollout status deployments/flask-app"
                  }
              }
        }
        stage("Cleaning up") {
              steps{
                    echo 'Cleaning up...'
                    sh "docker system prune"
              }
        }
    }
}