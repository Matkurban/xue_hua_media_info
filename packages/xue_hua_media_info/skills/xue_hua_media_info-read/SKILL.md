---
name: xue_hua_media_info-read
description: >-
  Use when calling MediaInfo.read, readImage, readAv, probe, or readMotionPhoto;
  constructing MediaSource.file, MediaSource.bytes, or MediaSource.asset;
  switching on ImageMetadata, VideoMetadata, or AudioMetadata; or catching
  MediaInfoError.
---

# xue_hua_media_info

Cross-platform Flutter plugin for image EXIF and video/audio metadata. App code uses `MediaInfo` static methods only. There is no `initialize()`, no plugin instance, and nothing to dispose.

Every public type, constructor, field, getter, method, operator, and error code is in:

- [`references/api.md`](references/api.md) — signatures and fields
- [`references/errors.md`](references/errors.md) — `MediaInfoError` codes and when they throw

Read those files before inventing a type, field, method, or error code.

## Import

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';
```

Use this library import only. Do not import `xue_hua_media_info_platform_interface` or call `XueHuaMediaInfoPlatform` from app code.

## Choose a method

| Call | Returns | Use when |
| --- | --- | --- |
| `MediaInfo.read(source)` | `MediaMetadata` | Kind unknown; one I/O (sniff + parse) |
| `MediaInfo.readImage(source)` | `ImageMetadata` | Source is a still image; non-image → `codeWrongKind` |
| `MediaInfo.readAv(source)` | `AvMetadata` | Source is video or audio-only; image → `codeWrongKind` |
| `MediaInfo.probe(source)` | `MediaKind` | Header only; skip a full parse |
| `MediaInfo.readMotionPhoto(source)` | `VideoMetadata` | Pixel / Samsung Motion Photo trailer; none → `codeTrackNotFound` |

Call `readMotionPhoto` only after `ImageMetadata.hasMotionPhoto` is `true`.

## Sources

Construct sources with the factories, not the subtype constructors:

```dart
MediaSource.file('/absolute/path/photo.jpg')
MediaSource.bytes(bytes)
MediaSource.asset('assets/photo.jpg')
MediaSource.asset('assets/photo.jpg', package: 'other_pkg')
```

On **Web**, `MediaSource.file` throws `MediaInfoError.codeUnsupported`. Use `bytes` or `asset`.

`AssetSource.resolvedKey` is `key` when `package` is null, otherwise `packages/<package>/<key>`. The plugin resolves that prefix; do not prepend `packages/` yourself.

## Switch on sealed results

`MediaMetadata` is sealed: `ImageMetadata` | `VideoMetadata` | `AudioMetadata`.
`AvMetadata` is sealed: `VideoMetadata` | `AudioMetadata`.

Write an exhaustive `switch`. Read first-class fields (`make`, `size`, `gps`, `pngText`, …). `extraTags` holds leftover vendor tags only. `pngText` is always present on `ImageMetadata`; an empty list means none, not failure. Missing GPS is `gps == null`, not an empty `GpsLocation`.

`ImageMetadata` date fields are naive EXIF `DateTime` values (no timezone). `VideoMetadata.size` is display size after `rotationDegrees`.

## Errors

Catch `MediaInfoError`. Compare `error.code` to the `MediaInfoError.code*` constants (see [`references/errors.md`](references/errors.md)). Unsupported formats throw; they never succeed silently.

Formats that throw `codeUnsupportedFormat` on **every** platform: Fujifilm RAF, Canon CR3, Phase One IIQ.

HEIC/HEIF and TIFF throw `codeUnsupportedFormat` on **Linux** and **Web**. Android HEIC needs API 28+. Windows HEIC needs a HEIF codec.

## Examples

### Auto-detect

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> printMeta(String path) async {
  try {
    final meta = await MediaInfo.read(MediaSource.file(path));
    switch (meta) {
      case ImageMetadata(:final make, :final size, :final gps, :final hasMotionPhoto):
        print('$make $size $gps motion=$hasMotionPhoto');
        if (hasMotionPhoto) {
          final clip = await MediaInfo.readMotionPhoto(MediaSource.file(path));
          print(clip.duration);
        }
      case VideoMetadata(:final duration, :final size):
        print('$size $duration');
      case AudioMetadata(:final duration, :final sampleRate):
        print('$duration $sampleRate');
    }
  } on MediaInfoError catch (error) {
    if (error.code == MediaInfoError.codeNotFound) {
      print('missing: ${error.message}');
      return;
    }
    rethrow;
  }
}
```

### Known image / asset

```dart
final image = await MediaInfo.readImage(
  const MediaSource.asset('assets/photo.jpg'),
);
for (final chunk in image.pngText) {
  print('${chunk.key}=${chunk.value}');
}
```

### Probe then read

```dart
final kind = await MediaInfo.probe(MediaSource.bytes(bytes));
final meta = switch (kind) {
  MediaKind.image => await MediaInfo.readImage(MediaSource.bytes(bytes)),
  MediaKind.video || MediaKind.audio => await MediaInfo.readAv(
    MediaSource.bytes(bytes),
  ),
};
```
