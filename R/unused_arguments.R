##################################################################
### Helper functions for handling the unused arguments errrors
##################################################################

find_unused_args <- function(msg) {
  
  temp <- sub(msg,pattern="Error.*unused argument(s?) ",replace="")
  temp <- sub(temp,pattern="\\(",replace="")
  temp <- sub(temp,pattern="\\)",replace="")
  temp <- sub(temp,pattern="\\n",replace="")
  unlist(strsplit(temp,split=", "))
  
  # Homer TODO:  learn regular expressions in R
  
}

find_replacement <- function(unused,topcall,with_namespace) {
  
  top_function_call <- as.character(topcall)[[1]]
  
#  tree <- capture.output(pryr::call_tree(parse(text=topcall)))
  
  # locate the function that was actually called in that top call, and 
  # find the names of its arguments
  if (with_namespace) {
      # it's the fifth element of the call_tree
      #function_branch <- tree[5]
      #error_function <- gsub(function_branch,pattern=".*`",replace="")
      # we find the namespace here:
      #pkg <- tree[4]
      #pkg <- gsub(pkg,pattern=".*`",replace="")
      # get those arguments:
      #call_to_do <- paste0("names(formals(",pkg,"::",error_function,"))")
      call_to_do <- paste0("names(formals(",top_function_call,"))")
      possible_arg_names <- eval(parse(text=call_to_do))
  } else {
    #no namespace so it's the second element of the tree
    #function_branch <- tree[2]
    #error_function <- gsub(function_branch,pattern=".*`",replace="")
    possible_arg_names <- names(formals(top_function_call))
  }

  
  #isolate the erroneous parameter name:
  unused_param <- sub(unused,pattern=" =.*",replace="")
  closest <- find_closest_word(unused_param, possible_arg_names)
  better_argument <- sub(unused,pattern=unused_param,replace=closest$word)
  better_argument
}

# sometimes you just gotta remove spaces
space_scrub <- function(str) {
  gsub(str,pattern="[[:blank:]]",replace="")
}


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

