/// Cross-platform native image EXIF and video/audio metadata for Flutter.
///
/// Call [MediaInfo.read] with a [MediaSource]; switch on the sealed
/// [MediaMetadata] result. No initialization is required.
///
/// Flutter 跨平台原生图片 EXIF 与视频/音频元数据插件。
///
/// 使用 [MediaSource] 调用 [MediaInfo.read]，再对密封的 [MediaMetadata]
/// 做 `switch`。无需初始化。
library;

export 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart'
    show
        AssetSource,
        AudioMetadata,
        AvMetadata,
        BytesSource,
        FileSource,
        GpsLocation,
        ImageMetadata,
        MediaInfoError,
        MediaKind,
        MediaMetadata,
        MediaSource,
        MetadataTag,
        PixelSize,
        PngTextChunk,
        VideoMetadata;

export 'src/media_info.dart';
