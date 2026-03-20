project(
  'boogie-atg',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
  },
)

grammar = configure_file(
  output : 'BoogiePL.atg',
  input : files('Source/Core/BoogiePL.atg'),
  copy : true,
  install_dir : get_option('datadir') / 'boogie-atg',
  install_mode: 'rw-r--r--'
)
