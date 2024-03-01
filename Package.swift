// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPySimpleGUI",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPySimpleGUI",
            targets: ["SwiftPySimpleGUI"]),
    ], dependencies: [
        .package(url: "https://github.com/pvieito/PythonKit.git", exact: "0.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftPySimpleGUI",
            dependencies: [.byName(name: "PythonKit")]
        ),
        .testTarget(
            name: "SwiftPySimpleGUITests",
            dependencies: ["SwiftPySimpleGUI"]),
    ]
)
