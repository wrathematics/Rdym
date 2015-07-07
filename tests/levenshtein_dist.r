ld <- function(a, b) Rdym:::levenshtein_dist(a, b)


test <- function(word1, word2)
{
  tmp <- function(word1, word2) ld(word1, word2) == adist(word1, word2)[1,1]
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
    invisible(TRUE)
}


test("kitten", "smitten")
test("gumbo", "gambol")
test("shave", "brave")
test("abcdef", "g")



a <- "rm"
b <- "rmorm"
stopifnot(ld(a, b) == 3)
stopifnot(ld(b, a) == 3)
