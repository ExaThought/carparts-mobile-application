flutter pub global activate rename
flutter pub global run rename --appname "carparts.com"
cd android
value=$(grep "build_number" /var/lib/jenkins/BUILD_NUMBER.properties | cut -d'=' -f2)
echo $value
# Increment the value
newvalue=$((value+1))
echo $newvalue
# Write the updated value back to the properties file
sed -i "s/build_number=$value/build_number=$newvalue/g" /var/lib/jenkins/BUILD_NUMBER.properties
# fastlane bump_version_code
flutter clean
flutter build appbundle --build-number=$newvalue
fastlane deploy_internal_testers_release package_name:com.carparts.app