project('tfc', 'c',
  version : '0.1',
  default_options : ['warning_level=3'])

gtk_dep = dependency('gtk4')

executable('tfc',
           'tfc.c',
           'tfc.gresource.c',
           dependencies: gtk_dep,
           install : true)
