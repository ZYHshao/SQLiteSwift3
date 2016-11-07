#
# Be sure to run `pod lib lint SQLiteSwift3.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SQLiteSwift3'
  s.version          = '0.1.2'
  s.summary          = 'A short description of SQLiteSwift3.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A short description of SQLiteSwift3 by jaki.
                       DESC

  s.homepage         = 'https://github.com/ZYHshao/SQLiteSwift3.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jaki' => '316045346@qq.com' }
  s.source           = { :git => 'https://github.com/ZYHshao/SQLiteSwift3.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SQLiteSwift3/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SQLiteSwift3' => ['SQLiteSwift3/Assets/*.png']
  # }
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation'
  s.libraries = 'sqlite3.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
