# Rails: Точки и другие спец символы в маршрутах.

Иногда бывает нужно использовать точки или какие-то другие специальные
символы в маршрутах и параметрах маршрутов. Например, мы хотим реализовать
систему которая бует отдавать файлы только пользователям которые являются
владельцами этих файлов.

Создадим такой маршрут:

```ruby
get 'user/:user_id/files/:file_name' => 'user_files#file', :as => :user_file
```

И попробуем им воспользоваться:

```ruby
link_to 'Download File', user_file_path('some_cool_file.jpg')
```

При выполнении это кода произойдет примено такая ошибка:

```
ActionView::Template::Error (No route matches {:action=>"file", :file_name=>"some_cool_file.jpg",
:user_id=>#<User id: 27>, :controller=>"user_files"}):
```

Это происходит потому что `.jpg` интерпертируется как формат, а формата .jpg
в этом action не предусмотрено. Для исправления нужно указать что
это расширение это часть параметра `:file_name`. Сделать это можно следующим
путем указания ограничения по регулярному выражение для этого параметра
включающего все символы `/.+/`:

```ruby
get 'user/:user_id/files/:file_name' => 'user_files#file', :as => :user_file, 
  :constraints => {:file => /.+/ }
```

Учтите что это регулярное выражение включает *все* символы, и в маршруте
вида `/user/1/files/pictures/coolest/some_cool_picture.jpg` в параметр `:file`
будет переданно значение `coolest/some_cool_picture.jpg`. Если же вы не хотите
интерпретировать `/` как часть параметра то этот символ надо исключить
из регулярного выражения:

```ruby
get 'user/:user_id/files/:file_name' => 'user_files#file', :as => :user_file, 
  :constraints => {:file => /[^\/]+/ }
```

В этом случае попытка построения маршурта вида:

```ruby
link_to 'Download File', user_file_path('pictures/coolest/some_cool_picture.jpg')
```

будет вызывать ошибку.
