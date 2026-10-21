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

export 'src/types/gps_location.dart' show GpsLocation;
export 'src/types/media_info_error.dart' show MediaInfoError;
export 'src/types/media_kind.dart' show MediaKind;
export 'src/types/media_metadata.dart'
    show AudioMetadata, AvMetadata, ImageMetadata, MediaMetadata, VideoMetadata;
export 'src/types/media_source.dart'
    show AssetSource, BytesSource, FileSource, MediaSource;
export 'src/types/metadata_tag.dart' show MetadataTag;
export 'src/types/pixel_size.dart' show PixelSize;
export 'src/types/png_text_chunk.dart' show PngTextChunk;
export 'xue_hua_media_info_platform_interface.dart';

export 'src/media_info.dart';
