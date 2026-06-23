// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListLists",
    defaultLocalization: "fr",
    platforms: [
        .iOS("17.5"),
        .macOS(.v14)
    ],
    products: [
        .library(name: "QuickListLists", targets: ["QuickListLists"])
    ],
    dependencies: [
        .package(path: "../QuickListCore"),
        .package(path: "../QuickListAnalytics"),
        .package(path: "../QuickListDesignSystem"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "QuickListLists",
            dependencies: [
                "QuickListCore",
                "QuickListAnalytics",
                "QuickListDesignSystem",
                .product(name: "Logging", package: "swift-log")
            ]
        )
    ]
)
