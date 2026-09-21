# `MediaInfoError` codes

Catch `MediaInfoError`. Compare `error.code` to the `MediaInfoError.code*` constants below. `message` is human-readable; `details` is an optional platform diagnostic payload.

Unsupported formats throw; they never succeed silently with empty metadata.

## Constants

| Constant | String value | Meaning |
| --- | --- | --- |
| `MediaInfoError.codeUnsupported` | `unsupported` | The operation is not supported on this platform. |
| `MediaInfoError.codeWrongKind` | `wrongKind` | The source is the wrong media kind for this method (e.g. `readImage` on a video). |
| `MediaInfoError.codeIo` | `io` | A file or I/O failure. |
| `MediaInfoError.codeUnsupportedFormat` | `unsupportedFormat` | Unrecognized or unsupported container / codec. |
| `MediaInfoError.codeExifNotFound` | `exifNotFound` | The image has no EXIF (or equivalent) metadata. |
| `MediaInfoError.codeTrackNotFound` | `trackNotFound` | No video/audio track, or no Motion Photo embedded MP4. |
| `MediaInfoError.codeMalformed` | `malformed` | Corrupt or invalid metadata. |
| `MediaInfoError.codeNotFound` | `notFound` | The referenced resource does not exist. |

## When each code throws

### `codeUnsupported`

- Web: `MediaSource.file` (`message`: `MediaSource.file is not supported on Web.`). Use `bytes` or `asset`.
- Native: unknown / unhandled source kind in the Pigeon payload.

### `codeWrongKind`

- `MediaInfo.readImage` when the source is not an image (`Source is not an image.`).
- `MediaInfo.readAv` when the source is an image (`Source is an image, not an AV container.`). Also thrown on the Dart method channel if a non-`AvMetadata` payload comes back.

### `codeIo`

- File open/read/write failures (Android, Linux temp-file wrap, Windows `IStream` wrap, invalid path).

### `codeUnsupportedFormat`

- Unrecognized media header.
- Fujifilm **RAF**, Canon **CR3**, Phase One **IIQ**, and other RAW: every platform.
- HEIC/HEIF: Linux and Web always; Android below API 28; Windows when no HEIF codec is installed.
- TIFF: Linux and Web.
- Linux image path that is not JPEG or PNG.
- Native decoder / discoverer failure (ImageIO, WIC, Media Foundation, GStreamer, Android retriever).
- Web Dart parsers when the buffer is not JPEG APP1, PNG, or MP4/MOV `moov`.

### `codeExifNotFound`

Stable public code: the image has no EXIF (or equivalent). Handle it. Current native and Web implementations more often return `ImageMetadata` with null first-class fields than throw this code.

### `codeTrackNotFound`

- `MediaInfo.readMotionPhoto` when no embedded MP4 trailer is present (`No embedded Motion Photo video.`) or the trailer is not a video (`Embedded trailer is not a video.`).
- AV parse when the container has no video or audio track (`No video or audio track.`).

### `codeMalformed`

- Corrupt media the platform cannot parse.
- Dart method-channel decode when the Pigeon payload kind does not include the matching `image` / `video` / `audio` message (`Image payload missing.`, `Video payload missing.`, `Audio payload missing.`).

### `codeNotFound`

- Local file does not exist.
- Flutter asset key missing (`Asset not found: …`).
- Missing path, byte payload, or asset key in the encoded source.

## Handling

```dart
try {
  final meta = await MediaInfo.read(source);
} on MediaInfoError catch (error) {
  switch (error.code) {
    case MediaInfoError.codeNotFound:
    case MediaInfoError.codeUnsupported:
    case MediaInfoError.codeUnsupportedFormat:
      // surface error.message
      return;
    default:
      rethrow;
  }
}
```
