did_you_mean <- function(name, lastcall, problem, msg)
{
  name <- sub(x=name, pattern="\\n", replacement="")
  #with.namespace <- length(grep(x=name, pattern="::")) > 0
  
  
  if (problem == "function") {
    #make the basic objects list:
    objs <- lapply(search(), objects)
    objs <- unique(c(ls(), do.call(c, objs)))
    closest <- find_closest_word(name, objs)
    word <- closest$word
  }
  else if (problem=="package") 
  {
    objs <- installed.packages()[,"Package"]
    closest <- find_closest_word(name, objs)
    word <- closest$word
  }
  else if (problem == "not_exported")
  {
    msg_frag <- sub(x=msg, pattern=".*namespace:", replacement="")
    pkg <- sub(x=msg_frag, pattern="'", replacement="")
    pkg <- sub(x=pkg,pattern="[[:space:]]$", replacement="")
    
    package_title <- paste0("package:",pkg)
    if (package_title %in% search()) {
      objs <- objects(paste0("package:", pkg))
    } else { #package not attached
      objs <- objects(getNamespace(pkg))
      #this won't give you all the objects, but
      #at least you get the ones exported from the
      #package
    }
    closest <- find_closest_word(name, objs)
    word <- closest$word
    word <- paste0(pkg, "::", word)
  }
  else if (problem == "object")
  {
#    if (!is.null(lastcall))
#    {
      expr <- parse(text=lastcall)
      objs <- process_ast(capture.output(do.call(pryr::call_tree, list(expr))))
      closest <- find_closest_word(name, objs)
      word <- closest$word
#      cat(paste0(sub(x=lastcall, pattern=name, replacement=word), "\n"))
#    }
#    return(invisible())
  }
  
  
  lang <- get_language()
  dym_local <- dym_translate(lang=lang)
  
  cat(paste0("\n", dym_local, word, "  ?\n"))
  if (!is.null(lastcall))
  {
    cat(paste0(sub(x=lastcall, pattern=name, replacement=word), "\n"))
  }
  
  
  return(invisible())
}


