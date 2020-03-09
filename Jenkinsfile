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
            sh'cat nginx-app-pod.yml'

          script{
            try{
              sh'sudo kubectl apply -f nginx-app-pod.yml -v=8'
              
            }catch(error){
              sh'sudo kubectl create -f nginx-app-pod.yml -v=8'
            }
          }
        }
    }

  }
}
