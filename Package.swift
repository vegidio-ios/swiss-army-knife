// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS-SAK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Network", targets: ["SAKNetwork"]),
        .library(name: "Util", targets: ["SAKUtil"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .exact("5.1.0")),
        .package(url: "https://github.com/fassko/Cache", .branch("master")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .exact("5.1.1")),
    ],
    targets: [
        // Network
        .target(
            name: "SAKNetwork",
            dependencies: ["Alamofire", "Cache", "RxSwift", "SAKUtil"],
            path: "Sources/Network"),
        .testTarget(
            name: "SAKNetworkTests",
            dependencies: ["SAKNetwork", "SAKUtil"],
            path: "Tests/Network"),
        
        // Util
        .target(
            name: "SAKUtil",
            dependencies: [],
            path: "Sources/Util"),
    ]
)
