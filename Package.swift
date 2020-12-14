// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

internal let package = Package(
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
        .package(url: "https://github.com/Alamofire/Alamofire", .exact("5.4.0")),
        .package(url: "https://github.com/hyperoslo/Cache", .exact("6.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .exact("6.0.0-rc.2")),

        // Test
        .package(url: "https://github.com/groue/CombineExpectations", .exact("0.5.0")),
    ],
    targets: [
        // Network
        .target(
            name: "SAKNetwork",
            dependencies: ["Alamofire", "Cache", "RxSwift", "SAKUtil"],
            path: "Source/Network"
        ),
        .testTarget(
            name: "SAKNetworkTests",
            dependencies: [
                "SAKNetwork",
                "SAKUtil",
                "CombineExpectations",
                .product(name: "RxBlocking", package: "RxSwift"),
            ],
            path: "Tests/Network"
        ),

        // Util
        .target(
            name: "SAKUtil",
            dependencies: [],
            path: "Source/Util"
        ),
        .testTarget(
            name: "SAKUtilTests",
            dependencies: [
                "SAKUtil",
            ],
            path: "Tests/Util"
        ),
    ]
)