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
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
        sh 'who'
      }
    }

    stage('Deploy to kubernetes cluster'){
        steps{
            sh '''
            docker pull $registry:$BUILD_NUMBER
            kubectl create deployment nginx --image=$registry:$BUILD_NUMBER 
            
            '''
            
        }
    }

  }
}
