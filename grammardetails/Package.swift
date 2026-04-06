// swift-tools-version:5.3

import Foundation
import PackageDescription

var sources = ["src/parser.c"]
if FileManager.default.fileExists(atPath: "src/scanner.c") {
    sources.append("src/scanner.c")
}

let package = Package(
    name: "TreeSitterGrammarDetailsMd",
    products: [
        .library(name: "TreeSitterGrammarDetailsMd", targets: ["TreeSitterGrammarDetailsMd"]),
    ],
    dependencies: [
        .package(name: "SwiftTreeSitter", url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterGrammarDetailsMd",
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
            name: "TreeSitterGrammarDetailsMdTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterGrammarDetailsMd",
            ],
            path: "bindings/swift/TreeSitterGrammarDetailsMdTests"
        )
    ],
    cLanguageStandard: .c11
)
