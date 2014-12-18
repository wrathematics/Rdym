# in output of dpryr's ast function, identify input objects, such as data frames,
#that might contain other objects the user intended to include in the input.
#Then find object-list for each such item (if it exists), and add it to the basic
#object list from searc()
process_ast <- function (ast_output) {
  # pattern for a valid R variable name:
  variable_pattern <- "`(\\.|[[:alpha:]])([[:alnum:]]|\\.|_)*"
  
  possible_containers <- character()
  has_variable_form <- function(string) (length(grep(string,pattern=variable_pattern))>0)
  isolate_variable_name <- function(string) {
    m <- regexpr(variable_pattern,string)
    temp <- regmatches(x=string,m)
    return(gsub(temp,pattern="`", replacement="")) 
  }
  
  #make the list of possible containers:
    for (string in ast_output) {
     if (has_variable_form(string)) {
        possible_cont <- isolate_variable_name(string)
        possible_containers <- c(possible_containers,possible_cont)
      }
    }
  
  #make the basic objects list:
  objs <- lapply(search(), objects)
  objs <- unique(c(ls(), do.call(c, objs)))
  
  #add on the objects contained in the valid containers:
  add_on <- function(x) {
    tryCatch(suppressWarnings(objects(eval(parse(text=x)))),
             error=function(e){
               return(NULL)
             })
  }
  new_objs <- lapply(possible_containers,add_on)
  objs <- unique(c(do.call(c,new_objs),objs))
  
  return(objs)
}


