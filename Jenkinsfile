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
            sh'echo "login and copy into admin and deploy"'
            sh 'scp -o StrictHostKeyChecking=no services.yml nginx-app-pod.yml admin@api.hantzy.com:/home/admin/'

          script{
            try{
              sh'ssh admin@api.hantzy.com kubectl apply -f nginx-app-pod.yml -v=8'
              
            }catch(error){
              sh'admin@api.hantzy.com kubectl create -f nginx-app-pod.yml -v=8'
            }
          }
        }
    }

  }
}
