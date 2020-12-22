#
# Be sure to run `pod lib lint WGZMJImageEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WGZMJImageEditor'
  s.version          = '0.1.2'
  s.summary          = 'A short description of WGZMJImageEditor.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jsonsnow/WGZMJImageEditor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jsonsnow' => '1183010734@qq.com' }
  s.source           = { :git => 'https://github.com/jsonsnow/WGZMJImageEditor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WGZMJImageEditor/Classes/**/*'
  
   s.resource = ['WGZMJImageEditor/Assets/**/*']
   s.dependency 'YYCategories', '~> 1.0.4'
   s.dependency 'Masonry',      '~> 1.0.1'
   s.dependency 'GPUImage', '~> 0.1.7'
   s.public_header_files = 'WGZMJImageEditor/Classes/**/*.h'
   s.pod_target_xcconfig = {
     'SUPPORTS_MACCATALYST' => 'YES',
     'DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER' => 'NO'
   }
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
