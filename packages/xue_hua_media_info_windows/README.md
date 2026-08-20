# xue_hua_media_info_windows

The Windows implementation of [`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info).
[`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info) 插件的 Windows 实现。

Still images use Windows Imaging Component (WIC); audio/video containers use
Media Foundation `IMFSourceReader`.

图片走 WIC；音视频走 Media Foundation `IMFSourceReader`。

## Usage / 用法

This package is [endorsed](https://flutter.dev/to/endorsed-federated-plugin),
which means you can simply use `xue_hua_media_info` normally. This package will
be automatically included in your app when you do, so you do not need to add it
to your `pubspec.yaml`.

本包是 `xue_hua_media_info` 的官方背书实现：直接依赖 `xue_hua_media_info` 即可自动引入，
无需在 `pubspec.yaml` 中单独添加。
