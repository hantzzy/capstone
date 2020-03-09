pipeline {
  environment {
    registry = "hantzy/capstone"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {

  stage('Cloning Git') {
   steps {
      git 'https://github.com/hantzzy/capstone.git'
     }
   }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {

            dockerImage.push()
          }
        }
      }
    }

    stage('Deploy to kubernetes cluster'){
        steps{
            sh'chmod +x edittag.sh'
            sh'./edittag.sh $BUILD_NUMBER'
            sh'ls'
            sh'pwd'
            sh'whoami'
            sh ''
            sshagent(['kops-server']) {
                sh"scp -o StrictHostKeyChecking=no services.yml nginx-app-pod.yml ubuntu@ec2-54-173-94-217.compute-1.amazonaws.com:/home/ubuntu"

          script{
            try{
              sh"ssh ubuntu@ec2-54-173-94-217.compute-1.amazonaws.com kubectl apply -f ."
              
            }catch(error){
              sh"ssh ubuntu@ec2-54-173-94-217.compute-1.amazonaws.com kubectl create -f ."
            }
          }
          }
        }
    }

  }
}
