// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLinuxBLE",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftLinuxBLE",
            targets: ["SwiftLinuxBLE"]),
    ],
    dependencies: [
	.package(url: "https://github.com/PureSwift/GATT", .branch("master")),
        .package(url: "https://github.com/PureSwift/BluetoothLinux", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftLinuxBLE",
            dependencies: ["GATT", "BluetoothLinux"]),
        .testTarget(
            name: "SwiftLinuxBLETests",
            dependencies: ["SwiftLinuxBLE"]),
    ]
)
