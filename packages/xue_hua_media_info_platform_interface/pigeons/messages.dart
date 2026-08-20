// Pigeon definition for the xue_hua_media_info plugin.
// Run `dart run pigeon --input pigeons/messages.dart` from the
// xue_hua_media_info_platform_interface package to regenerate all bindings.
//
// xue_hua_media_info 插件的 Pigeon 通信定义文件。
// 在 xue_hua_media_info_platform_interface 包目录下运行
// `dart run pigeon --input pigeons/messages.dart` 可重新生成所有平台绑定代码。
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    kotlinOut:
        '../xue_hua_media_info_android/android/src/main/kotlin/com/xuehua/xue_hua_media_info_android/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.xuehua.xue_hua_media_info_android',
    ),
    swiftOut:
        '../xue_hua_media_info_darwin/darwin/xue_hua_media_info_darwin/Sources/xue_hua_media_info_darwin/Messages.g.swift',
    cppHeaderOut: '../xue_hua_media_info_windows/windows/messages.g.h',
    cppSourceOut: '../xue_hua_media_info_windows/windows/messages.g.cpp',
    cppOptions: CppOptions(namespace: 'xue_hua_media_info_windows'),
    gobjectHeaderOut: '../xue_hua_media_info_linux/linux/messages.g.h',
    gobjectSourceOut: '../xue_hua_media_info_linux/linux/messages.g.cc',
    gobjectOptions: GObjectOptions(module: 'XhmiMessages'),
    dartPackageName: 'xue_hua_media_info_platform_interface',
  ),
)
/// Kind of a [MediaSourceMessage]. / [MediaSourceMessage] 的种类。
enum SourceKindMessage {
  /// Local filesystem path. / 本地文件路径。
  file,

  /// In-memory bytes. / 内存字节。
  bytes,

  /// Flutter asset key (already resolved). / 已解析的 Flutter Asset 键。
  asset,
}

/// Detected media kind. / 检测到的媒体种类。
enum MediaKindMessage {
  /// Still image. / 静态图片。
  image,

  /// Container with a video track. / 含视频轨的容器。
  video,

  /// Audio-only container. / 纯音频容器。
  audio,
}

/// Wire representation of a media source. / 媒体源的跨端传输结构。
class MediaSourceMessage {
  MediaSourceMessage({required this.kind, this.uri, this.bytes});

  /// Discriminator. / 种类。
  SourceKindMessage kind;

  /// File path or resolved asset key. / 文件路径或已解析的 asset 键。
  String? uri;

  /// In-memory payload for [SourceKindMessage.bytes]. / 字节源载荷。
  Uint8List? bytes;
}

/// Wire pixel size. / 像素尺寸传输结构。
class PixelSizeMessage {
  PixelSizeMessage({required this.width, required this.height});

  int width;
  int height;
}

/// Wire GPS. / GPS 传输结构。
class GpsLocationMessage {
  GpsLocationMessage({
    required this.latitude,
    required this.longitude,
    this.altitudeMeters,
  });

  double latitude;
  double longitude;
  double? altitudeMeters;
}

/// Wire leftover tag. / 残留标签传输结构。
class MetadataTagMessage {
  MetadataTagMessage({
    required this.name,
    required this.displayValue,
    this.stringValue,
    this.intValue,
    this.doubleValue,
  });

  String name;
  String displayValue;
  String? stringValue;
  int? intValue;
  double? doubleValue;
}

/// Wire PNG text chunk. / PNG 文本块传输结构。
class PngTextChunkMessage {
  PngTextChunkMessage({required this.key, required this.value});

  String key;
  String value;
}

/// Wire image metadata. Dates are ISO-8601 (no timezone) or empty.
/// 图片元数据传输结构。日期为无时区 ISO-8601 或空。
class ImageMetadataMessage {
  ImageMetadataMessage({
    required this.hasMotionPhoto,
    required this.pngText,
    required this.extraTags,
    this.make,
    this.model,
    this.software,
    this.size,
    this.orientation,
    this.dateTimeOriginal,
    this.dateTimeDigitized,
    this.dateTimeModified,
    this.gps,
  });

  String? make;
  String? model;
  String? software;
  PixelSizeMessage? size;
  int? orientation;
  String? dateTimeOriginal;
  String? dateTimeDigitized;
  String? dateTimeModified;
  GpsLocationMessage? gps;
  bool hasMotionPhoto;
  List<PngTextChunkMessage> pngText;
  List<MetadataTagMessage> extraTags;
}

/// Wire video metadata. / 视频元数据传输结构。
class VideoMetadataMessage {
  VideoMetadataMessage({
    required this.extraTags,
    this.durationMs,
    this.size,
    this.bitrate,
    this.rotationDegrees,
    this.make,
    this.model,
    this.gps,
  });

  int? durationMs;
  PixelSizeMessage? size;
  int? bitrate;
  int? rotationDegrees;
  String? make;
  String? model;
  GpsLocationMessage? gps;
  List<MetadataTagMessage> extraTags;
}

/// Wire audio metadata. / 音频元数据传输结构。
class AudioMetadataMessage {
  AudioMetadataMessage({
    required this.extraTags,
    this.durationMs,
    this.bitrate,
    this.sampleRate,
    this.channelCount,
    this.make,
    this.model,
    this.gps,
  });

  int? durationMs;
  int? bitrate;
  int? sampleRate;
  int? channelCount;
  String? make;
  String? model;
  GpsLocationMessage? gps;
  List<MetadataTagMessage> extraTags;
}

/// Tagged union of metadata results. / 带种类判别的元数据联合。
class MediaMetadataMessage {
  MediaMetadataMessage({
    required this.kind,
    this.image,
    this.video,
    this.audio,
  });

  MediaKindMessage kind;
  ImageMetadataMessage? image;
  VideoMetadataMessage? video;
  AudioMetadataMessage? audio;
}

/// Host API implemented natively for media metadata reads.
/// 由原生端实现的媒体元数据读取接口。
@HostApi()
abstract class MediaInfoHostApi {
  /// Auto-detect and read in one I/O. / 一次 I/O 自动识别并读取。
  @async
  MediaMetadataMessage read(MediaSourceMessage source);

  /// Read still-image metadata. / 读取静态图片元数据。
  @async
  ImageMetadataMessage readImage(MediaSourceMessage source);

  /// Read a video or audio-only container. / 读取视频或纯音频容器。
  @async
  MediaMetadataMessage readAv(MediaSourceMessage source);

  /// Header-only kind detection. / 仅检查文件头。
  @async
  MediaKindMessage probe(MediaSourceMessage source);

  /// Extract Motion Photo embedded MP4 metadata. / 提取动态照片内嵌 MP4。
  @async
  VideoMetadataMessage readMotionPhoto(MediaSourceMessage source);
}
