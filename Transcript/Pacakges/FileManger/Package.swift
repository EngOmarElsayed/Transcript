// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileManger",
    platforms: [
      .iOS(.v17),
      .macOS(.v14)
    ],
    products: [
        .library(
            name: "FileManger",
            targets: ["FileManger"]),
    ],
    targets: [
        .target(
            name: "FileManger"),
        .testTarget(
            name: "FileMangerTests",
            dependencies: ["FileManger"]),
    ]
)
