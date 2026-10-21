import 'package:flutter/foundation.dart';

/// A PNG `tEXt` (or equivalent) key/value chunk.
/// PNG `tEXt`（或等价）键值对。
@immutable
final class PngTextChunk {
  /// Creates a PNG text chunk. / 创建 PNG 文本块。
  const PngTextChunk({required this.key, required this.value});

  /// Chunk keyword. / 关键字。
  final String key;

  /// Chunk text. / 文本内容。
  final String value;

  @override
  bool operator ==(Object other) =>
      other is PngTextChunk && other.key == key && other.value == value;

  @override
  int get hashCode => Object.hash(key, value);

  @override
  String toString() => 'PngTextChunk($key=$value)';
}
