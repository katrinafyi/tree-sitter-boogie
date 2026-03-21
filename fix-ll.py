#!/usr/bin/env python3

import sys
import re

ll_rules = [
    # 'Expression',
    'ImpliesExpression',
    'LogicalExpression',
    'RelationalExpression',
    'BvTerm',
    'Term',
    'Factor',
    'Power',
    'IsConstructor',
    'UnaryExpression',
    'CoercionExpression',
    'ArrayExpression',
    # 'AtomExpression',
    'IdsTypeWhere'
]

inp = sys.stdin.read()

for ll in ll_rules:
    inp = re.sub(rf'\b{ll}\b', f'_{ll}', inp)

def transform_line(line: str):
    if not line.startswith('  _'):
        yield line
        return
    init, rest = line.split('(', 1)
    init_rule = init.split('::=')[-1]
    rule_name = init.split()[0].lstrip('_')

    if rule_name == 'UnaryExpression':
        yield '  _UnaryExpression ::= UnaryExpression | _CoercionExpression'
        yield line.replace('_', '', 1).replace('| _CoercionExpression', '')
        return

    rest = re.sub(r'\*$', '+', rest)
    rest = re.sub(r'\?$', '', rest)
    yield f'{init} | {rule_name}'
    yield f'  {rule_name} ::= {init_rule} ( {rest}'

inp = '\n'.join(x for l in inp.splitlines() for x in transform_line(l))

print(inp)
