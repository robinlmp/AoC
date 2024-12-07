// swift-tools-version: 6.0
import PackageDescription

let inputFiles: [Resource] = (1...25)
    .map { "Day \($0)/Day\($0).input" }
    .map {  .process($0) }

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    dependencies: [
        // Some recommended packages here, you might like to try them!
        
        // Sequence and collection algorithms
        // i.e. rotations, permutations, etc.
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        
        .package(url: "https://github.com/apple/swift-collections.git",
                 .upToNextMinor(from: "1.1.0")),
        
        // Support for numerical computing, including complex numbers
        //.package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            resources: inputFiles
        ),
        .testTarget(name: "AdventOfCodeTests", dependencies: ["AdventOfCode"], resources: inputFiles)
    ]
)
