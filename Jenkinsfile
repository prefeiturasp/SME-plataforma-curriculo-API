pipeline {
    agent {
      node { 
        label 'sme-ruby'
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
      
    stage('Analise Codigo') {
          when {
            branch 'develop'
          }
            steps {
                sh 'sonar-scanner \
                    -Dsonar.projectKey=SME-plataforma-curriculo-API \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://sonar.sme.prefeitura.sp.gov.br \
                    -Dsonar.login=871792927f842e93338784ee1eaa12c4914a4aa9'
                              }
       }
         
    stage('Docker build DEV') {
        when {
          branch 'develop'
        }
          steps {
          // Start JOB Rundeck para build das imagens Docker
      
          script {
           step([$class: "RundeckNotifier",
              includeRundeckLogs: true,
                               
              //JOB DE BUILD
              jobId: "d5491328-8b03-4f4e-bda1-5ee96c9d4b16",
              nodeFilters: "",
              //options: """
              //     PARAM_1=value1
               //    PARAM_2=value2
              //     PARAM_3=
              //     """,
              rundeckInstance: "Rundeck-SME",
              shouldFailTheBuild: true,
              shouldWaitForRundeckJob: true,
              tags: "",
              tailLog: true])
           }
        }
      }

    stage('Deploy DEV') {
        when {
          branch 'develop'
        }
          steps {
            //Start JOB Rundeck para update de deploy Kubernetes DEV
         
            script {
                step([$class: "RundeckNotifier",
                  includeRundeckLogs: true,
                  jobId: "4673e3fc-0dcd-445f-a6d5-e4dd4b31c0ae",
                  nodeFilters: "",
                  //options: """
                  //     PARAM_1=value1
                  //    PARAM_2=value2
                  //     PARAM_3=
                  //     """,
                  rundeckInstance: "Rundeck-SME",
                  shouldFailTheBuild: true,
                  shouldWaitForRundeckJob: true,
                  tags: "",
                  tailLog: true])
              }
          }
      }
		
	  stage('Docker build staging') {
            when {
                branch 'staging'
            }
            steps {
              // Start build das imagens Docker
      
          script {
            step([$class: "RundeckNotifier",
                includeRundeckLogs: true,
                    
                
                //JOB DE BUILD
                jobId: "50c05c49-94fb-4b56-a2ff-256b118b0d3a",
                nodeFilters: "",
                //options: """
                //     PARAM_1=value1
                //    PARAM_2=value2
                //     PARAM_3=
                //     """,
                rundeckInstance: "Rundeck-SME",
                shouldFailTheBuild: true,
                shouldWaitForRundeckJob: true,
                tags: "",
                tailLog: true])
           }
          }
        }    
       
    stage('Deploy staging') {
          when {
            branch 'staging'
          }
          steps {
            
            timeout(time: 24, unit: "HOURS") {
               telegramSend("${JOB_NAME}...O Build ${BUILD_DISPLAY_NAME} - Requer uma aprovação para deploy !!!\n Consulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)\n")
               input message: 'Deseja realizar o deploy?', ok: 'SIM', submitter: 'giuseppe_rosa'
            }
            //Start JOB Rundeck para update de imagens no host homologação 
         
            script {
                step([$class: "RundeckNotifier",
                includeRundeckLogs: true,
                jobId: "13413c00-6901-49dc-8ed4-8a8eb272a208",
                nodeFilters: "",
                //options: """
                //     PARAM_1=value1
                //    PARAM_2=value2
                //     PARAM_3=
                //     """,
                rundeckInstance: "Rundeck-SME",
                shouldFailTheBuild: true,
                shouldWaitForRundeckJob: true,
                tags: "",
                tailLog: true])
            }
         }
        }
	    
	  stage('Docker build PROD') {
        when {
          branch 'master'
        }
        steps {
            
            // Start JOB Rundeck para build das imagens Docker
      
            script {
              step([$class: "RundeckNotifier",
                includeRundeckLogs: true,
                
                
                //JOB DE BUILD
                jobId: "a5c86d4f-119d-4dce-ac32-a02cc38c7a6d",
                nodeFilters: "",
                //options: """
                //     PARAM_1=value1
                //    PARAM_2=value2
                //     PARAM_3=
                //     """,
                rundeckInstance: "Rundeck-SME",
                shouldFailTheBuild: true,
                shouldWaitForRundeckJob: true,
                tags: "",
                tailLog: true])
            }
         }
      }           
    
    stage('Deploy PROD') {
            when {
                branch 'master'
            }
            steps {
                timeout(time: 24, unit: "HOURS") {
                telegramSend("${JOB_NAME}...O Build ${BUILD_DISPLAY_NAME} - Requer uma aprovação para deploy !!!\n Consulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)\n")
                input message: 'Deseja realizar o deploy?', ok: 'SIM', submitter: 'giuseppe_rosa'
                }
                    
            
                script {
                    step([$class: "RundeckNotifier",
                    includeRundeckLogs: true,
                    jobId: "5d5042e1-b0ac-4a8f-ac61-97d94a0f4f8a",
                    nodeFilters: "",
                    //options: """
                    //     PARAM_1=value1
                    //    PARAM_2=value2
                    //     PARAM_3=
                    //     """,
                    rundeckInstance: "Rundeck-SME",
                    shouldFailTheBuild: true,
                    shouldWaitForRundeckJob: true,
                    tags: "",
                    tailLog: true])
                }
        
        
            }
        }
  }    


    
post {
        always {
          echo 'One way or another, I have finished'
        }
        success {
	  	    
          telegramSend("${JOB_NAME}...O Build ${BUILD_DISPLAY_NAME} - Esta ok !!!\n Consulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)\n\n Uma nova versão da aplicação esta disponivel!!!")
        }
        unstable {
          
          telegramSend("O Build ${BUILD_DISPLAY_NAME} <${env.BUILD_URL}> - Esta instavel ...\nConsulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)")
        }
        failure {
          
          telegramSend("${JOB_NAME}...O Build ${BUILD_DISPLAY_NAME}  - Quebrou. \nConsulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)")
        }
        changed {
          echo 'Things were different before...'
        }
        aborted {
          
          telegramSend("O Build ${BUILD_DISPLAY_NAME} - Foi abortado.\nConsulte o log para detalhes -> [Job logs](${env.BUILD_URL}console)")
        }
    }
}
