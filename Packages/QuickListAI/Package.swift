// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListAI",
    defaultLocalization: "fr",
    platforms: [
        .iOS("17.5"),
        .macOS(.v14)
    ],
    products: [
        .library(name: "QuickListAI", targets: ["QuickListAI"])
    ],
    dependencies: [
        .package(path: "../QuickListAnalytics"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "QuickListAI",
            dependencies: [
                "QuickListAnalytics",
                .product(name: "Logging", package: "swift-log")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
