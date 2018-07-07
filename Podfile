source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

inhibit_all_warnings!

use_frameworks!

workspace 'Template.xcworkspace'

#####################
#  Pod Definitions  #
#####################

def shared_pods
  # pod 'Alamofire', '~> 4.7' # Shared because of Shared.APIClientDelegate
  # pod 'AlamofireImage', '~> 3.3'
  # pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
  # pod 'Fabric', '~> 1.7'
  # pod 'Firebase', '~> 5.0', :subspecs => ['Analytics', 'Core', 'Messaging', 'Performance', 'RemoteConfig']
  # pod 'RealmSwift', '~> 3.5'
  # pod 'SwiftLint', '~> 0.25'
end

#############
#  Targets  #
#############

abstract_target 'TemplateWorkspace' do 
  shared_pods

  target 'Template' do
    project 'Template/Template.xcodeproj'

    target 'TemplateTests' do
      inherit! :search_paths
    end
  end
end