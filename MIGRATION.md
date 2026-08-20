# Migrating from 1.x to 2.0 / 从 1.x 迁移到 2.0

xue_hua_media_info 2.0 is a complete rewrite. The Rust (`flutter_rust_bridge` +
`nom-exif`) engine has been replaced by fully native implementations on every
platform, packaged as a federated plugin. The public API is new: 1.x’s dozens
of `FromFile` / `FromBytes` / sync / `*Async` / lazy / `Parser` entry points
are gone.

xue_hua_media_info 2.0 是一次彻底重写：Rust（`flutter_rust_bridge` + `nom-exif`）
引擎被各平台的纯原生实现取代，并采用联合插件架构发布。公开 API 也是全新的：
1.x 里 `FromFile` / `FromBytes` / 同步 / `*Async` / lazy / `Parser` 那十几条入口
全部删除。

| Platform / 平台 | 1.x | 2.0 |
| --- | --- | --- |
| Android | Rust FFI (nom-exif) | ExifInterface + MediaMetadataRetriever |
| iOS / macOS | Rust FFI | ImageIO + AVFoundation |
| Windows | Rust FFI | WIC + Media Foundation |
| Linux | Rust FFI | JPEG/PNG C 解析 + GstDiscoverer |
| Web | ❌ 不支持 | ✅ 纯 Dart（JPEG / PNG / MP4-MOV） |

Key benefits / 主要收益：

- No Rust toolchain, no cargokit, no FRB codegen — plain `flutter pub add`.
  无需 Rust 工具链、cargokit 与 FRB 代码生成，直接 `flutter pub add` 即可。
- One façade, one source type, sealed results. / 一个门面、一种源、密封结果。
- First-class fields instead of tag soup. / 一等字段，不再从标签列表里「捞」类型。
- New Web platform support. / 新增 Web 平台支持。

## Initialization / 初始化

There is no global engine. Call `MediaInfo` static methods directly.

不再有全局引擎；直接调用 `MediaInfo` 静态方法。

```dart
// 1.x
await XueHuaMediaInfo.initialize();
final metadata = XueHuaMediaInfo.readMediaMetadataFromFile(path: p);

// 2.0 — no initialization. / 无需任何初始化。
final metadata = await MediaInfo.read(MediaSource.file(p));
```

## Reading metadata / 读取元数据

| 1.x | 2.0 |
| --- | --- |
| `XueHuaMediaInfo.readMediaMetadataFromFile(path: p)` | `MediaInfo.read(MediaSource.file(p))` |
| `readMediaMetadataFromBytes(bytes: b)` | `MediaInfo.read(MediaSource.bytes(b))` |
| `readMediaMetadataFromFileAsync` / `*Async` | 所有方法都已是 `Future`；没有同步 API |
| `readImageExifFromFile` / `FromBytes` | `MediaInfo.readImage(source)` |
| `readImageExifLazy*` | 已删除；`readImage` 一次填好一等字段 |
| `readFullImageMetadata*` | 已删除；PNG `tEXt` 在 `ImageMetadata.pngText` |
| `readVideoMetadata*` | `MediaInfo.readAv(source)` 再 `switch` |
| `MediaMetadataParser` / 可复用 buffer | 已删除；每次调用无状态 |
| `videoOrAudio` | `MediaKind.video` 与 `MediaKind.audio` 拆开 |
| `ImageExif` extension getters on `List<MetadataEntry>` | `ImageMetadata.make` / `size` / `gps` 等一等字段 |
| Motion Photo 辅助方法 | `ImageMetadata.hasMotionPhoto` + `MediaInfo.readMotionPhoto` |
| Asset 读取 | `MediaSource.asset(key, package: …)`（`packages/<pkg>/` 在 Dart 侧解析） |

Example / 示例：

```dart
final meta = await MediaInfo.read(MediaSource.file('/path/to/photo.jpg'));
switch (meta) {
  case ImageMetadata(:final make, :final size, :final gps):
    print('$make $size $gps');
  case VideoMetadata(:final duration):
    print(duration);
  case AudioMetadata(:final duration):
    print(duration);
}
```

## Types / 类型

| 1.x | 2.0 |
| --- | --- |
| `XueHuaMediaInfo` | `MediaInfo` |
| `MediaMetadata` tag soup + `isImage` / `isVideo` | sealed `MediaMetadata` → `ImageMetadata` \| `VideoMetadata` \| `AudioMetadata` |
| `ImageExif` / `FullImageMetadata` | `ImageMetadata` |
| 散落的 `width` / `height` | `PixelSize` |
| GPS 标签 | `GpsLocation`（没有定位时 `gps == null`） |
| `MetadataEntry` 列表为核心 | `MetadataTag` 仅残留项 |
| FRB / `AnyhowException` | `MediaInfoError`（`code` 为类型上的字符串常量） |

## Formats no longer covered / 不再覆盖的格式

Relative to nom-exif 1.x, these are **impossible** on every 2.0 platform and
throw `unsupportedFormat`:

相对 nom-exif 1.x，下列格式在 2.0 **六端都不可能**，会抛 `unsupportedFormat`：

- Fujifilm **RAF**
- Canon **CR3**
- Phase One **IIQ**

HEIC/TIFF remain available on Android / Darwin / Windows (see the capability
matrix in the README). Linux and Web throw `unsupportedFormat` for those.

HEIC/TIFF 仍可在 Android / Darwin / Windows 上读取（见 README 能力矩阵）；
Linux 与 Web 对它们抛 `unsupportedFormat`。

## Errors / 错误

| 1.x | 2.0 |
| --- | --- |
| 字符串 / FRB 异常 | `MediaInfoError.codeUnsupported` |
| 种类不匹配 | `codeWrongKind` |
| I/O | `codeIo` |
| 无法识别 | `codeUnsupportedFormat` |
| 无 EXIF | `codeExifNotFound` |
| 无轨道 / 无 Motion Photo | `codeTrackNotFound` |
| 损坏 | `codeMalformed` |
| 找不到文件 | `codeNotFound` |
