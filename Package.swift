// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-ray",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Ray", targets: ["Ray"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-line.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-point.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(name: "Ray", dependencies: [
            .product(name: "Line", package: "swift-line"),
            .product(name: "Magnitude", package: "swift-magnitude"),
        ]),
        .testTarget(name: "Ray Tests", dependencies: [
            .target(name: "Ray"),
            .product(name: "Point", package: "swift-point"),
            .product(name: "Tagged", package: "swift-tagged"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
