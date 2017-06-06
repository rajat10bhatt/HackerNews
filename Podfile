# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Hacker News' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Hacker News
  pod 'RxSwift', '~> 3.0.0.beta.1'
  pod 'RxCocoa', '~> 3.0.0.beta.1'
  pod 'RxAlamofire'
  pod 'Moya-ObjectMapper'
  pod 'Moya'
  pod "RxPager"

  target 'Hacker NewsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Hacker NewsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
