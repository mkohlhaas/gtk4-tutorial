#include <gtk/gtk.h>

#define UNUSED(x) (void)(x)

static void
app_activate (GApplication *app, gpointer *user_data)
{
  UNUSED (app);
  UNUSED (user_data);

  g_print ("GtkApplication is activated.\n");
}

int
main (int argc, char **argv)
{
  GtkApplication *app = gtk_application_new ("com.github.ToshioCP.pr2", G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect (app, "activate", G_CALLBACK (app_activate), NULL);
  int stat = g_application_run (G_APPLICATION (app), argc, argv);

  g_object_unref (app);
  return stat;
}
