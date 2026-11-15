import 'src/types/media_kind.dart';
import 'src/types/media_metadata.dart';
import 'src/types/media_source.dart';
import 'xue_hua_media_info_method_channel.dart';

/// The interface that platform implementations of `xue_hua_media_info` must
/// implement.
///
/// Platform implementations should **extend** this class rather than implement
/// it, so that newly added methods (with default `UnimplementedError`
/// behavior) do not break them.
///
/// `xue_hua_media_info` 各平台实现必须实现的接口。
///
/// 平台实现应当**继承**（extends）本类而不是 implements，这样接口新增方法
/// （默认抛 `UnimplementedError`）时不会破坏现有实现。
abstract class XueHuaMediaInfoPlatform {
  /// Constructs a [XueHuaMediaInfoPlatform]. / 构造 [XueHuaMediaInfoPlatform]。
  XueHuaMediaInfoPlatform();

  /// The default instance of [XueHuaMediaInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelXueHuaMediaInfo], which uses Pigeon Native
  /// Interop (FFI/JNI) on Apple/Android and MethodChannel on Windows/Linux.
  /// The Web implementation replaces it during plugin registration.
  ///
  /// 当前使用的 [XueHuaMediaInfoPlatform] 默认实例。
  ///
  /// 默认为 [MethodChannelXueHuaMediaInfo]，在 Apple/Android 端使用 Pigeon
  /// Native Interop（FFI/JNI），在 Windows/Linux 端使用 MethodChannel；
  /// Web 实现会在插件注册时替换它。
  static XueHuaMediaInfoPlatform instance = MethodChannelXueHuaMediaInfo();

  /// Auto-detects the kind and reads metadata in one I/O.
  /// 自动识别种类并在一次 I/O 中读取元数据。
  Future<MediaMetadata> read(MediaSource source) {
    throw UnimplementedError('read() has not been implemented.');
  }

  /// Reads still-image metadata. Throws [MediaInfoError.codeWrongKind] when
  /// [source] is not an image.
  /// 读取静态图片元数据；源不是图片时抛 [MediaInfoError.codeWrongKind]。
  Future<ImageMetadata> readImage(MediaSource source) {
    throw UnimplementedError('readImage() has not been implemented.');
  }

  /// Reads a video or audio-only container. Throws
  /// [MediaInfoError.codeWrongKind] when [source] is an image.
  /// 读取视频或纯音频容器；源是图片时抛 [MediaInfoError.codeWrongKind]。
  Future<AvMetadata> readAv(MediaSource source) {
    throw UnimplementedError('readAv() has not been implemented.');
  }

  /// Inspects the file header only. / 仅检查文件头。
  Future<MediaKind> probe(MediaSource source) {
    throw UnimplementedError('probe() has not been implemented.');
  }

  /// Extracts the embedded MP4 from a Motion Photo.
  /// 从 Motion Photo 提取内嵌 MP4。
  Future<VideoMetadata> readMotionPhoto(MediaSource source) {
    throw UnimplementedError('readMotionPhoto() has not been implemented.');
  }
}
