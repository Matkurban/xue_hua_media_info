# Changelog

## 2.0.1

- Fix MSVC build: define `NOMINMAX`, parenthesize `std::min`, rename the image helper to `ReadImageInternal`, and cast Media Foundation stream indexes to `DWORD`.
  修复 MSVC 编译：定义 `NOMINMAX`、括号保护 `std::min`、将图片解析辅助函数重命名为 `ReadImageInternal`，并将 Media Foundation 流索引转为 `DWORD`。

## 2.0.0

Windows implementation using WIC and Media Foundation.
Windows 实现：WIC + Media Foundation。
