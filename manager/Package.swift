// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "manager",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other
        // packages.
        .library(
            name: "manager",
            targets: ["manager"]
        )
    ],
    dependencies: [
        .package(path: "../api"),
        .package(path: "../models"),
        .package(path: "../storage")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "manager",
            dependencies: [
                "api",
                "models",
                "storage"
            ]
        ),
        .testTarget(
            name: "managerTests",
            dependencies: ["manager"]
        )
    ]
)
