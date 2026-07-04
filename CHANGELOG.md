## 1.1.1

- Optimized initialization

## 1.1.0

### Bug fixes

* Fix Motion Photo embedded video extraction from **bytes** and **async** paths (`readEmbeddedVideoFromBytes*`,
  `parseEmbeddedVideoFrom*`) — previously only sync file path worked
* Fix Dart convenience getters (`make`, `width`, `durationMs`, etc.) returning null when Rust populates `rawValue`
* Lazy EXIF now records GPS parse failures in `parseErrors` instead of silently dropping them
* Serialize `u64` EXIF values above `i64::MAX` as text to avoid integer overflow on the Dart side

## 1.0.1

- Update freezed to the latest version

## 1.0.0

First public release.

### Core

* Flutter FFI plugin backed by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1
  and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) 2.12 — pure Rust, no FFmpeg or libexif
* Unified entry point [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) with `initialize()` for one-time native setup
* Supports **Android, iOS, macOS, Linux, Windows**

### Metadata reading

* **Images:** JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3
* **Video / audio:** MP4, MOV, 3GP, MKV, WEBM, MKA
* Auto-detect media type and read image EXIF or video track metadata (`readMediaMetadataFrom*`)
* Read from **file path** or **in-memory bytes**
* Eager EXIF (`readImageExifFrom*`) and lazy EXIF with per-tag error collection (`readImageExifLazyFrom*`)
* Full image metadata including PNG tEXt chunks (`readFullImageMetadataFrom*`)
* Fast media kind detection without full parse (`detectMediaKindFrom*`)
* GPS latitude, longitude, and altitude in image and video results

### Motion Photo

* Detect embedded MP4 in Pixel / Samsung Motion Photos (`ImageExif.hasEmbeddedVideo`)
* Extract embedded video track metadata (`readEmbeddedVideoFrom*`)

### Sync & async API

* **14 sync** one-shot reader methods on `XueHuaMediaInfo`
* **14 async** counterparts with `Async` suffix returning `Future<T>` (non-blocking I/O via tokio)

### Batch parsing

* Reusable [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart) via `XueHuaMediaInfo.createParser()` with internal
  buffer reuse
* **8 sync** + **8 async** parser methods for EXIF, video, full image, and embedded video

### Convenience extensions

* `VideoTrack`: `durationMs`, `duration`, `width`, `height`, `make`, `model`, etc.
* `ImageExif`: `make`, `model`, `width`, `height`, `orientation`, `dateTimeOriginal`, etc.
* `MediaMetadata`: `isImage`, `isVideo`, `imageExifOrNull`, `videoTrackOrNull`
* `List<MetadataEntry>`: `entryNamed`, `stringValue`, `intValue`, `doubleValue`
* `FullImageMetadata`: `pngText(key)`

### Documentation

* Doc comments on all public API methods and extension getters
* README with API reference, examples, and development guide

### Error handling

* Structured errors via `MediaInfoError` with `MediaInfoErrorCode` and message
