import PackageDescription

let package = Package(
  name: "SwiftyTextTable",
  exclude: ["Source/SwiftyTextTableTests"],
  targets: [
    Target(name: "SwiftyTextTable")
  ]
)
