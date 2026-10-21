import 'package:flutter/foundation.dart';

/// A structured error reported while reading media metadata.
/// 读取媒体元数据时报告的结构化错误。
@immutable
class MediaInfoError implements Exception {
  /// Creates a media-info error.
  ///
  /// [code]: a stable, machine-readable error code (see the `code*` constants).
  /// [message]: a human-readable description of what went wrong.
  /// [details]: optional platform-specific diagnostic payload.
  ///
  /// 创建媒体元数据错误。
  ///
  /// [code]：稳定的、可供程序判断的错误码（见 `code*` 常量）。
  /// [message]：供人阅读的错误描述。
  /// [details]：可选的平台相关诊断信息。
  const MediaInfoError({
    required this.code,
    required this.message,
    this.details,
  });

  /// The operation is not supported on this platform.
  /// 当前平台不支持该操作。
  static const String codeUnsupported = 'unsupported';

  /// The source is the wrong media kind for this method (e.g. `readImage` on a video).
  /// 源的媒体种类与所调方法不匹配（例如对视频调用 `readImage`）。
  static const String codeWrongKind = 'wrongKind';

  /// A file or I/O failure. / 文件或 I/O 失败。
  static const String codeIo = 'io';

  /// Unrecognized or unsupported container / codec.
  /// 无法识别或不支持的容器/编码。
  static const String codeUnsupportedFormat = 'unsupportedFormat';

  /// The image has no EXIF (or equivalent) metadata.
  /// 图片中没有 EXIF（或等价）元数据。
  static const String codeExifNotFound = 'exifNotFound';

  /// No video/audio track, or no Motion Photo embedded MP4.
  /// 没有音视频轨道，或 Motion Photo 中没有内嵌 MP4。
  static const String codeTrackNotFound = 'trackNotFound';

  /// Corrupt or invalid metadata. / 元数据损坏或非法。
  static const String codeMalformed = 'malformed';

  /// The referenced resource does not exist. / 指定的资源不存在。
  static const String codeNotFound = 'notFound';

  /// Stable machine-readable error code. / 稳定的机器可读错误码。
  final String code;

  /// Human-readable error description. / 供人阅读的错误描述。
  final String message;

  /// Optional platform-specific diagnostic payload. / 可选的平台相关诊断信息。
  final Object? details;

  @override
  bool operator ==(Object other) =>
      other is MediaInfoError &&
      other.code == code &&
      other.message == message &&
      other.details == details;

  @override
  int get hashCode => Object.hash(code, message, details);

  @override
  String toString() =>
      'MediaInfoError($code): $message'
      '${details == null ? '' : ' — $details'}';
}
