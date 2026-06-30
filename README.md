# xue_hua_media_info

**English** | [中文](README.zh-CN.md)

Flutter FFI plugin for reading **image EXIF** and **video/audio metadata**, powered by [nom-exif](https://github.com/mindeng/nom-exif) 3.6.1 and [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/).

---

## Features

| Feature | Description |
|---------|-------------|
| Pure Rust backend | No FFmpeg, libexif, or system dependencies |
| Unified API | One entry point for images and video/audio |
| Sync + Async | Blocking and `Future`-based reads |
| File + bytes | Read from path or in-memory buffer |
| Motion Photo | Pixel / Samsung embedded MP4 support |
| GPS | Latitude, longitude, altitude in results |
| Batch parsing | Reusable `MediaMetadataParser` with buffer reuse |
| Convenience getters | `exif.make`, `track.durationMs`, etc. |

---

## Supported formats

### Images

JPEG, PNG, HEIC/HEIF, AVIF, TIFF, Phase One IIQ, Fujifilm RAF, Canon CR3

### Video / audio

MP4, MOV, 3GP, MKV, WEBM, MKA

### Special

Pixel / Samsung **Motion Photo** — JPEG with an embedded MP4 video trailer

---

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  xue_hua_media_info: ^1.1.0
```

Supported platforms: **Android, iOS, macOS, Linux, Windows** (FFI plugin).

---

## Getting started

### 1. Initialize

Call once before any other API:

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await XueHuaMediaInfo.initialize();
}
```

### 2. Read metadata

```dart
// Auto-detect image or video from file
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

// Read from bytes (asset, network, memory)
final exif = XueHuaMediaInfo.readImageExifFromBytes(data: jpegBytes);
final track = XueHuaMediaInfo.readVideoMetadataFromBytes(data: movBytes);

// Detect type only (fast, no full parse)
final kind = XueHuaMediaInfo.detectMediaKindFromBytes(data: bytes);
// MediaKind.image or MediaKind.videoOrAudio
```

### 3. Async reads

Every sync method has an `Async` counterpart returning `Future<T>`:

```dart
final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: jpegBytes);
final track = await XueHuaMediaInfo.readVideoMetadataFromFileAsync(path: videoPath);
```

Use **sync** for simple scripts or when already on a background isolate.  
Use **async** in Flutter UI code to avoid blocking during file I/O.

---

## API reference

All public methods live on [`XueHuaMediaInfo`](lib/src/xue_hua_media_info.dart) and [`MediaMetadataParser`](lib/src/xue_hua_media_info.dart).  
Each method has doc comments in source code.

### `XueHuaMediaInfo` — one-shot readers

| Method | Description |
|--------|-------------|
| `initialize()` | Initialize native Rust library (once) |
| `readMediaMetadataFromFile` / `FromBytes` | Auto-detect and read image EXIF or video track |
| `readImageExifFromFile` / `FromBytes` | Read image EXIF (eager — all tags upfront) |
| `readImageExifLazyFromFile` / `FromBytes` | Read image EXIF (lazy — per-tag errors preserved) |
| `readVideoMetadataFromFile` / `FromBytes` | Read video/audio track metadata |
| `readFullImageMetadataFromFile` / `FromBytes` | EXIF + format extras (e.g. PNG tEXt) |
| `detectMediaKindFromFile` / `FromBytes` | Detect image vs video/audio (header only) |
| `readEmbeddedVideoFromFile` / `FromBytes` | Extract embedded MP4 from Motion Photo |
| `createParser()` | Create reusable batch parser |

**Async variants:** append `Async` to every method above (e.g. `readImageExifFromBytesAsync`).

### `MediaMetadataParser` — batch parsing

Create once with `XueHuaMediaInfo.createParser()`, then reuse for many files:

```dart
final parser = XueHuaMediaInfo.createParser();

for (final path in imagePaths) {
  final exif = parser.parseImageExifFromFile(path: path);
  print(exif.make);
}

for (final path in videoPaths) {
  final track = await parser.parseVideoMetadataFromFileAsync(path: path);
  print(track.durationMs);
}
```

| Method | Description |
|--------|-------------|
| `parseImageExifFromFile` / `FromBytes` | Parse image EXIF |
| `parseVideoMetadataFromFile` / `FromBytes` | Parse video/audio track |
| `parseFullImageMetadataFromFile` / `FromBytes` | Parse EXIF + format extras |
| `parseEmbeddedVideoFromFile` / `FromBytes` | Parse Motion Photo embedded video |

Each has an `Async` counterpart.

**Note:** `MediaMetadataParser` does not include lazy EXIF or auto-detect methods. Use `XueHuaMediaInfo` for those.

---

## Data types

### `ImageExif`

| Field | Description |
|-------|-------------|
| `entries` | List of EXIF tags (`MetadataEntry`) |
| `gps` | GPS location, if present |
| `hasEmbeddedVideo` | True for Motion Photos |
| `parseErrors` | Per-tag errors (lazy mode) |

### `VideoTrack`

| Field | Description |
|-------|-------------|
| `entries` | Track metadata tags |
| `gps` | GPS from video metadata |

Common tags include `Width`, `Height`, `DurationMs`, `Make`, `Model`.

### `MediaMetadata`

Union of image or video result from auto-detect reads:

```dart
metadata.isImage       // bool
metadata.isVideo       // bool
metadata.imageExifOrNull
metadata.videoTrackOrNull
```

### `FullImageMetadata`

| Field | Description |
|-------|-------------|
| `exif` | Parsed EXIF, if any |
| `pngTextChunks` | PNG tEXt key/value pairs |

### `MediaKind`

- `MediaKind.image` — JPEG, PNG, HEIC, etc.
- `MediaKind.videoOrAudio` — MP4, MOV, MKV, etc.

---

## Convenience extensions

Imported automatically via `package:xue_hua_media_info/xue_hua_media_info.dart`.

### `VideoTrack`

```dart
track.durationMs    // int? — milliseconds
track.duration      // Duration?
track.width         // int? — pixels
track.height        // int?
track.make          // String? — manufacturer
track.model         // String? — device model
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
entries.doubleValue('ExposureTime')
```

Prefer `ImageExif.gps` / `VideoTrack.gps` for location data instead of flat entries.

### `FullImageMetadata`

```dart
full.pngText('Comment')  // PNG tEXt lookup
```

---

## Motion Photo

Some JPEGs embed a short MP4 (Google Pixel, Samsung). Works from **file path, bytes, sync, and async**:

```dart
// From file
final exif = XueHuaMediaInfo.readImageExifFromFile(path: path);
if (exif.hasEmbeddedVideo) {
  final video = XueHuaMediaInfo.readEmbeddedVideoFromFile(path: path);
  print('Embedded duration: ${video.durationMs} ms');
}

// From bytes (asset, network)
final video = await XueHuaMediaInfo.readEmbeddedVideoFromBytesAsync(data: jpegBytes);
print('Embedded duration: ${video.durationMs} ms');
```

---

## Error handling

Failures throw `MediaInfoError` (implements `FrbException`):

```dart
try {
  final exif = XueHuaMediaInfo.readImageExifFromBytes(data: bytes);
} on MediaInfoError catch (e) {
  print('${e.code}: ${e.message}');
}
```

| Code | Meaning |
|------|---------|
| `MediaInfoErrorCode.io` | File or I/O failure |
| `MediaInfoErrorCode.unsupportedFormat` | Unrecognized or unsupported format |
| `MediaInfoErrorCode.exifNotFound` | No EXIF data in image |
| `MediaInfoErrorCode.trackNotFound` | No video/audio track (or no Motion Photo trailer) |
| `MediaInfoErrorCode.malformed` | Corrupt or invalid metadata |
| `MediaInfoErrorCode.unexpectedEof` | Unexpected end of file |
| `MediaInfoErrorCode.other` | Other errors |

---

## Sync vs async

| | Sync | Async |
|---|------|-------|
| Return type | `T` | `Future<T>` |
| File I/O | Blocking on calling isolate | Non-blocking (tokio) |
| Use case | Scripts, isolates, small reads | Flutter UI, `async`/`await` |
| Naming | `readImageExifFromBytes` | `readImageExifFromBytesAsync` |

Both paths share the same Rust/nom-exif backend and return identical types.

---

## Eager vs lazy EXIF

| | Eager (`readImageExifFrom*`) | Lazy (`readImageExifLazyFrom*`) |
|---|------------------------------|----------------------------------|
| Parse strategy | All tags parsed immediately | Tags parsed on demand |
| Errors | May fail entire read | Collected in `parseErrors` (including GPS parse failures) |
| Best for | Most apps needing full EXIF | Damaged/partial EXIF, debugging |

---

## Example app

```bash
cd example && flutter run
```

The example loads sample JPEG and MOV assets and displays Make, Model, dimensions, and duration.

---

## Development

### Regenerate FRB bindings

After changing the Rust API in `rust/src/api/`:

```bash
flutter_rust_bridge_codegen generate
```

### Run tests

```bash
# Dart unit tests
flutter test test/

# Rust unit tests
cd rust && cargo test

# Integration tests (macOS example)
cd example && flutter test integration_test/simple_test.dart -d macos

# Static analysis
dart analyze
```

### Project layout

```
lib/
  xue_hua_media_info.dart          # Public exports
  src/
    xue_hua_media_info.dart        # Facade API
    extensions/
      metadata_extensions.dart     # Convenience getters
    rust/                          # FRB generated (do not edit)
rust/
  src/api/
    reader.rs / reader_async.rs    # One-shot read API
    parser.rs / parser_async.rs    # Reusable parser API
    types.rs                       # DTO types for FRB
  src/convert.rs                   # nom-exif → DTO conversion
  src/embedded_video.rs            # Motion Photo embedded track extraction
```

---

## License

MIT (this plugin). [nom-exif](https://github.com/mindeng/nom-exif) is also MIT-licensed.
