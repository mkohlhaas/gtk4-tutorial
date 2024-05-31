project('menu', 'c', version: '0.1', default_options: ['warning_level=3'])

dep_glib = dependency('glib-2.0')
dep_gtk = dependency('gtk4')

executable('menu2_ui', 'menu2_ui.c', install: false, dependencies: [dep_glib, dep_gtk])

executable(
  'menu2_int16',
  'menu2_int16.c',
  install: false,
  dependencies: [dep_glib, dep_gtk],
)

executable(
  'menu2_change_state',
  'menu2_change_state.c',
  install: false,
  dependencies: [dep_glib, dep_gtk],
)

executable(
  'gvarianttype_test',
  'gvarianttype_test.c',
  install: false,
  dependencies: [dep_glib, dep_gtk],
)

executable('menu2', 'menu2.c', install: false, dependencies: [dep_glib, dep_gtk])

executable('menu1', 'menu1.c', install: false, dependencies: [dep_glib, dep_gtk])
