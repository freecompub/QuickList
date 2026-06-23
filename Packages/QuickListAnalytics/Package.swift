// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListAnalytics",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "QuickListAnalytics", targets: ["QuickListAnalytics"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "QuickListAnalytics",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        )
    ]
)
