# xue_hua_media_info

**English** | [简体中文](https://github.com/Matkurban/xue_hua_media_info/blob/main/README.zh-CN.md)

Cross-platform native Flutter plugin for reading image EXIF and video/audio
metadata. Call `MediaInfo.read` with a `MediaSource`; switch on the sealed
`MediaMetadata` result. No initialization.

跨平台原生 Flutter 插件：读取图片 EXIF 与视频/音频元数据。使用 `MediaSource`
调用 `MediaInfo.read`，再对密封的 `MediaMetadata` 做 `switch`。无需初始化。

Requires Flutter 3.44+ / Dart 3.12.

```yaml
dependencies:
  xue_hua_media_info: ^2.0.0
```

```dart
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

final meta = await MediaInfo.read(MediaSource.file('/path/to/photo.jpg'));
switch (meta) {
  case ImageMetadata(:final make, :final size, :final gps, :final hasMotionPhoto):
    print('$make $size $gps motion=$hasMotionPhoto');
  case VideoMetadata(:final duration, :final size):
    print('$size $duration');
  case AudioMetadata(:final duration, :final sampleRate):
    print('$duration $sampleRate');
}
```

Five methods: `read`, `readImage`, `readAv`, `probe`, `readMotionPhoto`.
See the [repository README](https://github.com/Matkurban/xue_hua_media_info)
for the capability matrix and architecture. Migrating from 1.x:
[MIGRATION.md](https://github.com/Matkurban/xue_hua_media_info/blob/main/MIGRATION.md).
