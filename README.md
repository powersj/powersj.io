# powersj.io

My personal site hosted on Netlify. Powered by [Hugo](https://gohugo.io) and
based on the [Hugo Coder](https://github.com/luizdepra/hugo-coder/) theme.

## License

Files under content/* are licensed under CC-BY-4.0. All other files are MIT.

## Optimized Images done via:

```shell
find -type f -name "*.jpg" -exec jpegoptim --strip-all {} \;
find -type f -name "*.png" -exec optipng -o5 {} \;
```
