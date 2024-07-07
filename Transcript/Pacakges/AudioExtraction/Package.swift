// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioExtraction",
    platforms: [
      .iOS(.v17),
      .macOS(.v14)
    ],
    products: [
        .library(
            name: "AudioExtraction",
            targets: ["AudioExtraction"]),
    ],
    targets: [
        .target(
            name: "AudioExtraction"),
        .testTarget(
            name: "AudioExtractionTests",
            dependencies: ["AudioExtraction"]),
    ]
)
