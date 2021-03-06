# Выпускаем pow наружу.

Думаю все разработчики Ruby on Rails которые работают на Mac OS X знакомы с
утилитой [pow](http://pow.cx). Давно и успешно использую её в разработке.
Но тут появилась необходимость добавить платежный сервис который слал callback'и
по указанному адресу. При этом, при попытке ввести URL который включал в себя
порт, выпадал в ошибку. Поэтому обычный туннель на внешний сервер тут
не подходил, нужно было проксировать через nginx. После того как все это успешно
настроил появилось желание чтоб все это работало в связке с pow. И это удалось!
Ниже инструкция как все это можно настроить.

## Что нужно?

* Сервер с внешним IP-адресом на который мы можем открыть ssh-тунель.
* Сервер на котором у нас есть доступ к настройкам nginx. В моем случае это
  тот же на котором открыт тунель.
* Домен для которого вы можете создать wildcard-поддомен.
* Машина под управлением Mac OS X на которой работает pow.

## Настройка DNS.

Для DNS, открываем консоль своего любимого регистратора домена, и настраиваем
обычный wildcard поддомен:

```
*.tunnel.example.com. A 10.0.0.1
```
(возможно что-то напутал, очень давно приходилось руками настраивать DNS)
Здесь:
* `*.tunnel.example.com.` - Наше доменное имя.
* `10.0.0.1` - IP-адрес nginx-сервера.

## Настраиваем nginx

На сервер с nginx создаём виртуальный хост со следующим конфигом:

```nginx
server {
  listen       80;
  server_name  ~^(?<domain>.+)\.tunnel\.example\.com$; # Наш домен

  location / {
    proxy_redirect off;

    proxy_set_header   Host               $domain.dev;  # Выставляем заголовок для pow
    proxy_set_header   X-Forwarded-Host   $host; # Оригинальный host. Без этого заголовка при след. загрузке браузер пытался уйти на $domain.dev
    proxy_set_header   X-Real-IP          $remote_addr; # Стандартные заголовки
    proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;

    proxy_pass http://localhost:8000/; # Адрес и порт на котором у нас открыт туннель. В данном случае на этом же сервере.
  }
}
```
Не забываем перезагрузить nginx после изменения конфига.

## Создаем тунель

### Вручную

Тунель можно открывать каждый раз когда нам нужно вручную, запуская команду на локальном хосте:

```bash
ssh -v -N -R 8000:localhost:80 user@10.0.0.1
```
Здесь:
* `-v` - будет выводится дополнительная информация. А то грустно смотреть когда
  ничего не происходит. Необязательный параметр.
* `-N` - не будет запущен shell по умолчанию. Необязательный параметр.
* `-R 8000:localhost:80` - собственно создание туннеля. С порта 8000 удаленного
  сервера на 80-ый порт локального хоста.
* `user@10.0.0.1` - пользователь и название/IP-адрес сервера на котором
  открываем тунель.

### Автоматически

Так как, каждый раз запускать лень, да будет постоянно в консоли висеть этот ssh,
я решил запускать его как демон при старте. Для этого в папке `~/Libary/LaunchAgents`
создаем файл `com.example.tunnel` с содержимым:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>com.example.tunnel</string> <!-- Название сервиса -->
        <key>ProgramArguments</key>
        <array>  <!-- Команда для запуска с аргументами -->
                <string>/usr/bin/ssh</string>
                <string>-N</string>
                <string>-R 8000:localhost:80</string>
                <string>user@10.0.0.1</string>
        </array>
        <key>KeepAlive</key>
        <dict>
                <key>NetworkState</key>  <!-- Запускаем/останавливаем в зависимости от наличия сети -->
                <true/>
                <key>OtherJobEnabled</key>
                <dict>
                        <key>cx.pow.powd</key>  <!-- Запускаем/останавливаем в зависимости от доступности pow -->
                        <true/>
                </dict>
        </dict>
        <key>RunAtLoad</key>  <!-- Запускаем при старте системы -->
        <true/>
</dict>
</plist>
```

и запускаем его командой:
```bash
launchctl load com.example.tunnel
```

## Тестируем!

Теперь открываем в браузере `http://my-project.tunnel.example.com`, ждем когда
pow запустит проект и погружаемся дальше в работу.
