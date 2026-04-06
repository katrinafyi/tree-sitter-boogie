# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "tree-sitter",
#   "tree_sitter_grammar_details_md@file:///home/rina/progs/tree-sitter-boogie/grammardetails",
# ]
# ///

import json
from tree_sitter import Language, Parser
import tree_sitter_grammar_details_md

lang = Language(tree_sitter_grammar_details_md.language())
p = Parser(lang)
t = p.parse(open('grammar.txt', 'rb').read())

char_classes = '''
letter
digit
posDigit
posDigitFrom2
hexdigit
special
cr
lf
tab
space
nondigitIdChar
idchar
nonidchar
charChar
stringChar
verbatimStringChar'''.split()

# print(char_classes)

def translate_charclass(node, char_class_defns):
    if node.child_count == 3:
        c = node.text[0]
        child = translate_charclass(node.child(1), char_class_defns)
        if c == b'[': return child + '?'
        elif c == b'{': return child + '*'
        elif c == b'(': return child
        assert False

    if node.type == "terminal_rule":
        node = node.child(0)
    if node.type == "terminal_atom":
        node = node.child(0)
    if node.type == "literal":
        node = node.child(0)

    text = node.text.decode('utf-8')
    match node.type:
        case "string_literal":
            return f"[{text.strip('"')}]"
        case "char_literal":
            return f"[{text.strip("'").replace(r"\'", "'")}]"
        case "terminal_name":
            return char_class_defns[text]
        case "terminal_addition":
            return '[' + ''.join(translate_charclass(x, char_class_defns) for x in node.children) + ']'
        case "terminal_subtraction":
            return '[' + translate_charclass(node.child(0), char_class_defns) + '&&[^' + translate_charclass(node.child(2), char_class_defns) + ']]'
        case "ANY":
            return r'[\s\S]'
        case "+" | "-":
            return ''
        case _:
            assert False, f"unknown charclass {node.type} {node.children}, {node.text}"

def translate_nonterminal2(node):

    if node.child_count == 3:
        c = node.text[:1]
        if c == b'[': f = 'optional'
        elif c == b'{': f = 'repeat'
        elif c == b'(': f = ''
        else: assert False, node.text
        yield f + '('
        yield from translate_nonterminal2(node.child(1))
        yield ')'
        return

    if node.type == "terminal_rule":
        node = node.child(0)
    if node.type == "terminal_atom":
        node = node.child(0)
    if node.type == "literal":
        node = node.child(0)

    text = node.text.decode('utf-8')
    match node.type:
        case "terminal_alternation":
            yield f"choice("
            for x in node.children:
                if x.type == 'terminal_rule':
                    yield from translate_nonterminal2(x)
                    yield ','
            yield ')'
        case "terminal_sequence":
            yield f"seq("
            for x in node.children:
                if x.type == 'terminal_rule':
                    yield from translate_nonterminal2(x)
                    yield ','
            yield ')'
        case "string_literal":
            yield json.dumps(text.strip('"'))
        case "char_literal":
            yield text
        case "terminal_name":
            yield "$." + text
        case "0":
            yield '"0"'
        case _:
            assert False, f"unknown token nonterminal. {node.type} {node.children}, {node.text}"


def translate_terminal(node, char_class_defns = {}):
    name = node.child(0).text.decode('ascii')
    yield f'{name}: $ =>'
    if name in char_classes:
        char_class_defns[name] = translate_charclass(node.child(2), char_class_defns)
        # for k, v in char_class_defns.items():
        #     print(k, v)
        yield f'new RustRegex({json.dumps(char_class_defns[name])})'
    else:
        yield from translate_nonterminal2(node.child(2))
    yield ','

def translate_nonterminal(node):
    yield from []

def translate(node):
    match node.type:
        case "terminal_decl":
            return translate_terminal(node)
        case "nonterminal_decl":
            return translate_nonterminal(node)
        case _:
            assert False, "unknown toplevel node type"

decls = [y for x in t.root_node.children for y in x.children]

print('module.exports = grammar({')
print('name: "grammar_details_md",')
print('rules: {')
for x in decls:
    for l in translate(x):
        print(l)
print('}')
print('})')
