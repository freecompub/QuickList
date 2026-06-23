// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "QuickListCore",
    defaultLocalization: "fr",
    platforms: [
        .iOS("17.5"),
        .macOS(.v14)
    ],
    products: [
        .library(name: "QuickListCore", targets: ["QuickListCore"])
    ],
    targets: [
        .target(name: "QuickListCore")
    ]
)
