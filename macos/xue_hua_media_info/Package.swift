// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xue_hua_media_info",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "xue-hua-media-info", targets: ["xue_hua_media_info"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "xue_hua_media_info_objc_gen",
            dependencies: [],
            publicHeadersPath: "."
        ),
        .target(
            name: "xue_hua_media_info",
            dependencies: [
                "xue_hua_media_info_objc_gen",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
