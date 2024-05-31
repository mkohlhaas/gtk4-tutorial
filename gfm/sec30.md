Up: [README.md](../README.md),  Prev: [Section 29](sec29.md), Next: [Section 31](sec31.md)

# GtkGridView and activate signal

GtkGridView is similar to GtkListView.
It displays a GListModel as a grid, which is like a square tessellation.

![Grid](../image/list4.png)

This is often seen when you use a file browser like GNOME Files (Nautilus).

In this section, let's make a very simple file browser `list4`.
It just shows the files in the current directory.
And a user can choose list or grid by clicking on buttons in the tool bar.
Each item in the list or grid has an icon and a filename.
In addition, `list4` provides the way to open the `tfe` text editor to show a text file.
A user can do that by double clicking on an item or pressing enter key when an item is selected.

## GtkDirectoryList

GtkDirectoryList implements GListModel and it contains information of files in a certain directory.
The items of the list are GFileInfo objects.

In the `list4` source files, GtkDirectoryList is described in a ui file and built by GtkBuilder.
The GtkDirectoryList instance is assigned to the "model" property of a GtkSingleSelection instance.
And the GtkSingleSelection instance is assigned to the "model" property of a GListView or GGridView instance.

~~~
GtkListView (model property) => GtkSingleSelection (model property) => GtkDirectoryList
GtkGridView (model property) => GtkSingleSelection (model property) => GtkDirectoryList
~~~

![DirectoryList](../image/directorylist.png)

The following is a part of the ui file `list4.ui`.

~~~xml
<object class="GtkListView" id="list">
  <property name="model">
    <object class="GtkSingleSelection" id="singleselection">
      <property name="model">
        <object class="GtkDirectoryList" id="directorylist">
          <property name="attributes">standard::name,standard::icon,standard::content-type</property>
        </object>
      </property>
    </object>
  </property>
</object>
<object class="GtkGridView" id="grid">
  <property name="model">singleselection</property>
</object>
~~~

GtkDirectoryList has an "attributes" property.
It is attributes of GFileInfo such as "standard::name", "standard::icon" and "standard::content-type".

- standard::name is a filename.
- standard::icon is an icon of the file. It is a GIcon object.
- standard::content-type is a content-type.
Content-type is the same as mime type for the internet.
For example, "text/plain" is a text file, "text/x-csrc" is a C source code and so on.
("text/x-csrc"is not registered to IANA media types.
Such "x-" subtype is not a standard mime type.)
Content type is also used by desktop systems.

GtkGridView uses the same GtkSingleSelection instance (`singleselection`).
So, its model property is set to it.

## Ui file of the window

The window is built with the following ui file.
(See the screenshot at the beginning of this section).

~~~xml
 1 <?xml version="1.0" encoding="UTF-8"?>
 2 <interface>
 3   <object class="GtkApplicationWindow" id="win">
 4     <property name="title">file list</property>
 5     <property name="default-width">600</property>
 6     <property name="default-height">400</property>
 7     <child>
 8       <object class="GtkBox" id="boxv">
 9         <property name="orientation">GTK_ORIENTATION_VERTICAL</property>
10         <child>
11           <object class="GtkBox" id="boxh">
12             <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
13             <child>
14               <object class="GtkLabel" id="dmy1">
15                 <property name="hexpand">TRUE</property>
16               </object>
17             </child>
18             <child>
19               <object class="GtkButton" id="btnlist">
20                 <property name="name">btnlist</property>
21                 <property name="action-name">win.view</property>
22                 <property name="action-target">&apos;list&apos;</property>
23                 <child>
24                   <object class="GtkImage">
25                     <property name="resource">/com/github/ToshioCP/list4/list.png</property>
26                   </object>
27                 </child>
28               </object>
29             </child>
30             <child>
31               <object class="GtkButton" id="btngrid">
32                 <property name="name">btngrid</property>
33                 <property name="action-name">win.view</property>
34                 <property name="action-target">&apos;grid&apos;</property>
35                 <child>
36                   <object class="GtkImage">
37                     <property name="resource">/com/github/ToshioCP/list4/grid.png</property>
38                   </object>
39                 </child>
40               </object>
41             </child>
42             <child>
43               <object class="GtkLabel" id="dmy2">
44                 <property name="width-chars">10</property>
45               </object>
46             </child>
47           </object>
48         </child>
49         <child>
50           <object class="GtkScrolledWindow" id="scr">
51             <property name="hexpand">TRUE</property>
52             <property name="vexpand">TRUE</property>
53           </object>
54         </child>
55       </object>
56     </child>
57   </object>
58   <object class="GtkListView" id="list">
59     <property name="model">
60       <object class="GtkSingleSelection" id="singleselection">
61         <property name="model">
62           <object class="GtkDirectoryList" id="directory_list">
63             <property name="attributes">standard::name,standard::icon,standard::content-type</property>
64           </object>
65         </property>
66       </object>
67     </property>
68   </object>
69   <object class="GtkGridView" id="grid">
70     <property name="model">singleselection</property>
71   </object>
72 </interface>
73 
~~~

The file consists of two parts.
The first part begins at the line 3 and ends at line 57.
This part is the widgets from the top level window to the scrolled window.
It also includes two buttons.
The second part begins at line 58 and ends at line 71.
This is the part of GtkListView and GtkGridView.

- 13-17, 42-46: Two labels are dummy labels.
They just work as a space to put the two buttons at the appropriate position.
- 18-41: GtkButton `btnlist` and `btngrid`.
These two buttons work as selection buttons to switch from list to grid and vice versa.
These two buttons are connected to a stateful action `win.view`.
This action has a parameter.
Such action consists of prefix, action name and parameter.
The prefix of the action is `win`, which means the action belongs to the top level window.
The prefix gives the scope of the action.
The action name is `view`.
The parameters are `list` or `grid`, which show the state of the action.
A parameter is also called a target, because it is a target to which the action changes its state.
We often write the detailed action like "win.view::list" or "win.view::grid".
- 21-22: The properties "action-name" and "action-target" belong to GtkActionable interface.
GtkButton implements GtkActionable.
The action name is "win.view" and the target is "list".
Generally, a target is GVariant, which can be string, integer, float and so on.
You need to use GVariant text format to write GVariant value in ui files.
If the type of the GVariant value is string, then the value with GVariant text format is bounded by single quotes or double quotes.
Because ui file is xml format text, single quote cannot be written without escape.
Its escape sequence is \&apos;.
Therefore, the target 'list' is written as \&apos;list\&apos;.
Because the button is connected to the action, "clicked" signal handler isn't needed.
- 23-27: The child widget of the button is GtkImage.
GtkImage has a "resource" property.
It is a GResource and GtkImage reads an image data from the resource and sets the image.
This resource is built from 24x24-sized png image data, which is an original icon.
- 50-53: GtkScrolledWindow.
Its child widget will be set with GtkListView or GtkGridView.

The action `view` is created, connected to the "activate" signal handler and inserted to the window (action map) as follows.

~~~C
act_view = g_simple_action_new_stateful ("view", g_variant_type_new("s"), g_variant_new_string ("list"));
g_signal_connect (act_view, "activate", G_CALLBACK (view_activated), NULL);
g_action_map_add_action (G_ACTION_MAP (win), G_ACTION (act_view));
~~~

The signal handler `view_activated` will be explained later.

## Factories

Each view (GtkListView and GtkGridView) has its own factory because its items have different structure of widgets.
The factories are GtkBuilderListItemFactory objects.
Their ui files are as follows.

factory_list.ui

~~~xml
 1 <?xml version="1.0" encoding="UTF-8"?>
 2 <interface>
 3   <template class="GtkListItem">
 4     <property name="child">
 5       <object class="GtkBox">
 6         <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
 7         <property name="spacing">20</property>
 8         <child>
 9           <object class="GtkImage">
10             <binding name="gicon">
11               <closure type="GIcon" function="get_icon">
12                 <lookup name="item">GtkListItem</lookup>
13               </closure>
14             </binding>
15           </object>
16         </child>
17         <child>
18           <object class="GtkLabel">
19             <property name="hexpand">TRUE</property>
20             <property name="xalign">0</property>
21             <binding name="label">
22               <closure type="gchararray" function="get_file_name">
23                 <lookup name="item">GtkListItem</lookup>
24               </closure>
25             </binding>
26           </object>
27         </child>
28       </object>
29     </property>
30   </template>
31 </interface>
32 
~~~

factory_grid.ui

~~~xml
 1 <?xml version="1.0" encoding="UTF-8"?>
 2 <interface>
 3   <template class="GtkListItem">
 4     <property name="child">
 5       <object class="GtkBox">
 6         <property name="orientation">GTK_ORIENTATION_VERTICAL</property>
 7         <property name="spacing">20</property>
 8         <child>
 9           <object class="GtkImage">
10             <property name="icon-size">GTK_ICON_SIZE_LARGE</property>
11             <binding name="gicon">
12               <closure type="GIcon" function="get_icon">
13                 <lookup name="item">GtkListItem</lookup>
14               </closure>
15             </binding>
16           </object>
17         </child>
18         <child>
19           <object class="GtkLabel">
20             <property name="hexpand">TRUE</property>
21             <property name="xalign">0.5</property>
22             <binding name="label">
23               <closure type="gchararray" function="get_file_name">
24                 <lookup name="item">GtkListItem</lookup>
25               </closure>
26             </binding>
27           </object>
28         </child>
29       </object>
30     </property>
31   </template>
32 </interface>
33 
~~~

The two files above are almost same.
The difference is:

- The orientation of the box
- The icon size
- The position of the text of the label

~~~
$ cd list4; diff factory_list.ui factory_grid.ui
6c6
<         <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
---
>         <property name="orientation">GTK_ORIENTATION_VERTICAL</property>
9a10
>             <property name="icon-size">GTK_ICON_SIZE_LARGE</property>
20c21
<             <property name="xalign">0</property>
---
>             <property name="xalign">0.5</property>
~~~

Two properties "gicon" (property of GtkImage) and "label" (property of GtkLabel) are in the ui files above.
Because GFileInfo doesn't have properties correspond to icon or filename, the factory uses closure tag to bind "gicon" and "label" properties to GFileInfo information.
A function `get_icon` gets GIcon from the GFileInfo object.
And a function `get_file_name` gets a filename from the GFileInfo object.

~~~C
 1 GIcon *
 2 get_icon (GtkListItem *item, GFileInfo *info) {
 3   GIcon *icon;
 4 
 5    /* g_file_info_get_icon can return NULL */
 6   icon = G_IS_FILE_INFO (info) ? g_file_info_get_icon (info) : NULL;
 7   return icon ? g_object_ref (icon) : NULL;
 8 }
 9 
10 char *
11 get_file_name (GtkListItem *item, GFileInfo *info) {
12   return G_IS_FILE_INFO (info) ? g_strdup (g_file_info_get_name (info)) : NULL;
13 }
~~~

One important thing is the ownership of the return values.
The return value is owned by the caller.
So, `g_obect_ref` or `g_strdup` is necessary.

## An activate signal handler of the button action

An activate signal handler `view_activate` switches the view.
It does two things.

- Changes the child widget of GtkScrolledWindow.
- Changes the CSS of buttons to show the current state.

~~~C
 1 static void
 2 view_activated(GSimpleAction *action, GVariant *parameter) {
 3   const char *view = g_variant_get_string (parameter, NULL);
 4   const char *other;
 5   char *css;
 6 
 7   if (strcmp (view, "list") == 0) {
 8     other = "grid";
 9     gtk_scrolled_window_set_child (scr, GTK_WIDGET (list));
10   }else {
11     other = "list";
12     gtk_scrolled_window_set_child (scr, GTK_WIDGET (grid));
13   }
14   css = g_strdup_printf ("button#btn%s {background: silver;} button#btn%s {background: white;}", view, other);
15   gtk_css_provider_load_from_data (provider, css, -1);
16   g_free (css);
17   g_action_change_state (G_ACTION (action), parameter);
18 }
~~~

The second parameter of this handler is the target of the clicked button.
Its type is GVariant.

- If `btnlist` has been clicked, then `parameter` is a GVariant of the string "list".
- If `btngrid` has been clicked, then `parameter` is a GVariant of the string "grid".

The third parameter `user_data` points NULL and it is ignored here.

- 3: `g_variant_get_string` gets the string from the GVariant variable.
- 7-13: Sets the child of `scr`.
The function `gtk_scrolled_window_set_child` decreases the reference count of the old child by one.
And it increases the reference count of the new child by one.
- 14-16: Sets the CSS for the buttons.
The background of the clicked button will be silver color and the other button will be white.
- 17: Changes the state of the action.
 
## Activate signal on GtkListView and GtkGridView

Views (GtkListView and GtkGridView) have an "activate" signal.
It is emitted when an item in the view is double clicked or the enter key is pressed.
You can do anything you like by connecting the "activate" signal to the handler.

The example `list4` launches `tfe` text file editor if the item of the list is a text file.

~~~C
static void
list_activate (GtkListView *list, int position, gpointer user_data) {
  GFileInfo *info = G_FILE_INFO (g_list_model_get_item (G_LIST_MODEL (gtk_list_view_get_model (list)), position));
  launch_tfe_with_file (info);
}

static void
grid_activate (GtkGridView *grid, int position, gpointer user_data) {
  GFileInfo *info = G_FILE_INFO (g_list_model_get_item (G_LIST_MODEL (gtk_grid_view_get_model (grid)), position));
  launch_tfe_with_file (info);
}

... ...
... ...

  g_signal_connect (GTK_LIST_VIEW (list), "activate", G_CALLBACK (list_activate), NULL);
  g_signal_connect (GTK_GRID_VIEW (grid), "activate", G_CALLBACK (grid_activate), NULL);
~~~

The second parameter of each handler is the position of the item (GFileInfo) of the GListModel.
So you can get the item with `g_list_model_get_item` function.

### Content type and application launch

The function `launch_tfe_with_file` gets a file from the GFileInfo instance.
If the file is a text file, it launches `tfe` with the file.

GFileInfo has information about file type.
The file type is like "text/plain", "text/x-csrc" and so on.
It is called content type.
Content type can be got with `g_file_info_get_content_type` function.

~~~C
 1 static void
 2 launch_tfe_with_file (GFileInfo *info) {
 3   GError *err = NULL;
 4   GFile *file;
 5   GList *files = NULL;
 6   const char *content_type;
 7   const char *text_type = "text/";
 8   GAppInfo *appinfo;
 9   int i;
10 
11   if (! info)
12     return;
13   content_type = g_file_info_get_content_type (info);
14 #ifdef debug
15   g_print ("%s\n", content_type);
16 #endif
17   if (! content_type)
18     return;
19   for (i=0;i<5;++i) { /* compare the first 5 characters */
20     if (content_type[i] != text_type[i])
21       return;
22   }
23   appinfo = g_app_info_create_from_commandline ("tfe", "tfe", G_APP_INFO_CREATE_NONE, &err);
24   if (err) {
25     g_printerr ("%s\n", err->message);
26     g_error_free (err);
27     return;
28   }
29   err = NULL;
30   file = g_file_new_for_path (g_file_info_get_name (info));
31   files = g_list_append (files, file);
32   if (! (g_app_info_launch (appinfo, files, NULL, &err))) {
33     g_printerr ("%s\n", err->message);
34     g_error_free (err);
35   }
36   g_list_free_full (files, g_object_unref);
37   g_object_unref (appinfo);
38 }
~~~

- 13: Gets the content type of the file from GFileInfo.
- 14-16: Prints the content type if "debug" is defined.
This is only useful to know a content type of a file.
If you don't want this, delete or uncomment the definition `#define debug 1` iat line 6 in the source file.
- 17-22: If no content type or the content type doesn't begin with "text/",the function returns.
- 23: Creates GAppInfo object of `tfe` application.
GAppInfo is an interface and the variable `appinfo` points a GDesktopAppInfo instance.
GAppInfo is a collection of information of applications.
- 32: Launches the application (`tfe`) with an argument `file`.
`g_app_info_launch` has four parameters.
The first parameter is GAppInfo object.
The second parameter is a list of GFile objects.
In this function, only one GFile instance is given to `tfe`, but you can give more arguments.
The third parameter is GAppLaunchContext, but this program gives NULL instead.
The last parameter is the pointer to the pointer to a GError.
- 36: `g_list_free_full` frees the memories used by the list and items.

If your distribution supports GTK 4, using `g_app_info_launch_default_for_uri` is convenient.
The function automatically determines the default application from the file and launches it.
For example, if the file is text, then it launches GNOME text editor with the file.
Such feature comes from desktop.

## Compilation and execution

The source files are located in [src/list4](../src/list4) directory.
To compile and execute list4, type as follows.

~~~
$ cd list4 # or cd src/list4. It depends your current directory.
$ meson setup _build
$ ninja -C _build
$ _build/list4
~~~

Then a file list appears as a list style.
Click on a button on the tool bar so that you can change the style to grid or back to list.
Double click "list4.c" item, then `tfe` text editor runs with the argument "list4.c".
The following is the screenshot.

![Screenshot](../image/screenshot_list4.png)

## "gbytes" property of GtkBuilderListItemFactory

GtkBuilderListItemFactory has "gbytes" property.
The property contains a byte sequence of ui data.
If you use this property, you can put the contents of `factory_list.ui` and `factory_grid.ui`into `list4.ui`.
The following shows a part of the new ui file (`list5.ui`).

~~~xml
  <object class="GtkListView" id="list">
    <property name="model">
      <object class="GtkSingleSelection" id="singleselection">
        <property name="model">
          <object class="GtkDirectoryList" id="directory_list">
            <property name="attributes">standard::name,standard::icon,standard::content-type</property>
          </object>
        </property>
      </object>
    </property>
    <property name="factory">
      <object class="GtkBuilderListItemFactory">
        <property name="bytes"><![CDATA[
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <template class="GtkListItem">
    <property name="child">
      <object class="GtkBox">
        <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
        <property name="spacing">20</property>
        <child>
          <object class="GtkImage">
            <binding name="gicon">
              <closure type="GIcon" function="get_icon">
                <lookup name="item">GtkListItem</lookup>
              </closure>
            </binding>
          </object>
        </child>
        <child>
          <object class="GtkLabel">
            <property name="hexpand">TRUE</property>
            <property name="xalign">0</property>
            <binding name="label">
              <closure type="gchararray" function="get_file_name">
                <lookup name="item">GtkListItem</lookup>
              </closure>
            </binding>
          </object>
        </child>
      </object>
    </property>
  </template>
</interface>
        ]]></property>
      </object>
    </property>
  </object>
~~~

CDATA section begins with "<![CDATA[" and ends with "]]>".
The contents of CDATA section is recognized as a string.
Any character, even if it is a key syntax marker such as '<' or '>', is recognized literally.
Therefore, the text between "<![CDATA[" and "]]>" is inserted to "bytes" property as it is.

This method decreases the number of ui files.
But, the new ui file is a bit complicated especially for the beginners.
If you feel some difficulty, it is better for you to separate the ui file.

A directory [src/list5](../src/list5) includes the ui file above.


Up: [README.md](../README.md),  Prev: [Section 29](sec29.md), Next: [Section 31](sec31.md)
