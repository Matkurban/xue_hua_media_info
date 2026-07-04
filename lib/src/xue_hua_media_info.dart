import 'rust/api/parser.dart' as frb_reader;
import 'rust/api/parser_async.dart' as frb_parser_async;
import 'rust/api/reader.dart' as frb;
import 'rust/api/reader_async.dart' as frb_async;
import 'rust/api/types.dart';
import 'rust/frb_generated.dart' show RustLib;
import 'dart:developer';

/// Entry point for reading image and video metadata.
///
/// 读取图片 EXIF 与视频/音频元数据的统一入口。
class XueHuaMediaInfo {
  XueHuaMediaInfo._();

  /// Initializes the native Rust library. Call once before any other API.
  ///
  /// 初始化原生 Rust 库。在使用任何其他 API 之前调用一次。
  static Future<void> initialize() async {
    try {
      if (!RustLib.instance.initialized) {
        await RustLib.init();
      }
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
        name: 'XueHuaMediaInfo.initialize',
      );
    }
  }

  /// Auto-detects media type and reads image EXIF or video track metadata from a file path.
  ///
  /// 自动识别媒体类型，从文件路径读取图片 EXIF 或视频/音频轨道元数据。
  ///
  /// Returns [MediaMetadata] containing either [ImageExif] or [VideoTrack].
  /// Throws [MediaInfoError] if the file cannot be read or parsed.
  ///
  /// 返回包含 [ImageExif] 或 [VideoTrack] 的 [MediaMetadata]。
  /// 文件无法读取或解析时抛出 [MediaInfoError]。
  static MediaMetadata readMediaMetadataFromFile({required String path}) =>
      frb.readMediaMetadataFromFile(path: path);

  /// Auto-detects media type and reads image EXIF or video track metadata from bytes.
  ///
  /// 自动识别媒体类型，从内存字节读取图片 EXIF 或视频/音频轨道元数据。
  ///
  /// Suitable for assets, network downloads, or in-memory buffers.
  ///
  /// 适用于 Asset、网络下载或内存缓冲区。
  static MediaMetadata readMediaMetadataFromBytes({required List<int> data}) =>
      frb.readMediaMetadataFromBytes(data: data);

  /// Reads image EXIF metadata from a file path (eager mode).
  ///
  /// 从文件路径读取图片 EXIF 元数据（急切模式）。
  ///
  /// All tags are parsed upfront into [ImageExif.entries].
  /// Use [readImageExifLazyFromFile] to preserve per-tag parse errors.
  ///
  /// 所有标签会一次性解析到 [ImageExif.entries]。
  /// 若需保留逐标签解析错误，请使用 [readImageExifLazyFromFile]。
  static ImageExif readImageExifFromFile({required String path}) =>
      frb.readImageExifFromFile(path: path);

  /// Reads image EXIF metadata from bytes (eager mode).
  ///
  /// 从内存字节读取图片 EXIF 元数据（急切模式）。
  static ImageExif readImageExifFromBytes({required List<int> data}) =>
      frb.readImageExifFromBytes(data: data);

  /// Reads image EXIF metadata from a file path (lazy mode).
  ///
  /// 从文件路径读取图片 EXIF 元数据（惰性模式）。
  ///
  /// Per-tag parse errors are collected in [ImageExif.parseErrors]
  /// instead of failing the entire read.
  ///
  /// 逐标签解析错误会收集到 [ImageExif.parseErrors]，
  /// 而不会导致整个读取失败。
  static ImageExif readImageExifLazyFromFile({required String path}) =>
      frb.readImageExifLazyFromFile(path: path);

  /// Reads image EXIF metadata from bytes (lazy mode).
  ///
  /// 从内存字节读取图片 EXIF 元数据（惰性模式）。
  static ImageExif readImageExifLazyFromBytes({required List<int> data}) =>
      frb.readImageExifLazyFromBytes(data: data);

  /// Reads video or audio track metadata from a file path.
  ///
  /// 从文件路径读取视频或音频轨道元数据。
  ///
  /// Supported containers include MP4, MOV, MKV, WEBM, and MKA.
  ///
  /// 支持 MP4、MOV、MKV、WEBM、MKA 等容器格式。
  static VideoTrack readVideoMetadataFromFile({required String path}) =>
      frb.readVideoMetadataFromFile(path: path);

  /// Reads video or audio track metadata from bytes.
  ///
  /// 从内存字节读取视频或音频轨道元数据。
  static VideoTrack readVideoMetadataFromBytes({required List<int> data}) =>
      frb.readVideoMetadataFromBytes(data: data);

  /// Reads full image metadata (EXIF plus format-specific extras) from a file path.
  ///
  /// 从文件路径读取完整图片元数据（EXIF 及格式特有信息）。
  ///
  /// For PNG, includes tEXt chunks in [FullImageMetadata.pngTextChunks].
  ///
  /// 对于 PNG，包含 [FullImageMetadata.pngTextChunks] 中的 tEXt 块。
  static FullImageMetadata readFullImageMetadataFromFile({
    required String path,
  }) => frb.readFullImageMetadataFromFile(path: path);

  /// Reads full image metadata (EXIF plus format-specific extras) from bytes.
  ///
  /// 从内存字节读取完整图片元数据（EXIF 及格式特有信息）。
  static FullImageMetadata readFullImageMetadataFromBytes({
    required List<int> data,
  }) => frb.readFullImageMetadataFromBytes(data: data);

  /// Detects whether a file is an image or video/audio track.
  ///
  /// 检测文件是图片还是视频/音频轨道。
  ///
  /// Does not parse full metadata; only inspects the file header.
  ///
  /// 不解析完整元数据，仅检查文件头。
  static MediaKind detectMediaKindFromFile({required String path}) =>
      frb.detectMediaKindFromFile(path: path);

  /// Detects whether bytes represent an image or video/audio track.
  ///
  /// 检测字节数据是图片还是视频/音频轨道。
  static MediaKind detectMediaKindFromBytes({required List<int> data}) =>
      frb.detectMediaKindFromBytes(data: data);

  /// Extracts embedded MP4 video metadata from a Motion Photo file path.
  ///
  /// 从 Motion Photo 文件路径提取内嵌 MP4 视频元数据。
  ///
  /// Use when [ImageExif.hasEmbeddedVideo] is true (Pixel / Samsung Motion Photos).
  ///
  /// 当 [ImageExif.hasEmbeddedVideo] 为 true 时使用（Pixel / 三星动态照片）。
  static VideoTrack readEmbeddedVideoFromFile({required String path}) =>
      frb.readEmbeddedVideoFromFile(path: path);

  /// Extracts embedded MP4 video metadata from Motion Photo bytes.
  ///
  /// 从 Motion Photo 字节数据提取内嵌 MP4 视频元数据。
  static VideoTrack readEmbeddedVideoFromBytes({required List<int> data}) =>
      frb.readEmbeddedVideoFromBytes(data: data);

  /// Async version of [readMediaMetadataFromFile].
  ///
  /// [readMediaMetadataFromFile] 的异步版本，返回 `Future<MediaMetadata>`。
  ///
  /// Non-blocking file I/O via nom-exif tokio integration.
  ///
  /// 通过 nom-exif tokio 集成实现非阻塞文件 I/O。
  static Future<MediaMetadata> readMediaMetadataFromFileAsync({
    required String path,
  }) => frb_async.readMediaMetadataFromFileAsync(path: path);

  /// Async version of [readMediaMetadataFromBytes].
  ///
  /// [readMediaMetadataFromBytes] 的异步版本。
  static Future<MediaMetadata> readMediaMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readMediaMetadataFromBytesAsync(data: data);

  /// Async version of [readImageExifFromFile].
  ///
  /// [readImageExifFromFile] 的异步版本。
  static Future<ImageExif> readImageExifFromFileAsync({required String path}) =>
      frb_async.readImageExifFromFileAsync(path: path);

  /// Async version of [readImageExifFromBytes].
  ///
  /// [readImageExifFromBytes] 的异步版本。
  static Future<ImageExif> readImageExifFromBytesAsync({
    required List<int> data,
  }) => frb_async.readImageExifFromBytesAsync(data: data);

  /// Async version of [readImageExifLazyFromFile].
  ///
  /// [readImageExifLazyFromFile] 的异步版本。
  static Future<ImageExif> readImageExifLazyFromFileAsync({
    required String path,
  }) => frb_async.readImageExifLazyFromFileAsync(path: path);

  /// Async version of [readImageExifLazyFromBytes].
  ///
  /// [readImageExifLazyFromBytes] 的异步版本。
  static Future<ImageExif> readImageExifLazyFromBytesAsync({
    required List<int> data,
  }) => frb_async.readImageExifLazyFromBytesAsync(data: data);

  /// Async version of [readVideoMetadataFromFile].
  ///
  /// [readVideoMetadataFromFile] 的异步版本。
  static Future<VideoTrack> readVideoMetadataFromFileAsync({
    required String path,
  }) => frb_async.readVideoMetadataFromFileAsync(path: path);

  /// Async version of [readVideoMetadataFromBytes].
  ///
  /// [readVideoMetadataFromBytes] 的异步版本。
  static Future<VideoTrack> readVideoMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readVideoMetadataFromBytesAsync(data: data);

  /// Async version of [readFullImageMetadataFromFile].
  ///
  /// [readFullImageMetadataFromFile] 的异步版本。
  static Future<FullImageMetadata> readFullImageMetadataFromFileAsync({
    required String path,
  }) => frb_async.readFullImageMetadataFromFileAsync(path: path);

  /// Async version of [readFullImageMetadataFromBytes].
  ///
  /// [readFullImageMetadataFromBytes] 的异步版本。
  static Future<FullImageMetadata> readFullImageMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_async.readFullImageMetadataFromBytesAsync(data: data);

  /// Async version of [detectMediaKindFromFile].
  ///
  /// [detectMediaKindFromFile] 的异步版本。
  static Future<MediaKind> detectMediaKindFromFileAsync({
    required String path,
  }) => frb_async.detectMediaKindFromFileAsync(path: path);

  /// Async version of [detectMediaKindFromBytes].
  ///
  /// [detectMediaKindFromBytes] 的异步版本。
  static Future<MediaKind> detectMediaKindFromBytesAsync({
    required List<int> data,
  }) => frb_async.detectMediaKindFromBytesAsync(data: data);

  /// Async version of [readEmbeddedVideoFromFile].
  ///
  /// [readEmbeddedVideoFromFile] 的异步版本。
  static Future<VideoTrack> readEmbeddedVideoFromFileAsync({
    required String path,
  }) => frb_async.readEmbeddedVideoFromFileAsync(path: path);

  /// Async version of [readEmbeddedVideoFromBytes].
  ///
  /// [readEmbeddedVideoFromBytes] 的异步版本。
  static Future<VideoTrack> readEmbeddedVideoFromBytesAsync({
    required List<int> data,
  }) => frb_async.readEmbeddedVideoFromBytesAsync(data: data);

  /// Creates a reusable parser for batch metadata reads.
  ///
  /// 创建可复用的解析器，用于批量读取元数据。
  ///
  /// Reuses an internal buffer across calls for better performance
  /// when processing many files or byte buffers.
  ///
  /// 多次调用时复用内部缓冲区，批量处理时性能更好。
  static MediaMetadataParser createParser() => MediaMetadataParser._();
}

/// Reusable parser for batch media metadata reads.
///
/// 可复用的媒体元数据批量解析器。
///
/// Create via [XueHuaMediaInfo.createParser].
///
/// 通过 [XueHuaMediaInfo.createParser] 创建。
class MediaMetadataParser {
  MediaMetadataParser._() : _inner = frb_reader.createMediaMetadataParser();

  final frb_reader.MediaMetadataParser _inner;

  /// Parses image EXIF from a file path using the reusable parser.
  ///
  /// 使用可复用解析器从文件路径解析图片 EXIF。
  ImageExif parseImageExifFromFile({required String path}) =>
      frb_reader.parseImageExifFromFile(parser: _inner, path: path);

  /// Parses image EXIF from bytes using the reusable parser.
  ///
  /// 使用可复用解析器从内存字节解析图片 EXIF。
  ImageExif parseImageExifFromBytes({required List<int> data}) =>
      frb_reader.parseImageExifFromBytes(parser: _inner, data: data);

  /// Parses video or audio track metadata from a file path.
  ///
  /// 从文件路径解析视频或音频轨道元数据。
  VideoTrack parseVideoMetadataFromFile({required String path}) =>
      frb_reader.parseVideoMetadataFromFile(parser: _inner, path: path);

  /// Parses video or audio track metadata from bytes.
  ///
  /// 从内存字节解析视频或音频轨道元数据。
  VideoTrack parseVideoMetadataFromBytes({required List<int> data}) =>
      frb_reader.parseVideoMetadataFromBytes(parser: _inner, data: data);

  /// Parses full image metadata (EXIF + format extras) from a file path.
  ///
  /// 从文件路径解析完整图片元数据（EXIF + 格式扩展信息）。
  FullImageMetadata parseFullImageMetadataFromFile({required String path}) =>
      frb_reader.parseFullImageMetadataFromFile(parser: _inner, path: path);

  /// Parses full image metadata (EXIF + format extras) from bytes.
  ///
  /// 从内存字节解析完整图片元数据（EXIF + 格式扩展信息）。
  FullImageMetadata parseFullImageMetadataFromBytes({
    required List<int> data,
  }) => frb_reader.parseFullImageMetadataFromBytes(parser: _inner, data: data);

  /// Parses embedded MP4 video metadata from a Motion Photo file path.
  ///
  /// 从 Motion Photo 文件路径解析内嵌 MP4 视频元数据。
  VideoTrack parseEmbeddedVideoFromFile({required String path}) =>
      frb_reader.parseEmbeddedVideoFromFile(parser: _inner, path: path);

  /// Parses embedded MP4 video metadata from Motion Photo bytes.
  ///
  /// 从 Motion Photo 字节数据解析内嵌 MP4 视频元数据。
  VideoTrack parseEmbeddedVideoFromBytes({required List<int> data}) =>
      frb_reader.parseEmbeddedVideoFromBytes(parser: _inner, data: data);

  /// Async version of [parseImageExifFromFile].
  ///
  /// [parseImageExifFromFile] 的异步版本。
  Future<ImageExif> parseImageExifFromFileAsync({required String path}) =>
      frb_parser_async.parseImageExifFromFileAsync(parser: _inner, path: path);

  /// Async version of [parseImageExifFromBytes].
  ///
  /// [parseImageExifFromBytes] 的异步版本。
  Future<ImageExif> parseImageExifFromBytesAsync({required List<int> data}) =>
      frb_parser_async.parseImageExifFromBytesAsync(parser: _inner, data: data);

  /// Async version of [parseVideoMetadataFromFile].
  ///
  /// [parseVideoMetadataFromFile] 的异步版本。
  Future<VideoTrack> parseVideoMetadataFromFileAsync({required String path}) =>
      frb_parser_async.parseVideoMetadataFromFileAsync(
        parser: _inner,
        path: path,
      );

  /// Async version of [parseVideoMetadataFromBytes].
  ///
  /// [parseVideoMetadataFromBytes] 的异步版本。
  Future<VideoTrack> parseVideoMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseVideoMetadataFromBytesAsync(
    parser: _inner,
    data: data,
  );

  /// Async version of [parseFullImageMetadataFromFile].
  ///
  /// [parseFullImageMetadataFromFile] 的异步版本。
  Future<FullImageMetadata> parseFullImageMetadataFromFileAsync({
    required String path,
  }) => frb_parser_async.parseFullImageMetadataFromFileAsync(
    parser: _inner,
    path: path,
  );

  /// Async version of [parseFullImageMetadataFromBytes].
  ///
  /// [parseFullImageMetadataFromBytes] 的异步版本。
  Future<FullImageMetadata> parseFullImageMetadataFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseFullImageMetadataFromBytesAsync(
    parser: _inner,
    data: data,
  );

  /// Async version of [parseEmbeddedVideoFromFile].
  ///
  /// [parseEmbeddedVideoFromFile] 的异步版本。
  Future<VideoTrack> parseEmbeddedVideoFromFileAsync({required String path}) =>
      frb_parser_async.parseEmbeddedVideoFromFileAsync(
        parser: _inner,
        path: path,
      );

  /// Async version of [parseEmbeddedVideoFromBytes].
  ///
  /// [parseEmbeddedVideoFromBytes] 的异步版本。
  Future<VideoTrack> parseEmbeddedVideoFromBytesAsync({
    required List<int> data,
  }) => frb_parser_async.parseEmbeddedVideoFromBytesAsync(
    parser: _inner,
    data: data,
  );
}
