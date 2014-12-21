did_you_mean <- function(name, lastcall, problem, msg, call_stack)
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
    
    # in order to make suggested code, take a risk and get lastcall
    # from history:
    
    lastcall <- get_lastcall(call_stack=1,msg)
    
  }
  else if (problem == "not_exported")
  {
    
#     msg_frag <- sub(x=msg, pattern=".*namespace:", replacement="")
#     pkg <- sub(x=msg_frag, pattern="'", replacement="")
#     pkg <- sub(x=pkg,pattern="[[:space:]]$", replacement="")

    # last call
    pkg <- as.character(as.list(lastcall)[[2]]) # gets the package
    name <- as.character(as.list(lastcall)[[3]]) # gets the alleged function

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

    # in order to make suggested code, take a risk and get lastcall
    # from history:

    lastcall <- get_lastcall(call_stack=1,msg)

  }
  else if (problem == "object")
  {
    #expr <- parse(text=lastcall)
    #objs <- process_ast(capture.output(do.call(pryr::call_tree, list(expr))))
    
    
    objs <- lapply(search(), objects)
    objs <- unique(c(ls(), do.call(c, objs)))
    
    possible_containers <- cull_calls(call_stack)
    
    #add on the objects contained in the valid containers:
    add_on <- function(x) {
      tryCatch(suppressWarnings(objects(eval(parse(text=x)))),
               error=function(e){
                 return(NULL)
               })
    }
    new_objs <- lapply(possible_containers,add_on)
    objs <- unique(c(do.call(c,new_objs),objs))
    
    closest <- find_closest_word(name, objs)
    word <- closest$word
  }
  else if (problem == "unused_arguments") {
    
    ### Easier now to find topcall now (see the anxious discussion below)
    cs_length <- length(call_stack)
    topcall <- call_stack[[cs_length - 1]]
    # stop_dym is the last call in this list
    
    
    # we need to recover the top call in the stack.  .Traceback won't give
    # the current stack, because the error is still being "handled".
    # fortunately R mentions the top call in the error message.
    #Let's isolate it:
#     temp <- sub(msg,pattern="Error in ",replace="")
#     topcall <- sub(temp,pattern=" : .*",replace="")
    #Question:  does this use of sub give problems in other languages?
    
    #Problem: if the top call is very long, then the above returns only an
    #initial substring of it.  This will happen frequently in complex graphics
    # functions, where arguments give titles, axis labels, etc.
    #To hedge against this possibility:
    
#     topcall <- space_scrub(topcall)
#     lastcall <- space_scrub(lastcall)
#     tc_length <- nchar(topcall)
#     if ((substr(lastcall,1,tc_length))==topcall) { #topcall probably is original call
#       topcall <- lastcall
#     }
    
    # Still this could blow up if calls are nested and topcall is long
    
    
    
    # recover the unused argument(s) from the error message:
    unused_args <- find_unused_args(msg)

    #see if a namespace is involved in the topcall:
    top_func_call <- as.character(topcall)[[1]]

    with_namespace <- length(grep(top_func_call,pattern="::")) > 0
    
    # for each unused argument, find a suggested replacement:
    replacements <- sapply(unused_args,find_replacement,topcall=topcall,
                           with_namespace=with_namespace)
    
   rep_length <- length(replacements)
   suggested_args <- character()
   if (rep_length > 1) {
    for (i in 1:(rep_length-1)) {
      suggested_args <- paste0(suggested_args,replacements[i],", ")
    }
  }
   suggested_args <- paste0(suggested_args,replacements[rep_length])
    
    # perform console output (sorry, cannot use procedure common to the
    # other errors)
    
    lang <- get_language()
    dym_local <- dym_translate(lang=lang)    
    cat(paste0("\n", dym_local, suggested_args, "  ?\n"))

    if (!is.null(lastcall) && topcall==lastcall) { # should not be empty, but just in case
      # ... we'll attempt this only if there is no nesting

      # get the wrong parameter names
      wrong_params <- character()
      for (i in 1:length(unused_args)) {
        wrong_params[i] <- gsub(unused_args[i],pattern=" = .*",replace="")
      }
      
      #get the suggested parameter names
      right_params <- character()
      for (i in 1:length(unused_args)) {
        right_params[i] <- gsub(replacements[i],pattern=" = .*",replace="")
      }
      
      #get new names for the list that is our call
      lc_names <- names(lastcall)
      for (i in 1:length(lastcall)) {
        if (lc_names[i] %in% wrong_params) {
          lc_names[i] <-right_params[which(wrong_params == lc_names[i])]
        }
      }
      
      suggested_call <- lastcall
      names(suggested_call) <- lc_names
      print(suggested_call)
      cat("\n")
      
    }
  
  # Note:  suggestion is not for copy-and-paste when some arguments are character string originally
  # with spaces

    return(invisible())
     
  }
  
  #the following applies to errors other than unused arguments:
  
  lang <- get_language()
  dym_local <- dym_translate(lang=lang)
  
  cat(paste0("\n", dym_local, word, "  ?\n"))
  if (!is.null(lastcall))
  {
    if (class(lastcall) == "call") {
        call_text <- capture.output(print(lastcall))
        cat(paste0(sub(x=call_text, pattern=name, replacement=word), "\n"))
    } else cat(paste0(sub(x=lastcall, pattern=name, replacement=word), "\n"))
  
  }
  
  return(invisible())
} # end handling unused arguments


