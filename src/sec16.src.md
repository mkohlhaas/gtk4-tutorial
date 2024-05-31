# How to build tfe (text file editor)

## How to compile and execute the text editor 'tfe'.

First, source files are in the [Gtk4-tutorila repository](https://github.com/ToshioCP/Gtk4-tutorial).
How to download them is written at the end of the [previous section](sec15.src.md).

The following is the instruction of compilation and execution.

- You need meson and ninja.
- If you have installed gtk4 from the source, you need to set environment variables to suit your installation.
- Change your current directory to `src/tfe5` directory.
- Type `meson setup _build` for configuration.
- Type `ninja -C _build` for compilation.
Then the application `tfe` is built under the `_build` directory.
- Type `_build/tfe` to execute it.

Then the window appears.
There are four buttons, `New`, `Open`, `Save` and `Close`.

- Click on `Open` button, then a file chooser dialog appears.
Choose a file in the list and click on `Open` button.
Then the file is read and a new Notebook Page appears.
- Edit the file and click on `Save` button, then the text is saved to the original file.
- Click `Close`, then the Notebook Page disappears.
- Click `Close` again, then the `Untitled` Notebook Page disappears and at the same time the application quits.

This is a very simple editor.
It is a good practice for you to add more features.

## Total number of lines, words and characters

@@@shell
LANG=C wc tfe5/meson.build tfe5/tfeapplication.c tfe5/tfe.gresource.xml tfe5/tfenotebook.c tfe5/tfenotebook.h tfetextview/tfetextview.c tfetextview/tfetextview.h tfe5/tfe.ui
@@@
