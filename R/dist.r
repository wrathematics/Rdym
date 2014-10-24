levenshtein_dist <- function(s, t)
{
  .Call("R_levenshtein_dist", s, t)
}

