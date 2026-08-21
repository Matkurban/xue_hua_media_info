import 'package:flutter/services.dart';
import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

import 'media_parsers.dart';

/// Web implementation of [XueHuaMediaInfoPlatform].
///
/// Parses JPEG APP1, PNG tEXt and MP4/MOV `moov` in Dart. File paths are not
/// available in the browser.
///
/// [XueHuaMediaInfoPlatform] 的 Web 实现。
///
/// 在 Dart 中解析 JPEG APP1、PNG tEXt 与 MP4/MOV `moov`。浏览器无法读取本地文件路径。
class XueHuaMediaInfoWeb extends XueHuaMediaInfoPlatform {
  @override
  Future<MediaMetadata> read(MediaSource source) async {
    final data = await _load(source);
    final kind = sniffMediaKind(data, uri: _uri(source));
    return switch (kind) {
      MediaKind.image => parseImageBytes(data),
      MediaKind.video || MediaKind.audio => parseAvBytes(data),
    };
  }

  @override
  Future<ImageMetadata> readImage(MediaSource source) async {
    final data = await _load(source);
    final kind = sniffMediaKind(data, uri: _uri(source));
    if (kind != MediaKind.image) {
      throw const MediaInfoError(
        code: MediaInfoError.codeWrongKind,
        message: 'Source is not an image.',
      );
    }
    return parseImageBytes(data);
  }

  @override
  Future<AvMetadata> readAv(MediaSource source) async {
    final data = await _load(source);
    final kind = sniffMediaKind(data, uri: _uri(source));
    if (kind == MediaKind.image) {
      throw const MediaInfoError(
        code: MediaInfoError.codeWrongKind,
        message: 'Source is an image, not an AV container.',
      );
    }
    return parseAvBytes(data);
  }

  @override
  Future<MediaKind> probe(MediaSource source) async {
    final data = await _load(source, prefix: 256);
    return sniffMediaKind(data, uri: _uri(source));
  }

  @override
  Future<VideoMetadata> readMotionPhoto(MediaSource source) async {
    final data = await _load(source);
    final offset = motionPhotoOffset(data);
    if (offset == null) {
      throw const MediaInfoError(
        code: MediaInfoError.codeTrackNotFound,
        message: 'No embedded Motion Photo video.',
      );
    }
    final embedded = Uint8List.sublistView(data, offset);
    final parsed = parseAvBytes(embedded);
    if (parsed is! VideoMetadata) {
      throw const MediaInfoError(
        code: MediaInfoError.codeTrackNotFound,
        message: 'Embedded trailer is not a video.',
      );
    }
    return parsed;
  }

  Future<Uint8List> _load(MediaSource source, {int? prefix}) async {
    final bytes = switch (source) {
      FileSource() => throw const MediaInfoError(
        code: MediaInfoError.codeUnsupported,
        message: 'MediaSource.file is not supported on Web.',
      ),
      BytesSource(:final data) => Uint8List.fromList(data),
      AssetSource() => Uint8List.sublistView(
        await rootBundle.load(source.resolvedKey),
      ),
    };
    if (prefix == null || bytes.length <= prefix) {
      return bytes;
    }
    return Uint8List.sublistView(bytes, 0, prefix);
  }

  String? _uri(MediaSource source) {
    return switch (source) {
      FileSource(:final path) => path,
      AssetSource(:final key) => key,
      BytesSource() => null,
    };
  }
}
