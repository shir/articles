# Ruby: Переменные в регулярных выражениях.

Бывает что нужно вставить одно регулярное выражение в другое.
Это можно сделать так же как со строкой:

```irb
ree-1.8.7-2010.02 > REGEXP1 = /[A-Za-z0-9\_][A-Za-z0-9\-\_\.]+/
ree-1.8.7-2010.02 > /^#{REGEXP1}$/
 => /^(?-mix:[A-Za-z0-9\_][A-Za-z0-9\-\_\.]+)$/
```

Но при такой вставке могут быть проблемы при дальнейшем преобразовании,
например в строку. Сравните:

```irb
> /^#{REGEXP1}$/.to_s
=> "(?-mix:^(?-mix:[A-Za-z0-9\\_][A-Za-z0-9\\-\\_\\.]+)$)"
```

и

```irb
> /^[A-Za-z0-9\_][A-Za-z0-9\-\_\.]+$/.to_s
=> "(?-mix:^[A-Za-z0-9\\_][A-Za-z0-9\\-\\_\\.]+$)"
```

Как видно, в результате выражения различаются. Для того чтоб такого
не присходило можно воспользоваться методом `#source`:

```irb
> /^#{REGEXP1.source}$/.to_s
=> "(?-mix:^[A-Za-z0-9\\_][A-Za-z0-9\\-\\_\\.]+$)"
```

В этом случае результат получается аналогичный, как если бы мы не использовали
переменную.
