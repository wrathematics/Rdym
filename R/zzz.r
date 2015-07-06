.onLoad <- function(libname, pkgname)
{
  if (interactive())
    options(error=stop_dym)
  
  invisible()
}



.onAttach <- function(...)
{
  if (!interactive())
    packageStartupMessage("NOTE:  The Rdym package can only be used interactively.")
  
  invisible()
}



.onUnload <- function(libpath)
{
  options(error=NULL)
}
