#' RdymEnable
#' 
#' Enable "did you mean?" error checking.
#' 
#' @examples
#' \dontrun{
#' RdymEnable()
#' nonsense # or something else that doesn't exist and causes an error
#' 
#' RdymDisable()
#' }
#' 
#' @rdname enable
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
#' @rdname enable
#' @export
RdymDisable <- function()
{
  options(error=NULL)
  
  invisible()
}
