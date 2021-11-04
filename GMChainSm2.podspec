
Pod::Spec.new do |spec|
  spec.name         = "GMChainSm2"
  spec.version      = "0.0.1"
  spec.summary      = "Swift 国密 Sm2 与 区块链的结合, 包含生成 助记词, 私钥公钥, 加密解密, 签名与验签, 支持通过公钥生成不同链的地址"
  spec.description  = 'Swift 国密 Sm2 与 区块链的结合, 包含生成 助记词, 私钥公钥, 加密解密, 签名与验签, 支持通过公钥生成不同链的地址'

  # spec.description  = <<-DESC
  # 国密 Sm2 与 区块链的结合, 包含生成 助记词, 私钥公钥, 加密解密, 签名与验签, 支持通过公钥生成不同链的地址
  #                 DESC

  spec.homepage     = "https://github.com/Ann-iOS/GMChainSm2"

  # spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "YangtingTombay" => "m18620345206@163.com" }

  spec.platform     = :ios
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/Ann-iOS/GMChainSm2.git", :tag => spec.version.to_s }

  # spec.pod_target_xcconfig = { 'ARCHS[sdk=iphonesimulator*]' => '$(ARCHS_STANDARD_64_BIT)' }
  # spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  # spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 armv7s x86_64' }

  spec.source_files  = "GMChainSm2", "GMChainSm2/**/*.{h,m}"
  spec.exclude_files = "GMChainSm2/**/*.h"

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  spec.requires_arc = true
  spec.static_framework = true
  spec.dependency "DBChainSm2"
  spec.dependency "HDWalletSDK"

end
