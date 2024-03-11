// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "DreamBuildShip",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "DreamBuildShip",
            targets: ["DreamBuildShip"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
        .package(url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "DreamBuildShip",
            dependencies: [
              .product(name: "Publish", package: "publish"),
              .product(name: "SplashPublishPlugin", package: "SplashPublishPlugin")
            ]
        ),
        
    ]
)
