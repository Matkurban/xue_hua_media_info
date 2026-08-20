import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

/// Reads image EXIF and video/audio metadata.
///
/// There is no initialization call and no long-lived native instance: every
/// method is a one-shot `source → Future<typed result>`.
///
/// Typical usage / 典型用法:
///
/// ```dart
/// final meta = await MediaInfo.read(MediaSource.file('/path/to/photo.jpg'));
/// switch (meta) {
///   case ImageMetadata(:final make, :final size):
///     print('$make $size');
///   case VideoMetadata(:final duration):
///     print(duration);
///   case AudioMetadata(:final duration):
///     print(duration);
/// }
/// ```
///
/// 读取图片 EXIF 与视频/音频元数据。
///
/// 无需 `initialize`，也没有长寿命原生实例：每个方法都是一次性的
/// `source → Future<类型化结果>`。
abstract final class MediaInfo {
  static XueHuaMediaInfoPlatform get _platform =>
      XueHuaMediaInfoPlatform.instance;

  /// Auto-detects the media kind and reads metadata in a **single I/O**.
  ///
  /// Returns [ImageMetadata], [VideoMetadata] or [AudioMetadata]. Throws
  /// [MediaInfoError] when the source cannot be read or parsed.
  ///
  /// 自动识别媒体种类并在**一次 I/O** 中读取元数据。
  ///
  /// 返回 [ImageMetadata]、[VideoMetadata] 或 [AudioMetadata]；
  /// 无法读取或解析时抛出 [MediaInfoError]。
  static Future<MediaMetadata> read(MediaSource source) =>
      _platform.read(source);

  /// Reads still-image metadata (EXIF plus format extras such as PNG tEXt).
  ///
  /// Throws [MediaInfoError] with [MediaInfoError.codeWrongKind] when
  /// [source] is not an image.
  ///
  /// 读取静态图片元数据（EXIF 及 PNG tEXt 等格式扩展）。
  ///
  /// 源不是图片时抛出 [MediaInfoError.codeWrongKind]。
  static Future<ImageMetadata> readImage(MediaSource source) =>
      _platform.readImage(source);

  /// Reads a video or audio-only container.
  ///
  /// Switch on the result: [VideoMetadata] or [AudioMetadata]. Throws
  /// [MediaInfoError.codeWrongKind] when [source] is an image.
  ///
  /// 读取视频或纯音频容器。
  ///
  /// 对结果做 `switch`：[VideoMetadata] 或 [AudioMetadata]。
  /// 源是图片时抛出 [MediaInfoError.codeWrongKind]。
  static Future<AvMetadata> readAv(MediaSource source) =>
      _platform.readAv(source);

  /// Inspects the file header only (no full metadata parse).
  ///
  /// 仅检查文件头，不解析完整元数据。
  static Future<MediaKind> probe(MediaSource source) => _platform.probe(source);

  /// Extracts embedded MP4 metadata from a Pixel / Samsung Motion Photo.
  ///
  /// Throws [MediaInfoError.codeTrackNotFound] when no trailer is present.
  /// Prefer calling this after [ImageMetadata.hasMotionPhoto] is true.
  ///
  /// 从 Pixel / 三星动态照片中提取内嵌 MP4 元数据。
  ///
  /// 没有 trailer 时抛出 [MediaInfoError.codeTrackNotFound]。
  /// 建议在 [ImageMetadata.hasMotionPhoto] 为 true 时再调用。
  static Future<VideoMetadata> readMotionPhoto(MediaSource source) =>
      _platform.readMotionPhoto(source);
}
