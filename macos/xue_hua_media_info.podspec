#
# macOS implementation of the xue_hua_media_info plugin.
# xue_hua_media_info 插件的 macOS 实现。
#
Pod::Spec.new do |s|
  s.name             = 'xue_hua_media_info'
  s.version          = '2.2.0'
  s.summary          = 'macOS implementation of the xue_hua_media_info plugin.'
  s.description      = <<-DESC
ImageIO + AVFoundation media metadata for the xue_hua_media_info Flutter plugin
on macOS (CocoaPods + Swift Package Manager, backed by Pigeon Swift FFI).
                       DESC
  s.homepage         = 'https://github.com/Matkurban/xue_hua_media_info'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = { 'Matkurban' => 'https://github.com/Matkurban' }
  s.source           = { :git => 'https://github.com/Matkurban/xue_hua_media_info.git', :tag => s.version.to_s }
  s.source_files     = 'xue_hua_media_info/Sources/**/*.{swift,m,h}'

  s.platform = :osx, '10.15'
  s.dependency 'FlutterMacOS'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

  s.swift_version = '5.9'
end
