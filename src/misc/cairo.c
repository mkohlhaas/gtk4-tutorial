#include <cairo.h>

int
main (void)
{
  int width       = 100;
  int height      = 100;
  int square_size = 40.0;

  /* Create surface and cairo */
  cairo_surface_t *surface = cairo_image_surface_create (CAIRO_FORMAT_RGB24, width, height);
  cairo_t         *cr      = cairo_create (surface);

  /* Paint the background white */
  cairo_set_source_rgb (cr, 1.0, 1.0, 1.0);
  cairo_paint (cr);

  /* Draw a black rectangle */
  cairo_set_source_rgb (cr, 0.0, 0.0, 0.0);
  cairo_set_line_width (cr, 2.0);
  cairo_rectangle (cr, width / 2.0 - (double)square_size / 2, height / 2.0 - (double)square_size / 2, square_size,
                   square_size);
  cairo_stroke (cr);

  /* Write the surface to a png file and clean up cairo and surface. */
  cairo_surface_write_to_png (surface, "rectangle.png");
  cairo_destroy (cr);
  cairo_surface_destroy (surface);
}
