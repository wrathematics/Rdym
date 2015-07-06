.onLoad <- function(libname, pkgname)
{
  if (interactive())
    options(error=stop_dym)
  else
    warning("The Rdym package can only be used interactively.", call.=FALSE, immediate.=TRUE)
  
  invisible()
}



.onUnload <- function(libpath)
{
  options(error=NULL)
}
