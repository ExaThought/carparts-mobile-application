cd ios
# fastlane bump_version_code
pod repo update
flutter clean
flutter pub get
flutter build ios 
# fastlane deploy_internal_testers_release package_name:com.exathought.vikray.mobile.customer.qa
# fastlane export_app package_name:com.exathought.vikray.mobile.customer.qa
# fastlane export_app
