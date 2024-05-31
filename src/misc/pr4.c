#include <gtk/gtk.h>

#define UNUSED(x) (void)(x)

static void
app_activate (GApplication *app, gpointer user_data)
{
  UNUSED (user_data);

  GtkWidget *win = gtk_application_window_new (GTK_APPLICATION (app));
  gtk_window_set_title (GTK_WINDOW (win), "pr4");
  gtk_window_set_default_size (GTK_WINDOW (win), 400, 300);
  gtk_window_present (GTK_WINDOW (win));
}

int
main (int argc, char **argv)
{
  GtkApplication *app = gtk_application_new ("com.github.ToshioCP.pr4", G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect (app, "activate", G_CALLBACK (app_activate), NULL);
  int stat = g_application_run (G_APPLICATION (app), argc, argv);

  g_object_unref (app);
  return stat;
}
