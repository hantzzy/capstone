pipeline {
  environment {
    registry = "hantzy/capstone"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {

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
            sh'kubectl create deployment nginx --image=hantzy/capstone:35'
            
        }
    }
    stage('NGINX container available to the network'){
        steps{
            sh'kubectl create service nodeport nginx --tcp=80:80'
            
        }
    }
  }
}
