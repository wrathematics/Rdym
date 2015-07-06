levenshtein_dist <- function(s, t)
{
  .Call(R_levenshtein_dist, s, t)
}



find_closest_word <- function(input, words)
{
  ret <- .Call(R_find_closest_word, input, words)
  
  if (is.integer(ret) && ret == -1L)
    stop("Internal Rdym error: no suitable list of replacement words found.  Please report this https://github.com/wrathematics/Rdym/issues")
  
  return(ret)
}

