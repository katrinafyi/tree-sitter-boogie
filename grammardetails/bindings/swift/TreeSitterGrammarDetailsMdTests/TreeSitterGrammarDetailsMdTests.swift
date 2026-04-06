import XCTest
import SwiftTreeSitter
import TreeSitterGrammarDetailsMd

final class TreeSitterGrammarDetailsMdTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_grammar_details_md())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading GrammarDetailsMd grammar")
    }
}
