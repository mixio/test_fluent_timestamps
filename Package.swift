// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "test_timestamps",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),
        //.package(url: "https://github.com/mixio/jjtools.git", from: "0.0.1"),
        .package(url: "/Users/jj/Developer/mixio-git-forks/jjtools-mixio.git", from:"0.0.6")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentPostgreSQL", "JJTools"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

