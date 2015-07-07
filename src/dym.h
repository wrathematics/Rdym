#ifndef __DYM_H
#define __DYM_H


#include <stdlib.h>
#include <string.h>
#include <stdint.h>


#define MAX(a,b) (a<b?b:a)
#define MIN(a,b) (a<b?a:b)
#define MIN3(a,b,c) MIN(MIN(a,b),MIN(b,c))

typedef uint16_t ldint_t;

#define BIGLDINT 65535

#define BADMATCH -1


int levenshtein_dist_noalloc(const char *s, const char *t, ldint_t *v0, ldint_t *v1);
int levenshtein_dist(const char *s, const char *t);
int did_you_mean(const char *input, const char **words, const int nwords, char **word);


#endif

