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



stop_dym <- function()
{
  lastcall <- get_lastcall()
  
  ### Handle error message
  msg <- geterrmessage()
  
  if (matcherr(msg=msg, pattern="could not find function") || matcherr(msg=msg, pattern="is not an exported object from"))
  {
    fun <- sub(x=msg, pattern=".*could not find function \"", replacement="")
    fun <- sub(x=fun, pattern="\"", replacement="")
    did_you_mean(fun, lastcall)
  }
  else if (matcherr(msg=msg, pattern="not found"))
  {
    obj <- sub(x=msg, pattern=".*: object '", replacement="")
    obj <- sub(x=obj, pattern="' not found\\n", replacement="")
    did_you_mean(obj, lastcall)
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

