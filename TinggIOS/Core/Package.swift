// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint:disable all
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "10.28.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Core",
            dependencies: [.product(name: "Alamofire", package: "Alamofire"), .product(name: "RealmSwift", package: "realm-swift")]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
