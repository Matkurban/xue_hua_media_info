# xue_hua_media_info_darwin

The iOS and macOS implementation of [`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info).
[`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info) 插件的 iOS 与 macOS 实现。

Still images use ImageIO; audio/video containers use AVFoundation. Sources are
shared (`sharedDarwinSource: true`) as a SwiftPM package plus a CocoaPods
podspec.

图片走 ImageIO；音视频走 AVFoundation。iOS/macOS 共用一份 Swift（SwiftPM + CocoaPods 双栈）。

## Usage / 用法

This package is [endorsed](https://flutter.dev/to/endorsed-federated-plugin),
which means you can simply use `xue_hua_media_info` normally. This package will
be automatically included in your app when you do, so you do not need to add it
to your `pubspec.yaml`.

本包是 `xue_hua_media_info` 的官方背书实现：直接依赖 `xue_hua_media_info` 即可自动引入，
无需在 `pubspec.yaml` 中单独添加。
