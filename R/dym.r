did_you_mean <- function(name, lastcall)
{
  name <- sub(x=name, pattern="\\n", replacement="")
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
  
  type <- eval(typeof(parse(text=paste0("`", word, "`"))))
  if (type == "closure")
    printword <- paste0(word, "()")
  else
    printword <- word
  
  cat(paste0("\nDid you mean:  ", printword, "  ?\n"))
  if (!missing(lastcall))
  {
    cat(paste0(sub(x=lastcall, pattern=name, replacement=word), "\n"))
  }
  
  invisible()
}


