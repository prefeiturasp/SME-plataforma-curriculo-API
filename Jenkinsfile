pipeline {

    environment {
      branchname =  env.BRANCH_NAME.toLowerCase()
      kubeconfig = getKubeconf(env.branchname)
      registryCredential = 'jenkins_registry'
    }

    agent {
      node {
        label 'ruby-rc'
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
	        when { branch 'staging' }
          steps {
              withSonarQubeEnv('sonarqube-local'){
                sh 'sonar-scanner \
                -Dsonar.projectKey=SME-plataforma-curriculo-API \
                -Dsonar.sources=.'
            }
          }
        }

      stage('Setup Testes') {
          agent {
          label 'setup'
          }
	  when { anyOf { branch 'develop'; } } 
          steps {
            script {
              CONTAINER_ID = sh (
              script: 'docker ps -q --filter "name=sme-curriculodb"',
              returnStdout: true
              ).trim()
              if (CONTAINER_ID) {
                sh "echo nome é: ${CONTAINER_ID}"
                sh "docker rm -f ${CONTAINER_ID}"
                sh 'docker run -d --rm --cap-add SYS_TIME --name sme-curriculodb --network curriculo-network -p 5432 -e TZ="America/Sao_Paulo" -e POSTGRES_DB=curriculo -e POSTGRES_PASSWORD=curriculo -e POSTGRES_USER=postgres postgres:9-alpine'
              } else {

                  sh 'docker run -d --rm --cap-add SYS_TIME --name sme-curriculodb --network curriculo-network -p 5432 -e TZ="America/Sao_Paulo" -e POSTGRES_DB=curriculo -e POSTGRES_PASSWORD=curriculo -e POSTGRES_USER=postgres postgres:9-alpine'
              }
            }
            script {
              CONTAINER_ID2 = sh (
              script: 'docker ps -q --filter "name=elasticsearch"',
              returnStdout: true
              ).trim()
              if (CONTAINER_ID2) {
                sh "echo nome é: ${CONTAINER_ID2}"
                sh "docker rm -f ${CONTAINER_ID2}"
                sh 'docker run -d --rm --cap-add SYS_TIME --name elasticsearch --net curriculo-network -p 9200:9200 -p 9300 -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" -e "discovery.type=single-node" -e "xpack.security.enabled=false" -e "http.cors.enabled=true" -e "http.cors.allow-origin=*" -e "http.cors.allow-credentials=true" -e "http.cors.allow-headers=X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization" docker.elastic.co/elasticsearch/elasticsearch:6.5.4'

              } else {
                  sh 'docker run -d --rm --cap-add SYS_TIME --name elasticsearch --net curriculo-network -p 9200:9200 -p 9300 -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" -e "discovery.type=single-node" -e "xpack.security.enabled=false" -e "http.cors.enabled=true" -e "http.cors.allow-origin=*" -e "http.cors.allow-credentials=true" -e "http.cors.allow-headers=X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization" docker.elastic.co/elasticsearch/elasticsearch:6.5.4'
                }
            }

          }
        }

    stage('Testes') {
	when { anyOf { branch 'develop'; } } 
        steps {
              sh 'bundle install'
              sh 'bundle exec rake db:drop RAILS_ENV=test'
              sh 'bundle exec rake db:create RAILS_ENV=test'
              sh 'bundle exec rake db:migrate RAILS_ENV=test'
              sh 'bundle exec rspec spec'
        }
    }

        stage('Build') {
          agent { label 'setup' }
          when { anyOf { branch 'master'; branch 'main'; branch "story/*"; branch 'develop'; branch 'staging'; } } 
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
            when { anyOf {  branch 'master'; branch 'main'; branch 'develop'; branch 'staging'; } }        
            steps {
                script{
                    if ( env.branchname == 'main' ||  env.branchname == 'master' || env.branchname == 'staging' ) {
                        sendTelegram("🤩 [Deploy ${env.branchname}] Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nMe aprove! \nLog: \n${env.BUILD_URL}")
                        timeout(time: 24, unit: "HOURS") {
                            input message: 'Deseja realizar o deploy?', ok: 'SIM', submitter: 'rodolpho_azeredo'
                        }
                    }
                    withCredentials([file(credentialsId: "${kubeconfig}", variable: 'config')]){
                      sh('cp $config '+"$home"+'/.kube/config')
                      sh "kubectl rollout restart deployment/curriculo-api -n sme-curriculo"
                      sh('rm -f '+"$home"+'/.kube/config')
                    }
                }
            }           
        }
  }

post {
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
    else if ("staging".equals(branchName)) { return "config_hom"; }
    else if ("develop".equals(branchName)) { return "config_dev"; }
}
