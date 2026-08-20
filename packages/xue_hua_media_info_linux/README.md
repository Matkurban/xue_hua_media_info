# xue_hua_media_info_linux

The Linux implementation of [`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info).
[`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info) 插件的 Linux 实现。

Still images use in-tree JPEG APP1 / PNG tEXt parsers (no libexif). Audio/video
containers use GStreamer `GstDiscoverer`.

图片使用仓内 JPEG APP1 / PNG tEXt 解析（不引入 libexif）；音视频使用 GStreamer
`GstDiscoverer`。

## Usage / 用法

This package is [endorsed](https://flutter.dev/to/endorsed-federated-plugin),
which means you can simply use `xue_hua_media_info` normally. This package will
be automatically included in your app when you do, so you do not need to add it
to your `pubspec.yaml`.

本包是 `xue_hua_media_info` 的官方背书实现：直接依赖 `xue_hua_media_info` 即可自动引入，
无需在 `pubspec.yaml` 中单独添加。
