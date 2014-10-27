# Rdym

Most search engines have a "did you mean?" functionality, where
suggestions are given in the presence of likely typos.  This
uses ancient spellchecker techniques to somewhat replicate
that functionality for R.

Say for example you run

```r
shapro.test(x=rnorm(20))
# Error: object 'shapro.test' not found
```

With the R-did-you-mean package, you can get a "did you mean?"
suggestion listed with the error:

```r
shapro.test(x=rnorm(20))
# Error: could not find function "shapro.test"
# 
# Did you mean:  shapiro.test()  ?
# shapiro.test(x=rnorm(20))
```

Missingness will propagate from outermost to innermost.  For example:

```r
librar> library(Rdym)

shapro.test(rnom(20))
# Error: could not find function "shapro.test"
# 
# Did you mean:  shapiro.test  ?
# shapiro.test(rnom(20))

shapiro.test(rnom(20))
# Error in stopifnot(is.numeric(x)) : could not find function "rnom"
# 
# Did you mean:  rnorm  ?
# shapiro.test(rnorm(20))

shapiro.test(rnorm(20))
#  Shapiro-Wilk normality test
# 
# data:  rnorm(20)
# W = 0.9366, p-value = 0.207
```


## Installation

```
devtools::install_github("wrathematics/Rdym")
```



## Software license and disclaimer

This software is licensed under the permissive 2-clause BSD license.
You can find a quick summary of the license here:

https://tldrlegal.com/license/bsd-2-clause-license-%28freebsd%29

The full terms of the license (it's very short) are contained in the
LICENSE file in the root directory of the project.
