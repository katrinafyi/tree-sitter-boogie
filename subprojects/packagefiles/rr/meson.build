project(
  'rr',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
  },
)

rr = configure_file(
  output : 'rr.war',
  input : files('rr.war'),
  copy : true,
  install_dir : get_option('datadir'),
)

meson.override_find_program('rr.jar', rr)
