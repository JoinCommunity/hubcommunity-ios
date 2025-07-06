// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "storage",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "storage",
            targets: ["storage"]),
    ],
    dependencies: [
        .package(path: "../models")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "storage",
            dependencies: ["models"]),
        .testTarget(
            name: "storageTests",
            dependencies: ["storage"]
        ),
    ]
)
