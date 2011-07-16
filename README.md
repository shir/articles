Just articles written by me.

# Table of content

## Rails

* [Remote links and before/after processing](https://github.com/shir/articles/blob/master/markdown/rails/remote-before-events.md)
* [Dots and other symbols in routes](https://github.com/shir/articles/blob/master/markdown/rails/dots-in-routes.md)

## Ruby

* [Log function return value](https://github.com/shir/articles/blob/master/markdown/ruby/log-return-value.md)
* [Variables in regexp](https://github.com/shir/articles/blob/master/markdown/ruby/variables-in-regexp.md)
* [Converting from markdown to html with syntax highlight](https://github.com/shir/articles/blob/master/markdown/ruby/markdown-to-html.md)

## Vim

* [Remove trailing spaces](https://github.com/shir/articles/blob/master/markdown/vim/remove-trailling-spaces.md)

# Converting

Install required gems via bundler:

```console
$ bundle install
```

Install [Pygments](http://pygments.org/). You can do it in Mac OS X with command:

```console
$ sudo easy_install pygments
```

Now you can use the Rake task to convert all articles to HTML format.

```console
$ rake convert:html
```

All HTML output will be in `html` directory in project root.
