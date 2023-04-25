// pipeline {
//     agent any
//     stages {
//         // stage('Flutter pub') {
//         //     steps {
//         //         sh 'pwd'
//         //         sh 'ls'
//         //         // sh 'flutter clean'
//         //         // sh 'flutter pub upgrade'
//         //         // sh 'flutter pub get'
//         //         sh 'flutter pub global activate rename'
//         //         sh 'flutter pub global run rename --appname "carparts.com"'
//         //         sh 'flutter pub run change_app_package_name:main com.carparts.app'
//         //     }
//         // }
//         stage('BuildNumber') {
//             steps {
//                 script{

//                 //Reading the current BUILD_NUMBER value

//                def  value = sh (
//                script: "grep 'build_number' /var/lib/jenkins/BUILD_NUMBER.properties | cut -d'=' -f2-",
//                returnStdout: true
//                )
//                echo "value: ${value}"
//                def num1 = 2
//                def num2 = 1
//                def newvalue = sh(returnStdout: true, script: "expr ${num1} + ${num2}").trim()
//                echo "The sum of ${num1} and ${num2} is ${newvalue}"
//                 sh 'echo "The newvalue is : $newvalue"'
//                 //Writing the current BUILD_NUMBER value
//                 sh 'sed -i "s/build_number=$value/build_number=$newvalue/g" /var/lib/jenkins/BUILD_NUMBER.properties'
                
//             }
//           }
//         }
//         stage('Flutter Build') {
//             steps {
//                 sh 'flutter clean'
//                 sh 'flutter build appbundle --build-number=$newvalue'
//             }
//         }
//         stage('Fastlane Deploy') {
//             steps {
//                 sh 'fastlane deploy_internal_testers_release package_name:com.carparts.app'
//             }
//         }
//     }
// }

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
                    def props = readFile(file: 'key.properties')
                    //def props = "storePassword=exathought321\nkeyPassword=exathought321\nkeyAlias=upload\nstoreFile=/var/lib/jenkins/upload-keystore.jks\n"
                    //writeFile(file: 'key.properties', text: props)
                    writeFile file: 'key.properties', text: 'storePassword=exathought321'
                    writeFile file: 'key.properties', text: 'keyPassword=exathought321'
                    writeFile file: 'key.properties', text: 'keyAlias=upload'
                    writeFile file: 'key.properties', text: 'storeFile=/var/lib/jenkins/upload-keystore.jks'
                    sh 'cat key.properties'
                }
                sh 'ls'
                sh 'pwd'
                // writeFile file: 'key.properties', text: 'storePassword=exathought321'
                // writeFile file: 'key.properties', text: 'keyPassword=exathought321'
                // writeFile file: 'key.properties', text: 'keyAlias=upload'
                // writeFile file: 'key.properties', text: 'storeFile=/var/lib/jenkins/upload-keystore.jks'
                // sh 'cat key.properties'
            }
        }
        stage('Build and Deploy') {
            steps {
                sh 'sh BuildAndDeployAndroidInternalTestersRelease.sh'
            }
        }
    }
}