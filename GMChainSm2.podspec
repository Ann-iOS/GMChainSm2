

Pod::Spec.new do |spec|
  spec.name         = "GMChainSm2"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of GMChainSm2."

  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "http://EXAMPLE/GMChainSm2"

  spec.license      = "MIT (example)"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "YangtingTombay" => "m18620345206@163.com" }
  # Or just: spec.author    = "YangtingTombay"
  # spec.authors            = { "YangtingTombay" => "m18620345206@163.com" }
  # spec.social_media_url   = "https://twitter.com/YangtingTombay"

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "http://EXAMPLE/GMChainSm2.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
