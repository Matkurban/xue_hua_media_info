/// The common platform interface for the `xue_hua_media_info` plugin.
///
/// Platform implementations extend [XueHuaMediaInfoPlatform]; app code should
/// depend on the `xue_hua_media_info` package instead of this one.
///
/// `xue_hua_media_info` 插件的通用平台接口。
///
/// 各平台实现需继承 [XueHuaMediaInfoPlatform]；应用代码请依赖
/// `xue_hua_media_info` 包而非本包。
library;

export 'src/method_channel_xue_hua_media_info.dart';
export 'src/types/gps_location.dart';
export 'src/types/media_info_error.dart';
export 'src/types/media_kind.dart';
export 'src/types/media_metadata.dart';
export 'src/types/media_source.dart';
export 'src/types/metadata_tag.dart';
export 'src/types/pixel_size.dart';
export 'src/types/png_text_chunk.dart';
export 'src/xue_hua_media_info_platform.dart';
