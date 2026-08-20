#
# iOS + macOS shared implementation of the xue_hua_media_info plugin.
# xue_hua_media_info 插件的 iOS 与 macOS 共享实现。
#
Pod::Spec.new do |s|
  s.name             = 'xue_hua_media_info_darwin'
  s.version          = '2.0.0'
  s.summary          = 'iOS and macOS implementation of the xue_hua_media_info plugin.'
  s.description      = <<-DESC
ImageIO + AVFoundation media metadata for the xue_hua_media_info Flutter
plugin, shared between iOS and macOS (CocoaPods + Swift Package Manager).
                       DESC
  s.homepage         = 'https://github.com/Matkurban/xue_hua_media_info'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = { 'Matkurban' => 'https://github.com/Matkurban' }
  s.source           = { :git => 'https://github.com/Matkurban/xue_hua_media_info.git', :tag => s.version.to_s }
  s.source_files     = 'xue_hua_media_info_darwin/Sources/xue_hua_media_info_darwin/**/*.swift'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'

  s.ios.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.osx.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.swift_version = '5.9'
end
