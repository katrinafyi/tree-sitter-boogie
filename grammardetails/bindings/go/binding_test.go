package tree_sitter_grammar_details_md_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_grammar_details_md "github.com/tree-sitter/tree-sitter-grammar_details_md/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_grammar_details_md.Language())
	if language == nil {
		t.Errorf("Error loading GrammarDetailsMd grammar")
	}
}
