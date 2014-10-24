# Rdym

Most search engines have a "did you mean?" functionality, where
suggestions are given in the presence of likely typos.  This
uses ancient spellchecker techniques to somewhat replicate
that functionality for R.

At the moment, I'm still trying to figure out how to hijack `eval`,
so it's very much "do it yourself" at the moment.  But I'm
hoping to change that.



## Example

Ideally, I will eventually find a (simple) way to modify R's `eval`.
But to get a flavor for the general behavior, you can explicitly
call `did_you_mean()`:

```r
did_you_mean("wiret.csv")
# Did you mean:  write.csv  ?
```

By default, the function will search the namespaces of all loaded
packages, plus the content of `ls()`.

```r
myfun <- function(x) x+1
did_you_mean("myfn")
# Did you mean:  myfun  ?
```

If the misspelling occurs with a namespace, we only search that namespace.
For example:

```r
did_you_mean("base::wiret.csv")
# Did you mean:  base::parent.env  ?
did_you_mean("utils::wiret.csv")
# Did you mean:  utils::write.csv  ?
```

Notice that `write.csv()` is in the `utils` package, and not
the `base` package.



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
