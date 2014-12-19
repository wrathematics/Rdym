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
  
  tree <- capture.output(pryr::call_tree(parse(text=topcall)))
  
  #locate the function that was actually called in that top call:
  if (with_namespace) {
      # it's the fifth element of the call_tree
      function_branch <- tree[5]
  } else {
    #no namespace so it's the second element of the tree
    function_branch <- tree[2]
  }
  
  error_function <- gsub(function_branch,pattern=".*`",replace="")
  
  # find the paramater names.
  possible_arg_names <- names(formals(error_function))
  
  # NOTE:  The above call fails when there is a namespace involved and it is not loaded
  # don't want to load the namespace on the user, so ...
  # TODO find a way around this problem
  
  #isolate the erroneous parameter name:
  unused_param <- sub(unused,pattern=" =.*",replace="")
  closest <- find_closest_word(unused_param, possible_arg_names)
  better_argument <- sub(unused,pattern=unused_param,replace=closest$word)
  better_argument
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

