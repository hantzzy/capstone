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

  }
}