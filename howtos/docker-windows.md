---
title: Поднятие Laravel-проекта на Docker под Windows
tags:
  - docker
variables:
  nginx_container_name:
    description: Имя контейнера с nginx
    required: true
    default: app_nginx
  nginx_port:
    description: Порт nginx
    required: true
    default: 8876

---

- [ ] Заполняем имя контейнера, который выведется при выполнении команды <var>nginx_container_name</var>

# Установка Docker Desktop на ПК

- [ ] Убедиться, что в Windows включена виртуализация. Для этого вызываем диспетчер задач 
  
и во вкладке производительность смотрим параметр "виртуализация".
![Изображение](https://howto.parfentiy.site/images/isVirtualOn.png "Это успех")
Если не включено, то включаем в BIOS.

- [ ] Скачиваем дистрибутив Docker для Windows по [ссылке](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?_gl=1*1129h03*_ga*MTQ1MDI5MjY5Ni4xNjg3MTE3MTkw*_ga_XJWPQMJYHQ*MTY5MDgwMDg0Mi4xMi4xLjE2OTA4MDA5NzEuMjMuMC4w)
  
#### При установке обратить внимание на то, чтобы галочка "Install required Windows components for WSL 2" была установлена

- [ ] После этого скачиваем из [Microsoft Store](https://www.microsoft.com/store/productid/9PN20MSR04DW?ocid=pdpshare) 
  дистрибутив ubuntu и после скачивания устанавливаем его.
  
- [ ] Запускем Docker Desktop и идем в настройки->resources->WSL integration и включаем галочку Ubuntu

- [ ] Находим в трее значок докера и нажимаем ПКМ, в меню смотрим, если высветилось "Switch to windows containers...",
то ничего не делаем, иначе - жмем на этот пункт.
  
- [ ] Открываем командную строку Windows и вводим команды:
  ```
    wsl.exe --update
  ```
  ```
    wsl --set-default-version 2
  ```
  ```
    docker
  ```
  ```
    docker compose
  ```
  Докер и docker compose должны запуститься в командной строке и выдать список своих параметров и ключей. Значит все в порядке

- [ ] Дополнительно проверяем запуск тестового контейнера

  ```
    docker run hello-world
  ```
Должно вывести "Hello from Docker!".

# Установка и запуск Nginx

- [ ] Если Nginx был установлен ранее и уже работает, то переходим к следующему разделу

- [ ] На ПК в любом месте создаем папку, например nginx
- [ ] В ней создаем файл docker-compose.yml и вставляем содержимое
  ```
    version: '3'
  
    services:
      nginx:
        image: nginx:latest
        volumes:
          - ./:/var/www/
          - ./nginx/conf.d/:/etc/nginx/conf.d/
        ports:
          - "$nginx_port:80"
        container_name: $nginx_container_name
  ```


- [ ] Далее, в созданной папке, где лежит docker-compose.yml, создаем папку nginx\conf.d и в ней файл nginx.conf,
  и прописываем в нем конфигурацию nginx:
  ```
    server {
    
        root /var/www/public;
      
        location / {
            try_files $uri /index.html;
        }
    
    }
  ```
- [ ] В этой же папке создаем папку public и кладем туда файл index.html со следующим содержимым:
  ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    HELLO
    </body>
    </html>
  ```
- [ ] Запускаем команду для проверки, должна появится linux bash-строка
  ```
  docker exec -it $nginx_container_name bash
  ```
  
- [ ] В командной строке Windows, в папке с созданным файлом, пишем команду запуска nginx
  ```
    docker-compose up -d
  ```

- [ ] Проверяем, запустился ли Nginx по [ссылке](http://localhost:$nginx_port)

- [ ] Для перезагрузки процесса и применения изменений в конфгах можно ввести команду:
  ```
    docker exec app_nginx nginx -s reload
  ```

