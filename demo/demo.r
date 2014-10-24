library(Rdym)

levenshtein_dist("sitting", "kitten")
levenshtein_dist("gumbo", "gambol")


find_nearest_word("kitten", c("smitten", "smiling", "kiting"))
find_nearest_word("kitten", c("smitten", "smiling", "kiting", "bitten"))
find_nearest_word("kitten", c("smitten", "smiling", "kiting", "kitten"))


did_you_mean("wiret.csv")
did_you_mean("utils::wiret.csv")
