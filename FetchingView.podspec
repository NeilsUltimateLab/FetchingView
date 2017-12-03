#
# Be sure to run `pod lib lint FetchingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FetchingView'
  s.version          = '0.1.0'
  s.summary          = 'Views to indicate data fetching states.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Views to show on different states of data fetching. Shows indicator views for fetching state, error states etc.
                       DESC

  s.homepage         = 'https://github.com/NeilsUltimateLab/FetchingView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NeilsUltimateLab' => 'neilsultimatelab@icloud.com' }
  s.source           = { :git => 'https://github.com/NeilsUltimateLab/FetchingView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FetchingView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FetchingView' => ['FetchingView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
