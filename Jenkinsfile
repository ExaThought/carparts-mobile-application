pipeline {
    agent any
    stages {
        stage('Overwrite Properties File') {
            steps {
                sh 'pwd'
                sh 'ls'
                dir('android') {
                    sh 'ls' 
                    sh 'pwd'
                    writeFile file: 'key.properties', text: '''
                    storePassword=jeevitha321
                    keyPassword=jeevitha321
                    keyAlias=upload
                    storeFile=/var/lib/jenkins/Car-prts/upload-keystore.jks
                    '''
                    sh 'cat key.properties'
                }
                sh 'ls'
                sh 'pwd'
            }
        }
        stage('Build and Deploy') {
            steps {
                sh 'sh BuildAndDeployAndroidInternalTestersRelease.sh'
            }
        }
    }
}