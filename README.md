# xue_hua_media_info

Flutter FFI plugin for reading image and video metadata, powered by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/).

## Supported formats

**Images:** JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3

**Video / audio:** MP4, MOV, 3GP, MKV, WEBM, MKA

**Special:** Pixel / Samsung Motion Photo (JPEG with embedded MP4)

## Setup

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

await XueHuaMediaInfo.initialize();
```

## Quick start

```dart
// Auto-detect image or video from a file path
final metadata = XueHuaMediaInfo.readMediaMetadataFromFile(path: '/path/to/media.jpg');

// Read image EXIF from bytes
final exif = XueHuaMediaInfo.readImageExifFromBytes(data: jpegBytes);

// Read video / audio track metadata
final track = XueHuaMediaInfo.readVideoMetadataFromBytes(data: mp4Bytes);

// Detect media type
final kind = XueHuaMediaInfo.detectMediaKindFromBytes(data: bytes); // MediaKind.image or .videoOrAudio

// Full image metadata (EXIF + PNG tEXt chunks)
final full = XueHuaMediaInfo.readFullImageMetadataFromFile(path: '/path/to/image.png');

// Convenience getters on VideoTrack / ImageExif
print(track.durationMs);        // milliseconds
print(track.duration);          // Duration
print(track.width);
print(track.height);
print(exif.make);
print(exif.model);
print(exif.dateTimeOriginal);

// Auto-detected metadata helpers
if (metadata.isVideo) {
  print(metadata.videoTrackOrNull?.durationMs);
}

// Motion Photo embedded video
if (exif.hasEmbeddedVideo) {
  final embedded = XueHuaMediaInfo.readEmbeddedVideoFromFile(path: motionPhotoPath);
  print(embedded.durationMs);
}

// Reusable parser for batch processing
final parser = XueHuaMediaInfo.createParser();
final batchExif = parser.parseImageExifFromBytes(data: jpegBytes);
```

## Async API

Every sync method has an async counterpart with an `Async` suffix returning `Future<T>`:

```dart
// Non-blocking reads from bytes or file paths
final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: jpegBytes);
final track = await XueHuaMediaInfo.readVideoMetadataFromFileAsync(path: videoPath);

// Reusable parser with async methods
final parser = XueHuaMediaInfo.createParser();
final batchExif = await parser.parseImageExifFromBytesAsync(data: jpegBytes);
```

Use sync methods for simple, blocking reads; use async methods when integrating with Flutter `async`/`await` workflows or when reading from disk without blocking the UI isolate.

## API overview

| Method | Description |
|--------|-------------|
| `XueHuaMediaInfo.readMediaMetadataFromFile/FromBytes` | Auto-detect and read image EXIF or video track metadata |
| `XueHuaMediaInfo.readImageExifFromFile/FromBytes` | Read image EXIF (eager) |
| `XueHuaMediaInfo.readImageExifLazyFromFile/FromBytes` | Read image EXIF (lazy, preserves per-tag parse errors) |
| `XueHuaMediaInfo.readVideoMetadataFromFile/FromBytes` | Read video / audio track metadata |
| `XueHuaMediaInfo.readFullImageMetadataFromFile/FromBytes` | EXIF plus format-specific metadata (e.g. PNG tEXt) |
| `XueHuaMediaInfo.detectMediaKindFromFile/FromBytes` | Detect whether input is image or video/audio |
| `XueHuaMediaInfo.readEmbeddedVideoFromFile/FromBytes` | Extract embedded MP4 metadata from Motion Photos |
| `XueHuaMediaInfo.createParser()` | Create a reusable parser for batch reads |
| `MediaMetadataParser.parseImageExifFromFile/FromBytes` | Parse image EXIF using a reusable parser |
| `MediaMetadataParser.parseVideoMetadataFromFile/FromBytes` | Parse video metadata using a reusable parser |
| `MediaMetadataParser.parseFullImageMetadataFromFile/FromBytes` | Parse full image metadata using a reusable parser |
| `MediaMetadataParser.parseEmbeddedVideoFromFile/FromBytes` | Parse embedded video using a reusable parser |
| `XueHuaMediaInfo.*Async` / `MediaMetadataParser.*Async` | Async variants of all reader and parser methods above |

Errors are thrown as `MediaInfoError` (implements `FrbException`).

## Convenience getters

Extensions on result types (imported automatically):

| Type | Getters |
|------|---------|
| `VideoTrack` | `durationMs`, `duration`, `width`, `height`, `make`, `model`, `software`, `author`, `createDate` |
| `ImageExif` | `make`, `model`, `software`, `width`, `height`, `orientation`, `dateTimeOriginal`, `createDate`, `modifyDate` |
| `MediaMetadata` | `isImage`, `isVideo`, `imageExifOrNull`, `videoTrackOrNull` |
| `List<MetadataEntry>` | `entryNamed`, `stringValue`, `intValue`, `doubleValue` |
| `FullImageMetadata` | `pngText(key)` |

## Development

Regenerate bindings after changing Rust API:

```bash
flutter_rust_bridge_codegen generate
```

Run example app:

```bash
cd example && flutter run
```

Run integration tests:

```bash
cd example && flutter test integration_test/simple_test.dart -d macos
```

Run Rust unit tests:

```bash
cd rust && cargo test
```

## License

MIT (plugin). nom-exif is also MIT-licensed.
