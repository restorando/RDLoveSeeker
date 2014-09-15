Pod::Spec.new do |s|
  s.name             = "RDLoveSeeker"
  s.version          = "0.2.1"
  s.summary          = "RDLoveSeeker is a simple library for user feedback."
  s.description      = <<-DESC
                       RDLoveSeeker is a library that requests user feedback and delivers it to the app store for stars or an email compose view if feedback is negative.
                       DESC
  s.homepage         = "https://github.com/Restorando"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Lucas Vidal" => "lucas@restorando.com" }
  s.source           = { :git => "https://github.com/Restorando/RDLoveSeeker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/Restorando'

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/ios'
  s.resources = 'Assets', 'RDLoveSeeker-Localizable.strings'
  s.prefix_header_file = 'Classes/ios/RDLoveSeeker-Prefix.pch'
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
