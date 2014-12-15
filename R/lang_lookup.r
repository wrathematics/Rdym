### Generated from R's po files in Rdym/raw/po.r, and the resulting
### dataframe is copied from R's vi(langtable)

langtable <- structure(list(lang = c("de", "es", "fr", "it", "ja", "ko", "nn",                                         
  "pl", "ru", "tr", "zh_CN", "zh_TW", "en"), obj_pre = c("Objekt ",               
  "objeto ", "objet ", "oggetto ", " オブジェクト ", "객체 ",                     
  "fann ikkje objektet ", "nie znaleziono obiektu ", "объект ",                   
  "", "找不到对象", "找不到物件 ", "object"), obj_post = c(" nicht gefunden",     
  " no encontrado", " introuvable", " non trovato", " がありません ",             
  "를 찾을 수 없습니다", "", "", " не найден",                                    
  " nesnesi bulunamadı", "", "", "not found"), fun_pre = c("konnte Funktion ",    
  "no se pudo encontrar la funci\U3e33663cn ", "impossible de trouver la fonction ",
  "non trovo la funzione ", " 関数 ", "함수 ", "fann ikkje funksjonen ",          
  "nie udało się znaleźć funkcji ", "не могу найти функцию ",                     
  "", "没有", "沒有這個函數 ", "could not find function"                          
  ), fun_post = c(" nicht finden", "", "", "", " を見つけることができませんでした ",
  "를 찾을 수 없습니다", "", "", "", " fonksiyonu bulunamadı",                    
  "这个函数", "", "")), .Names = c("lang", "obj_pre", "obj_post",                 
  "fun_pre", "fun_post"), row.names = c(NA, -13L), class = "data.frame")          


get_language <- function()
{
  lang <- Sys.getenv()["LANGUAGE"]
  lang <- sub(x=lang, pattern="^.*:", replacement="")
  
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


