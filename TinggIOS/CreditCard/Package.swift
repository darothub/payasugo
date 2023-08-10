// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreditCard",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CreditCard",
            targets: ["CreditCard"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Theme"),
        .package(path: "../CoreUI"),
        .package(path: "../Core"),
        .package(path: "../Permissions"),
        .package(path: "../CoreNavigation"),
        .package(path: "../FreshChat"),
        .package(path: "../Pin")
        
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CreditCard",
            dependencies: ["Core", "Theme", "CoreUI", "Permissions", "CoreNavigation", "FreshChat", "Pin"]),
        .testTarget(
            name: "CreditCardTests",
            dependencies: ["CreditCard"]),
    ]
)
