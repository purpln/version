// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Version",
    platforms: [.iOS(.v10)],
    products: [.library(name: "Version", targets: ["Version"])],
    dependencies: [],
    targets: [.target(name: "Version")]
)
