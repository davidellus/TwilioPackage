// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwilioPackage",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TwilioPackage",
            targets: ["TwilioPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TwilioPackage",
            dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "CryptoSwift", package: "CryptoSwift")
        ]),
        .testTarget(
            name: "TwilioPackageTests",
            dependencies: ["TwilioPackage"]),
    ]
)
