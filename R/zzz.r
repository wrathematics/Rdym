.onLoad <- function(libname, pkgname)
{
  if (interactive())
    RdymEnable()
  
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
  RdymDisable()
}
