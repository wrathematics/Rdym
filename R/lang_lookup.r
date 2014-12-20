get_language <- function()
{
  lang <- Sys.getenv()["LANGUAGE"]
  lang <- sub(x=lang, pattern="^.*:", replacement="")
  
  if (is.na(lang)) lang <- "en"
  else if (!(lang %in% langtable$lang)) lang <- "en"
  
  return(lang)
}



get_langrow <- function(lang)
{
  row <- which(langtable$lang == lang)
  
  return(row)
}



check_lang <- function(lang)
{
  if (length(get_langrow(lang=lang)) == 0)
    stop("Language is not supported in Rdym at this time.  If you have localization support in R, please file an issue with Rdym.")
  
  return(invisible())
}



get_missing_obj <- function(lang)
{
  langrow <- get_langrow(lang=lang)
  
  obj <- paste0("(?<=", langtable$obj_pre[langrow], ")(.*)(?=", langtable$obj_post[langrow], ")")
  return(obj)
}



get_missing_fun <- function(lang)
{
  langrow <- get_langrow(lang=lang)
  
  fun <- paste0("(?<=", langtable$fun_pre[langrow], ")(.*)(?=", langtable$fun_post[langrow], ")")
  return(fun)
}



get_error_token <- function(lang)
{
  langrow <- get_langrow(lang=lang)
  
  err <- langtable$err[langrow]
  return(err)
}



### Taken from Google Translage; accuracy/coherence not guaranteed.
dym_translate <- function(lang)
{
  # Danish
  if (lang == "da")
    dym <- "Mente du"
  # German
  else if (lang == "de")
    dym <- "Meinten Sie"
  # Spanish
  else if (lang == "es")
    dym <- "Quiso decir"
  # French
  else if (lang == "fr")
    dym <- "Vouliez-vous dire"
  # Italian
  else if (lang == "it")
    dym <- "Forse cercavi"
  # Japanese --- I know this isn't idiomatic, but this is the best 
  # I can do without rewriting a bunch of stuff I don't want to rewrite
  else if (lang == "ja") 
    dym <- "\u3042\u306a\u305f\u306f\u3092\u610f\u5473\u3057\u305f"
  # Korean
  else if (lang == "ko")
    dym <- "\ucc3e\uc73c \uc168\ub098\uc694"
  # Norwegian
  else if (lang == "nn")
    dym <- "Mente du"
  # Polish
  else if (lang == "pl")
    dym <- "Czy chodzi\u0142o Ci o"
  # Portugese
  else if (lang == "pt")
    dym <- "Queria dizer"
  # Russian
  else if (lang == "ru")
    dym <- "\u0412\u044b \u0438\u043c\u0435\u043b\u0438 \u0432 \u0432\u0438\u0434\u0443"
  # Turkish --- see comments for Japanese above.
  else if (lang == "tr")
    dym <- "E\u011fer demek istediniz"
  # Chinese - simplified
  else if (lang == "zh_CN")
    dym <- "\u4f60\u7684\u610f\u601d\u662f"
  # Chinese - traditional
  else if (lang == "zh_TW")
    dym <- "\u4f60\u7684\u610f\u601d\u662f"
  # Default to English because whatever
  else
    dym <- "Did you mean"
  
  return(paste0(dym, ":  "))
}

