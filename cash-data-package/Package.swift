// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cash-data-package",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "cash-data-package",
            targets: ["cash-data-package"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "cash-network-package", path: "cash-network-package")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "cash-data-package",
            dependencies: ["cash-network-package"]),
        .testTarget(
            name: "cash-data-packageTests",
            dependencies: ["cash-data-package"]),
    ]
)
