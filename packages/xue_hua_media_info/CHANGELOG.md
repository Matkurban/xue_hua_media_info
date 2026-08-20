# Changelog

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
