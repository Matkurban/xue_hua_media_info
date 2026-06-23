import 'rust/api/parser.dart' as frb_reader;
import 'rust/api/parser_async.dart' as frb_parser_async;
import 'rust/api/reader.dart' as frb;
import 'rust/api/reader_async.dart' as frb_async;
import 'rust/api/types.dart';
import 'rust/frb_generated.dart' show RustLib;

/// Entry point for reading image and video metadata.
class XueHuaMediaInfo {
  XueHuaMediaInfo._();

  /// Initializes the native Rust library. Call once before any other API.
  static Future<void> initialize() => RustLib.init();

  static MediaMetadata readMediaMetadataFromFile({required String path}) =>
      frb.readMediaMetadataFromFile(path: path);

  static MediaMetadata readMediaMetadataFromBytes({required List<int> data}) =>
      frb.readMediaMetadataFromBytes(data: data);

  static ImageExif readImageExifFromFile({required String path}) =>
      frb.readImageExifFromFile(path: path);

  static ImageExif readImageExifFromBytes({required List<int> data}) =>
      frb.readImageExifFromBytes(data: data);

  static ImageExif readImageExifLazyFromFile({required String path}) =>
      frb.readImageExifLazyFromFile(path: path);

  static ImageExif readImageExifLazyFromBytes({required List<int> data}) =>
      frb.readImageExifLazyFromBytes(data: data);

  static VideoTrack readVideoMetadataFromFile({required String path}) =>
      frb.readVideoMetadataFromFile(path: path);

  static VideoTrack readVideoMetadataFromBytes({required List<int> data}) =>
      frb.readVideoMetadataFromBytes(data: data);

  static FullImageMetadata readFullImageMetadataFromFile({
    required String path,
  }) => frb.readFullImageMetadataFromFile(path: path);

  static FullImageMetadata readFullImageMetadataFromBytes({
    required List<int> data,
  }) => frb.readFullImageMetadataFromBytes(data: data);

  static MediaKind detectMediaKindFromFile({required String path}) =>
      frb.detectMediaKindFromFile(path: path);

  static MediaKind detectMediaKindFromBytes({required List<int> data}) =>
      frb.detectMediaKindFromBytes(data: data);

  static VideoTrack readEmbeddedVideoFromFile({required String path}) =>
      frb.readEmbeddedVideoFromFile(path: path);

  static VideoTrack readEmbeddedVideoFromBytes({required List<int> data}) =>
      frb.readEmbeddedVideoFromBytes(data: data);

  static Future<MediaMetadata> readMediaMetadataFromFileAsync({
    required String path,
  }) => frb_async.readMediaMetadataFromFileAsync(path: path);

  static Future<MediaMetadata> readMediaMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readMediaMetadataFromBytesAsync(data: data);

  static Future<ImageExif> readImageExifFromFileAsync({required String path}) =>
      frb_async.readImageExifFromFileAsync(path: path);

  static Future<ImageExif> readImageExifFromBytesAsync({
    required List<int> data,
  }) => frb_async.readImageExifFromBytesAsync(data: data);

  static Future<ImageExif> readImageExifLazyFromFileAsync({
    required String path,
  }) => frb_async.readImageExifLazyFromFileAsync(path: path);

  static Future<ImageExif> readImageExifLazyFromBytesAsync({
    required List<int> data,
  }) => frb_async.readImageExifLazyFromBytesAsync(data: data);

  static Future<VideoTrack> readVideoMetadataFromFileAsync({
    required String path,
  }) => frb_async.readVideoMetadataFromFileAsync(path: path);

  static Future<VideoTrack> readVideoMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readVideoMetadataFromBytesAsync(data: data);

  static Future<FullImageMetadata> readFullImageMetadataFromFileAsync({
    required String path,
  }) => frb_async.readFullImageMetadataFromFileAsync(path: path);

  static Future<FullImageMetadata> readFullImageMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readFullImageMetadataFromBytesAsync(data: data);

  static Future<MediaKind> detectMediaKindFromFileAsync({
    required String path,
  }) => frb_async.detectMediaKindFromFileAsync(path: path);

  static Future<MediaKind> detectMediaKindFromBytesAsync({
    required List<int> data,
  }) => frb_async.detectMediaKindFromBytesAsync(data: data);

  static Future<VideoTrack> readEmbeddedVideoFromFileAsync({
    required String path,
  }) => frb_async.readEmbeddedVideoFromFileAsync(path: path);

  static Future<VideoTrack> readEmbeddedVideoFromBytesAsync({
    required List<int> data,
  }) => frb_async.readEmbeddedVideoFromBytesAsync(data: data);

  /// Creates a reusable parser for batch metadata reads.
  static MediaMetadataParser createParser() => MediaMetadataParser._();
}

/// Reusable parser for batch media metadata reads.
///
/// Create via [XueHuaMediaInfo.createParser].
class MediaMetadataParser {
  MediaMetadataParser._() : _inner = frb_reader.createMediaMetadataParser();

  final frb_reader.MediaMetadataParser _inner;

  ImageExif parseImageExifFromFile({required String path}) =>
      frb_reader.parseImageExifFromFile(parser: _inner, path: path);

  ImageExif parseImageExifFromBytes({required List<int> data}) =>
      frb_reader.parseImageExifFromBytes(parser: _inner, data: data);

  VideoTrack parseVideoMetadataFromFile({required String path}) =>
      frb_reader.parseVideoMetadataFromFile(parser: _inner, path: path);

  VideoTrack parseVideoMetadataFromBytes({required List<int> data}) =>
      frb_reader.parseVideoMetadataFromBytes(parser: _inner, data: data);

  FullImageMetadata parseFullImageMetadataFromFile({required String path}) =>
      frb_reader.parseFullImageMetadataFromFile(parser: _inner, path: path);

  FullImageMetadata parseFullImageMetadataFromBytes({
    required List<int> data,
  }) => frb_reader.parseFullImageMetadataFromBytes(parser: _inner, data: data);

  VideoTrack parseEmbeddedVideoFromFile({required String path}) =>
      frb_reader.parseEmbeddedVideoFromFile(parser: _inner, path: path);

  VideoTrack parseEmbeddedVideoFromBytes({required List<int> data}) =>
      frb_reader.parseEmbeddedVideoFromBytes(parser: _inner, data: data);

  Future<ImageExif> parseImageExifFromFileAsync({required String path}) =>
      frb_parser_async.parseImageExifFromFileAsync(parser: _inner, path: path);

  Future<ImageExif> parseImageExifFromBytesAsync({required List<int> data}) =>
      frb_parser_async.parseImageExifFromBytesAsync(parser: _inner, data: data);

  Future<VideoTrack> parseVideoMetadataFromFileAsync({required String path}) =>
      frb_parser_async.parseVideoMetadataFromFileAsync(
        parser: _inner,
        path: path,
      );

  Future<VideoTrack> parseVideoMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseVideoMetadataFromBytesAsync(
    parser: _inner,
    data: data,
  );

  Future<FullImageMetadata> parseFullImageMetadataFromFileAsync({
    required String path,
  }) => frb_parser_async.parseFullImageMetadataFromFileAsync(
    parser: _inner,
    path: path,
  );

  Future<FullImageMetadata> parseFullImageMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseFullImageMetadataFromBytesAsync(
    parser: _inner,
    data: data,
  );

  Future<VideoTrack> parseEmbeddedVideoFromFileAsync({required String path}) =>
      frb_parser_async.parseEmbeddedVideoFromFileAsync(
        parser: _inner,
        path: path,
      );

  Future<VideoTrack> parseEmbeddedVideoFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseEmbeddedVideoFromBytesAsync(
    parser: _inner,
    data: data,
  );
}
