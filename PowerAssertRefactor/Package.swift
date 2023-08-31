// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "PowerAssertRefactor",
  platforms: [.macOS(.v10_15)],
  products: [
    .executable(
      name: "PowerAssertRefactor",
      targets: ["PowerAssertRefactor"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"
    ),
  ],
  targets: [
    .executableTarget(
      name: "PowerAssertRefactor",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax")
      ]
    ),
  ]
)
