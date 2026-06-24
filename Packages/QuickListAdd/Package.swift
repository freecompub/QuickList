// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListAdd",
    defaultLocalization: "fr",
    platforms: [
        .iOS("17.5"),
        .macOS(.v14)
    ],
    products: [
        .library(name: "QuickListAdd", targets: ["QuickListAdd"])
    ],
    dependencies: [
        .package(path: "../QuickListCore"),
        .package(path: "../QuickListAnalytics"),
        .package(path: "../QuickListDesignSystem"),
        .package(path: "../QuickListAI"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "QuickListAdd",
            dependencies: [
                "QuickListCore",
                "QuickListAnalytics",
                "QuickListDesignSystem",
                "QuickListAI",
                .product(name: "Logging", package: "swift-log")
            ]
        )
    ]
)
