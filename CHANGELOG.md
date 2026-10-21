## 2.1.0

- Ship as one Flutter plugin package. Platform implementations, the platform interface, and the Web plugin now live in `xue_hua_media_info` instead of separate endorsed packages.
  改为单个 Flutter 插件包。平台实现、平台接口和 Web 插件都收进 `xue_hua_media_info`，不再拆成独立的 endorsed 包。
- Public Dart API is unchanged. Import `package:xue_hua_media_info/xue_hua_media_info.dart` as before. `XueHuaMediaInfoPlatform` is exported from that library; the method channel is `package:xue_hua_media_info/xue_hua_media_info_method_channel.dart`.
  公开 Dart API 不变，仍从 `package:xue_hua_media_info/xue_hua_media_info.dart` 导入。`XueHuaMediaInfoPlatform` 由该库导出；method channel 位于 `package:xue_hua_media_info/xue_hua_media_info_method_channel.dart`。
- Regenerate Pigeon bindings with pigeon 29.0.11. Channel names now use the prefix `dev.flutter.pigeon.xue_hua_media_info`.
  使用 pigeon 29.0.11 重新生成绑定。通道前缀改为 `dev.flutter.pigeon.xue_hua_media_info`。

## 2.0.7

- Depend on `xue_hua_media_info_android` 2.0.4. The Android implementation and the example use Android Gradle Plugin 9.1.0, Gradle 9.3.1, and Kotlin 2.4.0.
  依赖 `xue_hua_media_info_android` 2.0.4。Android 实现与示例使用 Android Gradle Plugin 9.1.0、Gradle 9.3.1 与 Kotlin 2.4.0。

## 2.0.6

- Depend on `xue_hua_media_info_android` 2.0.3 and `xue_hua_media_info_darwin` 2.0.2 so Android, iOS, and macOS implement the Pigeon 29 suspend/async Host APIs.
  依赖 `xue_hua_media_info_android` 2.0.3 与 `xue_hua_media_info_darwin` 2.0.2，使 Android、iOS、macOS 实现 Pigeon 29 的 suspend/async Host API。

## 2.0.5

- update `xue_hua_media_info_platform_interface` version

## 2.0.4

- Depend on `xue_hua_media_info_windows` 2.0.1 (MSVC compile fix). 2.0.3
  still resolved `^2.0.0` because the Windows 2.0.2 commit had not been
  merged when 2.0.3 was published.
  依赖 `xue_hua_media_info_windows` 2.0.1（MSVC 编译修复）。2.0.3 发布时尚未
  合并 Windows 2.0.2 提交，因此仍解析到 `^2.0.0`。

## 2.0.3

- Ship the `xue_hua_media_info-read` package skill (`skills/`) so agents can
  install it with `dart run skills@ get`.
  随包发布 `xue_hua_media_info-read` skill，可用 `dart run skills@ get` 安装。

## 2.0.2

- Depend on `xue_hua_media_info_windows` 2.0.1, which fixes MSVC compile errors
  on Windows.
  依赖 `xue_hua_media_info_windows` 2.0.1，修复 Windows 上的 MSVC 编译错误。

## 2.0.1

- Align the example Android build with Gradle 8.14.5 and Android Gradle Plugin 8.13.2.
  示例 Android 工程对齐 Gradle 8.14.5 与 Android Gradle Plugin 8.13.2。

## 2.0.0

Complete rewrite as a federated plugin with fully native implementations.
彻底重写为联合插件，全平台纯原生实现。

- **BREAKING**: the Rust (`flutter_rust_bridge` + `nom-exif`) engine is removed.
  移除 Rust 引擎。
- New `MediaInfo` API: `read` / `readImage` / `readAv` / `probe` /
  `readMotionPhoto` with sealed `MediaMetadata` results.
  全新 `MediaInfo` API 与密封结果类型。
- First-class fields (`PixelSize`, `GpsLocation`, `pngText`) instead of tag
  soup. 一等字段取代标签列表。
- New Web platform support. 新增 Web 平台支持。
- Structured `MediaInfoError` with stable string codes.
  统一结构化错误码。
