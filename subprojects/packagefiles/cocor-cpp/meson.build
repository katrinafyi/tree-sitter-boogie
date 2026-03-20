project(
  'cocor-cpp',
  'cpp',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : {
    'warning_level': '3',
    'datadir': meson.project_source_root(),
  },
)

inc = include_directories('src')

scanner_frame = configure_file(
  output: 'Scanner.frame',
  input: 'src/Scanner.frame',
  copy: true,
  install_dir : get_option('datadir') / 'cocor-cpp',
)

frame = configure_file(
  output: 'Parser.frame',
  input: 'src/Parser.frame',
  copy: true,
  install_dir : get_option('datadir') / 'cocor-cpp',
)

sources = files(
  'src/Action.cpp',
  'src/BitArray.cpp',
  'src/CharClass.cpp',
  'src/CharSet.cpp',
  'src/Coco.cpp',
  'src/Comment.cpp',
  'src/DFA.cpp',
  'src/Generator.cpp',
  'src/HashTable.cpp',
  'src/Melted.cpp',
  'src/Node.cpp',
  'src/Parser.cpp',
  'src/ParserGen.cpp',
  'src/Position.cpp',
  'src/Scanner.cpp',
  'src/SortedList.cpp',
  'src/State.cpp',
  'src/StringBuilder.cpp',
  'src/Symbol.cpp',
  'src/Tab.cpp',
  'src/Target.cpp',
)

cocor_cpp = executable(
  'CocoR-CPP',
  sources,
  include_directories: inc,
  install: true,
)

meson.override_find_program('CocoR-CPP', cocor_cpp)
