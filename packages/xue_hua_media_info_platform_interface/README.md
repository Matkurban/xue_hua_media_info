# xue_hua_media_info_platform_interface

A common platform interface for the [`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info) plugin.
[`xue_hua_media_info`](https://pub.dev/packages/xue_hua_media_info) 插件的通用平台接口。

This interface allows platform-specific implementations of the
`xue_hua_media_info` plugin, as well as the plugin itself, to ensure they are
supporting the same interface.

本接口确保 `xue_hua_media_info` 插件及其各平台实现遵循同一套契约。

## Usage / 用法

To implement a new platform-specific implementation of `xue_hua_media_info`,
extend `XueHuaMediaInfoPlatform` with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`XueHuaMediaInfoPlatform` by calling
`XueHuaMediaInfoPlatform.instance = MyPlatform()`.

要为 `xue_hua_media_info` 编写新的平台实现，请**继承**（extends）
`XueHuaMediaInfoPlatform` 并实现平台行为，然后在注册插件时通过
`XueHuaMediaInfoPlatform.instance = MyPlatform()` 设置默认实例。
