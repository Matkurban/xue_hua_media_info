# xue_hua_media_info

**[English](README.md)** | 简体中文

跨平台**原生** Flutter 插件，用于读取**图片 EXIF** 与**视频/音频元数据**。应用只依赖门面包
[`xue_hua_media_info`](packages/xue_hua_media_info)；各端通过
[Pigeon](https://pub.dev/packages/pigeon) 接入联合插件实现。无需 Rust 工具链、无需 FFI、无需全局 `initialize()`。

| 平台 | 静态图片 | 音视频 |
| --- | --- | --- |
| Android | `androidx.exifinterface` | `MediaMetadataRetriever` |
| iOS / macOS | ImageIO | AVFoundation |
| Windows | WIC | Media Foundation `IMFSourceReader` |
| Linux | 仓内 JPEG APP1 / PNG tEXt | GStreamer `GstDiscoverer` |
| Web | Dart JPEG APP1 / PNG tEXt | Dart `moov`（`mvhd` / `tkhd`） |

从 1.x（Rust/FFI）迁移请见 [MIGRATION.md](MIGRATION.md)。

---

## 安装

```yaml
dependencies:
  xue_hua_media_info: ^2.0.0
```

需要 **Flutter 3.44+**（Dart 3.12）。无需任何初始化调用。

## 用法

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

final source = MediaSource.asset('assets/photo.jpg');
// MediaSource.file('/path/to/photo.jpg')
// MediaSource.bytes(bytes)

final meta = await MediaInfo.read(source);
switch (meta) {
  case ImageMetadata(:final make, :final size, :final gps, :final hasMotionPhoto):
    if (hasMotionPhoto) {
      final clip = await MediaInfo.readMotionPhoto(source);
    }
  case VideoMetadata(:final duration, :final size):
  case AudioMetadata(:final duration, :final sampleRate):
}
```

`MediaInfo` 是 `abstract final` 类，只有五个静态方法：

| 方法 | 结果 | 说明 |
| --- | --- | --- |
| `read` | `MediaMetadata` | 自动识别；**一次 I/O**（原生嗅探+解析） |
| `readImage` | `ImageMetadata` | 非图片 → `wrongKind` |
| `readAv` | `AvMetadata`（`VideoMetadata` \| `AudioMetadata`） | 图片 → `wrongKind` |
| `probe` | `MediaKind` | 只看文件头 |
| `readMotionPhoto` | `VideoMetadata` | 无内嵌 MP4 → `trackNotFound` |

一等字段（`make`、`PixelSize`、`GpsLocation` 等）由原生直接填写。`extraTags` 只放未提升的厂商标签；`pngText` 始终出现在 `ImageMetadata` 上（空列表表示没有文本块，不是失败）。

错误为带稳定字符串码的 `MediaInfoError`：`unsupported`、`wrongKind`、`io`、`unsupportedFormat`、`exifNotFound`、`trackNotFound`、`malformed`、`notFound`。做不到的格式会抛码，禁止静默成功。

## 能力矩阵

**立即** = 本次 `Future` 带真实字段。**不可能** = `unsupported` / `unsupportedFormat`。

| | Android | Darwin | Windows | Linux | Web |
| --- | --- | --- | --- | --- | --- |
| JPEG 一等 EXIF | 立即 | 立即 | 立即 | 立即（APP1） | 立即（APP1） |
| PNG `pngText` | 立即 | 立即 | 立即 | 立即 | 立即 |
| HEIC / HEIF | API 28+ | 立即 | 有 HEIF 编解码器则立即，否则 `unsupportedFormat` | 不可能 | 不可能 |
| TIFF | 立即 | 立即 | 立即 | 不可能 | 不可能 |
| RAF / CR3 / IIQ | 不可能 | 不可能 | 不可能 | 不可能 | 不可能 |
| MP4 / MOV / 3GP | 立即 | 立即 | 立即 | 立即 | 立即（`moov`） |
| MKV / WEBM / MKA | 设备相关 | 有限 | 有编解码器 | `GstDiscoverer` | 不可能 |
| Motion Photo | 立即 | 立即 | 立即 | 立即 | 立即 |
| `MediaSource.file` | 立即 | 立即 | 立即 | 立即 | `unsupported` |

有视频轨 → `VideoMetadata`，仅音频轨 → `AudioMetadata`。旋转后的展示尺寸由各端按平台惯例填好。

## 架构

```text
应用  →  MediaInfo（门面）
     →  XueHuaMediaInfoPlatform
     →  MethodChannelXueHuaMediaInfo  →  Pigeon MediaInfoHostApi  →  原生
     →  Web（纯 Dart，替换 instance，不走 channel）
```

本仓库是 Melos 8 工作区（配置写在根 `pubspec.yaml` 的 `melos:`，没有独立的 `melos.yaml`）。包位于 `packages/`。

## 许可证

Apache License 2.0，见 [LICENSE](LICENSE)。
