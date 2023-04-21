pipeline {
    agent any
    stages {
        // stage('Flutter pub') {
        //     steps {
        //         sh 'pwd'
        //         sh 'ls'
        //         // sh 'flutter clean'
        //         // sh 'flutter pub upgrade'
        //         // sh 'flutter pub get'
        //         sh 'flutter pub global activate rename'
        //         sh 'flutter pub global run rename --appname "carparts.com"'
        //         sh 'flutter pub run change_app_package_name:main com.carparts.app'
        //     }
        // }
        stage('BuildNumber') {
            steps {
                script{
//                     GIT_COMMIT_EMAIL = sh (
//     script: 'git --no-pager show -s --format=\'%ae\'',
//     returnStdout: true
// ).trim()
// echo "Git committer email: ${GIT_COMMIT_EMAIL}"
def testvalue = sh (
    script: "grep 'build_number' /var/lib/jenkins/BUILD_NUMBER.properties | cut -d'=' -f2-",
    returnStdout: true
).trim()
echo "testvalue: ${testvalue}"
                //Reading the current BUILD_NUMBER value
                def value=sh "grep 'build_number' /var/lib/jenkins/BUILD_NUMBER.properties | cut -d'=' -f2-"
                //sh'echo "$value"'
                print "The number is : ${value}"
                //sh 'echo "The number is : ${value}"'
                //Incrementing the BUILD_NUMBER by 1
                //sh '((value++))'
                //def newvalue= value+1
                sh 'newvalue=$((value+1))'
                //def newvalue=sh "((value+1))"
                sh 'echo "The newvalue is : $newvalue"'
                //Writing the current BUILD_NUMBER value
                sh 'sed -i "s/build_number=$value/build_number=$newvalue/g" /var/lib/jenkins/BUILD_NUMBER.properties'
            }
          }
        }
        stage('Flutter Build') {
            steps {
                sh 'flutter clean'
                sh 'flutter build appbundle --build-number=$newvalue'
            }
        }
        stage('Fastlane Deploy') {
            steps {
                sh 'fastlane deploy_internal_testers_release package_name:com.carparts.app'
            }
        }
    }
}