/// A type-safe description of where media bytes come from.
///
/// Use one of the three factory constructors:
/// [MediaSource.file], [MediaSource.bytes] or [MediaSource.asset].
///
/// 描述媒体数据来源的类型安全模型。
///
/// 请使用三个工厂构造函数之一：
/// [MediaSource.file]（本地文件）、[MediaSource.bytes]（内存字节）、
/// [MediaSource.asset]（Flutter Asset 资源）。
sealed class MediaSource {
  /// Creates a media source. / 创建媒体源。
  const MediaSource();

  /// A local filesystem path. / 本地文件系统路径。
  ///
  /// [path]: absolute path of the media file.
  /// [path]：媒体文件的绝对路径。
  const factory MediaSource.file(String path) = FileSource;

  /// An in-memory buffer. / 内存缓冲区。
  ///
  /// Suitable for assets already loaded, network downloads, or pasted bytes.
  /// 适用于已加载的 Asset、网络下载或内存中的字节。
  const factory MediaSource.bytes(List<int> data) = BytesSource;

  /// A Flutter asset key. / Flutter Asset 资源键。
  ///
  /// [key]: the asset key as declared in `pubspec.yaml`.
  /// [package]: when the asset belongs to another package, its package name.
  ///
  /// [key]：在 `pubspec.yaml` 中声明的资源键。
  /// [package]：当资源属于其他 package 时，填写其包名。
  const factory MediaSource.asset(String key, {String? package}) = AssetSource;
}

/// A [MediaSource] backed by a local file. / 基于本地文件的媒体源。
final class FileSource extends MediaSource {
  /// Creates a local-file source with the given [path].
  /// 使用给定的 [path] 创建本地文件媒体源。
  const FileSource(this.path);

  /// Absolute path of the media file. / 媒体文件的绝对路径。
  final String path;

  @override
  bool operator ==(Object other) => other is FileSource && other.path == path;

  @override
  int get hashCode => Object.hash(runtimeType, path);

  @override
  String toString() => 'MediaSource.file($path)';
}

/// A [MediaSource] backed by in-memory bytes. / 基于内存字节的媒体源。
final class BytesSource extends MediaSource {
  /// Creates a bytes source. / 创建字节媒体源。
  const BytesSource(this.data);

  /// Raw media bytes. / 原始媒体字节。
  final List<int> data;

  @override
  bool operator ==(Object other) => other is BytesSource && other.data == data;

  @override
  int get hashCode => Object.hash(runtimeType, Object.hashAll(data));

  @override
  String toString() => 'MediaSource.bytes(${data.length} bytes)';
}

/// A [MediaSource] backed by a Flutter asset. / 基于 Flutter Asset 的媒体源。
final class AssetSource extends MediaSource {
  /// Creates an asset source. / 创建 Asset 媒体源。
  const AssetSource(this.key, {this.package});

  /// The asset key declared in `pubspec.yaml`. / 在 `pubspec.yaml` 中声明的资源键。
  final String key;

  /// The owning package name, when the asset comes from another package.
  /// 当资源来自其他 package 时的包名。
  final String? package;

  /// The fully-resolved asset key used by the Flutter engine, including the
  /// `packages/<package>/` prefix when [package] is set.
  ///
  /// 返回 Flutter 引擎实际使用的完整资源键；当设置了 [package] 时会带上
  /// `packages/<package>/` 前缀。
  String get resolvedKey => package == null ? key : 'packages/$package/$key';

  @override
  bool operator ==(Object other) =>
      other is AssetSource && other.key == key && other.package == package;

  @override
  int get hashCode => Object.hash(runtimeType, key, package);

  @override
  String toString() => 'MediaSource.asset($key, package: $package)';
}
