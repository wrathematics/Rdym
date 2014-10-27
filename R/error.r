matcherr <- function(msg, pattern)
{
  length(grep(x=msg, pattern=pattern)) > 0
}


stop_dym <- function()
{
  ### Get command that errored
  Rhistfile <- tempfile(".Rhistory")
  savehistory(Rhistfile)
  Rhist <- readLines(Rhistfile)
  unlink(Rhistfile)
  
  lastcall <- Rhist[length(Rhist)]
  
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
  else
  {
    #TODO
  }
  
  invisible()
}

.onLoad <- function(libname, pkgname)
{
  options(error=stop_dym)
  invisible()
}

.onUnload <- function(libpath)
{
  options(error=NULL)
}
