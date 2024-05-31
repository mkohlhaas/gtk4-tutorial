#include <gtk/gtk.h>

int
main (int argc, char **argv)
{
  GtkApplication *app  = gtk_application_new ("com.github.ToshioCP.pr1", G_APPLICATION_DEFAULT_FLAGS);
  int             stat = g_application_run (G_APPLICATION (app), argc, argv);

  g_object_unref (app);
  return stat;
}
