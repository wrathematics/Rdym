#ifndef __DYM_H
#define __DYM_H


#include <stdlib.h>
#include <string.h>
#include <stdint.h>


#define MIN(a,b) (a<b?a:b)
#define MIN3(a,b,c) MIN(MIN(a,b),MIN(b,c))

typedef uint16_t ldint_t;

#define BIGLDINT 65535

#define BADMATCH -1


#endif

