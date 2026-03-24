#!/usr/bin/env python3

import sys
import re

# rules to be written into un-left-factored form. for example,
#
#     Term ::= Factor ("+" Factor)*
#
# becomes
#
#     _Term ::= _Factor | Term
#     Term  ::= _Factor ("+" _Factor)+
#
# where the "_" indicates an expression of Term or stronger
# precedence. the Term rule is changed to match exactly Term only.
ll_rules = [
    # 'EquivExpression',
    # 'ImpliesExpression',
    # 'LogicalExpression',
    # 'RelationalExpression',
    # 'BvTerm',
    # 'Term',
    # 'Factor',
    # 'Power',
    # 'IsConstructor',
    # 'UnaryExpression',
    # 'CoercionExpression',
    # 'ArrayExpression',
    # # 'AtomExpression',
    # 'IdsTypeWhere'
]

make_underscore = [
    # 'Expression'
]

# make these rules right-precedence for ITE handling
make_prec_right = [
    # "EquivExpression",
    # "ImpliesExpression",
    # "LogicalExpression",
    # "BvTerm",
    # "Term",
    # "Factor",
    # "CoercionExpression",
    # "ArrayExpression"
]

inp = sys.stdin.read()

for ll in ll_rules + make_underscore:
    inp = re.sub(rf'\b{ll}\b', f'_{ll}', inp)

# this runs after underscores have already been inserted
def transform_line(line: str):
    rule_name = line.split('::=')[0].strip().lstrip('_')
    if rule_name in make_underscore or not line.startswith('  _'):
        yield line
        return
    init, rest = line.split('(', 1)
    init_rule = init.split('::=')[-1]

    if rule_name == 'UnaryExpression':
        yield '  _UnaryExpression ::= UnaryExpression | _CoercionExpression'
        yield line.replace('_', '', 1).replace('| _CoercionExpression', '')
        return

    rest = re.sub(r'\*$', '+', rest)
    rest = re.sub(r'\?$', '', rest)
    yield f'{init} | {rule_name}'
    if rule_name in make_prec_right:
        yield f'  {rule_name} ::= >( {init_rule} ( {rest} )'
    else:
        yield f'  {rule_name} ::= {init_rule} ( {rest}'

inp = '\n'.join(x for l in inp.splitlines() for x in transform_line(l))

print(inp)
