#!groovy

properties(
    [
        [$class: 'BuildDiscarderProperty', strategy:
          [$class: 'LogRotator', artifactDaysToKeepStr: '14', artifactNumToKeepStr: '5', daysToKeepStr: '30', numToKeepStr: '60']],
        pipelineTriggers(
          [
              pollSCM('H/15 * * * *'),
              cron('@daily'),
          ]
        )
    ]
)
node {
 def app
 def image = 'registry.hub.docker.com/mastannpu87/angular-test'
    stage('Checkout') {
        //disable to recycle workspace data to save time/bandwidth
        //adding test1 comment
        deleteDir()
        checkout scm
    }

    docker.image('trion/ng-cli-karma:1.2.1').inside {
      stage('NPM Install') {
          withEnv(["NPM_CONFIG_LOGLEVEL=warn"]) {
              sh 'npm install'
          }
      }

      stage('Test') {
          withEnv(["CHROME_BIN=/usr/bin/chromium-browser"]) {
            sh 'ng test --progress=false --watch false'
          }
          junit '**/test-results.xml'
      }

      stage('Lint') {
          sh 'ng lint'
      }
        
      stage('Build') {
          milestone()
          sh 'ng build --prod --aot --sm --progress=false'
      }
    }
    //end docker

    stage('docker build') {
        //sh 'docker build -t angular-test .'
       app = docker.build image
    }
    stage('docker push') {
     docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {           
       app.push("${env.BUILD_NUMBER}") 
    }
    }
    stage('Deploy') {
        milestone()
        echo "Deploying..."
    }
}
