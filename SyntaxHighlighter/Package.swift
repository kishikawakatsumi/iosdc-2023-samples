// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "SyntaxHighlighter",
  platforms: [.macOS(.v10_15)],
  products: [
    .executable(
      name: "SyntaxHighlighter",
      targets: ["SyntaxHighlighter"]
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
      name: "SyntaxHighlighter",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax")
      ]
    ),
  ]
)
