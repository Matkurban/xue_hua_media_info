# xue_hua_media_info

**English** | [简体中文](README.zh-CN.md)

Cross-platform **native** Flutter plugin for reading **image EXIF** and
**video/audio metadata**. Apps depend on the façade package
[`xue_hua_media_info`](packages/xue_hua_media_info); each platform is a
federated implementation wired through
[Pigeon](https://pub.dev/packages/pigeon). No Rust toolchain, no FFI, no
global `initialize()`.

| Platform | Still images | Audio / video |
| --- | --- | --- |
| Android | `androidx.exifinterface` | `MediaMetadataRetriever` |
| iOS / macOS | ImageIO | AVFoundation |
| Windows | WIC | Media Foundation `IMFSourceReader` |
| Linux | in-tree JPEG APP1 / PNG tEXt | GStreamer `GstDiscoverer` |
| Web | Dart JPEG APP1 / PNG tEXt | Dart `moov` (`mvhd` / `tkhd`) |

Migrating from 1.x (the Rust/FFI version)? See [MIGRATION.md](MIGRATION.md).

---

## Installation

```yaml
dependencies:
  xue_hua_media_info: ^2.0.0
```

Requires **Flutter 3.44+** (Dart 3.12). There is no initialization call.

## Usage

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

`MediaInfo` is an `abstract final` class with five static methods:

| Method | Result | Notes |
| --- | --- | --- |
| `read` | `MediaMetadata` | Auto-detect; **one I/O** (native sniff + parse) |
| `readImage` | `ImageMetadata` | Non-image → `wrongKind` |
| `readAv` | `AvMetadata` (`VideoMetadata` \| `AudioMetadata`) | Image → `wrongKind` |
| `probe` | `MediaKind` | Header only |
| `readMotionPhoto` | `VideoMetadata` | No embedded MP4 → `trackNotFound` |

First-class fields (`make`, `PixelSize`, `GpsLocation`, …) are filled by the
native side. `extraTags` only holds leftover vendor tags; `pngText` is always
present on `ImageMetadata` (empty list means “none”, not failure).

Errors are `MediaInfoError` with stable string codes: `unsupported`,
`wrongKind`, `io`, `unsupportedFormat`, `exifNotFound`, `trackNotFound`,
`malformed`, `notFound`. Unsupported formats throw; they never succeed
silently.

## Capability matrix

**Immediate** = the `Future` completes with real fields. **Impossible** =
`unsupported` / `unsupportedFormat`.

| | Android | Darwin | Windows | Linux | Web |
| --- | --- | --- | --- | --- | --- |
| JPEG first-class EXIF | Immediate | Immediate | Immediate | Immediate (APP1) | Immediate (APP1) |
| PNG `pngText` | Immediate | Immediate | Immediate | Immediate | Immediate |
| HEIC / HEIF | API 28+ | Immediate | Immediate if a HEIF codec is installed, else `unsupportedFormat` | Impossible | Impossible |
| TIFF | Immediate | Immediate | Immediate | Impossible | Impossible |
| RAF / CR3 / IIQ | Impossible | Impossible | Impossible | Impossible | Impossible |
| MP4 / MOV / 3GP | Immediate | Immediate | Immediate | Immediate | Immediate (`moov`) |
| MKV / WEBM / MKA | Device-dependent | Limited | If a codec is installed | `GstDiscoverer` | Impossible |
| Motion Photo | Immediate | Immediate | Immediate | Immediate | Immediate |
| `MediaSource.file` | Immediate | Immediate | Immediate | Immediate | `unsupported` |

A container with a video track becomes `VideoMetadata`; audio-only becomes
`AudioMetadata`. Display size after rotation is filled by the native
platform’s usual convention.

## Architecture

```text
App  →  MediaInfo (façade)
     →  XueHuaMediaInfoPlatform
     →  MethodChannelXueHuaMediaInfo  →  Pigeon MediaInfoHostApi  →  native
     →  Web (pure Dart, replaces instance, no channel)
```

This repository is a Melos 8 workspace (`pubspec.yaml` `melos:` key; there is
no `melos.yaml`). Packages live under `packages/`.

## License

Apache License 2.0. See [LICENSE](LICENSE).
