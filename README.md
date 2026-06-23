# xue_hua_media_info

Flutter FFI plugin for reading image and video metadata, powered by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/).

## Supported formats

**Images:** JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3

**Video / audio:** MP4, MOV, 3GP, MKV, WEBM, MKA

**Special:** Pixel / Samsung Motion Photo (JPEG with embedded MP4)

## Setup

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

await RustLib.init();
```

## Quick start

```dart
// Auto-detect image or video from a file path
final metadata = readMediaMetadataFromFile(path: '/path/to/media.jpg');

// Read image EXIF from bytes
final exif = readImageExifFromBytes(data: jpegBytes);

// Read video / audio track metadata
final track = readVideoMetadataFromBytes(data: mp4Bytes);

// Detect media type
final kind = detectMediaKindFromBytes(data: bytes); // MediaKindDto.image or .videoOrAudio

// Full image metadata (EXIF + PNG tEXt chunks)
final full = readFullImageMetadataFromFile(path: '/path/to/image.png');

// Motion Photo embedded video
if (exif.hasEmbeddedVideo) {
  final embedded = readEmbeddedVideoFromFile(path: motionPhotoPath);
}

// Reusable parser for batch processing
final parser = createMediaMetadataParser();
final batchExif = parseImageExifFromBytes(parser: parser, data: jpegBytes);
```

## API overview

| Function | Description |
|----------|-------------|
| `readMediaMetadataFromFile` / `FromBytes` | Auto-detect and read image EXIF or video track metadata |
| `readImageExifFromFile` / `FromBytes` | Read image EXIF (eager) |
| `readImageExifLazyFromFile` / `FromBytes` | Read image EXIF (lazy, preserves per-tag parse errors) |
| `readVideoMetadataFromFile` / `FromBytes` | Read video / audio track metadata |
| `readFullImageMetadataFromFile` / `FromBytes` | EXIF plus format-specific metadata (e.g. PNG tEXt) |
| `detectMediaKindFromFile` / `FromBytes` | Detect whether input is image or video/audio |
| `readEmbeddedVideoFromFile` / `FromBytes` | Extract embedded MP4 metadata from Motion Photos |
| `createMediaMetadataParser` | Create a reusable parser for batch reads |
| `parseImageExifFromFile` / `FromBytes` | Parse image EXIF using a reusable parser |
| `parseVideoMetadataFromFile` / `FromBytes` | Parse video metadata using a reusable parser |
| `parseFullImageMetadataFromFile` / `FromBytes` | Parse full image metadata using a reusable parser |
| `parseEmbeddedVideoFromFile` / `FromBytes` | Parse embedded video using a reusable parser |

Errors are thrown as `MediaInfoError` (implements `FrbException`).

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
