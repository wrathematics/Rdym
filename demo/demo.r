library(Rdym)

levenshtein_dist("sitting", "kitten")
levenshtein_dist("gumbo", "gambol")


find_nearest_word("kitten", c("smitten", "smiling", "kiting"))
find_nearest_word("kitten", c("smitten", "smiling", "kiting", "bitten"))
find_nearest_word("kitten", c("smitten", "smiling", "kiting", "kitten"))



levenshtein_dist("write.csv", "de")
