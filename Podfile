source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
inhibit_all_warnings!
use_frameworks!

target 'Affirmations' do
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'Kingfisher'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  
  pod 'SwiftyStoreKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
