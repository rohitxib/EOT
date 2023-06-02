# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EyeOnTask' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EyeOnTask
  pod 'IQKeyboardManagerSwift'
  pod 'ReachabilitySwift'
  pod 'NVActivityIndicatorView'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'MBProgressHUD'
  pod 'SDWebImage'
  pod 'JJFloatingActionButton'
  #pod 'iOSPhotoEditor'
  pod 'BarcodeScanner'
  pod 'BarcodeScanner'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'

    end
  end
end


#post_install do |installer|
#  installer.generated_projects.each do |project|
#        project.targets.each do |target|
#            target.build_configurations.each do |config|
#                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#             end
#        end
# end
#    installer.pods_project.targets.each do |target|
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#  end
#end
