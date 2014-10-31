levenshtein_dist <- function(s, t)
{
  .Call(R_levenshtein_dist, s, t)
}



find_closest_word <- function(input, words)
{
  .Call(R_find_closest_word, input, words)
}

