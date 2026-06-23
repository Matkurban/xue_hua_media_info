# xue_hua_media_info

Flutter FFI plugin for reading **image EXIF** and **video/audio metadata**, powered by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/).

Flutter FFI 插件，用于读取**图片 EXIF** 与**视频/音频元数据**，底层基于 [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 与 [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/)。

---

## Features / 特性

| Feature | Description |
|---------|-------------|
| Pure Rust backend | No FFmpeg, libexif, or system dependencies / 纯 Rust 实现，无 FFmpeg、libexif 等系统依赖 |
| Unified API | One entry point for images and video/audio / 图片与音视频统一 API |
| Sync + Async | Blocking and `Future`-based reads / 同步与异步两种调用方式 |
| File + bytes | Read from path or in-memory buffer / 支持文件路径与内存字节 |
| Motion Photo | Pixel / Samsung embedded MP4 support / 支持 Pixel / 三星动态照片内嵌视频 |
| GPS | Latitude, longitude, altitude in results / 结果中包含 GPS 经纬度与海拔 |
| Batch parsing | Reusable `MediaMetadataParser` with buffer reuse / 可复用解析器，批量处理更高效 |
| Convenience getters | `exif.make`, `track.durationMs`, etc. / 便捷 getter：`exif.make`、`track.durationMs` 等 |

---

## Supported formats / 支持格式

### Images / 图片

JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3

### Video / audio / 视频 / 音频

MP4, MOV, 3GP, MKV, WEBM, MKA

### Special / 特殊格式

Pixel / Samsung **Motion Photo** — JPEG with an embedded MP4 video trailer  
Pixel / 三星 **动态照片** — JPEG 末尾内嵌 MP4 短视频

---

## Installation / 安装

Add to `pubspec.yaml`:

```yaml
dependencies:
  xue_hua_media_info: ^1.0.0
```

Supported platforms: **Android, iOS, macOS, Linux, Windows** (FFI plugin).

支持平台：**Android、iOS、macOS、Linux、Windows**（FFI 插件）。

---

## Getting started / 快速开始

### 1. Initialize / 初始化

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await XueHuaMediaInfo.initialize(); // call once / 调用一次
}
```

### 2. Read metadata / 读取元数据

```dart
// Auto-detect image or video from file / 自动识别并读取文件
final metadata = XueHuaMediaInfo.readMediaMetadataFromFile(
  path: '/path/to/photo.jpg',
);

if (metadata.isImage) {
  final exif = metadata.imageExifOrNull!;
  print('${exif.make} ${exif.model}');
  print('${exif.width} x ${exif.height}');
} else if (metadata.isVideo) {
  final track = metadata.videoTrackOrNull!;
  print('Duration: ${track.durationMs} ms');
}

// Read from bytes (asset, network, memory) / 从字节读取
final exif = XueHuaMediaInfo.readImageExifFromBytes(data: jpegBytes);
final track = XueHuaMediaInfo.readVideoMetadataFromBytes(data: movBytes);

// Detect type only (fast, no full parse) / 仅检测类型（快速，不完整解析）
final kind = XueHuaMediaInfo.detectMediaKindFromBytes(data: bytes);
// MediaKind.image or MediaKind.videoOrAudio
```

### 3. Async reads / 异步读取

Every sync method has an `Async` counterpart returning `Future<T>`:

每个同步方法都有对应的 `Async` 版本，返回 `Future<T>`：

```dart
final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: jpegBytes);
final track = await XueHuaMediaInfo.readVideoMetadataFromFileAsync(path: videoPath);
```

Use **sync** for simple scripts or when already on a background isolate.  
Use **async** in Flutter UI code to avoid blocking during file I/O.

**同步**适合脚本或已在后台 Isolate 的场景。  
**异步**适合 Flutter UI，避免文件 I/O 阻塞主线程。

---

## API reference / API 参考

All public methods live on [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) and [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart).  
Each method has bilingual doc comments in source code.

所有公开方法定义于 [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) 与 [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart)，源码中含中英双语文档注释。

### `XueHuaMediaInfo` — one-shot readers / 一次性读取

| Method | EN | 中文 |
|--------|----|------|
| `initialize()` | Initialize native Rust library (once) | 初始化原生库（一次） |
| `readMediaMetadataFromFile` / `FromBytes` | Auto-detect and read image EXIF or video track | 自动识别并读取图片 EXIF 或视频轨道 |
| `readImageExifFromFile` / `FromBytes` | Read image EXIF (eager — all tags upfront) | 读取图片 EXIF（急切模式，一次解析全部标签） |
| `readImageExifLazyFromFile` / `FromBytes` | Read image EXIF (lazy — per-tag errors preserved) | 读取图片 EXIF（惰性模式，保留逐标签错误） |
| `readVideoMetadataFromFile` / `FromBytes` | Read video/audio track metadata | 读取视频/音频轨道元数据 |
| `readFullImageMetadataFromFile` / `FromBytes` | EXIF + format extras (e.g. PNG tEXt) | EXIF + 格式扩展（如 PNG tEXt） |
| `detectMediaKindFromFile` / `FromBytes` | Detect image vs video/audio (header only) | 检测图片或视频/音频（仅读文件头） |
| `readEmbeddedVideoFromFile` / `FromBytes` | Extract embedded MP4 from Motion Photo | 从动态照片提取内嵌 MP4 元数据 |
| `createParser()` | Create reusable batch parser | 创建可复用批量解析器 |

**Async variants:** append `Async` to every method above (e.g. `readImageExifFromBytesAsync`).  
**异步变体：** 在上述方法名后加 `Async`（如 `readImageExifFromBytesAsync`）。

### `MediaMetadataParser` — batch parsing / 批量解析

Create once with `XueHuaMediaInfo.createParser()`, then reuse for many files:

```dart
final parser = XueHuaMediaInfo.createParser();

for (final path in imagePaths) {
  final exif = parser.parseImageExifFromFile(path: path);
  print(exif.make);
}

// Async batch / 异步批量
for (final path in videoPaths) {
  final track = await parser.parseVideoMetadataFromFileAsync(path: path);
  print(track.durationMs);
}
```

| Method | EN | 中文 |
|--------|----|------|
| `parseImageExifFromFile` / `FromBytes` | Parse image EXIF | 解析图片 EXIF |
| `parseVideoMetadataFromFile` / `FromBytes` | Parse video/audio track | 解析视频/音频轨道 |
| `parseFullImageMetadataFromFile` / `FromBytes` | Parse EXIF + format extras | 解析 EXIF + 格式扩展 |
| `parseEmbeddedVideoFromFile` / `FromBytes` | Parse Motion Photo embedded video | 解析动态照片内嵌视频 |

Each has an `Async` counterpart.  
均有对应的 `Async` 版本。

---

## Data types / 数据类型

### `ImageExif`

| Field | EN | 中文 |
|-------|----|------|
| `entries` | List of EXIF tags (`MetadataEntry`) | EXIF 标签列表 |
| `gps` | GPS location, if present | GPS 位置信息 |
| `hasEmbeddedVideo` | True for Motion Photos | 动态照片时为 true |
| `parseErrors` | Per-tag errors (lazy mode) | 逐标签解析错误（惰性模式） |

### `VideoTrack`

| Field | EN | 中文 |
|-------|----|------|
| `entries` | Track metadata tags | 轨道元数据标签 |
| `gps` | GPS from video metadata | 视频中的 GPS 信息 |

Common tags include `Width`, `Height`, `DurationMs`, `Make`, `Model`.  
常见标签：`Width`、`Height`、`DurationMs`、`Make`、`Model`。

### `MediaMetadata`

Union of image or video result from auto-detect reads:

```dart
metadata.isImage       // bool
metadata.isVideo       // bool
metadata.imageExifOrNull
metadata.videoTrackOrNull
```

自动识别读取的联合结果，包含图片或视频分支。

### `FullImageMetadata`

| Field | EN | 中文 |
|-------|----|------|
| `exif` | Parsed EXIF, if any | 解析出的 EXIF |
| `pngTextChunks` | PNG tEXt key/value pairs | PNG tEXt 键值对 |

### `MediaKind`

- `MediaKind.image` — JPEG, PNG, HEIC, etc.
- `MediaKind.videoOrAudio` — MP4, MOV, MKV, etc.

---

## Convenience extensions / 便捷扩展

Imported automatically via `package:xue_hua_media_info/xue_hua_media_info.dart`.

通过主包导入后自动可用。

### `VideoTrack`

```dart
track.durationMs    // int? — milliseconds / 毫秒
track.duration      // Duration?
track.width         // int? — pixels / 像素
track.height        // int?
track.make          // String? — manufacturer / 制造商
track.model         // String? — device model / 型号
track.software      // String?
track.author        // String?
track.createDate    // String?
```

### `ImageExif`

```dart
exif.make
exif.model
exif.software
exif.width
exif.height
exif.orientation
exif.dateTimeOriginal
exif.createDate
exif.modifyDate
```

### `List<MetadataEntry>`

```dart
entries.entryNamed('Make')
entries.stringValue('Make')
entries.intValue('Width')
entries.doubleValue('Latitude')
```

### `FullImageMetadata`

```dart
full.pngText('Comment')  // PNG tEXt lookup / 查找 PNG tEXt
```

---

## Motion Photo / 动态照片

Some JPEGs embed a short MP4 (Google Pixel, Samsung). Workflow:

部分 JPEG 内嵌 MP4 短视频（Google Pixel、三星等）。流程：

```dart
final exif = XueHuaMediaInfo.readImageExifFromFile(path: path);

if (exif.hasEmbeddedVideo) {
  final video = XueHuaMediaInfo.readEmbeddedVideoFromFile(path: path);
  print('Embedded duration: ${video.durationMs} ms');
}
```

---

## Error handling / 错误处理

Failures throw `MediaInfoError` (implements `FrbException`):

```dart
try {
  final exif = XueHuaMediaInfo.readImageExifFromBytes(data: bytes);
} on MediaInfoError catch (e) {
  print('${e.code}: ${e.message}');
}
```

Common codes: invalid input, unsupported format, I/O error, parse failure.  
常见错误码：无效输入、不支持格式、I/O 错误、解析失败。

---

## Sync vs async / 同步与异步对比

| | Sync / 同步 | Async / 异步 |
|---|-------------|--------------|
| Return type | `T` | `Future<T>` |
| File I/O | Blocking on calling isolate | Non-blocking (tokio) |
| Use case | Scripts, isolates, small reads | Flutter UI, `async`/`await` |
| Naming | `readImageExifFromBytes` | `readImageExifFromBytesAsync` |

Both paths share the same Rust/nom-exif backend and return identical types.  
两种路径共用同一 Rust/nom-exif 后端，返回类型完全一致。

---

## Eager vs lazy EXIF / 急切 vs 惰性 EXIF

| | Eager (`readImageExifFrom*`) | Lazy (`readImageExifLazyFrom*`) |
|---|------------------------------|----------------------------------|
| Parse strategy | All tags parsed immediately | Tags parsed on demand |
| Errors | May fail entire read | Collected in `parseErrors` |
| Best for | Most apps needing full EXIF | Damaged/partial EXIF, debugging |

| | 急切模式 | 惰性模式 |
|---|---------|---------|
| 策略 | 一次解析全部标签 | 按需解析 |
| 错误 | 可能导致整体失败 | 写入 `parseErrors` |
| 适用 | 常规 EXIF 读取 | 损坏/部分 EXIF、调试 |

---

## Example app / 示例应用

```bash
cd example && flutter run
```

The example loads sample JPEG and MOV assets and displays Make, Model, dimensions, and duration.  
示例加载测试 JPEG 与 MOV，展示 Make、Model、尺寸与时长。

---

## Development / 开发

### Regenerate FRB bindings / 重新生成 FRB 绑定

After changing Rust API in `rust/src/api/`:

```bash
flutter_rust_bridge_codegen generate
```

### Run tests / 运行测试

```bash
# Dart unit tests / Dart 单元测试
flutter test test/

# Rust unit tests / Rust 单元测试
cd rust && cargo test

# Integration tests (macOS example) / 集成测试
cd example && flutter test integration_test/simple_test.dart -d macos

# Static analysis / 静态分析
dart analyze
```

### Project layout / 项目结构

```
lib/
  xue_hua_media_info.dart          # Public exports / 公开导出
  src/
    xue_hua_media_info.dart        # Facade API + doc comments / 门面 API
    extensions/
      metadata_extensions.dart     # Convenience getters / 便捷 getter
    rust/                          # FRB generated (do not edit) / FRB 生成
rust/
  src/api/
    reader.rs / reader_async.rs    # One-shot read API
    parser.rs / parser_async.rs    # Reusable parser API
    types.rs                       # DTO types for FRB
  src/convert.rs                   # nom-exif → DTO conversion
```

---

## License / 许可证

MIT (this plugin). [nom-exif](https://github.com/mindeng/nom-exif) is also MIT-licensed.

本插件采用 MIT 许可证。[nom-exif](https://github.com/mindeng/nom-exif) 同为 MIT。
