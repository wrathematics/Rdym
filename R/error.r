matcherr <- function(msg, pattern)
{
  length(grep(x=msg, pattern=pattern, perl=TRUE)) > 0
}



get_lastcall <- function()
{
  Rhistfile <- tempfile(".Rhistory")
  savehistory(Rhistfile)
  Rhist <- readLines(Rhistfile)
  unlink(Rhistfile)
  
  return( Rhist[length(Rhist)] )
}



scrub <- function(msg, pre, post)
{
  if (pre != "") fun <- sub(x=msg, pattern=paste0(".*", pre), replacement="")
  if (post != "") fun <- sub(x=fun, pattern=paste0(post, ".*"), replacement="")
  
  fun <- gsub(x=fun, pattern="( +|\"|\'|\\n|«|»)", replacement="")
  
  fun
}


stop_dym <- function()
{
  lastcall <- get_lastcall()
  
  msg <- geterrmessage()
  
  ### Language support
  lang <- get_language()
  check_lang(lang)
  
  missing_fun <- get_missing_fun(lang)
  missing_obj <- get_missing_obj(lang)
  
  if (matcherr(msg=msg, pattern=missing_fun) || 
      matcherr(msg=msg, pattern="is not an exported object from")) # TODO
  {
    langrow <- get_langrow(lang=lang)
    pre <- langtable$fun_pre[langrow]
    post <- langtable$fun_post[langrow]
    
    fun <- scrub(msg=msg, pre=pre, post=post)
    did_you_mean(fun, lastcall)
  }
  else if (matcherr(msg=msg, pattern=missing_obj))
  {
    langrow <- get_langrow(lang=lang)
    pre <- langtable$obj_pre[langrow]
    post <- langtable$obj_post[langrow]
    
    fun <- scrub(msg=msg, pre=pre, post=post)
    did_you_mean(fun, lastcall)
  }
  else if (matcherr(msg=msg, pattern="unused argument(?s)"))
  {
    #TODO
  }
  else
  {
    #TODO
  }
  
  invisible()
}

