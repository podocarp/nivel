#include <sys/ioctl.h>
#include <stdio.h>
#include <math.h>

int main(int argc, char **argv)
{
  struct winsize sz;

  ioctl(0, TIOCGWINSZ, &sz);
  int x = ceil((float)sz.ws_xpixel / (float)sz.ws_col);
  int y = ceil((float)sz.ws_ypixel / (float)sz.ws_row);
  printf("%d %d", x, y);
  return 0;
}

