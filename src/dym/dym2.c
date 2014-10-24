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

#define STRINITSIZE 10


int levenshtein_dist_partial(const int k, const char *s, const char *t, ldint_t *v0, ldint_t *v1)
{
  int i, j;
  int ret;
  ldint_t cost;
  
  const size_t slen = strlen(s);
  const size_t tlen = strlen(t);
  const size_t vlen = tlen + 1;
  
  if (strcmp(s, t) == 0) return 0;
  if (strlen(s) == 0) return strlen(t);
  if (strlen(t) == 0) return strlen(s);
  
  
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
    
    if (v0[tlen] > k)
      return BADMATCH;
  }
  
  ret = (int) v1[tlen];
  
  return ret;
}




// On exit, function value is the Levenshtein distance, and word is
// the closest word for the input vocabulary
int did_you_mean2(const char *input, const char **words, const int nwords, char **word)
{
  int i;
  int least_dist = -1;
  int closest_word;
  int dist;
  int k = BIGLDINT;
  const int vlen = strlen(input);
  ldint_t *v0, *v1;
  
  v0 = malloc(vlen * sizeof(ldint_t));
  v1 = malloc(vlen * sizeof(ldint_t));
  
  for (i=0; i<nwords; i++)
  {
    dist = levenshtein_dist_partial(k, words[i], input, v0, v1); // note, input/word[i] order here matters
    
    if (dist == BADMATCH) continue;
    
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
  
  free(v0);
  free(v1);
  
  word = malloc(strlen(words[least_dist]) * sizeof(*word));
  
  for (i=0; i<strlen(words[i]); i++)
    (*word)[i] = (words[least_dist])[i];
  
  return least_dist;
}

