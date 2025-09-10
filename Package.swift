// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitAuthManager",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "GitAuthManager",
            targets: ["GitAuthManager"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "GitAuthManager",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
