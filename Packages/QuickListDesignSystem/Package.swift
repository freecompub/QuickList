// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListDesignSystem",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "QuickListDesignSystem", targets: ["QuickListDesignSystem"])
    ],
    targets: [
        .target(
            name: "QuickListDesignSystem",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
