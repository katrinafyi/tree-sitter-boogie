project(
  'ts-ebnf-gen',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
  },
)

parse_grammar = configure_file(
  output : 'parse_grammar.lua',
  input : files('src/lua/parse_grammar.lua'),
  copy : true,
  install_dir : get_option('bindir'),
  install_mode: 'rwxr-xr-x'
)

meson.override_find_program('parse_grammar.lua', parse_grammar)
