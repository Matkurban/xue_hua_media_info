import 'package:flutter/foundation.dart';

import 'gps_location.dart';
import 'media_kind.dart';
import 'metadata_tag.dart';
import 'pixel_size.dart';
import 'png_text_chunk.dart';

/// Result of [reading] media metadata.
///
/// Switch on the sealed subtypes: [ImageMetadata], [VideoMetadata],
/// [AudioMetadata].
///
/// 读取媒体元数据的结果。
///
/// 请对密封子类 [ImageMetadata]、[VideoMetadata]、[AudioMetadata] 做 `switch`。
sealed class MediaMetadata {
  /// Creates metadata. / 创建元数据。
  const MediaMetadata();

  /// Discriminator matching the runtime type. / 与运行时类型对应的种类。
  MediaKind get kind;
}

/// Still-image metadata (EXIF plus format extras such as PNG tEXt).
/// 静态图片元数据（EXIF 及 PNG tEXt 等格式扩展）。
@immutable
final class ImageMetadata extends MediaMetadata {
  /// Creates image metadata. / 创建图片元数据。
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

  /// Camera / scanner manufacturer. / 相机制造商。
  final String? make;

  /// Camera model. / 相机型号。
  final String? model;

  /// Firmware or editor software. / 固件或编辑软件。
  final String? software;

  /// Pixel width and height, when known. / 像素宽高（若已知）。
  final PixelSize? size;

  /// EXIF orientation (1–8), when present. / EXIF 方向（1–8）。
  final int? orientation;

  /// Capture time (naive local / EXIF, no timezone).
  /// 拍摄时间（无时区的 EXIF naive 时间，按本地解释）。
  final DateTime? dateTimeOriginal;

  /// Digitization time. / 数字化时间。
  final DateTime? dateTimeDigitized;

  /// File modification time from metadata. / 元数据中的修改时间。
  final DateTime? dateTimeModified;

  /// GPS, when present. Missing GPS is `null`, not an empty object.
  /// GPS；没有定位时为 `null`。
  final GpsLocation? gps;

  /// Whether this JPEG looks like a Pixel / Samsung Motion Photo.
  /// 是否像 Pixel / 三星动态照片。
  final bool hasMotionPhoto;

  /// PNG `tEXt` chunks. Empty when the image is not a PNG or has none.
  /// An empty list is success, not a missing-metadata error.
  /// PNG `tEXt` 块；非 PNG 或没有文本块时为空列表（空列表不是失败）。
  final List<PngTextChunk> pngText;

  /// Tags that were not lifted into first-class fields.
  /// 未提升为一等字段的残留标签。
  final List<MetadataTag> extraTags;

  @override
  MediaKind get kind => MediaKind.image;

  @override
  bool operator ==(Object other) =>
      other is ImageMetadata &&
      other.make == make &&
      other.model == model &&
      other.software == software &&
      other.size == size &&
      other.orientation == orientation &&
      other.dateTimeOriginal == dateTimeOriginal &&
      other.dateTimeDigitized == dateTimeDigitized &&
      other.dateTimeModified == dateTimeModified &&
      other.gps == gps &&
      other.hasMotionPhoto == hasMotionPhoto &&
      listEquals(other.pngText, pngText) &&
      listEquals(other.extraTags, extraTags);

  @override
  int get hashCode => Object.hash(
    make,
    model,
    software,
    size,
    orientation,
    dateTimeOriginal,
    dateTimeDigitized,
    dateTimeModified,
    gps,
    hasMotionPhoto,
    Object.hashAll(pngText),
    Object.hashAll(extraTags),
  );
}

/// Shared fields of audio/video containers.
/// 音视频容器的共用字段。
sealed class AvMetadata extends MediaMetadata {
  /// Creates container metadata. / 创建容器元数据。
  const AvMetadata();

  /// Duration, when the container reports one. / 时长（若容器提供）。
  Duration? get duration;

  /// Device manufacturer, when tagged. / 设备制造商（若有标签）。
  String? get make;

  /// Device model, when tagged. / 设备型号（若有标签）。
  String? get model;

  /// GPS, when present. / GPS（若有）。
  GpsLocation? get gps;
}

/// Video-track container metadata. / 含视频轨的容器元数据。
@immutable
final class VideoMetadata extends AvMetadata {
  /// Creates video metadata. / 创建视频元数据。
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

  /// Display size after applying [rotationDegrees], when known.
  /// 应用 [rotationDegrees] 之后的展示尺寸（若已知）。
  final PixelSize? size;

  /// Bitrate in bits per second, when known. / 比特率（bit/s）。
  final int? bitrate;

  /// Rotation in degrees (0 / 90 / 180 / 270), when tagged.
  /// 旋转角度（0 / 90 / 180 / 270）。
  final int? rotationDegrees;

  @override
  final String? make;

  @override
  final String? model;

  @override
  final GpsLocation? gps;

  /// Leftover tags. / 残留标签。
  final List<MetadataTag> extraTags;

  @override
  MediaKind get kind => MediaKind.video;

  @override
  bool operator ==(Object other) =>
      other is VideoMetadata &&
      other.duration == duration &&
      other.size == size &&
      other.bitrate == bitrate &&
      other.rotationDegrees == rotationDegrees &&
      other.make == make &&
      other.model == model &&
      other.gps == gps &&
      listEquals(other.extraTags, extraTags);

  @override
  int get hashCode => Object.hash(
    duration,
    size,
    bitrate,
    rotationDegrees,
    make,
    model,
    gps,
    Object.hashAll(extraTags),
  );
}

/// Audio-only container metadata. / 纯音频容器元数据。
@immutable
final class AudioMetadata extends AvMetadata {
  /// Creates audio metadata. / 创建音频元数据。
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

  /// Bitrate in bits per second. / 比特率（bit/s）。
  final int? bitrate;

  /// Sample rate in Hz. / 采样率（Hz）。
  final int? sampleRate;

  /// Channel count. / 声道数。
  final int? channelCount;

  @override
  final String? make;

  @override
  final String? model;

  @override
  final GpsLocation? gps;

  /// Leftover tags. / 残留标签。
  final List<MetadataTag> extraTags;

  @override
  MediaKind get kind => MediaKind.audio;

  @override
  bool operator ==(Object other) =>
      other is AudioMetadata &&
      other.duration == duration &&
      other.bitrate == bitrate &&
      other.sampleRate == sampleRate &&
      other.channelCount == channelCount &&
      other.make == make &&
      other.model == model &&
      other.gps == gps &&
      listEquals(other.extraTags, extraTags);

  @override
  int get hashCode => Object.hash(
    duration,
    bitrate,
    sampleRate,
    channelCount,
    make,
    model,
    gps,
    Object.hashAll(extraTags),
  );
}
