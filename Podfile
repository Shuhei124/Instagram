# Uncomment the next line to define a global platform for your project
platform :ios, '14.3'

target 'Instagram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Instagram

# add the Firebase pod for Google Analytics
pod 'Firebase','6.27.0'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
pod 'FirebaseUI/Storage'

# add pods for any other desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
 

end

