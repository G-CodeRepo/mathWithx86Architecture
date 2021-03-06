#ifndef CDECL_HEADER_FILE
#define CDECL_HEADER_FILE

/*
 * Define macros to specify the standard C calling convention
 * The macros are designed so that they will work with all
 * supported C/C++ compilers.
 *
 * To use define your function prototype like this:
 *
 * return_type PRE_CDECL func_name( args ) POST_CDECL;
 *
 * For example:
 *
 * int PRE_CDECL f( int x, int y) POST_CDECL;
 */


#if defined(__GNUC__)
#  define PRE_CDECL
#  define POST_CDECL __attribute__((cdecl))
#else
#  define PRE_CDECL __cdecl
#  define POST_CDECL
#endif

#endif

#include <stdio.h>
#include <stdlib.h>

int PRE_CDECL asm_main( void ) POST_CDECL;

float compute_f(float x, float y);

int main(int argc, char **argv)
{
  float derivative;
  float x,y;

  if (argc != 3) { 
    fprintf(stderr,"Usage: %s <float value> <float value>\n",argv[0]);
    exit(1);
  }

  if (sscanf(argv[1],"%f",&x) != 1) {
    fprintf(stderr,"Invalid command-line argument '%s'\n",argv[1]);
    exit(1);
  }

  if (sscanf(argv[2],"%f",&y) != 1) {
    fprintf(stderr,"Invalid command-line argument '%s'\n",argv[2]);
    exit(1);
  }

  printf("f(%.5f,%.5f) = %.9f\n",x,y,compute_f(x,y));  

  exit(0);
}
