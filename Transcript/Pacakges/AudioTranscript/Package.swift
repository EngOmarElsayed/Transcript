// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioTranscript",
    platforms: [
      .iOS(.v17),
      .macOS(.v14)
    ],
    products: [
        .library(
            name: "AudioTranscript",
            targets: ["AudioTranscript"]),
    ],
    targets: [
        .target(
            name: "AudioTranscript"
        ),
        .testTarget(
            name: "AudioTranscriptTests",
            dependencies: ["AudioTranscript"]
        )
    ]
)
