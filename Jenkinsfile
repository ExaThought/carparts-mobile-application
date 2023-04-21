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

                //Reading the current BUILD_NUMBER value

               def  value = sh (
               script: "grep 'build_number' /var/lib/jenkins/BUILD_NUMBER.properties | cut -d'=' -f2-",
               returnStdout: true
               )
               echo "value: ${value}"
               def sum = value.toInt() + 1
               def  newvalue = value.toInt() + 1
               def  newvalue2 = "${value.toInt()} + 1"
               def  newvalue3 = "${value.toInt() + 1}"
               def  newvalue4= "${value.toInt()}" + 1
            //    def newvalue= sh (
            //    script: "${value}+1");
                // sh 'newvalue=$((value+1))'
            //     def str1 =sh (
            //    script: "${value}")
            //     def int1 =sh (
            //    script: "${str1}.toInteger()")
                echo "newvalue 0: ${sum}"
                echo "newvalue 1:${newvalue}"
                echo "newvalue 2: ${newvalue2}"
                echo "newvalue 3: ${newvalue3}"
                // sh 'echo "The newvalue is : $newvalue"'
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