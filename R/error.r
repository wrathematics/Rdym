matcherr <- function(msg, pattern)
{
  length(grep(x=msg, pattern=pattern, perl=TRUE)) > 0
}


# TODO in this function:  correctly handle "is not an exported object from"
# Also, problem in simpleFind:  when you use pckg::func() and mess up inside,
# simpleFind makes wrong choice about what cannot be found

stop_dym <- function()
{

  ### Handle error message
  msg <- geterrmessage()
  
  get_lastcall <- function(msg) {
      #try to get from history
      #this will fail if user enters more than one command per line
      #but if command is spread over multiple lines we are fine
    
      #assume input is not spread over more than this number of lines plus one:
      backsearch_limit <- 10
      
      Rhistfile <- tempfile(".Rhistory")
      savehistory(Rhistfile)
      Rhist <- readLines(Rhistfile)
      unlink(Rhistfile)
      n <- length(Rhist)
      place <- n
      match <- FALSE
      call_frag <- Rhist[n]
      safety <- 0 #count up to sanity_limit
      while (!match && safety <= backsearch_limit) {
        
        #oddly, the following fails with text: "mean(NULL)",
        #but it works fine from console
        current_msg <- tryCatch(eval(parse(text=call_frag)),
                                error=function(e) {
                                  return(geterrmessage())
                                })
        
        msg_chop <- sub(msg,pattern="Error.*: ",replace="")
        msg_chop <- sub(msg_chop,pattern="[[:space:]]$",replace="")
        msg_chop <- sub(msg_chop,pattern="^[[:space:]]*",replace="")
        if (current_msg == msg_chop) {
          match <- TRUE 
        }
          else {
          place <- place - 1
          safety <- safety + 1
          call_frag <- paste0(Rhist[place],call_frag)
        }
      }
      if (match == FALSE) return(NULL) else return(call_frag)
  }
  lastcall <- get_lastcall(msg)
  
  if (matcherr(msg=msg, pattern="could not find function") || matcherr(msg=msg, pattern="is not an exported object from"))
  {
    fun <- sub(x=msg, pattern=".*could not find function \"", replacement="")
    fun <- sub(x=fun, pattern="\"", replacement="")
    fun <- sub(x=fun, pattern="\\n", replacement="")
    did_you_mean(fun, lastcall,problem="function",msg)
  }
  
  if (matcherr(msg=msg, pattern="is not an exported object from"))
  {
    notExported <- sub(x=msg, pattern="Error: ", replacement="")
    notExported <- sub(x=notExported, pattern=" is not an exported object from.*", replacement="")
    notExported <- gsub(x=notExported, pattern="'", replacement="")
    did_you_mean(notExported, lastcall,problem="not_exported",msg)
  }
  
  
  if (matcherr(msg=msg, pattern="not found"))
  {
    obj <- sub(x=msg, pattern=".*object '", replacement="")
    obj <- sub(x=obj, pattern="' not found\\n", replacement="") 
    did_you_mean(obj, lastcall,problem="object",msg)
  }
  
  if (matcherr(msg=msg, pattern="there is no package called"))
  {
    pack <- sub(x=msg, pattern=".*there is no package called ", replacement="")
    pack <- sub(x=pack, pattern="\\n", replacement="")
    pack <- gsub(pack,pattern="[[:punct:]]",replace="")
    did_you_mean(pack, lastcall,problem="package",msg)
  }
  
  if (matcherr(msg=msg, pattern="unused argument(?s)"))
  {
    #TODO
  }
  
  invisible()
}

