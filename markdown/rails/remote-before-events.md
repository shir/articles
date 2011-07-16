У нас есть ссылка которая делает ajax запрос:

```ruby
link_to 'Cool work', cool_work_path, :remote => true
```

Мы хотим сделать какую-то обработку перед отправление запрос и после его выполнения.
Для этого в пакете jquery-rails предусмотрены следующие события:

- `ajax:before` - Вызывается в самом начале обработки запроса.
- `ajax:beforeSend` - Вызывается непосредственно перед отправкой запроса. Если возвращается false
   то выполнение запроса будет остановлено.
- `ajax:success` - Вызывается непосредственно после выполнения запроса если он был выполнен успешно.
- `ajax:complete` - Вызывается после выполнения запроса независимо от статуса.
- `ajax:error` - Вызывается если произошла ошибка.

Вернемся к нашей ссылке. Добавим к ней аттрибут `id` чтоб было легче на нее ссылаться.

```ruby
link_to 'Cool work', cool_work_path, :remote => true, :id => 'cool_link'
```

И в application.js пишем обработчик для событий.

```javascript
$(function () {
  $("#cool_link").live("ajax:before", function () {
    $(this).html("Processing...")
  };
});

$(function () {
  $("#cool_link").live("ajax:complete", function () {
    $(this).html("Cool work")
  };
});
```
