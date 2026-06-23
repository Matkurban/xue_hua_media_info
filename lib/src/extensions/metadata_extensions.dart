import '../rust/api/types.dart';

/// Lookup helpers for metadata tag lists.
extension MetadataEntryListExtension on List<MetadataEntry> {
  /// Returns the first entry whose [tagName] matches exactly.
  MetadataEntry? entryNamed(String tagName) {
    for (final entry in this) {
      if (entry.tagName == tagName) {
        return entry;
      }
    }
    return null;
  }

  /// Returns the display string for [tagName], if present.
  String? stringValue(String tagName) => entryNamed(tagName)?.asString;

  /// Returns a parsed integer for [tagName], if present and parseable.
  int? intValue(String tagName) => entryNamed(tagName)?.asInt;

  /// Returns a parsed floating-point value for [tagName], if present.
  double? doubleValue(String tagName) => entryNamed(tagName)?.asDouble;
}

/// Typed value accessors for a single metadata entry.
extension MetadataEntryExtension on MetadataEntry {
  /// Text representation of this entry's value.
  String? get asString {
    final raw = rawValue;
    if (raw != null) {
      return raw.maybeWhen(
        text: (value) => value,
        dateTime: (value) => value,
        naiveDateTime: (value) => value,
        bytes: (value) => value,
        orElse: () => null,
      );
    }
    return displayValue.isEmpty ? null : displayValue;
  }

  /// Integer value, preferring structured [rawValue] when available.
  int? get asInt {
    final raw = rawValue;
    if (raw != null) {
      final fromRaw = raw.maybeWhen(
        integer: (value) => value.toInt(),
        float: (value) => value.round(),
        orElse: () => null,
      );
      if (fromRaw != null) {
        return fromRaw;
      }
    }
    return int.tryParse(displayValue);
  }

  /// Floating-point value, preferring structured [rawValue] when available.
  double? get asDouble {
    final raw = rawValue;
    if (raw != null) {
      final fromRaw = raw.maybeWhen(
        float: (value) => value,
        integer: (value) => value.toDouble(),
        orElse: () => null,
      );
      if (fromRaw != null) {
        return fromRaw;
      }
    }
    return double.tryParse(displayValue);
  }
}

/// Convenience getters for video / audio track metadata.
extension VideoTrackExtension on VideoTrack {
  /// Duration in milliseconds, if available.
  int? get durationMs => entries.intValue('DurationMs');

  /// Duration as a [Duration], if [durationMs] is available.
  Duration? get duration {
    final ms = durationMs;
    return ms == null ? null : Duration(milliseconds: ms);
  }

  /// Video width in pixels, if available.
  int? get width => entries.intValue('Width');

  /// Video height in pixels, if available.
  int? get height => entries.intValue('Height');

  /// Device or camera manufacturer, if available.
  String? get make => entries.stringValue('Make');

  /// Device or camera model, if available.
  String? get model => entries.stringValue('Model');

  /// Recording software, if available.
  String? get software => entries.stringValue('Software');

  /// Author / creator, if available.
  String? get author => entries.stringValue('Author');

  /// Creation timestamp string, if available.
  String? get createDate => entries.stringValue('CreateDate');
}

/// Convenience getters for image EXIF metadata.
extension ImageExifExtension on ImageExif {
  /// Camera or device manufacturer, if available.
  String? get make => entries.stringValue('Make');

  /// Camera or device model, if available.
  String? get model => entries.stringValue('Model');

  /// Software that created the image, if available.
  String? get software => entries.stringValue('Software');

  /// Original capture time, if available.
  String? get dateTimeOriginal => entries.stringValue('DateTimeOriginal');

  /// Digitized / created time, if available.
  String? get createDate => entries.stringValue('CreateDate');

  /// Last modified time, if available.
  String? get modifyDate => entries.stringValue('ModifyDate');

  /// Image width in pixels (prefers EXIF-specific tags).
  int? get width =>
      entries.intValue('ExifImageWidth') ?? entries.intValue('ImageWidth');

  /// Image height in pixels (prefers EXIF-specific tags).
  int? get height =>
      entries.intValue('ExifImageHeight') ?? entries.intValue('ImageHeight');

  /// Image orientation tag value, if available.
  int? get orientation => entries.intValue('Orientation');
}

/// Convenience accessors for auto-detected media metadata.
extension MediaMetadataExtension on MediaMetadata {
  /// Whether this result contains image EXIF metadata.
  bool get isImage => maybeMap(imageExif: (_) => true, orElse: () => false);

  /// Whether this result contains video / audio track metadata.
  bool get isVideo => maybeMap(videoTrack: (_) => true, orElse: () => false);

  /// Image EXIF payload when [isImage] is true.
  ImageExif? get imageExifOrNull =>
      maybeMap(imageExif: (value) => value.field0, orElse: () => null);

  /// Video track payload when [isVideo] is true.
  VideoTrack? get videoTrackOrNull =>
      maybeMap(videoTrack: (value) => value.field0, orElse: () => null);
}

/// Convenience accessors for full image metadata (EXIF + format extras).
extension FullImageMetadataExtension on FullImageMetadata {
  /// First PNG tEXt value for [key], if present.
  String? pngText(String key) {
    for (final chunk in pngTextChunks) {
      if (chunk.key == key) {
        return chunk.value;
      }
    }
    return null;
  }
}
