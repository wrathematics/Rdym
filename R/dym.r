sub_lastcall <- function(name, word, lastcall)
{
  if (class(lastcall) == "call")
    lastcall <- utils::capture.output(lastcall)
  
  paste0(sub(x=lastcall, pattern=name, replacement=word))
}



### "could not find function"
dym_function <- function(name, lastcall, problem, msg, call_stack)
{
  #make the basic objects list:
  objs <- lapply(search(), objects)
  objs <- unique(c(ls(), do.call(c, objs)))
  closest <- find_closest_word(name, objs)
  word <- closest$word
  
  lastcall <- sub_lastcall(name, word, lastcall)
  
  return(list(suggestion=word, lastcall=lastcall))
}



### "there is no package called"
dym_package <- function(name, lastcall, problem, msg, call_stack)
{
  objs <- utils::installed.packages()[, "Package"]
  closest <- find_closest_word(name, objs)
  word <- closest$word
  
  lastcall <- sub_lastcall(name, word, lastcall)
  
  return(list(suggestion=word, lastcall=lastcall))
}



### "is not an exported object from"
dym_export <- function(name, lastcall, problem, msg, call_stack)
{
  # use the last call to recover package name and alleged function name
  pkg <- as.character(as.list(lastcall)[[2]]) # gets the package
  name <- as.character(as.list(lastcall)[[3]]) # gets the alleged function
  
  package_title <- paste0("package:", pkg)
  if (package_title %in% search())
    objs <- objects(paste0("package:", pkg))
  else
    objs <- objects(getNamespace(pkg))
  
  closest <- find_closest_word(name, objs)
  word <- closest$word
  
  # in order to make suggested code, take a risk and get lastcall
  # from history:
  lastcall <- sub_lastcall(name, word, lastcall)
  
  return(list(suggestion=word, lastcall=lastcall))
}



### "object %s not found"
dym_object <- function(name, lastcall, problem, msg, call_stack)
{
  objs <- lapply(search(), objects)
  objs <- unique(c(ls(), do.call(c, objs)))
  
  possible_containers <- cull_calls(call_stack)
  
  #add on the objects contained in the valid containers:
  add_on <- function(x) if (exists(x)) x else NULL
  
  new_objs <- lapply(possible_containers, add_on)
  objs <- unique(c(do.call(c, new_objs), objs))
  
  closest <- find_closest_word(name, objs)
  word <- closest$word
  lastcall <- sub_lastcall(name, word, lastcall)
  
  return(list(suggestion=word, lastcall=lastcall))
}



### unused argument
dym_unused <- function(name, lastcall, problem, msg, call_stack)
{
  ### find the call that gnerated the error:
  cs_length <- length(call_stack)
  topcall <- call_stack[[cs_length - 1]]
  # stop_dym is the last call in call_stack
  
  
  # recover the unused argument(s) from the error message:
  unused_args <- find_unused_args(msg)

  #see if a namespace is involved in the topcall:
  top_func_call <- as.character(topcall)[[1]]

  with_namespace <- length(grep(top_func_call, pattern="::")) > 0
  
  # for each unused argument, find a suggested replacement:
  replacements <- sapply(unused_args, find_replacement, topcall=topcall, 
                         with_namespace=with_namespace)
  
  rep_length <- length(replacements)
  suggestion <- character()
  if (rep_length > 1) {
    for (i in 1:(rep_length-1)) {
      suggestion <- paste0(suggestion, replacements[i], ", ")
    }
  }
  suggestion <- paste0(suggestion, replacements[rep_length])
  
  
  if (!is.null(lastcall) && topcall==lastcall) # should not be empty, but just in case
  {
    # ... we'll attempt this only if there is no nesting
    
    # get the wrong parameter names
    wrong_params <- character()
    for (i in 1:length(unused_args)) {
      wrong_params[i] <- gsub(unused_args[i], pattern=" = .*", replacement="")
    }
    
    #get the suggested parameter names
    right_params <- character()
    for (i in 1:length(unused_args)) {
      right_params[i] <- gsub(replacements[i], pattern=" = .*", replacement="")
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
  }
  
  suggested_call <- capture.output(suggested_call)
  
  return(list(suggestion=suggestion, lastcall=suggested_call))
}



did_you_mean <- function(name, lastcall, problem, msg, call_stack)
{
  name <- sub(x=name, pattern="\\n", replacement="")
  
  if (problem == "function")
    out <- dym_function(name, lastcall, problem, msg, call_stack)
  else if (problem=="package") 
    out <- dym_package(name, lastcall, problem, msg, call_stack)
  else if (problem == "not_exported")
    out <- dym_export(name, lastcall, problem, msg, call_stack)
  else if (problem == "object")
    out <- dym_object(name, lastcall, problem, msg, call_stack)
  else if (problem == "unused_arguments")
    out <- dym_unused(name, lastcall, problem, msg, call_stack)
  
  suggestion <- out$suggestion
  lastcall <- out$lastcall
  
  #the following applies to errors other than unused arguments:
  lang <- get_language()
  dym_local <- dym_translate(lang=lang)
  
  cat(paste0("\n", dym_local, suggestion, "  ?\n"))
  if (!is.null(lastcall))
      cat(lastcall, "\n")
  
  return(invisible())
}

