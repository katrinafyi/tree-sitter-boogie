project(
  'tree-sitter-boogie',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
    'datadir': meson.project_source_root(),
  },
)

# ts_ebnf_gen = subproject('ts-ebnf-gen', required : get_option('subproject_ebnf_gen'))
parse_grammar = find_program('parse_grammar.lua')
# cocor_cpp = subproject('cocor-cpp', required : get_option('subproject_coco'))
cocor = find_program('CocoR-CPP')

if get_option('boogie_atg') == ''
  boogie_atg = subproject('boogie-atg').get_variable('grammar')
else
  boogie_atg = files(get_option('boogie_atg'))
endif

fs = import('fs')

frames = files('frames/Parser.frame', 'frames/Scanner.frame')
frames_dir = run_command('dirname', frames[0], capture : true, check : true).stdout().strip()

original_ebnf = custom_target(
  'Parser.ebnf',
  output: ['Parser.ebnf'],
  command: [
    cocor, boogie_atg,
    '-genRREBNF',
    '-frames', frames_dir,
    '-o', '@OUTDIR@'
  ],
  # install: true,
  # install_dir: get_option('datadir'),
  # install_tag: 'grammar'
)

fix_ebnf = files('fix-ebnf.sh')
fix_ebnf_diff = files('fix-ebnf.diff')
fix_grammar = files('fix-grammar.sh')

boogie_ebnf_task = custom_target(
  'boogie.ebnf',
  output: ['boogie.ebnf', 'boogie.ebnf.orig'],
  command: [
    'bash', '-c', '$1 < $2 > $3.orig && cp $3.orig $3 && patch $3 --merge -i $4',
    'boogie-ebnf-task',
    fix_ebnf,
    original_ebnf,
    '@OUTPUT0@',
    fix_ebnf_diff
  ],
)
boogie_ebnf = boogie_ebnf_task[0]

grammar_js = custom_target(
  'grammar.js',
  output: 'grammar.js',
  command: [
    'bash', '-c', '$1 $2 | $3 > $4',
    'unpatched-js-task',
    parse_grammar,
    boogie_ebnf,
    fix_grammar,
    '@OUTPUT@'
  ],
  install: true,
  install_dir: get_option('datadir'),
  install_tag: 'grammar'
)

rr_ebnf = custom_target(
  'rr.ebnf',
  output: 'rr.ebnf',
  command: [
    'sh', '-c', '$0 < $1 > $2',
    files('./to-hash-x.sh'), original_ebnf, '@OUTPUT@'
  ],
  install: true,
  install_dir: get_option('datadir'),
  install_tag: 'grammar'
)

java = find_program('java')

rr_jar = find_program('rr.jar', required: false)
if not rr_jar.found()
  rr_jar = subproject('rr').get_variable('rr_jar')
endif

rr_zip = custom_target(
  'rr.zip',
  output: 'rr.zip',
  command: [
    java,
    '-jar',
    rr_jar,
    '-html',
    '-noembedded',
    '-out:rr.zip',
    rr_ebnf
  ]
)
