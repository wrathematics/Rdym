#' RdymEnable
#' 
#' Enable "did you mean?" error checking.
#' 
#' @export
RdymEnable <- function()
{
  options(error=stop_dym)
  
  invisible()
}



#' RdymDisable
#' 
#' Disable "did you mean?" error checking.
#' 
#' @export
RdymDisable <- function()
{
  options(error=NULL)
  
  invisible()
}
