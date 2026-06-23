## 0.3.0

* Added async API with `Async` suffix on all reader and parser methods (e.g. `readImageExifFromBytesAsync`, `parseVideoMetadataFromFileAsync`)
* Sync API unchanged; use async methods when you want non-blocking I/O via nom-exif tokio integration

## 0.2.1

* Added Dart convenience extensions: `VideoTrack.durationMs`, `ImageExif.make`, and other common field getters

## 0.2.0

* **Breaking:** Public API is now accessed via `XueHuaMediaInfo.initialize()` and `XueHuaMediaInfo.xxx()` static methods
* **Breaking:** Removed `Dto` suffix from all data types (`ImageExif`, `MediaMetadata`, `VideoTrack`, etc.)
* Added `MediaMetadataParser` Dart wrapper for batch parsing via `XueHuaMediaInfo.createParser()`
* Fixed inconsistent eager/lazy conversion in `parseFullImageMetadataFromBytes`

## 0.1.0

* Initial release: image EXIF and video/audio metadata reading via nom-exif 3.6.1
* Sync API for file path and in-memory bytes input
* Motion Photo embedded video support
* PNG tEXt metadata via `readFullImageMetadataFrom*`
* Reusable `MediaMetadataParser` for batch processing
* GPS location data in image and video metadata results
