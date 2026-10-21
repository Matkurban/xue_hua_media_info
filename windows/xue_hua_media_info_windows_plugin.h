#ifndef FLUTTER_PLUGIN_XUE_HUA_MEDIA_INFO_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_XUE_HUA_MEDIA_INFO_WINDOWS_PLUGIN_H_

#include <flutter/plugin_registrar_windows.h>

#include <string>

#include "messages.g.h"

namespace xue_hua_media_info_windows {

class XueHuaMediaInfoWindowsPlugin : public flutter::Plugin,
                                     public MediaInfoHostApi {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  explicit XueHuaMediaInfoWindowsPlugin(std::wstring assets_dir);
  virtual ~XueHuaMediaInfoWindowsPlugin();

  XueHuaMediaInfoWindowsPlugin(const XueHuaMediaInfoWindowsPlugin&) = delete;
  XueHuaMediaInfoWindowsPlugin& operator=(
      const XueHuaMediaInfoWindowsPlugin&) = delete;

  void Read(const MediaSourceMessage& source,
            std::function<void(ErrorOr<MediaMetadataMessage> reply)> result)
      override;
  void ReadImage(
      const MediaSourceMessage& source,
      std::function<void(ErrorOr<ImageMetadataMessage> reply)> result) override;
  void ReadAv(const MediaSourceMessage& source,
              std::function<void(ErrorOr<MediaMetadataMessage> reply)> result)
      override;
  void Probe(const MediaSourceMessage& source,
             std::function<void(ErrorOr<MediaKindMessage> reply)> result)
      override;
  void ReadMotionPhoto(
      const MediaSourceMessage& source,
      std::function<void(ErrorOr<VideoMetadataMessage> reply)> result) override;

 private:
  std::wstring assets_dir_;
};

}  // namespace xue_hua_media_info_windows

#endif  // FLUTTER_PLUGIN_XUE_HUA_MEDIA_INFO_WINDOWS_PLUGIN_H_
