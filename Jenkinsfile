pipeline {

    agent any

    environment {
      username = "tanbs"
      CUR_WORKSPACE = "${WORKSPACE}"
      IMAGE_VERSION = "v1.0"
    }

    stages {

        stage('pre-check') {
            steps {
               sh 'printenv'
               sh 'java -version'
               sh 'git --version'
               sh 'docker version'
               sh 'pwd && ls -alh'
               sh "echo ${username}"
            }
        }

        stage('compile') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /var/jenkins_home/maven/.m2:/root/.m2'
                 }
            }
            steps {
               sh 'pwd && ls -alh'
               sh 'mvn -v'
               sh "echo 默认的工作目录: ${CUR_WORKSPACE}"
               sh 'cd ${CUR_WORKSPACE} && mvn clean package -s "/var/jenkins_home/maven/conf/settings.xml" -Dmaven.test.skip=true '
            }
        }

        stage('test'){
            steps {
                echo "test..."
                sh 'pwd && ls -alh'
            }
        }

        stage('build-image'){
            steps {
                echo "build image..."
                sh 'docker version'
                sh 'pwd && ls -alh'
                sh 'docker build -t devops-demo:${IMAGE_VERSION} .'
            }
        }

        stage('pull-image'){
            steps {
                echo "pull image..."
                sh 'docker version'
                sh 'pwd && ls -alh'
                withCredentials(
                    [usernamePassword(
                        credentialsId: 'aliyun-image-repo',
                        usernameVariable: 'ali_user',
                        passwordVariable: 'ali_pwd')]
                         ) {
                     sh "docker login --username=${ali_user} --password=${ali_pwd} registry.cn-hangzhou.aliyuncs.com"
                     sh "docker tag devops-demo:${IMAGE_VERSION} registry.cn-hangzhou.aliyuncs.com/tanbingshi/jenkins-demo:${IMAGE_VERSION}"
                     sh "docker push registry.cn-hangzhou.aliyuncs.com/tanbingshi/jenkins-demo:${IMAGE_VERSION}"
                }
            }
        }

        stage('deploy'){
            steps {
                echo "deploy..."
                sh 'pwd && ls -alh'
                sh 'docker rm -f devops-demo'
                sh 'docker run -d -p 8888:8080 --name devops-demo devops-demo:${IMAGE_VERSION}'
            }
            post {
                failure {
                    echo "deploy failure..."
                }
                success {
                    echo "deploy success..."
                }
            }
        }

    }

    post {
         failure {
            echo "this stages failure... $currentBuild.result"
         }
         success {
             echo "this stages success... $currentBuild.result"
         }
    }

}