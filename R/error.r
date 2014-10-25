matcherr <- function(msg, pattern)
{
  length(grep(x=msg, pattern=pattern)) > 0
}


stop_dym <- function()
{
  msg <- geterrmessage()
  
  if (matcherr(msg=msg, pattern="could not find function") || matcherr(msg=msg, pattern="is not an exported object from"))
  {
    fun <- sub(x=msg, pattern="Error: could not find function \"", replacement="")
    fun <- sub(x=fun, pattern="\"", replacement="")
    did_you_mean(fun)
  }
  else if (matcherr(msg=msg, pattern="not found"))
  {
    obj <- sub(x=msg, pattern="Error: object '", replacement="")
    obj <- sub(x=obj, pattern="' not found", replacement="")
    did_you_mean(obj)
  }
  
  invisible()
}

.onLoad <- function(libname, pkgname)
{
  ### from https://stackoverflow.com/questions/18972845/get-last-top-level-command-as-a-character-string/25134931#25134931
.lastcall <<- NULL # create an empty variable to store into
  addTaskCallback(
    function(expr, value, ok, visible)
    {
      assign(".lastcall", as.character(substitute(expr))[2], .GlobalEnv)
      TRUE
    },
    name='storelast'
  )
  
  
  
  options(error=stop_dym)
  invisible()
}

.onUnload <- function(libpath)
{
  options(error=NULL)
}
