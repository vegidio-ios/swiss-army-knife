// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-armyknife",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Network", targets: ["Network"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(name: "Extensions", dependencies: [], path: "Sources/Extensions"),
        .target(name: "Network", dependencies: [], path: "Sources/Network"),
    ]
)
