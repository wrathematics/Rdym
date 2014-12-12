matcherr <- function(msg, pattern)
{
  length(grep(x=msg, pattern=pattern, perl=TRUE)) > 0
}



get_lastcall <- function()
{

# original code
#   Rhistfile <- tempfile(".Rhistory")
#   savehistory(Rhistfile)
#   Rhist <- readLines(Rhistfile)
#   unlink(Rhistfile)
#   return(Rhist[length(Rhist)])


# Let's try using traceback(), in case user spreads call over
# several lines
  
  ## capture all the output to a file.
  dumpFile <- file("all.Rout", open = "wt")
  sink(dumpFile,type="output")
  stack <- traceback(1)
  sink(type="message")
  sink()
  close(dumpFile)
  unlink("all.Rout")
  return(stack[[length(stack)]])

}

get_lastcall_2 <- function(name)
{
  Rhistfile <- tempfile(".Rhistory")
  savehistory(Rhistfile)
  Rhist <- readLines(Rhistfile)
  unlink(Rhistfile)
  
  m <- length(Rhist)
  current <- Rhist[m]
  place <- m
  while (length(grep(x=current,pattern=name))==0 ){
    place <- place -1 
    current <- paste0(Rhist[place],current)
  }
  command <- gsub(x=current,pattern=paste0(".*",name),replace=name)
  return(command)
}


# TODO in this function:  correctly handle "is not an exported object from"
# Also, problem in simpleFind:  when you use pckg::func() and mess up inside,
# simpleFind makes wrong choice about what cannot be found

stop_dym <- function()
{
  
  lastcall <- get_lastcall()
  ### Handle error message
  msg <- geterrmessage()
  
  
  
  if (matcherr(msg=msg, pattern="could not find function") || matcherr(msg=msg, pattern="is not an exported object from"))
  {
    fun <- sub(x=msg, pattern=".*could not find function \"", replacement="")
    fun <- sub(x=fun, pattern="\"", replacement="")
    fun <- sub(x=fun, pattern="\\n", replacement="")
    
    lastcall <- get_lastcall_2(fun)
    did_you_mean(fun, lastcall,problem="function")
  }
  else if (matcherr(msg=msg, pattern="not found"))
  {
    obj <- sub(x=msg, pattern=".*object '", replacement="")
    obj <- sub(x=obj, pattern="' not found\\n", replacement="")
    
    #isolated object?
    l2 <- get_lastcall_2(obj)
    if (l2 == obj) lastcall <- l2
    
    did_you_mean(obj, lastcall,problem="object")
  }
  else if (matcherr(msg=msg, pattern="there is no package called"))
  {
    pack <- sub(x=msg, pattern=".*there is no package called ", replacement="")
    pack <- sub(x=pack, pattern="\\n", replacement="")
    pack <- gsub(pack,pattern="[[:punct:]]",replace="")
    did_you_mean(pack, lastcall,problem="package")
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

