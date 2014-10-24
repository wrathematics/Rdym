library(Rdym)

test <- function(word1, word2)
{
  tmp <- function(word1, word2) levenshtein_dist(word1, word2) == adist(word1, word2)[1,1]
  t1 <- tmp(word1, word2)
  t2 <- tmp(word2, word1)
  t3 <- tmp(word1, word1)
  
  if (!all(c(t1, t2, t3)))
  {
    if (!t1 && !t2)
      stop("it's really broken")
    if (!t1 || !t2)
      stop("symmetry fails")
    if (!t3)
      stop("reflexivity fails")
  }
  else
    TRUE
}


test("kitten", "smitten")
test("gumbo", "gambol")
test("shave", "brave")
test("abcdef", "g")

