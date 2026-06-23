## 1.0.0

First public release. / 首次公开发布。

### Core / 核心能力

* Flutter FFI plugin backed by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) 2.12 — pure Rust, no FFmpeg or libexif
* 基于 nom-exif 3.6.1 与 flutter_rust_bridge 2.12 的 Flutter FFI 插件，纯 Rust 实现，无 FFmpeg、libexif 等系统依赖
* Unified entry point [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) with `initialize()` for one-time native setup
* 统一入口 `XueHuaMediaInfo`，通过 `initialize()` 一次性初始化原生库
* Supports **Android, iOS, macOS, Linux, Windows**
* 支持 **Android、iOS、macOS、Linux、Windows**

### Metadata reading / 元数据读取

* **Images:** JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3
* **Video / audio:** MP4, MOV, 3GP, MKV, WEBM, MKA
* Auto-detect media type and read image EXIF or video track metadata (`readMediaMetadataFrom*`)
* 自动识别媒体类型，读取图片 EXIF 或视频/音频轨道元数据
* Read from **file path** or **in-memory bytes**
* 支持**文件路径**与**内存字节**两种输入
* Eager EXIF (`readImageExifFrom*`) and lazy EXIF with per-tag error collection (`readImageExifLazyFrom*`)
* 急切 EXIF 与惰性 EXIF（保留逐标签解析错误）
* Full image metadata including PNG tEXt chunks (`readFullImageMetadataFrom*`)
* 完整图片元数据，含 PNG tEXt 块
* Fast media kind detection without full parse (`detectMediaKindFrom*`)
* 快速媒体类型检测（不完整解析）
* GPS latitude, longitude, and altitude in image and video results
* 图片与视频结果中包含 GPS 经纬度与海拔

### Motion Photo / 动态照片

* Detect embedded MP4 in Pixel / Samsung Motion Photos (`ImageExif.hasEmbeddedVideo`)
* 检测 Pixel / 三星动态照片中的内嵌 MP4（`hasEmbeddedVideo`）
* Extract embedded video track metadata (`readEmbeddedVideoFrom*`)
* 提取内嵌视频轨道元数据

### Sync & async API / 同步与异步 API

* **14 sync** one-shot reader methods on `XueHuaMediaInfo`
* **14 async** counterparts with `Async` suffix returning `Future<T>` (non-blocking I/O via tokio)
* `XueHuaMediaInfo` 提供 **14 个同步**一次性读取方法及 **14 个异步**对应方法（`Async` 后缀，`Future<T>`，tokio 非阻塞 I/O）

### Batch parsing / 批量解析

* Reusable [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart) via `XueHuaMediaInfo.createParser()` with internal buffer reuse
* 可复用 `MediaMetadataParser`，内部缓冲区复用，适合批量处理
* **8 sync** + **8 async** parser methods for EXIF, video, full image, and embedded video
* **8 个同步** + **8 个异步**解析方法

### Convenience extensions / 便捷扩展

* `VideoTrack`: `durationMs`, `duration`, `width`, `height`, `make`, `model`, etc.
* `ImageExif`: `make`, `model`, `width`, `height`, `orientation`, `dateTimeOriginal`, etc.
* `MediaMetadata`: `isImage`, `isVideo`, `imageExifOrNull`, `videoTrackOrNull`
* `List<MetadataEntry>`: `entryNamed`, `stringValue`, `intValue`, `doubleValue`
* `FullImageMetadata`: `pngText(key)`

### Documentation / 文档

* Bilingual (EN / 中文) doc comments on all public API methods and extension getters
* 全部公开 API 与扩展 getter 均含中英双语文档注释
* Detailed bilingual README with API reference, examples, and development guide
* 详细双语 README，含 API 参考、示例与开发指南

### Error handling / 错误处理

* Structured errors via `MediaInfoError` with `MediaInfoErrorCode` and message
* 结构化错误 `MediaInfoError`，含错误码与消息
