// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "SwiftyTextTable",
  targets: [
    .target(name: "SwiftyTextTable"),
    .testTarget(name: "SwiftyTextTableTests", dependencies: [
      "SwiftyTextTable",
    ]),
  ]
)
