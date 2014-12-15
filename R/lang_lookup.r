### Generated from R's po files in Rdym/raw/po.r, and the resulting
### dataframe is copied from R's vi(langtable)

langtable <- structure(list(lang = c("de", "es", "fr", "it", "ja", "ko", "nn",               
  "pl", "ru", "tr", "zh_CN", "zh_TW", "en"), obj_pre = c("Objekt ",               
  "objeto ", "objet ", "oggetto ", " ã\u0082ªã\u0083\u0096ã\u0082¸ã\u0082§ã\u0082¯ã\u0083\u0088 ",
  "ê°\u009dì²´ ", "fann ikkje objektet ", "nie znaleziono obiektu ",              
  "Ð¾Ð±Ñ\u008aÐµÐºÑ\u0082 ", "", "æ\u0089¾ä¸\u008då\u0088°å¯¹è±¡",                
  "æ\u0089¾ä¸\u008då\u0088°ç\u0089©ä»¶ ", "object"),                              
      obj_post = c(" nicht gefunden", " no encontrado", " introuvable",           
      " non trovato", " ã\u0081\u008cã\u0081\u0082ã\u0082\u008aã\u0081¾ã\u0081\u009bã\u0082\u0093 ",
      "ë¥¼ ì°¾ì\u009d\u0084 ì\u0088\u0098 ì\u0097\u0086ì\u008aµë\u008b\u0088ë\u008b¤",
      "", "", " Ð½Ðµ Ð½Ð°Ð¹Ð´ÐµÐ½", " nesnesi bulunamadÄ±",                       
      "", "", "not found"), fun_pre = c("konnte Funktion ", "no se pudo encontrar la funciü¾\u008c¶\u0098¼n ",
      "impossible de trouver la fonction ", "non trovo la funzione ",             
      " é\u0096¢æ\u0095° ", "í\u0095¨ì\u0088\u0098 ", "fann ikkje funksjonen ",   
      "nie udaÅ\u0082o siÄ\u0099 znaleÅºÄ\u0087 funkcji ",                        
      "Ð½Ðµ Ð¼Ð¾Ð³Ñ\u0083 Ð½Ð°Ð¹Ñ\u0082Ð¸ Ñ\u0084Ñ\u0083Ð½ÐºÑ\u0086Ð¸Ñ\u008e ",   
      "", "æ²¡æ\u009c\u0089", "æ²\u0092æ\u009c\u0089é\u0080\u0099å\u0080\u008bå\u0087½æ\u0095¸ ",
      "could not find function"), fun_post = c(" nicht finden",                   
      "", "", "", " ã\u0082\u0092è¦\u008bã\u0081¤ã\u0081\u0091ã\u0082\u008bã\u0081\u0093ã\u0081¨ã\u0081\u008cã\u0081§ã\u0081\u008dã\u0081¾ã\u0081\u009bã\u0082\u0093ã\u0081§ã\u0081\u0097ã\u0081\u009f ",
      "ë¥¼ ì°¾ì\u009d\u0084 ì\u0088\u0098 ì\u0097\u0086ì\u008aµë\u008b\u0088ë\u008b¤",
      "", "", "", " fonksiyonu bulunamadÄ±", "è¿\u0099ä¸ªå\u0087½æ\u0095°",       
      "", "")), .Names = c("lang", "obj_pre", "obj_post", "fun_pre",              
  "fun_post"), row.names = c(NA, -13L), class = "data.frame")                                                                                                                                                                               

Encoding(langtable$obj_pre) <- "UTF-8"
Encoding(langtable$obj_post) <- "UTF-8"
Encoding(langtable$fun_pre) <- "UTF-8"
Encoding(langtable$fun_post) <- "UTF-8"


get_language <- function()
{
  lang <- Sys.getenv()["LANGUAGE"]
  lang <- sub(x=lang, pattern="^.*:", replacement="")
  
  if (lang == "en_US") lang <- "en"
  
  lang
}

get_langrow <- function(lang)
{
  which(langtable$lang == lang)
}

check_lang <- function(lang)
{
  if (length(get_langrow(lang=lang)) == 0)
    stop("Language is not supported in Rdym at this time.  If you have localization support in R, please file an issue with Rdym.")
  
  invisible()
}

get_missing_obj <- function(lang)
{
  langrow <- get_langrow(lang=lang)
  
  paste0("(?<=", langtable$obj_pre[langrow], ")(.*)(?=", langtable$obj_post[langrow], ")")
}

get_missing_fun <- function(lang)
{
  langrow <- get_langrow(lang=lang)
  
  paste0("(?<=", langtable$fun_pre[langrow], ")(.*)(?=", langtable$fun_post[langrow], ")")
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
  # Korean
  else if (lang == "ko")
    dym <- "찾으 셨나요?"
  # Norwegian
  else if (lang == "nn")
    dym <- "Mente du"
  # Polish
  else if (lang == "pl")
    dym <- "Czy chodziło Ci o"
  # Portugese
  else if (lang == "pt")
    dym <- "Queria dizer"
  # Default to English because whatever
  else
    dym <- "Did you mean"
  
  paste0(dym, ":  ")
}

