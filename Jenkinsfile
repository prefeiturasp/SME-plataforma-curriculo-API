pipeline {

    environment {
      branchname =  env.BRANCH_NAME.toLowerCase()
      kubeconfig = getKubeconf(env.branchname)
      registryCredential = 'jenkins_registry'
      namespace = "${env.branchname == 'develop' ? 'curriculo-dev' : env.branchname == 'staging' ? 'curriculo-hom' : env.branchname == 'staging-r2' ? 'curriculo-hom2' : 'sme-curriculo' }"	    
    }

    agent { kubernetes { 
              label 'ruby-rc'
              defaultContainer 'ruby-rc'
            }
          }

    options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
      disableConcurrentBuilds()
      skipDefaultCheckout()
    }

      stages {

        stage('CheckOut') {
            steps {
              checkout scm
            }
        }

        stage('AnaliseCodigo') {
	        when { branch 'testecurriculo' }
          agent { kubernetes { 
              label 'ruby-rc'
              defaultContainer 'builder'
            }
          }
          steps {
              withSonarQubeEnv('sonarqube-local'){
                sh 'sonar-scanner \
                -Dsonar.projectKey=SME-plataforma-curriculo-API \
                -Dsonar.sources=.'
            }
          }
        }

     stage('Testes') {
	when { anyOf { branch 'testecurriculo'; } } 
        agent { kubernetes { 
              label 'ruby-rc'
              defaultContainer 'ruby-rc'
            }
          }
        steps {
	      checkout scm
              	
	      sh 'bundle install'
              sh 'bundle exec rake db:drop RAILS_ENV=test RAILS_EXECJS_RUNTIME=therubyracer'
              sh 'bundle exec rake db:create RAILS_ENV=test RAILS_EXECJS_RUNTIME=therubyracer'
              sh 'bundle exec rake db:migrate RAILS_ENV=test RAILS_EXECJS_RUNTIME=therubyracer'
              sh 'bundle exec rspec spec RAILS_EXECJS_RUNTIME=therubyracer'
        }
    }

        stage('Build') {
          agent { kubernetes { 
              label 'builder'
              defaultContainer 'builder'
            }
          }
          when { anyOf { branch 'master'; branch 'main'; branch "story/*"; branch 'develop'; branch 'testecurriculo'; } } 
          steps {
            script {
	      checkout scm
              imagename = "registry.sme.prefeitura.sp.gov.br/${env.branchname}/curriculo-api"        
              dockerImage = docker.build(imagename, "-f Dockerfile .")
              docker.withRegistry( 'https://registry.sme.prefeitura.sp.gov.br', registryCredential ) {
              dockerImage.push()
              }
              sh "docker rmi $imagename"
            }
          }
        }
	    
        stage('Deploy'){
            when { anyOf {  branch 'master'; branch 'main'; branch 'develop'; branch 'testecurriculo'; } }        
            steps {
                script{
                    if ( env.branchname == 'main' ||  env.branchname == 'master' ) {
                        sendTelegram("🤩 [Deploy ${env.branchname}] Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nMe aprove! \nLog: \n${env.BUILD_URL}")
                        withCredentials([string(credentialsId: 'aprovadores_curriculo', variable: 'aprovadores')]) {
                            timeout(time: 24, unit: "HOURS") {
                                input message: 'Deseja realizar o deploy?', ok: 'SIM', submitter: "${aprovadores}"
                            }
                        }
                    }
                    withCredentials([file(credentialsId: "${kubeconfig}", variable: 'config')]){
                      sh('cp $config '+"$home"+'/.kube/config')
                      sh "kubectl rollout restart deployment/curriculo-api -n ${namespace}"
                      sh('rm -f '+"$home"+'/.kube/config')
                    }
                }
            }           
        }
  }

post {
    always{ node('setup'){ sh 'docker rm -f elasticsearch && docker rm -f sme-curriculodb' } }
    success { sendTelegram("🚀 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Success \nLog: \n${env.BUILD_URL}console") }
    unstable { sendTelegram("💣 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Unstable \nLog: \n${env.BUILD_URL}console") }
    failure { sendTelegram("💥 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Failure \nLog: \n${env.BUILD_URL}console") }
    aborted { sendTelegram ("😥 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Aborted \nLog: \n${env.BUILD_URL}console") }
  }
}
def sendTelegram(message) {
    def encodedMessage = URLEncoder.encode(message, "UTF-8")
    withCredentials([string(credentialsId: 'telegramToken', variable: 'TOKEN'),
    string(credentialsId: 'telegramChatId', variable: 'CHAT_ID')]) {
        response = httpRequest (consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON',
                httpMode: 'GET',
                url: 'https://api.telegram.org/bot'+"$TOKEN"+'/sendMessage?text='+encodedMessage+'&chat_id='+"$CHAT_ID"+'&disable_web_page_preview=true',
                validResponseCodes: '200')
        return response
    }
}
def getKubeconf(branchName) {
    if("master".equals(branchName)) { return "config_prd"; }
    else if ("staging".equals(branchName)) { return "config_release"; }
    else if ("develop".equals(branchName)) { return "config_release"; }
}
