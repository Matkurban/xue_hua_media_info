/// Web implementation of the `xue_hua_media_info` plugin.
/// `xue_hua_media_info` 插件的 Web 实现。
library;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

import 'src/xue_hua_media_info_web.dart';

export 'src/xue_hua_media_info_web.dart';

/// Registers the Web implementation with the plugin registry.
/// 向插件注册表注册 Web 实现。
class XueHuaMediaInfoWebPlugin {
  /// Called by Flutter when the plugin is registered on Web.
  /// Flutter 在 Web 上注册本插件时调用。
  static void registerWith(Registrar registrar) {
    XueHuaMediaInfoPlatform.instance = XueHuaMediaInfoWeb();
  }
}
