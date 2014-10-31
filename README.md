# Rdym

Most search engines have a "did you mean?" functionality, where
suggestions are given in the presence of likely typos.  This
uses ancient spellchecker techniques to somewhat replicate
that functionality for R.



## Example

Usage of the package is completely passive, beyond loading it with
the usual `library(Rdym)` call.  Say for example you run:

```r
shapro.test(x=rnorm(20))
# Error: object 'shapro.test' not found
```

With the R-did-you-mean package, you can get a "did you mean?"
suggestion listed with the error:

```r
library(Rdym)

shapro.test(x=rnorm(20))
# Error: could not find function "shapro.test"
# 
# Did you mean:  shapiro.test()  ?
# shapiro.test(x=rnorm(20))
```

Missingness will propagate from outermost to innermost.  For example:

```r
library(Rdym)

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

You can install directly from GitHub via the devtools package:

```
devtools::install_github("wrathematics/Rdym")
```



## How it works

When R detects that a function or object listed in the user's input
is not found, the package finds the minimum
[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
between the "unfound" word and all symbols in the user's global
environment plus all loaded namespaces.  The word with minimum Levenshtein
distance (in the event of ties, the first such detected is returned) is
then suggested as an alternative to the missing symbol.



## Software license and disclaimer

This software is licensed under the permissive 2-clause BSD license.
You can find a quick summary of the license here:

https://tldrlegal.com/license/bsd-2-clause-license-%28freebsd%29

The full terms of the license follows:

```
Copyright (C) 2014 Drew Schmidt. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

