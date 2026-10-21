import 'package:flutter/foundation.dart';

/// A vendor or leftover tag that was not lifted into a first-class field.
/// 未被提升为一等字段的厂商/冷门标签。
@immutable
final class MetadataTag {
  /// Creates a leftover tag. / 创建残留标签。
  const MetadataTag({
    required this.name,
    required this.displayValue,
    this.stringValue,
    this.intValue,
    this.doubleValue,
  });

  /// Canonical or native tag name. / 规范名或原生标签名。
  final String name;

  /// Human-readable value. / 供人阅读的值。
  final String displayValue;

  /// Typed string, when the native API exposed one. / 类型化字符串（若有）。
  final String? stringValue;

  /// Typed integer, when parseable. / 类型化整数（若可解析）。
  final int? intValue;

  /// Typed floating-point value, when parseable. / 类型化浮点（若可解析）。
  final double? doubleValue;

  @override
  bool operator ==(Object other) =>
      other is MetadataTag &&
      other.name == name &&
      other.displayValue == displayValue &&
      other.stringValue == stringValue &&
      other.intValue == intValue &&
      other.doubleValue == doubleValue;

  @override
  int get hashCode =>
      Object.hash(name, displayValue, stringValue, intValue, doubleValue);

  @override
  String toString() => 'MetadataTag($name=$displayValue)';
}
