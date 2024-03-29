#
# Be sure to run `pod lib lint cmutti2018.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'cmutti2018'
  s.version          = '0.1.0'
  s.summary          = 'd08 piscine iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Loong description'

  s.homepage         = 'https://github.com/Tolo789/cmutti2018'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tolo789' => 'cmutti@student.42.fr' }
  s.source           = { :git => 'https://github.com/Tolo789/cmutti2018.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'cmutti2018/Classes/**/*.swift'
  s.resource = 'cmutti2018/*.xcdatamodeld'
  
  # s.resource_bundles = {
  #   'cmutti2018' => ['cmutti2018/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.swift_version = '4.0.3'
end
