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
      }
    }

    stage('Deploy to kubernetes cluster'){
        steps{
            sh '''
            docker pull $registry:$BUILD_NUMBER
            kubectl run --generator=run-pod/v1 app  --image=$registry:$BUILD_NUMBER  --port=80
            kubectl port-forward  app 8000:80
            '''
        }
    }

  }
}
