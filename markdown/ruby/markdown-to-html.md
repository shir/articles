# Конвертация Markdown в HTML с подсветкой кода.

Недавно начал использовать Markdown для написания сових статей.
Но очень не хватало подсветки синтакисиса.

Тут, как нельзя кстати, вышел railscast [Markdown with Redcarpet](http://railscasts.com/episodes/272-markdown-with-redcarpet).
По его мотивам и написла Raketask с помощью которого конвертирую
все свои статьи в HTML.

Код можно посмотреть [тут](https://github.com/shir/articles). Основная логика
в файле [`lib/tasks/converting.rake`](https://github.com/shir/articles/blob/master/lib/tasks/converting.rake)

Перед запуском устанавливаете [Pygments](http://pygments.org/).
В Max OS X это можно сделать командой:

```console
$ sudo easy_install pygments
```

И необходимые gem'ы:

```console
$ bundle install
```

Для запуска конвертации выполянете команду:

```console
$ rake convert:html
```
Если будут желающие то оформлю как отдельный gem.
