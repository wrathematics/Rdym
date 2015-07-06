# Rdym

* **Version:** 0.4.0
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/Rdym.png)](https://travis-ci.org/wrathematics/Rdym) 
* **License:** [![License](http://img.shields.io/badge/license-BSD%202--Clause-orange.svg?style=flat)](http://opensource.org/licenses/BSD-2-Clause)
* **Authors:** Drew Schmidt and Homer White


Most search engines have a "did you mean?" feature, where suggestions are 
given in the presence of likely typos.  And while search engines use 
sophisticated NLP methods on their vast amounts of user-generated data to 
create accurate suggestions, you can get by with some ancient spellchecker 
techniques.  So a little while ago, I did just that with 
[the Rdym package for R](https://github.com/wrathematics/Rdym).



## Example

Usage of the package is completely passive, beyond loading it with the usual 
`library(Rdym)` call.  Say for example you run:

```r
shapro.test(x=rnorm(20))
# Error: object 'shapro.test' not found
```

Note the missing "i" in what should be `shapiro.test()`.  With Rdym loaded, 
you can get a "did you mean?" suggestion along with the error:

```r
library(Rdym)

shapro.test(x=rnorm(20))
# Error: could not find function "shapro.test"
# 
# Did you mean:  shapiro.test()  ?
# shapiro.test(x=rnorm(20))
```

If the spellchecker guessed correctly, then you should be able to just 
copy/paste the suggestion after the "Did you mean" line into R.

Suggestions are given as errors are discovered by the R interpreter.  
For example:

```r
library(Rdym)

shapro.test(rmorm(20))
# Error: could not find function "shapro.test"
# 
# Did you mean:  shapiro.test  ?
# shapiro.test(rmorm(20))

shapiro.test(rmorm(20))
# Error in stopifnot(is.numeric(x)) : could not find function "rmorm"
# 
# Did you mean:  rnorm  ?
# shapiro.test(rnorm(20))

shapiro.test(rnorm(20))
#  Shapiro-Wilk normality test
# 
# data:  rnorm(20)
# W = 0.9366, p-value = 0.207
```



## How it works

When R detects that a function or object listed in the user's input is not 
found, the package finds the minimum 
[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) 
between the "unfound" token and all symbols in the user's global environment 
plus all loaded namespaces.  The word with minimum Levenshtein distance (in 
the event of ties, the first such detected) is then suggested as an 
alternative to the missing symbol.

Fairly efficient 
[C code](https://github.com/wrathematics/Rdym/tree/master/src) 
is used to compute the Levenshtein distances.  The "error interception" is 
just using R's `options()` to set a function to run post error (as seen 
[here](https://github.com/wrathematics/Rdym/blob/master/R/zzz.r)).  The 
package won't work with batch mode R, so you have to use it in an 
interactive R session.

Also keep in mind this is basically just a toy.  You shouldn't think of 
this as being in the same class of capabilities as a search engine's 
suggester.



## Installation

You can install directly from GitHub via the devtools package:

```r
devtools::install_github("wrathematics/Rdym")
```

