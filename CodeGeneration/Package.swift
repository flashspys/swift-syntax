// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "CodeGeneration",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .executable(name: "generate-swiftsyntax", targets: ["generate-swiftsyntax"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", revision: "4727d3c3f81be056cf7f9636d682ac9879270d12"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.2.2")),
  ],
  targets: [
    .executableTarget(
      name: "generate-swiftsyntax",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "SyntaxSupport",
        "Utils",
      ]
    ),
    .target(
      name: "SyntaxSupport",
      exclude: [
        "gyb_helpers",
        "AttributeKinds.swift.gyb",
        "AttributeNodes.swift.gyb",
        "AvailabilityNodes.swift.gyb",
        "BuilderInitializableTypes.swift.gyb",
        "Classification.swift.gyb",
        "CommonNodes.swift.gyb",
        "DeclNodes.swift.gyb",
        "ExprNodes.swift.gyb",
        "GenericNodes.swift.gyb",
        "PatternNodes.swift.gyb",
        "StmtNodes.swift.gyb",
        "SyntaxBaseKinds.swift.gyb",
        "TokenSpec.swift.gyb",
        "Traits.swift.gyb",
        "Trivia.swift.gyb",
        "TypeNodes.swift.gyb",
      ]
    ),
    .target(
      name: "Utils",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        "SyntaxSupport",
      ]
    ),
  ]
)
