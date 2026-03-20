project(
  'tree-sitter-boogie',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
    'datadir': meson.project_source_root(),
  },
)

ts_ebnf_gen = subproject('ts-ebnf-gen', required : get_option('subproject_ebnf_gen'))
parse_grammar = find_program('parse_grammar.lua')

cocor_cpp = subproject('cocor-cpp', required : get_option('subproject_coco'))
cocor = find_program('CocoR-CPP')

if get_option('boogie_atg') == ''
  boogie_atg = subproject('boogie-atg').get_variable('grammar')
else
  boogie_atg = files(get_option('boogie_atg'))
endif

fs = import('fs')

unpatched_ebnf = custom_target(
  'unpatched-ebnf',
  output: ['Parser.ebnf'],
  command: [
    cocor, boogie_atg, '-genRREBNF',
    '-frames', fs.parent(cocor_cpp.get_variable('frame').full_path()),
    '-o', '@OUTDIR@'
  ]
)

fix_ebnf = files('fix-ebnf.sh')
fix_grammar = files('fix-grammar.sh')

boogie_ebnf = custom_target(
  'boogie-ebnf',
  output: ['boogie.ebnf'],
  command: [
    'bash', '-c', '$1 < $2 > $3',
    'boogie-ebnf-task',
    fix_ebnf,
    unpatched_ebnf,
    '@OUTPUT@'
  ]
)

unpatched_js = custom_target(
  'unpatched-js',
  output: 'unpatched.js',
  command: [
    'bash', '-c', '$1 $2 | $3 > $4',
    'unpatched-js-task',
    parse_grammar,
    boogie_ebnf,
    fix_grammar,
    '@OUTPUT@'
  ]
)

fix_grammar_diff = files('fix-grammar.diff')
grammar_js = custom_target(
  'grammar-js',
  output: 'grammar.js',
  command: [
    'bash', '-c', 'cp -v $1 $2 && patch $2 --merge -i $3',
    'grammar-js-task',
    unpatched_js,
    '@OUTPUT@',
    fix_grammar_diff
  ]
)
