// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DisplayLink",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(name: "DisplayLink", targets: ["DisplayLink"]),
    ],
    targets: [
        .target(
            name: "DisplayLink",
            path: ".",
            sources: ["DisplayLink.swift"]
        ),
    ]
)
