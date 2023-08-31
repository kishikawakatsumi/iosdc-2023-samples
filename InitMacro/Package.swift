// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "InitMacro",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: "InitMacro",
      targets: ["InitMacro"]
    ),
    .executable(
      name: "InitMacroClient",
      targets: ["InitMacroClient"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"
    ),
  ],
  targets: [
    .macro(
      name: "InitMacroPlugin",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .target(name: "InitMacro", dependencies: ["InitMacroPlugin"]),
    .executableTarget(name: "InitMacroClient", dependencies: ["InitMacro"]),
    .testTarget(
      name: "InitMacroTests",
      dependencies: [
        "InitMacroPlugin",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
