// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickAdd",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "QuickAdd", targets: ["QuickAdd"])
    ],
    dependencies: [
        .package(path: "../QuickListCore"),
        .package(path: "../QuickListAnalytics"),
        .package(path: "../QuickListDesignSystem"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "QuickAdd",
            dependencies: [
                "QuickListCore",
                "QuickListAnalytics",
                "QuickListDesignSystem",
                .product(name: "Logging", package: "swift-log")
            ]
        )
    ]
)
