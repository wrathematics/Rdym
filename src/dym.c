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


#include "dym.h"


// Based on the explanation here: https://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
int levenshtein_dist_noalloc(const char *s, const char *t, ldint_t *v0, ldint_t *v1)
{
  int i, j;
  int ret;
  ldint_t cost;
  
  const size_t slen = strlen(s);
  const size_t tlen = strlen(t);
  const size_t vlen = tlen + 1;
  
  if (strncmp(s, t, slen) == 0) return 0;
  if (slen == 0) return tlen;
  if (tlen == 0) return slen;
  
  
  for (i=0; i<vlen; i++)
    v0[i] = i;
  
  for (i=0; i<slen; i++)
  {
    v1[0] = i+1;
    
    for (j=0; j<tlen; j++)
    {
      cost = (s[i] == t[j]) ? 0 : 1;
      v1[j+1] = MIN3(v1[j] + 1, v0[j+1] + 1, v0[j] + cost);
    }
    
    for (j=0; j<vlen; j++)
      v0[j] = v1[j];
  }
  
  ret = (int) v1[tlen];
  
  return ret;
}



int levenshtein_dist(const char *s, const char *t)
{
  int ret;
  ldint_t *v0, *v1;
  
  const size_t vlen = strlen(t) + 1;
  
  v0 = malloc(vlen * sizeof(*v0));
  v1 = malloc(vlen * sizeof(*v1));
  
  ret = levenshtein_dist_noalloc(s, t, v0, v1);
  
  free(v0);
  free(v1);
  
  return ret;
}



// On exit, function value is the Levenshtein distance, and word is
// the closest word for the input vocabulary
int did_you_mean(const char *input, const char **words, const int nwords, char **word)
{
  int i;
  int least_dist = -1;
  int closest_word;
  int dist;
  int wordlen;
  
  for (i=0; i<nwords; i++)
  {
    dist = levenshtein_dist(input, words[i]);
    
    if (dist == 0)
    {
      closest_word = i;
      least_dist = 0;
      break;
    }
    
    if (dist <= least_dist || least_dist < 0)
    {
      closest_word = i;
      least_dist = dist;
    }
  }
  
  
  wordlen = strlen(words[closest_word]);
  word = malloc(wordlen * sizeof(*word));
  
  for (i=0; i<wordlen; i++)
    (*word)[i] = (words[closest_word])[i];
  
  return least_dist;
}

