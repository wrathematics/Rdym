matcherr <- function(msg, pattern)
{
  grepl(x=msg, pattern=pattern, perl=TRUE)
}


scrub <- function(msg, pre, post)
{
  if (pre != "") fun <- sub(x=msg, pattern=paste0(".*", pre), replacement="")
  if (post != "") fun <- sub(x=fun, pattern=paste0(post, ".*"), replacement="")
  
  fun <- gsub(x=fun, pattern="( +|\"|\'|\\n|\u00ab|\u00bb)", replacement="")
  
  fun
}




get_lastcall <- function(call_stack,msg)
{
  # the lst item in the call stack is the code for stop_dym
  #if call stack has length greater thne one, then we can get the last call from the stack:
  #no guesswork with R history
  if (length(call_stack) > 1) return(call_stack[[1]])
  
  # guess from R history; this could fail if user enter multiple commands on a single line
  # but probability is low, I think
  backsearch_limit <- 10
  
  Rhistfile <- tempfile(".Rhistory")
  savehistory(Rhistfile)
  Rhist <- readLines(Rhistfile)
  unlink(Rhistfile)

  n <- length(Rhist)
  place <- n
  match <- FALSE
  call_frag <- Rhist[n]
  safety <- 0 #count up to backsearch_limit
  while (!match && safety <= backsearch_limit) {

    error <- function(e) geterrmessage()
    current_msg <- tryCatch(eval(parse(text=call_frag)), error=error)
    msg_chop <- sub(msg,pattern=".*: ",replacement="")
    msg_chop <- sub(msg_chop,pattern="[[:space:]]$",replacement="")
    msg_chop <- sub(msg_chop,pattern="^[[:space:]]*",replacement="")
    if (current_msg == msg_chop) {
      match <- TRUE 
    }
      else {
      place <- place - 1
      safety <- safety + 1
      call_frag <- paste0(Rhist[place],call_frag)
    }
  }
  if (match == FALSE) 
    return(NULL) 
  else
    return(call_frag)
}



stop_dym <- function()
{
  ### Get the call stack (will always contain at least the call for stop_dym)
  call_stack <- sys.calls()
  
  ### Language support
  lang <- get_language()
  check_lang(lang)
  
  missing_fun <- get_missing_fun(lang)
  missing_obj <- get_missing_obj(lang)
  
  msg <- geterrmessage()
  lastcall <- get_lastcall(call_stack,msg)
  
  
  if (matcherr(msg=msg, pattern=missing_fun))
  {
    langrow <- get_langrow(lang=lang)
    pre <- langtable$fun_pre[langrow]
    post <- langtable$fun_post[langrow]
    
    fun <- scrub(msg=msg, pre=pre, post=post)
    did_you_mean(fun, lastcall, problem="function", msg, call_stack)
  }
  else if (matcherr(msg=msg, pattern="is not an exported object from"))
  {
    notExported <- sub(x=msg, pattern="Error: ", replacement="")
    notExported <- sub(x=notExported, pattern=" is not an exported object from.*", replacement="")
    notExported <- gsub(x=notExported, pattern="'", replacement="")
    did_you_mean(notExported,lastcall,problem="not_exported",msg, call_stack)
  }
  else if (matcherr(msg=msg, pattern=missing_obj))
  {
    langrow <- get_langrow(lang=lang)
    pre <- langtable$obj_pre[langrow]
    post <- langtable$obj_post[langrow]
    
    obj <- scrub(msg=msg, pre=pre, post=post)
    did_you_mean(obj, lastcall, problem="object", msg, call_stack)
  }
  else if (matcherr(msg=msg, pattern="there is no package called"))
  {
    pack <- sub(x=msg, pattern=".*there is no package called ", replacement="")
    pack <- sub(x=pack, pattern="\\n", replacement="")
    pack <- gsub(pack,pattern="[[:punct:]]",replacement="")
    did_you_mean(pack, lastcall,problem="package",msg, call_stack)
  }
  
  if (matcherr(msg=msg, pattern="unused argument(?s)"))
  {  
    # best to work on problematic tokens in dym.R, so put placeholder for name
    did_you_mean(name="placeholder",lastcall,problem="unused_arguments",msg, call_stack)
  }
  
  invisible()
}

