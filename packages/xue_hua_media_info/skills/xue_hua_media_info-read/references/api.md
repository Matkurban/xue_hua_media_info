# Public API

Authoritative signatures for `package:xue_hua_media_info`. Types are re-exported from `xue_hua_media_info_platform_interface`; app code imports `package:xue_hua_media_info/xue_hua_media_info.dart` only.

Not exported (do not use from app code): `XueHuaMediaInfoPlatform`, `MethodChannelXueHuaMediaInfo`, Pigeon message types.

---

## `MediaInfo`

```dart
abstract final class MediaInfo
```

No public constructor. No instance fields. No `initialize()`. Each method is a one-shot `MediaSource` → `Future`.

### `MediaInfo.read`

```dart
static Future<MediaMetadata> read(MediaSource source)
```

Auto-detects the media kind and reads metadata in a **single I/O**. Returns `ImageMetadata`, `VideoMetadata`, or `AudioMetadata`. Throws `MediaInfoError` when the source cannot be read or parsed.

### `MediaInfo.readImage`

```dart
static Future<ImageMetadata> readImage(MediaSource source)
```

Reads still-image metadata (EXIF plus format extras such as PNG tEXt). Throws `MediaInfoError` with `MediaInfoError.codeWrongKind` when `source` is not an image.

### `MediaInfo.readAv`

```dart
static Future<AvMetadata> readAv(MediaSource source)
```

Reads a video or audio-only container. Switch on the result: `VideoMetadata` or `AudioMetadata`. Throws `MediaInfoError.codeWrongKind` when `source` is an image.

### `MediaInfo.probe`

```dart
static Future<MediaKind> probe(MediaSource source)
```

Inspects the file header only (no full metadata parse). Returns `MediaKind.image`, `MediaKind.video`, or `MediaKind.audio`.

### `MediaInfo.readMotionPhoto`

```dart
static Future<VideoMetadata> readMotionPhoto(MediaSource source)
```

Extracts embedded MP4 metadata from a Pixel / Samsung Motion Photo. Throws `MediaInfoError.codeTrackNotFound` when no trailer is present. Call this after `ImageMetadata.hasMotionPhoto` is `true`.

---

## `MediaSource`

```dart
sealed class MediaSource {
  const MediaSource();
  const factory MediaSource.file(String path) = FileSource;
  const factory MediaSource.bytes(List<int> data) = BytesSource;
  const factory MediaSource.asset(String key, {String? package}) = AssetSource;
}
```

Type-safe description of where media bytes come from. Use the three factory constructors.

- `file`: local filesystem path. `path` is the absolute path of the media file.
- `bytes`: in-memory buffer (already-loaded assets, downloads, pasted bytes).
- `asset`: Flutter asset key as declared in `pubspec.yaml`. `package` is the owning package name when the asset belongs to another package.

### `FileSource`

```dart
final class FileSource extends MediaSource {
  const FileSource(this.path);
  final String path; // absolute path of the media file
  @override
  bool operator ==(Object other); // other is FileSource && other.path == path
  @override
  int get hashCode; // Object.hash(runtimeType, path)
  @override
  String toString(); // 'MediaSource.file($path)'
}
```

Prefer `MediaSource.file(path)`. On Web this source throws `MediaInfoError.codeUnsupported`.

### `BytesSource`

```dart
final class BytesSource extends MediaSource {
  const BytesSource(this.data);
  final List<int> data; // raw media bytes
  @override
  bool operator ==(Object other); // other is BytesSource && other.data == data
  @override
  int get hashCode; // Object.hash(runtimeType, Object.hashAll(data))
  @override
  String toString(); // 'MediaSource.bytes(${data.length} bytes)'
}
```

Prefer `MediaSource.bytes(data)`. `==` uses `List.==` on `data` (identity for a typical growable list).

### `AssetSource`

```dart
final class AssetSource extends MediaSource {
  const AssetSource(this.key, {this.package});
  final String key;       // asset key declared in pubspec.yaml
  final String? package;  // owning package name when the asset is from another package
  String get resolvedKey; // key, or 'packages/$package/$key' when package is set
  @override
  bool operator ==(Object other); // other is AssetSource && other.key == key && other.package == package
  @override
  int get hashCode; // Object.hash(runtimeType, key, package)
  @override
  String toString(); // 'MediaSource.asset($key, package: $package)'
}
```

Prefer `MediaSource.asset(key, package: …)`. Pass the pubspec key; `resolvedKey` already includes the `packages/<package>/` prefix when needed.

---

## `MediaKind`

```dart
enum MediaKind {
  image, // still image (JPEG, PNG, HEIC, TIFF, …)
  video, // container with at least one video track
  audio, // audio-only container
}
```

Returned by `MediaInfo.probe` and by `MediaMetadata.kind`. A container with a video track is `video`; audio-only is `audio`.

---

## `MediaMetadata`

```dart
sealed class MediaMetadata {
  const MediaMetadata();
  MediaKind get kind; // discriminator matching the runtime type
}
```

Result of reading media metadata. Switch on the sealed subtypes: `ImageMetadata`, `VideoMetadata`, `AudioMetadata`.

No `==`, `hashCode`, or `toString` override on the base class.

---

## `ImageMetadata`

```dart
@immutable
final class ImageMetadata extends MediaMetadata {
  const ImageMetadata({
    this.make,
    this.model,
    this.software,
    this.size,
    this.orientation,
    this.dateTimeOriginal,
    this.dateTimeDigitized,
    this.dateTimeModified,
    this.gps,
    this.hasMotionPhoto = false,
    this.pngText = const [],
    this.extraTags = const [],
  });

  final String? make;                 // camera / scanner manufacturer
  final String? model;                // camera model
  final String? software;             // firmware or editor software
  final PixelSize? size;              // pixel width and height, when known
  final int? orientation;             // EXIF orientation (1–8), when present
  final DateTime? dateTimeOriginal;   // capture time (naive local / EXIF, no timezone)
  final DateTime? dateTimeDigitized;  // digitization time
  final DateTime? dateTimeModified;   // file modification time from metadata
  final GpsLocation? gps;             // GPS; missing GPS is null, not an empty object
  final bool hasMotionPhoto;          // whether this JPEG looks like a Pixel / Samsung Motion Photo
  final List<PngTextChunk> pngText;   // PNG tEXt chunks; empty when not a PNG or has none
  final List<MetadataTag> extraTags;  // tags not lifted into first-class fields

  @override
  MediaKind get kind; // MediaKind.image
  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

`==` compares every field; `pngText` and `extraTags` use `listEquals`. `hashCode` is `Object.hash` of the scalar fields plus `Object.hashAll(pngText)` and `Object.hashAll(extraTags)`. No `toString` override.

`pngText`: an empty list is success, not a missing-metadata error. `hasMotionPhoto` default is `false`.

---

## `AvMetadata`

```dart
sealed class AvMetadata extends MediaMetadata {
  const AvMetadata();
  Duration? get duration;   // duration, when the container reports one
  String? get make;         // device manufacturer, when tagged
  String? get model;        // device model, when tagged
  GpsLocation? get gps;     // GPS, when present
}
```

Shared fields of audio/video containers. Switch on `VideoMetadata` | `AudioMetadata`. No `==` / `hashCode` / `toString` on this class.

---

## `VideoMetadata`

```dart
@immutable
final class VideoMetadata extends AvMetadata {
  const VideoMetadata({
    this.duration,
    this.size,
    this.bitrate,
    this.rotationDegrees,
    this.make,
    this.model,
    this.gps,
    this.extraTags = const [],
  });

  @override
  final Duration? duration;
  final PixelSize? size;           // display size after applying rotationDegrees, when known
  final int? bitrate;              // bits per second, when known
  final int? rotationDegrees;      // 0 / 90 / 180 / 270, when tagged
  @override
  final String? make;
  @override
  final String? model;
  @override
  final GpsLocation? gps;
  final List<MetadataTag> extraTags; // leftover tags

  @override
  MediaKind get kind; // MediaKind.video
  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

`==` compares `duration`, `size`, `bitrate`, `rotationDegrees`, `make`, `model`, `gps`, and `listEquals` on `extraTags`. `hashCode` is `Object.hash` of those scalars plus `Object.hashAll(extraTags)`. No `toString` override.

---

## `AudioMetadata`

```dart
@immutable
final class AudioMetadata extends AvMetadata {
  const AudioMetadata({
    this.duration,
    this.bitrate,
    this.sampleRate,
    this.channelCount,
    this.make,
    this.model,
    this.gps,
    this.extraTags = const [],
  });

  @override
  final Duration? duration;
  final int? bitrate;              // bits per second
  final int? sampleRate;           // Hz
  final int? channelCount;         // channel count
  @override
  final String? make;
  @override
  final String? model;
  @override
  final GpsLocation? gps;
  final List<MetadataTag> extraTags;

  @override
  MediaKind get kind; // MediaKind.audio
  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

No `size` or `rotationDegrees` (those exist only on `VideoMetadata`). `==` compares `duration`, `bitrate`, `sampleRate`, `channelCount`, `make`, `model`, `gps`, and `listEquals` on `extraTags`. `hashCode` is `Object.hash` of those plus `Object.hashAll(extraTags)`. No `toString` override.

---

## `GpsLocation`

```dart
@immutable
final class GpsLocation {
  const GpsLocation({
    required this.latitude,
    required this.longitude,
    this.altitudeMeters,
  });

  final double latitude;         // decimal degrees, positive north
  final double longitude;        // decimal degrees, positive east
  final double? altitudeMeters;  // metres, when present; missing is null

  @override
  bool operator ==(Object other);
  @override
  int get hashCode; // Object.hash(latitude, longitude, altitudeMeters)
  @override
  String toString();
}
```

`==` compares `latitude`, `longitude`, and `altitudeMeters`. `toString()` is `GpsLocation($latitude, $longitude)` or `GpsLocation($latitude, $longitude, ${altitudeMeters}m)` when altitude is present.

---

## `PixelSize`

```dart
@immutable
final class PixelSize {
  const PixelSize({required this.width, required this.height});
  final int width;   // pixels
  final int height;  // pixels
  @override
  bool operator ==(Object other); // other is PixelSize && other.width == width && other.height == height
  @override
  int get hashCode; // Object.hash(width, height)
  @override
  String toString(); // '${width}x$height'
}
```

Integer pixel dimensions.

---

## `PngTextChunk`

```dart
@immutable
final class PngTextChunk {
  const PngTextChunk({required this.key, required this.value});
  final String key;    // chunk keyword
  final String value;  // chunk text
  @override
  bool operator ==(Object other); // other is PngTextChunk && other.key == key && other.value == value
  @override
  int get hashCode; // Object.hash(key, value)
  @override
  String toString(); // 'PngTextChunk($key=$value)'
}
```

A PNG `tEXt` (or equivalent) key/value chunk.

---

## `MetadataTag`

```dart
@immutable
final class MetadataTag {
  const MetadataTag({
    required this.name,
    required this.displayValue,
    this.stringValue,
    this.intValue,
    this.doubleValue,
  });

  final String name;           // canonical or native tag name
  final String displayValue;   // human-readable value
  final String? stringValue;   // typed string, when the native API exposed one
  final int? intValue;         // typed integer, when parseable
  final double? doubleValue;   // typed floating-point value, when parseable

  @override
  bool operator ==(Object other);
  @override
  int get hashCode; // Object.hash(name, displayValue, stringValue, intValue, doubleValue)
  @override
  String toString(); // 'MetadataTag($name=$displayValue)'
}
```

A vendor or leftover tag that was not lifted into a first-class field. `==` compares all five fields.

---

## `MediaInfoError`

See [`errors.md`](errors.md) for codes and throw sites.

```dart
@immutable
class MediaInfoError implements Exception {
  const MediaInfoError({
    required this.code,
    required this.message,
    this.details,
  });

  static const String codeUnsupported = 'unsupported';
  static const String codeWrongKind = 'wrongKind';
  static const String codeIo = 'io';
  static const String codeUnsupportedFormat = 'unsupportedFormat';
  static const String codeExifNotFound = 'exifNotFound';
  static const String codeTrackNotFound = 'trackNotFound';
  static const String codeMalformed = 'malformed';
  static const String codeNotFound = 'notFound';

  final String code;      // stable machine-readable error code
  final String message;   // human-readable error description
  final Object? details;  // optional platform-specific diagnostic payload

  @override
  bool operator ==(Object other);
  @override
  int get hashCode; // Object.hash(code, message, details)
  @override
  String toString();
}
```

`==` compares `code`, `message`, and `details`. `toString()` is `MediaInfoError($code): $message` and appends ` — $details` when `details` is not null.

Compare `error.code` to the `code*` constants, not to ad-hoc string literals.
