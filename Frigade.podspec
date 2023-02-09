#
# Be sure to run `pod lib lint Frigade.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Frigade'
  s.version          = '0.1.4'
  s.summary          = 'The official iOS SDK for Frigade.'
  s.swift_versions = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Frigade is the easiest way for developers to build high-quality product onboarding and education.
  DESC

  s.homepage         = 'https://frigade.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'christianmat' => 'christian@frigade.com' }
  s.source           = { :git => 'https://github.com/FrigadeHQ/ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'


  s.ios.deployment_target = '13.0'

  s.source_files = 'Frigade/Classes/**/*'

  # s.resource_bundles = {
  #   'Frigade' => ['Frigade/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher', '~> 7.0'
end
