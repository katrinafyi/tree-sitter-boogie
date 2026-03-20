project(
  'rr',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
  },
)

rr_jar = custom_target(
  'rr.jar',
  output: 'rr.jar',
  command: [
    'wget',
    '-nv',
    'https://repo1.maven.org/maven2/de/bottlecaps/rr/rr-webapp/2.6/rr-webapp-2.6.war',
    '-O', '@OUTPUT@'
  ],
  install: true,
  install_dir: get_option('datadir'),
)
