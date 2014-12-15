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


langtable$obj_pre <- iconv(langtable$obj_pre, "ISO_8859-1", "UTF-8")
langtable$obj_post <- iconv(langtable$obj_post, "ISO_8859-1", "UTF-8")
langtable$fun_pre <- iconv(langtable$fun_pre, "ISO_8859-1", "UTF-8")
langtable$fun_post <- iconv(langtable$fun_post, "ISO_8859-1", "UTF-8")


langtable

