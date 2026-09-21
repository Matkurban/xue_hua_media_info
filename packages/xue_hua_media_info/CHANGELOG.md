# Changelog

## 2.0.4

- Depend on `xue_hua_media_info_windows` 2.0.1 (MSVC compile fix). 2.0.3
  still resolved `^2.0.0` because the Windows 2.0.2 commit had not been
  merged when 2.0.3 was published.
  依赖 `xue_hua_media_info_windows` 2.0.1（MSVC 编译修复）。2.0.3 发布时尚未
  合并 Windows 2.0.2 提交，因此仍解析到 `^2.0.0`。

## 2.0.3

- Ship the `xue_hua_media_info-read` package skill (`skills/`) so agents can
  install it with `dart run skills@ get`.
  随包发布 `xue_hua_media_info-read` skill，可用 `dart run skills@ get` 安装。

## 2.0.2

- Depend on `xue_hua_media_info_windows` 2.0.1, which fixes MSVC compile errors
  on Windows.
  依赖 `xue_hua_media_info_windows` 2.0.1，修复 Windows 上的 MSVC 编译错误。

## 2.0.1

- Align the example Android build with Gradle 8.14.5 and Android Gradle Plugin 8.13.2.
  示例 Android 工程对齐 Gradle 8.14.5 与 Android Gradle Plugin 8.13.2。

## 2.0.0

Complete rewrite as a federated plugin with fully native implementations.
彻底重写为联合插件，全平台纯原生实现。

- **BREAKING**: the Rust (`flutter_rust_bridge` + `nom-exif`) engine is removed;
  see [MIGRATION.md](https://github.com/Matkurban/xue_hua_media_info/blob/main/MIGRATION.md).
  移除 Rust 引擎，迁移指南见 MIGRATION.md。
- New `MediaInfo` API: `read` / `readImage` / `readAv` / `probe` /
  `readMotionPhoto` with sealed `MediaMetadata` results.
  全新 `MediaInfo` API 与密封结果类型。
- First-class fields (`PixelSize`, `GpsLocation`, `pngText`) instead of tag
  soup. 一等字段取代标签列表。
- New Web platform support. 新增 Web 平台支持。
- Structured `MediaInfoError` with stable string codes.
  统一结构化错误码。
