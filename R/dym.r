did_you_mean <- function(name, lastcall, problem, msg)
{
  name <- sub(x=name, pattern="\\n", replacement="")
  
  
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
    expr <- parse(text=lastcall)
    objs <- process_ast(capture.output(do.call(pryr::call_tree, list(expr))))
    closest <- find_closest_word(name, objs)
    word <- closest$word
  }
  else if (problem == "unused_arguments") {
    
    
    # we need to recover the top call in the stack.  .Traceback won't give
    # the current stack, because the error is still being "handled".
    # fortunately R mentions the top call in the error message.
    #Let's isolate it:
    temp <- sub(msg,pattern="Error in ",replace="")
    topcall <- sub(temp,pattern=" : .*",replace="")
    #Question:  does this use of sub give problems in other languages?
    
    #Problem: if the top call is very long, then the above returns only an
    #initial substring of it.  This will happen frequently in complex graphics
    # functions, where arguments give titles, axis labels, etc.
    #To hedge against this possibility:
    
    topcall <- space_scrub(topcall)
    lastcall <- space_scrub(lastcall)
    tc_length <- nchar(topcall)
    if ((substr(lastcall,1,tc_length))==topcall) { #topcall probably is original call
      topcall <- lastcall
    }
    
    # Still this could blow up if calls are nested and topcall is long
    
    
    
    # recover the unused argument(s) from the error message:
    unused_args <- find_unused_args(msg)
    
    with_namespace <- length(grep(topcall,pattern="::")) > 0
    #well, it PROBABLY involves a namespace!
    
    # for each unused argument, find a suggested replacement:
    replacements <- sapply(unused_args,find_replacement,topcall=topcall,
                           with_namespace=with_namespace)
    
    # make the replacments in topcall:
    better_call <- topcall
    rep_length <- length(replacements)
    for (i in 1:rep_length) {
      better_call <- sub(better_call,pattern=unused_args[i],
                         replace=replacements[i])
    }
    
   suggested_args <- character()
   for (i in 1:(rep_length-1)) {
     suggested_args <- paste0(suggested_args,replacements[i],", ")
   }
   suggested_args <- paste0(suggested_args,replacements[rep_length])
    
    # perform console output (sorry, cannot use procedure common to the
    # other errors)
    
    lang <- get_language()
    dym_local <- dym_translate(lang=lang)    
    cat(paste0("\n", dym_local, suggested_args, "  ?\n"))
    if (!is.null(lastcall)) {
      lastcall <- space_scrub(lastcall)
      better_call <- space_scrub(better_call)
      topcall <- space_scrub(topcall)
      suggestion <- substr_find_and_replace(lastcall,topcall,better_call) 
      cat(paste0(suggestion, "\n"))
    }

    return(invisible())
     
  }
  
  #the following applies to errors other than unused arguments:
  
  lang <- get_language()
  dym_local <- dym_translate(lang=lang)
  
  cat(paste0("\n", dym_local, word, "  ?\n"))
  if (!is.null(lastcall))
  {
    cat(paste0(sub(x=lastcall, pattern=name, replacement=word), "\n"))
  }
  
  return(invisible())
} # end handling unused arguments


