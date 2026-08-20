import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

/// In-memory [XueHuaMediaInfoPlatform] test double.
/// 内存版 [XueHuaMediaInfoPlatform] 测试替身。
class FakeMediaInfoPlatform extends XueHuaMediaInfoPlatform
    with MockPlatformInterfaceMixin {
  /// Recorded method names. / 记录的方法名。
  final List<String> calls = [];

  /// Stub returned by [read] / [readImage]. / [read] / [readImage] 的替身结果。
  MediaMetadata nextRead = const ImageMetadata(make: 'Canon');

  /// Stub returned by [readAv]. / [readAv] 的替身结果。
  AvMetadata nextAv = const VideoMetadata(
    duration: Duration(milliseconds: 1000),
    size: PixelSize(width: 1920, height: 1080),
  );

  /// Stub returned by [probe]. / [probe] 的替身结果。
  MediaKind nextKind = MediaKind.image;

  /// Stub returned by [readMotionPhoto]. / [readMotionPhoto] 的替身结果。
  VideoMetadata nextMotionPhoto = const VideoMetadata(
    duration: Duration(milliseconds: 500),
  );

  /// When set, the next call throws this error. / 设置后下一次调用抛出该错误。
  MediaInfoError? nextError;

  T _run<T>(String name, T Function() body) {
    calls.add(name);
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
    return body();
  }

  @override
  Future<MediaMetadata> read(MediaSource source) async {
    return _run('read:$source', () => nextRead);
  }

  @override
  Future<ImageMetadata> readImage(MediaSource source) async {
    return _run('readImage:$source', () {
      final value = nextRead;
      if (value is ImageMetadata) {
        return value;
      }
      throw const MediaInfoError(
        code: MediaInfoError.codeWrongKind,
        message: 'Not an image.',
      );
    });
  }

  @override
  Future<AvMetadata> readAv(MediaSource source) async {
    return _run('readAv:$source', () => nextAv);
  }

  @override
  Future<MediaKind> probe(MediaSource source) async {
    return _run('probe:$source', () => nextKind);
  }

  @override
  Future<VideoMetadata> readMotionPhoto(MediaSource source) async {
    return _run('readMotionPhoto:$source', () => nextMotionPhoto);
  }
}
