import XCTest
import SwiftTreeSitter
import TreeSitterBoogie

final class TreeSitterBoogieTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_boogie())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Boogie grammar")
    }
}
