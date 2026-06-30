# xue_hua_media_info

[English](README.md) | **中文**

Flutter FFI 插件，用于读取**图片 EXIF** 与**视频/音频元数据**。底层基于纯 Rust 库 [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1，通过 [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) 与 Dart 交互。无需 FFmpeg、libexif 等系统依赖。

---

## 特性

| 特性 | 说明 |
|------|------|
| 纯 Rust 后端 | 无 FFmpeg、libexif 等系统依赖，跨平台编译友好 |
| 统一 API | 图片与音视频共用同一套入口，自动识别媒体类型 |
| 同步 + 异步 | 阻塞式同步调用与 `Future` 异步调用均支持 |
| 文件 + 字节 | 支持本地文件路径与内存字节（Asset、网络、缓存） |
| 动态照片 | 支持 Pixel / 三星 Motion Photo 内嵌 MP4 视频元数据提取 |
| GPS | 图片与视频结果中包含经纬度、海拔等位置信息 |
| 批量解析 | `MediaMetadataParser` 复用内部缓冲区，适合相册批量扫描 |
| 便捷 getter | `exif.make`、`track.durationMs` 等扩展方法，简化常用字段读取 |

---

## 支持格式

### 图片

JPEG、PNG、HEIC/HEIF、AVIF、TIFF、Phase One IIQ、Fujifilm RAF、Canon CR3

### 视频 / 音频

MP4、MOV、3GP、MKV、WEBM、MKA

### 特殊格式

Pixel / 三星 **动态照片（Motion Photo）** — JPEG 末尾内嵌 MP4 短视频，可通过专用 API 提取内嵌视频元数据。

---

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  xue_hua_media_info: ^1.1.0
```

支持平台：**Android、iOS、macOS、Linux、Windows**（FFI 插件）。

---

## 快速开始

### 1. 初始化

在使用任何读取 API 之前，**必须先调用一次** `initialize()`。Flutter 应用需先确保 binding 已初始化：

```dart
import 'package:flutter/widgets.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await XueHuaMediaInfo.initialize();
  runApp(const MyApp());
}
```

### 2. 读取元数据

插件支持三种典型输入来源：

| 来源 | 典型场景 | 推荐 API |
|------|----------|----------|
| 本地文件路径 | 相册沙盒、下载目录 | `readXxxFromFile` / `readXxxFromFileAsync` |
| Asset 字节 | `rootBundle.load` | `readXxxFromBytes` / `readXxxFromBytesAsync` |
| 网络/内存字节 | HTTP 下载、内存缓存 | `readXxxFromBytes` / `readXxxFromBytesAsync` |

**自动识别媒体类型**（不知道文件是图片还是视频时）：

```dart
final metadata = XueHuaMediaInfo.readMediaMetadataFromFile(
  path: '/path/to/photo.jpg',
);

if (metadata.isImage) {
  final exif = metadata.imageExifOrNull!;
  print('相机: ${exif.make} ${exif.model}');
  print('尺寸: ${exif.width} x ${exif.height}');
} else if (metadata.isVideo) {
  final track = metadata.videoTrackOrNull!;
  print('时长: ${track.durationMs} ms');
}
```

**已知媒体类型时**，可直接调用专用方法：

```dart
// 图片 EXIF
final exif = XueHuaMediaInfo.readImageExifFromBytes(data: jpegBytes);

// 视频/音频轨道
final track = XueHuaMediaInfo.readVideoMetadataFromBytes(data: movBytes);

// 仅检测类型（只读文件头，速度快，适合列表页预筛）
final kind = XueHuaMediaInfo.detectMediaKindFromBytes(data: bytes);
// MediaKind.image 或 MediaKind.videoOrAudio
```

### 3. 异步读取

每个同步方法都有对应的 `Async` 版本，返回 `Future<T>`：

```dart
final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: jpegBytes);
final track = await XueHuaMediaInfo.readVideoMetadataFromFileAsync(path: videoPath);
```

**选型建议：**

- **Flutter UI 代码**：优先使用 `*Async` 方法，避免文件 I/O 阻塞主 Isolate，防止界面卡顿。
- **脚本、已在后台 Isolate 中**：可使用同步方法，代码更简洁。
- 同步与异步共用同一 Rust/nom-exif 后端，返回类型完全一致。

---

## API 参考

所有公开方法定义于 [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) 与 [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart)。源码中含详细文档注释。

**命名规则：** 同步方法为 `readXxxFromFile` / `readXxxFromBytes`；异步方法在方法名末尾加 `Async`（如 `readImageExifFromBytesAsync`）。

### `XueHuaMediaInfo` — 一次性读取

| 方法 | 说明 | 适用场景 |
|------|------|----------|
| `initialize()` | 初始化原生 Rust 库（全局只需一次） | 应用启动时 |
| `readMediaMetadataFromFile` / `FromBytes` | 自动识别并读取图片 EXIF 或视频轨道 | 不确定文件类型时 |
| `readImageExifFromFile` / `FromBytes` | 读取图片 EXIF（急切模式，一次解析全部标签） | 常规 EXIF 读取 |
| `readImageExifLazyFromFile` / `FromBytes` | 读取图片 EXIF（惰性模式，保留逐标签错误） | EXIF 部分损坏、调试 |
| `readVideoMetadataFromFile` / `FromBytes` | 读取视频/音频轨道元数据 | MP4、MOV、MKV 等 |
| `readFullImageMetadataFromFile` / `FromBytes` | EXIF + 格式扩展（如 PNG tEXt 块） | 需要 PNG 文本块等额外信息 |
| `detectMediaKindFromFile` / `FromBytes` | 检测图片或视频/音频（仅读文件头） | 列表页快速分类，无需完整解析 |
| `readEmbeddedVideoFromFile` / `FromBytes` | 从动态照片提取内嵌 MP4 元数据 | `hasEmbeddedVideo == true` 时 |
| `createParser()` | 创建可复用批量解析器 | 批量处理大量文件 |

上述每个方法均有 `Async` 异步版本。

### `MediaMetadataParser` — 批量解析

通过 `XueHuaMediaInfo.createParser()` 创建一次，多次复用。内部缓冲区在多次调用间复用，适合相册批量扫描等场景：

```dart
final parser = XueHuaMediaInfo.createParser();

// 同步批量
for (final path in imagePaths) {
  final exif = parser.parseImageExifFromFile(path: path);
  print(exif.make);
}

// 异步批量
for (final path in videoPaths) {
  final track = await parser.parseVideoMetadataFromFileAsync(path: path);
  print(track.durationMs);
}
```

| 方法 | 说明 |
|------|------|
| `parseImageExifFromFile` / `FromBytes` | 解析图片 EXIF |
| `parseVideoMetadataFromFile` / `FromBytes` | 解析视频/音频轨道 |
| `parseFullImageMetadataFromFile` / `FromBytes` | 解析 EXIF + 格式扩展 |
| `parseEmbeddedVideoFromFile` / `FromBytes` | 解析动态照片内嵌视频 |

均有对应的 `Async` 版本。

**注意：** `MediaMetadataParser` **不包含** lazy EXIF（`readImageExifLazy*`）和 auto-detect（`readMediaMetadata*`）方法。如需这些能力，请使用 `XueHuaMediaInfo` 一次性读取 API。

---

## 数据类型

### `ImageExif` — 图片 EXIF 结果

| 字段 | 说明 |
|------|------|
| `entries` | EXIF 标签列表（`List<MetadataEntry>`） |
| `gps` | GPS 位置信息（`GpsLocation?`），含经纬度、海拔 |
| `hasEmbeddedVideo` | 是否为动态照片（内嵌 MP4），为 `true` 时可调用 `readEmbeddedVideo*` |
| `parseErrors` | 逐标签解析错误（惰性模式下收集，含 GPS 解析失败） |

### `VideoTrack` — 视频/音频轨道结果

| 字段 | 说明 |
|------|------|
| `entries` | 轨道元数据标签列表 |
| `gps` | 视频中的 GPS 信息 |

常见标签名：`Width`、`Height`、`DurationMs`、`Make`、`Model`、`Software`、`Author`、`CreateDate`。

### `MediaMetadata` — 自动识别结果

`readMediaMetadataFrom*` 返回的联合类型，包含图片或视频其中一个分支：

```dart
metadata.isImage          // 是否为图片 EXIF
metadata.isVideo          // 是否为视频/音频轨道
metadata.imageExifOrNull  // 图片时非 null
metadata.videoTrackOrNull // 视频时非 null
```

### `FullImageMetadata` — 完整图片元数据

| 字段 | 说明 |
|------|------|
| `exif` | 解析出的 EXIF（可能为 null） |
| `pngTextChunks` | PNG tEXt 键值对列表 |

### `MediaKind` — 媒体类型枚举

- `MediaKind.image` — JPEG、PNG、HEIC 等图片格式
- `MediaKind.videoOrAudio` — MP4、MOV、MKV 等视频/音频容器

### `MetadataEntry` — 单条元数据

每条 entry 包含 `tagName`、`displayValue`、`rawValue`（结构化原始值）等字段。便捷 getter（如 `exif.make`）内部通过 `entries` 查找并解析 `rawValue`。

---

## 便捷扩展

通过 `import 'package:xue_hua_media_info/xue_hua_media_info.dart';` 自动导入，无需额外 import。

### `VideoTrack` 扩展

```dart
track.durationMs    // int? — 时长（毫秒）
track.duration      // Duration?
track.width         // int? — 宽度（像素）
track.height        // int? — 高度（像素）
track.make          // String? — 制造商
track.model         // String? — 型号
track.software      // String? — 录制软件
track.author        // String? — 作者
track.createDate    // String? — 创建时间
```

### `ImageExif` 扩展

```dart
exif.make              // 制造商
exif.model             // 型号
exif.software          // 软件
exif.width             // 宽度（优先 ExifImageWidth / ImageWidth）
exif.height            // 高度
exif.orientation       // 方向（1–8）
exif.dateTimeOriginal  // 原始拍摄时间
exif.createDate        // 创建时间
exif.modifyDate        // 修改时间
```

### `List<MetadataEntry>` 查找辅助

```dart
entries.entryNamed('Make')       // 按 tagName 查找第一条
entries.stringValue('Make')      // 字符串值
entries.intValue('Width')        // 整数值
entries.doubleValue('ExposureTime')  // 浮点值（支持 rational）
```

**GPS 读取建议：** 优先使用 `ImageExif.gps` / `VideoTrack.gps` 获取结构化位置信息，而非在 flat entries 中查找 `Latitude` 等标签。

### `FullImageMetadata` 扩展

```dart
full.pngText('Comment')  // 查找 PNG tEXt 块中指定 key 的值
```

### `MediaMetadata` 扩展

```dart
metadata.isImage
metadata.isVideo
metadata.imageExifOrNull
metadata.videoTrackOrNull
```

---

## 动态照片（Motion Photo）

Google Pixel、三星等设备的 JPEG 可能在文件末尾内嵌一段 MP4 短视频。完整工作流：

```dart
// 步骤 1：读取 EXIF，检查是否含内嵌视频
final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: jpegBytes);

if (exif.hasEmbeddedVideo) {
  // 步骤 2：提取内嵌 MP4 的视频元数据
  // 支持文件路径、内存字节、同步与异步
  final video = await XueHuaMediaInfo.readEmbeddedVideoFromBytesAsync(
    data: jpegBytes,
  );
  print('内嵌视频时长: ${video.durationMs} ms');
  print('尺寸: ${video.width} x ${video.height}');
}
```

从本地文件读取时，将 `FromBytes` 换为 `FromFile` 即可。

---

## 错误处理

读取失败时抛出 `MediaInfoError`（实现 `FrbException`）：

```dart
try {
  final exif = XueHuaMediaInfo.readImageExifFromBytes(data: bytes);
} on MediaInfoError catch (e) {
  print('错误码: ${e.code}');
  print('详情: ${e.message}');
}
```

| 错误码 | 含义 |
|--------|------|
| `MediaInfoErrorCode.io` | 文件不存在、权限不足或其他 I/O 错误 |
| `MediaInfoErrorCode.unsupportedFormat` | 无法识别的文件格式 |
| `MediaInfoErrorCode.exifNotFound` | 图片中未找到 EXIF 数据 |
| `MediaInfoErrorCode.trackNotFound` | 未找到视频/音频轨道，或 JPEG 无动态照片 trailer |
| `MediaInfoErrorCode.malformed` | 元数据损坏或格式无效 |
| `MediaInfoErrorCode.unexpectedEof` | 文件意外截断 |
| `MediaInfoErrorCode.other` | 其他错误（如内部任务失败） |

---

## 同步 vs 异步

| | 同步 | 异步 |
|---|------|------|
| 返回类型 | `T` | `Future<T>` |
| 文件 I/O | 在调用 Isolate 上阻塞 | 非阻塞（tokio） |
| 适用场景 | 脚本、后台 Isolate、小文件 | Flutter UI、`async`/`await` |
| 方法命名 | `readImageExifFromBytes` | `readImageExifFromBytesAsync` |

两种路径共用同一 Rust/nom-exif 后端，返回类型完全一致。

---

## 急切 vs 惰性 EXIF

| | 急切模式（`readImageExifFrom*`） | 惰性模式（`readImageExifLazyFrom*`） |
|---|--------------------------------|--------------------------------------|
| 解析策略 | 一次解析全部标签 | 按需解析 |
| 错误处理 | 单个标签严重错误可能导致整体失败 | 错误收集到 `parseErrors`（含 GPS 解析失败） |
| 适用场景 | 大多数常规 EXIF 读取 | EXIF 部分损坏、调试、需要容忍个别坏标签 |

---

## 示例应用

```bash
cd example && flutter run
```

示例应用从 Asset 加载测试 JPEG 与 MOV，异步读取并展示 Make、Model、尺寸、时长等信息。可作为集成参考。

---

## 开发

### 重新生成 FRB 绑定

修改 `rust/src/api/` 中的 Rust API 后：

```bash
flutter_rust_bridge_codegen generate
```

### 运行测试

```bash
# Dart 单元测试
flutter test test/

# Rust 单元测试
cd rust && cargo test

# 集成测试（macOS 示例）
cd example && flutter test integration_test/simple_test.dart -d macos

# 静态分析
dart analyze
```

### 项目结构

```
lib/
  xue_hua_media_info.dart          # 公开导出
  src/
    xue_hua_media_info.dart        # 门面 API
    extensions/
      metadata_extensions.dart     # 便捷 getter
    rust/                          # FRB 生成代码（请勿手动编辑）
rust/
  src/api/
    reader.rs / reader_async.rs    # 一次性读取 API
    parser.rs / parser_async.rs    # 可复用解析器 API
    types.rs                       # FRB 导出类型
  src/convert.rs                   # nom-exif → DTO 转换
  src/embedded_video.rs            # 动态照片内嵌视频提取
```

---

## 许可证

本插件采用 MIT 许可证。[nom-exif](https://github.com/mindeng/nom-exif) 同为 MIT 许可证。
