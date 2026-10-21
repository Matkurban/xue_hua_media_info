import 'package:flutter/foundation.dart';

/// Integer pixel dimensions. / 整数像素宽高。
@immutable
final class PixelSize {
  /// Creates a size in pixels. / 创建像素尺寸。
  const PixelSize({required this.width, required this.height});

  /// Width in pixels. / 宽度（像素）。
  final int width;

  /// Height in pixels. / 高度（像素）。
  final int height;

  @override
  bool operator ==(Object other) =>
      other is PixelSize && other.width == width && other.height == height;

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => '${width}x$height';
}
