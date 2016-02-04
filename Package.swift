import PackageDescription

let package = Package(
  name: "SwiftyTextTable",
  targets: [
    Target(name: "SwiftyTextTable"),
    Target(name: "SwiftyTextTableTests",
      dependencies: [
        .Target(name: "SwiftyTextTable")
      ]),
  ]
)
