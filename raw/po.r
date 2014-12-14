### Languages

RSRC <- "~/R/R-devel/"

pofiles <- paste0(RSRC, "/src/library/base/po")

files <- dir(pofiles)
files <- files[!grepl(x=files, pattern="(R-|R[.]|RG)")]
files


pct_s <- paste0("[\\]?[\"\']", "%s", "[\\]?[\"\']")

missing_obj <- paste("object", pct_s, "not found")
missing_fun <- paste("could not find function", pct_s)

len <- length(files)

langtable <- data.frame(
  lang=character(len), 
  obj_pre=character(len), 
  obj_post=character(len),
  fun_pre=character(len),
  fun_post=character(len), 
  stringsAsFactors=FALSE
)


prepost <- function(text, x)
{
  x <- text[which(grepl(x=text, pattern=x)) + 1]
  x <- sub(x=x, pattern="msgstr ", replacement="")
  x <- gsub(x=x, pattern="[\\]?[\"\']", replacement="")
  x <- unlist(strsplit(x=x, split="%s"))
  
  x
}

for (i in 1:len)
{
  file <- files[i]
  text <- readLines(paste0(pofiles, "/", file))
  
  missing_obj_local <- prepost(text=text, x=missing_obj)
  missing_fun_local <- prepost(text=text, x=missing_fun)
  
  langtable$lang[i] <- sub(x=file, pattern="[.]po", replacement="")
  langtable$obj_pre[i] <- missing_obj_local[1]
  langtable$obj_post[i] <- missing_obj_local[2]
  langtable$fun_pre[i] <- missing_fun_local[1]
  langtable$fun_post[i] <- missing_fun_local[2] 
}

delete <- ( is.na(langtable$obj_pre) & is.na(langtable$obj_post) ) | 
          ( is.na(langtable$fun_pre) & is.na(langtable$fun_post) )

langtable <- langtable[!delete, ]

langtable

