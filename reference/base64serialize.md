# Helpers for converting R objects to strings and back

`base64serialize()` converts an R object into a string suitable for
storing in an environment variable. Use this function for encoding
entire R objects (such as OAuth tokens).

`base64unserialize()` is the inverse operation to `base64serialize()`.
Use this function in your `tic.R` to access the R object previously
encoded by `base64serialize()`.

## Usage

``` r
base64serialize(x, compression = "gzip")

base64unserialize(x, compression = "gzip")
```

## Arguments

- x:

  Object to serialize or deserialize

- compression:

  Passed on as `type` argument to
  [`memCompress()`](https://rdrr.io/r/base/memCompress.html) or
  [`memDecompress()`](https://rdrr.io/r/base/memCompress.html).

## Examples

``` r
serial <- base64serialize(1:10)
base64unserialize(serial)
#>  [1]  1  2  3  4  5  6  7  8  9 10
```
