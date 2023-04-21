flutter pub global activate rename
flutter pub global run rename --appname "carparts.com"
cd android
# fastlane bump_version_code
flutter clean
flutter build appbundle --build-number=2
fastlane deploy_internal_testers_release package_name:com.carparts.app
