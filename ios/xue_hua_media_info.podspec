#
# iOS implementation of the xue_hua_media_info plugin.
# xue_hua_media_info 插件的 iOS 实现。
#
Pod::Spec.new do |s|
  s.name             = 'xue_hua_media_info'
  s.version          = '2.2.1'
  s.summary          = 'iOS implementation of the xue_hua_media_info plugin.'
  s.description      = <<-DESC
ImageIO + AVFoundation media metadata for the xue_hua_media_info Flutter plugin
on iOS (CocoaPods + Swift Package Manager, backed by Pigeon Swift FFI).
                       DESC
  s.homepage         = 'https://github.com/Matkurban/xue_hua_media_info'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = { 'Matkurban' => 'https://github.com/Matkurban' }
  s.source           = { :git => 'https://github.com/Matkurban/xue_hua_media_info.git', :tag => s.version.to_s }
  s.source_files     = 'xue_hua_media_info/Sources/xue_hua_media_info/**/*.swift'

  s.platform = :ios, '13.0'
  s.dependency 'Flutter'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }

  s.swift_version = '5.9'
end
