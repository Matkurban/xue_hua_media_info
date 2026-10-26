## 2.1.3

- Windows: re-enable C++ exceptions for the plugin (`_HAS_EXCEPTIONS=1`) and return explicit `FlutterError` details so Pigeon error replies decode as `MediaInfoError` instead of `FormatException`.
  Windows：为插件重新启用 C++ 异常（`_HAS_EXCEPTIONS=1`），并显式返回 `FlutterError`，使 Pigeon 错误回复解码为 `MediaInfoError` 而非 `FormatException`。
- Windows: do not fail `readImage` when WIC cannot decode Exif-only / Motion Photo JPEG stubs; fall back to IFD0 ImageWidth/Length and Exif PixelX/YDimension for size (parity with Linux metadata-only path).
  Windows：WIC 无法解码仅含 Exif / 动态照片 JPEG 桩文件时不再让 `readImage` 失败；尺寸回退到 IFD0 ImageWidth/Length 与 Exif PixelX/YDimension（与 Linux 仅元数据路径对齐）。

## 2.1.2

- Windows: bump googletest so CMake ≥ 4 can configure the example; sniff RIFF/WAVE (and ID3/MP3) by magic bytes for `BytesSource`; parse `GCamera:MotionPhotoOffset` for modern Pixel motion photos.
  Windows：升级 googletest 以便 CMake ≥ 4 能配置示例；按魔数识别 RIFF/WAVE（及 ID3/MP3）以支持无扩展名的 `BytesSource`；解析现代 Pixel 动态照片的 `GCamera:MotionPhotoOffset`。
- Example: silence Flutter beta-only `package:flutter/material.dart` deprecation info so `flutter analyze` stays clean without breaking stable Flutter.
  示例：忽略 Flutter beta 上 `package:flutter/material.dart` 的弃用 info，保证 `flutter analyze` 干净且不破坏稳定版 Flutter。

## 2.1.1

- Fix Linux build after the 2.1.0 monolith collapse: Pigeon C enums are now `XUE_HUA_MEDIA_INFO_*` (not `…_PLATFORM_INTERFACE_*`), and bump googletest so CMake ≥ 4 can configure the example.
  修复 2.1.0 合并为单包后的 Linux 编译：Pigeon C 枚举改为 `XUE_HUA_MEDIA_INFO_*`（不再使用 `…_PLATFORM_INTERFACE_*`），并升级 googletest 以便 CMake ≥ 4 能配置示例工程。
- Linux/Web: detect RIFF/WAVE (and ID3/MP3 frames) as audio by magic bytes so `BytesSource` works without a file extension; parse `GCamera:MotionPhotoOffset` for modern Pixel motion photos; pick a sensible temp-file suffix for GStreamer.
  Linux/Web：按魔数识别 RIFF/WAVE（及 ID3/MP3）音频，使无扩展名的 `BytesSource` 可用；解析现代 Pixel 动态照片的 `GCamera:MotionPhotoOffset`；为 GStreamer 选择合适的临时文件后缀。
- Example: use a real PNG sample with tEXt, expand Linux `integration_test` coverage (image/video/audio/EXIF/GPS/motion photo/error paths).
  示例：改用带 tEXt 的真实 PNG，并扩充 Linux `integration_test` 覆盖面（图/视/音、EXIF/GPS、动态照片、错误路径）。

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
