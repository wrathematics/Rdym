##################################################################
### Helper functions for handling the unused arguments errrors
##################################################################

find_unused_args <- function(msg) {  
  temp <- sub(msg,pattern="Error.*unused argument(s?) ",replace="")
  temp <- sub(temp,pattern="\\(",replace="")
  temp <- sub(temp,pattern="\\)",replace="")
  temp <- sub(temp,pattern="\\n",replace="")
  unlist(strsplit(temp,split=", ")) 
  # Homer TODO:  really learn regular expressions in R!
  # Also:  use of English, here.  Perhaps worth writing a parenthesis-matching
  #routine to pull out the unused arguments
}


find_replacement <- function(unused,topcall,with_namespace) {
  
  top_function_call <- as.character(topcall)[[1]]
  
  if (with_namespace) {
      call_to_do <- paste0("names(formals(",top_function_call,"))")
      possible_arg_names <- eval(parse(text=call_to_do))
  } else {
    possible_arg_names <- names(formals(top_function_call))
  }

  #isolate the erroneous parameter name:
  unused_param <- sub(unused,pattern=" =.*",replace="")
  closest <- find_closest_word(unused_param, possible_arg_names)
  better_argument <- sub(unused,pattern=unused_param,replace=closest$word)
  better_argument
  
} # end find_replacment



# sometimes you just gotta remove spaces (but we may no longer need this)
space_scrub <- function(str) {
  gsub(str,pattern="[[:blank:]]",replace="")
}




# this may also no longer be needed
substr_find_and_replace <- function(text,to_be_replaced,replacement_string) {
  text_length <- nchar(text)
  match_length <- nchar(to_be_replaced)
  revised <- character()
  for (i in 1:text_length) {
    matches <- (substr(text,i,i+match_length-1) == to_be_replaced)
    if (matches) {
      before <- substr(text,1,i-1)
      after <- substr(text,i+match_length,text_length)
      revised <- paste0(before,replacement_string,after)
    }
  }
  revised
}

