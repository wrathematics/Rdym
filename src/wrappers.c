/* 
  Copyright (C) 2014 Drew Schmidt. All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
    * Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#include <R.h>
#include <Rinternals.h>
#include <stdlib.h>
#include <string.h>
#include "dym.h"

#define CHARPT(x,i) ((char*)CHAR(STRING_ELT(x,i)))
#define CHARARR(x) ((const char **)STRING_PTR(x))
#define INT(x) INTEGER(x)[0]


SEXP R_levenshtein_dist(SEXP s, SEXP t)
{
  SEXP ret;
  PROTECT(ret = allocVector(INTSXP, 1));
  
  INTEGER(ret)[0] = levenshtein_dist(CHARPT(s, 0), CHARPT(t, 0));
  
  UNPROTECT(1);
  return ret;
}



SEXP R_find_closest_word(SEXP input, SEXP words)
{
  int i;
  int least_dist;
  int closest_word, current_dist;
  const int nwords = LENGTH(words);
  
  SEXP ret, ret_names, dist, word;
  PROTECT(dist = allocVector(INTSXP, 1));
  
  ldint_t *v0, *v1;
  
  const size_t vlen = strlen(CHARPT(input, 0)) + 1;
  
  v0 = malloc(vlen * sizeof(*v0));
  v1 = malloc(vlen * sizeof(*v1));
  
  
  for (i=0; i<nwords; i++)
  {
    current_dist = levenshtein_dist_noalloc(CHARPT(words, i), CHARPT(input, 0), v0, v1);
    
    if (current_dist == 0)
    {
      closest_word = i;
      least_dist = 0;
      break;
    }
    
    if (current_dist < least_dist || i == 0)
    {
      closest_word = i;
      least_dist = current_dist;
    }
  }
  
  free(v0);
  free(v1);
  
  INT(dist) = current_dist;
  
  PROTECT(word = allocVector(STRSXP, 1));
  SET_STRING_ELT(word, 0, mkChar(CHARPT(words, closest_word)));
  
  PROTECT(ret = allocVector(VECSXP, 2));
  SET_VECTOR_ELT(ret, 0, dist);
  SET_VECTOR_ELT(ret, 1, word);
  
  PROTECT(ret_names = allocVector(STRSXP, 2));
  SET_STRING_ELT(ret_names, 0, mkChar("dist"));
  SET_STRING_ELT(ret_names, 1, mkChar("word"));
  setAttrib(ret, R_NamesSymbol, ret_names);
  
  UNPROTECT(4);
  return ret;
}

