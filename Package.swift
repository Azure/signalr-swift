// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SignalRClient",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "SignalRClient", targets: ["SignalRClient"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/inaka/EventSource.git", revision: "78934b3"
        ),
        .package(url: "https://github.com/hirotakan/MessagePacker.git", .exact("0.4.7"))
    ],
    targets: [
        .target(
            name: "SignalRClient",
            dependencies: [
                .product(name: "EventSource", package: "EventSource", condition: .when(platforms: [.macOS, .iOS, .tvOS, .visionOS, .watchOS])),
                .product(name: "MessagePacker", package: "MessagePacker")
            ]
        ),
        .testTarget(
            name: "SignalRClientTests", dependencies: ["SignalRClient"],
            swiftSettings: [
//                .enableExperimentalFeature("StrictConcurrency")
              ]
        ),
    ]
)
