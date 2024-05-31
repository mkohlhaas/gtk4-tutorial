Up: [README.md](../README.md),  Prev: [Section 7](sec7.md), Next: [Section 9](sec9.md)

# Defining a final class

## A very simple editor

We made a very simple file viewer in the previous section.
Now we go on to rewrite it and turn it into very simple editor.
Its source file is `tfe1.c` (text file editor 1) under `tfe` directory.

GtkTextView is a multi-line editor.
So, we don't need to write the editor from scratch.
We just add two things to the file viewer:

- Pointers to GFile instances.
- A text-save function.

There are a couple of ways to store the pointers.

- Use global variables
- Make a child class of GtkTextView and its each instance holds a pointer to the GFile instance.

Using global variables is easy to implement.
Define a sufficient size pointer array to GFile.
For example,

~~~C
GFile *f[20];
~~~

The variable `f[i]` corresponds to the file associated with the i-th GtkNotebookPage.

However, There are two problems.
The first is the size of the array.
If a user gives too many arguments (more than 20 in the example above), it is impossible to store all the pointers to the GFile instances.
The second is difficulty to maintain the program.
We have a small program so far.
But, the more you develop the program, the bigger its size grows.
Generally speaking, it is very difficult to maintain global variables in a big program.
When you check the global variable, you need to check all the codes that use the variable.

Making a child class is a good idea in terms of maintenance.
And we prefer it rather than a global variable.

Be careful that we are thinking about "child class", not "child widget".
Child class and child widget are totally different.
Class is a term of GObject system.
If you are not familiar with GObject, see:

- [GObject API reference](https://docs.gtk.org/gobject/)
- [GObject tutorial for beginners](https://toshiocp.github.io/Gobject-tutorial/)

A child class inherits everything from the parent and, in addition, extends its performance.
We will define TfeTextView as a child class of GtkTextView.
It has everything that GtkTextView has and adds a pointer to a GFile.

![Child object of GtkTextView](../image/child.png)

## How to define a child class of GtkTextView

You need to know GObject system convention.
First, look at the program below.

~~~C
#define TFE_TYPE_TEXT_VIEW tfe_text_view_get_type ()
G_DECLARE_FINAL_TYPE (TfeTextView, tfe_text_view, TFE, TEXT_VIEW, GtkTextView)

struct _TfeTextView
{
  GtkTextView parent;
  GFile *file;
};

G_DEFINE_FINAL_TYPE (TfeTextView, tfe_text_view, GTK_TYPE_TEXT_VIEW);

static void
tfe_text_view_init (TfeTextView *tv) {
}

static void
tfe_text_view_class_init (TfeTextViewClass *class) {
}

void
tfe_text_view_set_file (TfeTextView *tv, GFile *f) {
  tv -> file = f;
}

GFile *
tfe_text_view_get_file (TfeTextView *tv) {
  return tv -> file;
}

GtkWidget *
tfe_text_view_new (void) {
  return GTK_WIDGET (g_object_new (TFE_TYPE_TEXT_VIEW, NULL));
}
~~~

- TfeTextView is divided into two parts.
Tfe and TextView.
Tfe is called prefix or namespace.
TextView is called object.
- There are three different identifier patterns.
TfeTextView (camel case), tfe\_text\_view (this is used for functions) and TFE\_TEXT\_VIEW (This is used to cast a object to TfeTextView).
- First, define `TFE_TYPE_TEXT_VIEW` macro as `tfe_text_view_get_type ()`.
The name is always (prefix)\_TYPE\_(object) and the letters are upper case.
And the replacement text is always (prefix)\_(object)\_get\_type () and the letters are lower case.
This definition is put before `G_DECLARE_FINAL_TYPE` macro.
- The arguments of `G_DECLARE_FINAL_TYPE` macro are the child class name in camel case, lower case with underscore, prefix (upper case),
object (upper case with underscore) and parent class name (camel case).
The following two C structures are declared in the expansion of the macro.
  - `typedef struct _TfeTextView TfeTextView`
  - `typedef struct {GtkTextViewClass parent_class; } TfeTextViewClass;`
- These declaration tells us that TfeTextView and TfeTextViewClass are C structures.
"TfeTextView" has two meanings, class name and C structure name.
The C structure TfeTextView is called object.
Similarly, TfeTextViewClass is called class.
- Declare the structure `_TfeTextView`.
The underscore is necessary.
The first member is the parent object (C structure).
Notice this is not a pointer but the object itself.
The second member and after are members of the child object.
TfeTextView structure has a pointer to a GFile instance as a member.
- `G_DEFINE_FINEL_TYPE` macro.
The arguments are the child object name in camel case, lower case with underscore and parent object type (prefix)\_TYPE\_(module).
This macro is mainly used to register the new class to the type system.
Type system is a base system of GObject.
Every class has its own type.
The types of GObject, GtkWidget and TfeTextView are `G_TYPE_OBJECT`, `GTK_TYPE_WIDGET` and `TFE_TYPE_TEXT_VIEW` respectively.
For example, `TFE_TYPE_TEXT_VIEW` is a macro and it is expanded to a function `tfe_text_view_get_type()`.
It returns a integer which is unique among all GObject system classes.
- The instance init function `tfe_text_view_init` is called when the instance is created.
It is the same as a constructor in other object oriented languages.
- The class init function `tfe_text_view_class_init` is called when the class is created.
- Two functions `tfe_text_view_set_file` and `tfe_text_view_get_file` are public functions.
Public functions are open and you can call them anywhere.
They are the same as public method in other object oriented languages.
`tv` is a pointer to the TfeTextView object (C structure).
It has a member `file` and it is pointed by `tv->file`.
- TfeTextView instance creation function is `tfe_text_view_new`.
Its name is (prefix)\_(object)\_new.
It uses `g_object_new` function to create the instance.
The arguments are (prefix)\_TYPE\_(object), a list to initialize properties and NULL.
NULL is the end mark of the property list.
No property is initialized here.
And the return value is casted to GtkWidget.

This program shows the outline how to define a child class.

## Close-request signal

Imagine that you are using this editor.
First, you run the editor with arguments.
The arguments are filenames.
The editor reads the files and shows the window with the text of files in it.
Then you edit the text.
After you finish editing, you click on the close button of the window and quit the editor.
The editor updates files just before the window closes.

GtkWindow emits the "close-request" signal when the close button is clicked.
We will connect the signal and the handler `before_close`.
(A handler is a C function which is connected to a signal.)
The function `before_close` is called when the signal "close-request" is emitted.

~~~C
g_signal_connect (win, "close-request", G_CALLBACK (before_close), NULL);
~~~

The argument `win` is a GtkApplicationWindow, in which the signal "close-request" is defined, and `before_close` is the handler.
The `G_CALLBACK` cast is necessary for the handler.
The program of `before_close` is as follows.

~~~C
 1 static gboolean
 2 before_close (GtkWindow *win, GtkWidget *nb) {
 3   GtkWidget *scr;
 4   GtkWidget *tv;
 5   GFile *file;
 6   char *pathname;
 7   GtkTextBuffer *tb;
 8   GtkTextIter start_iter;
 9   GtkTextIter end_iter;
10   char *contents;
11   unsigned int n;
12   unsigned int i;
13   GError *err = NULL;
14 
15   n = gtk_notebook_get_n_pages (GTK_NOTEBOOK (nb));
16   for (i = 0; i < n; ++i) {
17     scr = gtk_notebook_get_nth_page (GTK_NOTEBOOK (nb), i);
18     tv = gtk_scrolled_window_get_child (GTK_SCROLLED_WINDOW (scr));
19     file = tfe_text_view_get_file (TFE_TEXT_VIEW (tv));
20     tb = gtk_text_view_get_buffer (GTK_TEXT_VIEW (tv));
21     gtk_text_buffer_get_bounds (tb, &start_iter, &end_iter);
22     contents = gtk_text_buffer_get_text (tb, &start_iter, &end_iter, FALSE);
23     if (! g_file_replace_contents (file, contents, strlen (contents), NULL, TRUE, G_FILE_CREATE_NONE, NULL, NULL, &err)) {
24       g_printerr ("%s.\n", err->message);
25       g_clear_error (&err);
26     }
27     g_free (contents);
28     g_object_unref (file);
29   }
30   return FALSE;
31 }
~~~

The numbers on the left are line numbers.

- 15: The number of note book pages is assigned to `n`.
- 16-29: For loop with regard to the index to each page.
- 17-19: `scr`, `tv` and `file` is assigned pointers to the GtkScrolledWindow, TfeTextView and GFile.
The GFile of TfeTextView was stored when `app_open` handler was called. It will be shown later.
- 20-22: `tb` is assigned the GtkTextBuffer of the TfeTextView.
The contents of the buffer are accessed with iterators.
Iterators points somewhere in the buffer.
The function `gtk_text_buffer_get_bounds` assigns the start and end of the buffer to `start_iter` and `end_iter` respectively.
Then the function `gtk_text_buffer_get_text` returns the text between `start_iter` and `end_iter`, which is the whole text in the buffer.
- 23-26: The text is saved to the file.
If it fails, error messages are displayed.
The GError instance must be freed and the pointer `err` needs to be NULL for the next run in the loop.
- 27: `contents` are freed.
- 28: GFile is useless. `g_object_unref` decreases the reference count of the GFile.
Reference count will be explained in the later section.
The reference count will be zero and the GFile instance will destroy itself.

## Source code of tfe1.c

The following is the whole source code of `tfe1.c`.

~~~C
  1 #include <gtk/gtk.h>
  2 
  3 /* Define TfeTextView Widget which is the child class of GtkTextView */
  4 
  5 #define TFE_TYPE_TEXT_VIEW tfe_text_view_get_type ()
  6 G_DECLARE_FINAL_TYPE (TfeTextView, tfe_text_view, TFE, TEXT_VIEW, GtkTextView)
  7 
  8 struct _TfeTextView
  9 {
 10   GtkTextView parent;
 11   GFile *file;
 12 };
 13 
 14 G_DEFINE_FINAL_TYPE (TfeTextView, tfe_text_view, GTK_TYPE_TEXT_VIEW);
 15 
 16 static void
 17 tfe_text_view_init (TfeTextView *tv) {
 18   tv->file = NULL;
 19 }
 20 
 21 static void
 22 tfe_text_view_class_init (TfeTextViewClass *class) {
 23 }
 24 
 25 void
 26 tfe_text_view_set_file (TfeTextView *tv, GFile *f) {
 27   tv->file = f;
 28 }
 29 
 30 GFile *
 31 tfe_text_view_get_file (TfeTextView *tv) {
 32   return tv -> file;
 33 }
 34 
 35 GtkWidget *
 36 tfe_text_view_new (void) {
 37   return GTK_WIDGET (g_object_new (TFE_TYPE_TEXT_VIEW, NULL));
 38 }
 39 
 40 /* ---------- end of the definition of TfeTextView ---------- */
 41 
 42 static gboolean
 43 before_close (GtkWindow *win, GtkWidget *nb) {
 44   GtkWidget *scr;
 45   GtkWidget *tv;
 46   GFile *file;
 47   char *pathname;
 48   GtkTextBuffer *tb;
 49   GtkTextIter start_iter;
 50   GtkTextIter end_iter;
 51   char *contents;
 52   unsigned int n;
 53   unsigned int i;
 54   GError *err = NULL;
 55 
 56   n = gtk_notebook_get_n_pages (GTK_NOTEBOOK (nb));
 57   for (i = 0; i < n; ++i) {
 58     scr = gtk_notebook_get_nth_page (GTK_NOTEBOOK (nb), i);
 59     tv = gtk_scrolled_window_get_child (GTK_SCROLLED_WINDOW (scr));
 60     file = tfe_text_view_get_file (TFE_TEXT_VIEW (tv));
 61     tb = gtk_text_view_get_buffer (GTK_TEXT_VIEW (tv));
 62     gtk_text_buffer_get_bounds (tb, &start_iter, &end_iter);
 63     contents = gtk_text_buffer_get_text (tb, &start_iter, &end_iter, FALSE);
 64     if (! g_file_replace_contents (file, contents, strlen (contents), NULL, TRUE, G_FILE_CREATE_NONE, NULL, NULL, &err)) {
 65       g_printerr ("%s.\n", err->message);
 66       g_clear_error (&err);
 67     }
 68     g_free (contents);
 69     g_object_unref (file);
 70   }
 71   return FALSE;
 72 }
 73 
 74 static void
 75 app_activate (GApplication *app) {
 76   g_print ("You need to give filenames as arguments.\n");
 77 }
 78 
 79 static void
 80 app_open (GApplication *app, GFile ** files, gint n_files, gchar *hint) {
 81   GtkWidget *win;
 82   GtkWidget *nb;
 83   GtkWidget *lab;
 84   GtkNotebookPage *nbp;
 85   GtkWidget *scr;
 86   GtkWidget *tv;
 87   GtkTextBuffer *tb;
 88   char *contents;
 89   gsize length;
 90   char *filename;
 91   int i;
 92   GError *err = NULL;
 93 
 94   win = gtk_application_window_new (GTK_APPLICATION (app));
 95   gtk_window_set_title (GTK_WINDOW (win), "file editor");
 96   gtk_window_set_default_size (GTK_WINDOW (win), 600, 400);
 97 
 98   nb = gtk_notebook_new ();
 99   gtk_window_set_child (GTK_WINDOW (win), nb);
100 
101   for (i = 0; i < n_files; i++) {
102     if (g_file_load_contents (files[i], NULL, &contents, &length, NULL, &err)) {
103       scr = gtk_scrolled_window_new ();
104       tv = tfe_text_view_new ();
105       tb = gtk_text_view_get_buffer (GTK_TEXT_VIEW (tv));
106       gtk_text_view_set_wrap_mode (GTK_TEXT_VIEW (tv), GTK_WRAP_WORD_CHAR);
107       gtk_scrolled_window_set_child (GTK_SCROLLED_WINDOW (scr), tv);
108 
109       tfe_text_view_set_file (TFE_TEXT_VIEW (tv),  g_file_dup (files[i]));
110       gtk_text_buffer_set_text (tb, contents, length);
111       g_free (contents);
112       filename = g_file_get_basename (files[i]);
113       lab = gtk_label_new (filename);
114       gtk_notebook_append_page (GTK_NOTEBOOK (nb), scr, lab);
115       nbp = gtk_notebook_get_page (GTK_NOTEBOOK (nb), scr);
116       g_object_set (nbp, "tab-expand", TRUE, NULL);
117       g_free (filename);
118     } else {
119       g_printerr ("%s.\n", err->message);
120       g_clear_error (&err);
121     }
122   }
123   if (gtk_notebook_get_n_pages (GTK_NOTEBOOK (nb)) > 0) {
124     g_signal_connect (win, "close-request", G_CALLBACK (before_close), nb);
125     gtk_window_present (GTK_WINDOW (win));
126   } else
127     gtk_window_destroy (GTK_WINDOW (win));
128 }
129 
130 int
131 main (int argc, char **argv) {
132   GtkApplication *app;
133   int stat;
134 
135   app = gtk_application_new ("com.github.ToshioCP.tfe1", G_APPLICATION_HANDLES_OPEN);
136   g_signal_connect (app, "activate", G_CALLBACK (app_activate), NULL);
137   g_signal_connect (app, "open", G_CALLBACK (app_open), NULL);
138   stat =g_application_run (G_APPLICATION (app), argc, argv);
139   g_object_unref (app);
140   return stat;
141 }
~~~

- 109: The GFile pointer of the TfeTextView is set to the copy of `files[i]`, which is a GFile created with the command line argument.
The GFile will be destroyed by the system later.
So it needs to be copied before the assignment.
`g_file_dup` duplicates the GFile.
Note: GFile is *not* thread safe. Duplicating GFile avoids a trouble comes from the different thread.
- 124: The "close-request" signal is connected to `before_close` handler.
The fourth argument is called "user data" and it will be the second argument of the signal handler.
So, `nb` is given to `before_close` as the second argument.

Now it's time to compile and run.

~~~
$ cd src/tfe
$ comp tfe1
$ ./a.out taketori.txt`.
~~~

Modify the contents and close the window.
Make sure that the file is modified.

Now we got a very simple editor.
It's not smart.
We need more features like open, save, saveas, change font and so on.
We will add them in the next section and after.

Up: [README.md](../README.md),  Prev: [Section 7](sec7.md), Next: [Section 9](sec9.md)
