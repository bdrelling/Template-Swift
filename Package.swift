// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MyModule",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "MyModule", targets: ["MyModule"])
    ],
    dependencies: [
        // add dependencies here
    ],
    targets: [
        // Product Targets
        .target(
            name: "MyModule",
            dependencies: []
        ),
        // Test Targets
        .testTarget(
            name: "MyModuleTests",
            dependencies: [
                .target(name: "MyModule"),
            ]
        ),
    ]
)

#if swift(>=5.5)
// Add Kipple Tools if possible.
package.dependencies.append(
    .package(url: "https://github.com/swift-kipple/Tools", from: "0.2.5")
)
#endif
