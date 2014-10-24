find_closest_word <- function(input, words)
{
  shortest = -1L
  
  for (i in 1L:length(words))
  {
    dist <- levenshtein_dist(input, words[i])
    if (dist == 0)
    {
      closest <- i
      shortest = 0L
      break
    }
    
    if (dist <= shortest || shortest < 0)
    {
      closest <- i
      shortest <- dist
    }
  }
  
  return(list(dist=dist, word=words[closest]))
}



did_you_mean <- function(name)
{
  with.namespace <- length(grep(x=name, pattern="::")) > 0
  
  if (with.namespace)
  {
    pkg <- sub(x=name, pattern="::.*$", replacement="")
    name <- sub(x=name, pattern=".+::", replacement="")
    objs <- objects(paste0("package:", pkg))
  }
  else
  {
    objs <- lapply(search(), objects)
    objs <- unique(c(ls(), do.call(c, objs)))
  }
  
  closest <- find_closest_word(name, objs)
  
  if (with.namespace)
    word <- paste0(pkg, "::", closest$word)
  else
    word <- closest$word
  
  cat(paste0("Did you mean:  ", word, "  ?\n"))
  
  invisible()
}


