import '../rust/api/types.dart';

/// Lookup helpers for metadata tag lists.
///
/// 元数据标签列表的查找辅助扩展。
extension MetadataEntryListExtension on List<MetadataEntry> {
  /// Returns the first entry whose [tagName] matches exactly.
  ///
  /// 返回 [tagName] 完全匹配的第一个条目。
  MetadataEntry? entryNamed(String tagName) {
    for (final entry in this) {
      if (entry.tagName == tagName) {
        return entry;
      }
    }
    return null;
  }

  /// Returns the display string for [tagName], if present.
  ///
  /// 返回 [tagName] 对应的显示字符串，不存在时返回 null。
  String? stringValue(String tagName) => entryNamed(tagName)?.asString;

  /// Returns a parsed integer for [tagName], if present and parseable.
  ///
  /// 返回 [tagName] 对应的整数值，不存在或无法解析时返回 null。
  int? intValue(String tagName) => entryNamed(tagName)?.asInt;

  /// Returns a parsed floating-point value for [tagName], if present.
  ///
  /// 返回 [tagName] 对应的浮点数值，不存在或无法解析时返回 null。
  double? doubleValue(String tagName) => entryNamed(tagName)?.asDouble;
}

/// Typed value accessors for a single metadata entry.
///
/// 单个元数据条目的类型化值访问扩展。
extension MetadataEntryExtension on MetadataEntry {
  /// Text representation of this entry's value.
  ///
  /// 该条目值的文本表示。
  String? get asString {
    final raw = rawValue;
    if (raw != null) {
      final fromRaw = raw.maybeWhen(
        text: (value) => value,
        dateTime: (value) => value,
        naiveDateTime: (value) => value,
        orElse: () => null,
      );
      if (fromRaw != null) {
        return fromRaw;
      }
    }
    return displayValue.isEmpty ? null : displayValue;
  }

  /// Integer value, preferring structured [rawValue] when available.
  ///
  /// 整数值，优先使用结构化 [rawValue]。
  int? get asInt {
    final raw = rawValue;
    if (raw != null) {
      final fromRaw = raw.maybeWhen(
        integer: (value) => value.toInt(),
        float: (value) => value.round(),
        rational: (value) => _rationalToDouble(value)?.round(),
        signedRational: (value) => _rationalToDouble(value)?.round(),
        orElse: () => null,
      );
      if (fromRaw != null) {
        return fromRaw;
      }
    }
    return int.tryParse(displayValue);
  }

  /// Floating-point value, preferring structured [rawValue] when available.
  ///
  /// 浮点数值，优先使用结构化 [rawValue]。
  double? get asDouble {
    final raw = rawValue;
    if (raw != null) {
      final fromRaw = raw.maybeWhen(
        float: (value) => value,
        integer: (value) => value.toDouble(),
        rational: (value) => _rationalToDouble(value),
        signedRational: (value) => _rationalToDouble(value),
        orElse: () => null,
      );
      if (fromRaw != null) {
        return fromRaw;
      }
    }
    return double.tryParse(displayValue);
  }
}

double? _rationalToDouble(Rational value) {
  if (value.denominator == 0) {
    return null;
  }
  return value.numerator / value.denominator;
}

/// Convenience getters for video / audio track metadata.
///
/// 视频/音频轨道元数据的便捷 getter 扩展。
extension VideoTrackExtension on VideoTrack {
  /// Duration in milliseconds, if available.
  ///
  /// 时长（毫秒），来自 `DurationMs` 标签。
  int? get durationMs => entries.intValue('DurationMs');

  /// Duration as a [Duration], if [durationMs] is available.
  ///
  /// 将 [durationMs] 转换为 [Duration]。
  Duration? get duration {
    final ms = durationMs;
    return ms == null ? null : Duration(milliseconds: ms);
  }

  /// Video width in pixels, if available.
  ///
  /// 视频宽度（像素）。
  int? get width => entries.intValue('Width');

  /// Video height in pixels, if available.
  ///
  /// 视频高度（像素）。
  int? get height => entries.intValue('Height');

  /// Device or camera manufacturer, if available.
  ///
  /// 设备或相机制造商（Make）。
  String? get make => entries.stringValue('Make');

  /// Device or camera model, if available.
  ///
  /// 设备或相机型号（Model）。
  String? get model => entries.stringValue('Model');

  /// Recording software, if available.
  ///
  /// 录制软件（Software）。
  String? get software => entries.stringValue('Software');

  /// Author / creator, if available.
  ///
  /// 作者/创建者（Author）。
  String? get author => entries.stringValue('Author');

  /// Creation timestamp string, if available.
  ///
  /// 创建时间字符串（CreateDate）。
  String? get createDate => entries.stringValue('CreateDate');
}

/// Convenience getters for image EXIF metadata.
///
/// 图片 EXIF 元数据的便捷 getter 扩展。
extension ImageExifExtension on ImageExif {
  /// Camera or device manufacturer, if available.
  ///
  /// 相机或设备制造商（Make）。
  String? get make => entries.stringValue('Make');

  /// Camera or device model, if available.
  ///
  /// 相机或设备型号（Model）。
  String? get model => entries.stringValue('Model');

  /// Software that created the image, if available.
  ///
  /// 生成图片的软件（Software）。
  String? get software => entries.stringValue('Software');

  /// Original capture time, if available.
  ///
  /// 原始拍摄时间（DateTimeOriginal）。
  String? get dateTimeOriginal => entries.stringValue('DateTimeOriginal');

  /// Digitized / created time, if available.
  ///
  /// 数字化/创建时间（CreateDate）。
  String? get createDate => entries.stringValue('CreateDate');

  /// Last modified time, if available.
  ///
  /// 最后修改时间（ModifyDate）。
  String? get modifyDate => entries.stringValue('ModifyDate');

  /// Image width in pixels (prefers EXIF-specific tags).
  ///
  /// 图片宽度（像素），优先使用 ExifImageWidth / ImageWidth。
  int? get width =>
      entries.intValue('ExifImageWidth') ?? entries.intValue('ImageWidth');

  /// Image height in pixels (prefers EXIF-specific tags).
  ///
  /// 图片高度（像素），优先使用 ExifImageHeight / ImageHeight。
  int? get height =>
      entries.intValue('ExifImageHeight') ?? entries.intValue('ImageHeight');

  /// Image orientation tag value, if available.
  ///
  /// 图片方向值（Orientation，1–8）。
  int? get orientation => entries.intValue('Orientation');
}

/// Convenience accessors for auto-detected media metadata.
///
/// 自动识别媒体元数据的便捷访问扩展。
extension MediaMetadataExtension on MediaMetadata {
  /// Whether this result contains image EXIF metadata.
  ///
  /// 结果是否包含图片 EXIF 元数据。
  bool get isImage => maybeMap(imageExif: (_) => true, orElse: () => false);

  /// Whether this result contains video / audio track metadata.
  ///
  /// 结果是否包含视频/音频轨道元数据。
  bool get isVideo => maybeMap(videoTrack: (_) => true, orElse: () => false);

  /// Image EXIF payload when [isImage] is true.
  ///
  /// 当 [isImage] 为 true 时返回 [ImageExif]，否则为 null。
  ImageExif? get imageExifOrNull =>
      maybeMap(imageExif: (value) => value.field0, orElse: () => null);

  /// Video track payload when [isVideo] is true.
  ///
  /// 当 [isVideo] 为 true 时返回 [VideoTrack]，否则为 null。
  VideoTrack? get videoTrackOrNull =>
      maybeMap(videoTrack: (value) => value.field0, orElse: () => null);
}

/// Convenience accessors for full image metadata (EXIF + format extras).
///
/// 完整图片元数据（EXIF + 格式扩展）的便捷访问扩展。
extension FullImageMetadataExtension on FullImageMetadata {
  /// First PNG tEXt value for [key], if present.
  ///
  /// 返回 PNG tEXt 块中 [key] 对应的第一个值，不存在时返回 null。
  String? pngText(String key) {
    for (final chunk in pngTextChunks) {
      if (chunk.key == key) {
        return chunk.value;
      }
    }
    return null;
  }
}
