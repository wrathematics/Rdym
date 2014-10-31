.onLoad <- function(libname, pkgname)
{
  if (interactive())
    options(error=stop_dym)
  
  invisible()
}



.onUnload <- function(libpath)
{
  options(error=NULL)
}
