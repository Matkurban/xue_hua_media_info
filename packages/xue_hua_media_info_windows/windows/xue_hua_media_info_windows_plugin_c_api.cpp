#include "include/xue_hua_media_info_windows/xue_hua_media_info_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "xue_hua_media_info_windows_plugin.h"

void XueHuaMediaInfoWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  xue_hua_media_info_windows::XueHuaMediaInfoWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
