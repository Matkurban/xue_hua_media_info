/// Detected kind of a media file. / 检测到的媒体种类。
enum MediaKind {
  /// A still image (JPEG, PNG, HEIC, TIFF, …). / 静态图片。
  image,

  /// A container with at least one video track. / 含视频轨的容器。
  video,

  /// An audio-only container. / 纯音频容器。
  audio,
}
