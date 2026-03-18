// swift-tools-version:5.3

import Foundation
import PackageDescription

var sources = ["src/parser.c"]
if FileManager.default.fileExists(atPath: "src/scanner.c") {
    sources.append("src/scanner.c")
}

let package = Package(
    name: "TreeSitterBoogie",
    products: [
        .library(name: "TreeSitterBoogie", targets: ["TreeSitterBoogie"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterBoogie",
            dependencies: [],
            path: ".",
            sources: sources,
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterBoogieTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterBoogie",
            ],
            path: "bindings/swift/TreeSitterBoogieTests"
        )
    ],
    cLanguageStandard: .c11
)
