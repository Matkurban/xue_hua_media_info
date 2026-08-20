import 'package:flutter/services.dart';

import 'messages.g.dart';
import 'types/gps_location.dart';
import 'types/media_info_error.dart';
import 'types/media_kind.dart';
import 'types/media_metadata.dart';
import 'types/media_source.dart';
import 'types/metadata_tag.dart';
import 'types/pixel_size.dart';
import 'types/png_text_chunk.dart';
import 'xue_hua_media_info_platform.dart';

/// The default [XueHuaMediaInfoPlatform] implementation backed by a Pigeon
/// method channel.
///
/// Shared by Android, iOS, macOS, Windows and Linux. Web replaces the
/// platform instance instead of using this class.
///
/// 基于 Pigeon MethodChannel 的默认 [XueHuaMediaInfoPlatform] 实现。
///
/// 被 Android / iOS / macOS / Windows / Linux 共用；Web 端直接替换平台实例。
class MethodChannelXueHuaMediaInfo extends XueHuaMediaInfoPlatform {
  /// Creates the method-channel implementation.
  ///
  /// [api]: test double for the generated Pigeon client; production uses the
  /// default.
  ///
  /// 创建 MethodChannel 实现。[api] 用于测试注入。
  MethodChannelXueHuaMediaInfo({MediaInfoHostApi? api})
    : _api = api ?? MediaInfoHostApi();

  final MediaInfoHostApi _api;

  @override
  Future<MediaMetadata> read(MediaSource source) {
    return _guard(
      () async => _decodeMetadata(await _api.read(_encode(source))),
    );
  }

  @override
  Future<ImageMetadata> readImage(MediaSource source) {
    return _guard(
      () async => _decodeImage(await _api.readImage(_encode(source))),
    );
  }

  @override
  Future<AvMetadata> readAv(MediaSource source) {
    return _guard(() async {
      final message = await _api.readAv(_encode(source));
      final decoded = _decodeMetadata(message);
      if (decoded is AvMetadata) {
        return decoded;
      }
      throw const MediaInfoError(
        code: MediaInfoError.codeWrongKind,
        message: 'Expected video or audio metadata.',
      );
    });
  }

  @override
  Future<MediaKind> probe(MediaSource source) {
    return _guard(() async => _decodeKind(await _api.probe(_encode(source))));
  }

  @override
  Future<VideoMetadata> readMotionPhoto(MediaSource source) {
    return _guard(
      () async => _decodeVideo(await _api.readMotionPhoto(_encode(source))),
    );
  }

  MediaSourceMessage _encode(MediaSource source) {
    return switch (source) {
      FileSource(:final path) => MediaSourceMessage(
        kind: SourceKindMessage.file,
        uri: path,
      ),
      BytesSource(:final data) => MediaSourceMessage(
        kind: SourceKindMessage.bytes,
        bytes: Uint8List.fromList(data),
      ),
      AssetSource() => MediaSourceMessage(
        kind: SourceKindMessage.asset,
        uri: source.resolvedKey,
      ),
    };
  }

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PlatformException catch (e) {
      throw MediaInfoError(
        code: e.code,
        message: e.message ?? 'Unknown platform error',
        details: e.details,
      );
    }
  }

  static MediaKind _decodeKind(MediaKindMessage kind) {
    return switch (kind) {
      MediaKindMessage.image => MediaKind.image,
      MediaKindMessage.video => MediaKind.video,
      MediaKindMessage.audio => MediaKind.audio,
    };
  }

  static MediaMetadata _decodeMetadata(MediaMetadataMessage message) {
    return switch (message.kind) {
      MediaKindMessage.image => _decodeImage(
        message.image ??
            (throw const MediaInfoError(
              code: MediaInfoError.codeMalformed,
              message: 'Image payload missing.',
            )),
      ),
      MediaKindMessage.video => _decodeVideo(
        message.video ??
            (throw const MediaInfoError(
              code: MediaInfoError.codeMalformed,
              message: 'Video payload missing.',
            )),
      ),
      MediaKindMessage.audio => _decodeAudio(
        message.audio ??
            (throw const MediaInfoError(
              code: MediaInfoError.codeMalformed,
              message: 'Audio payload missing.',
            )),
      ),
    };
  }

  static ImageMetadata _decodeImage(ImageMetadataMessage message) {
    return ImageMetadata(
      make: message.make,
      model: message.model,
      software: message.software,
      size: _decodeSize(message.size),
      orientation: message.orientation,
      dateTimeOriginal: parseMetadataDate(message.dateTimeOriginal),
      dateTimeDigitized: parseMetadataDate(message.dateTimeDigitized),
      dateTimeModified: parseMetadataDate(message.dateTimeModified),
      gps: _decodeGps(message.gps),
      hasMotionPhoto: message.hasMotionPhoto,
      pngText: [
        for (final chunk in message.pngText)
          PngTextChunk(key: chunk.key, value: chunk.value),
      ],
      extraTags: [for (final tag in message.extraTags) _decodeTag(tag)],
    );
  }

  static VideoMetadata _decodeVideo(VideoMetadataMessage message) {
    return VideoMetadata(
      duration: _decodeDuration(message.durationMs),
      size: _decodeSize(message.size),
      bitrate: message.bitrate,
      rotationDegrees: message.rotationDegrees,
      make: message.make,
      model: message.model,
      gps: _decodeGps(message.gps),
      extraTags: [for (final tag in message.extraTags) _decodeTag(tag)],
    );
  }

  static AudioMetadata _decodeAudio(AudioMetadataMessage message) {
    return AudioMetadata(
      duration: _decodeDuration(message.durationMs),
      bitrate: message.bitrate,
      sampleRate: message.sampleRate,
      channelCount: message.channelCount,
      make: message.make,
      model: message.model,
      gps: _decodeGps(message.gps),
      extraTags: [for (final tag in message.extraTags) _decodeTag(tag)],
    );
  }

  static PixelSize? _decodeSize(PixelSizeMessage? size) {
    if (size == null) {
      return null;
    }
    return PixelSize(width: size.width, height: size.height);
  }

  static GpsLocation? _decodeGps(GpsLocationMessage? gps) {
    if (gps == null) {
      return null;
    }
    return GpsLocation(
      latitude: gps.latitude,
      longitude: gps.longitude,
      altitudeMeters: gps.altitudeMeters,
    );
  }

  static MetadataTag _decodeTag(MetadataTagMessage tag) {
    return MetadataTag(
      name: tag.name,
      displayValue: tag.displayValue,
      stringValue: tag.stringValue,
      intValue: tag.intValue,
      doubleValue: tag.doubleValue,
    );
  }

  static Duration? _decodeDuration(int? milliseconds) {
    if (milliseconds == null) {
      return null;
    }
    return Duration(milliseconds: milliseconds);
  }
}

/// Parses EXIF / ISO-8601 date strings into a naive [DateTime].
///
/// Accepts `yyyy:MM:dd HH:mm:ss` (EXIF) and `yyyy-MM-ddTHH:mm:ss`.
/// Returns `null` when [raw] is null, empty, or unparseable.
///
/// 将 EXIF / ISO-8601 日期字符串解析为无时区 [DateTime]。
DateTime? parseMetadataDate(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final exif = RegExp(
    r'^(\d{4}):(\d{2}):(\d{2})[ T](\d{2}):(\d{2}):(\d{2})',
  ).firstMatch(raw);
  if (exif != null) {
    return DateTime(
      int.parse(exif.group(1)!),
      int.parse(exif.group(2)!),
      int.parse(exif.group(3)!),
      int.parse(exif.group(4)!),
      int.parse(exif.group(5)!),
      int.parse(exif.group(6)!),
    );
  }
  return DateTime.tryParse(raw);
}
