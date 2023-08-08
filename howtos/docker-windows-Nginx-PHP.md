---
title: Поднятие Nginx и PHP-fpm на Docker под Windows
tags:
  - docker
  variables:
    disk:
      description: Диск, где создавать докерские файлы
      required: true
      default: D
    folder:
      description: Название папки с докерскими файлами
      required: true
      default: nginx
    nginx_port:
      description: Порт nginx
      required: true
      default: 8876
    php_version:
      description: Версия PHP в виртуальной машине
      required: true
      example: 8.0
    

---
- [ ] Заполняем букву диска, где будет докерская папка <var>disk</var>
- [ ] Заполняем размещение папки, в которой будут находиться докерские файлы <var>folder</var>
- [ ] Заполняем номер порта для nginx <var>nginx_port</var>

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

# Установка и запуск Nginx + PHP-fpm

- [ ] Если Nginx был установлен ранее и уже работает, то переходим к следующему разделу

- [ ] Создаем папку и всю структуру, где будут лежать докерские файлы и создаем пустой docker-compose.yml
  ```
    $disk:
    cd $disk:\
    mkdir $folder
    mkdir $folder\nginx
    mkdir $folder\nginx\conf.d
    mkdir $folder\public
    copy NUL $folder\docker-compose.yml
    copy NUL $folder\nginx\conf.d\nginx.conf
    copy NUL $folder\public\index.php
    cd $folder
  ```  

- [ ] В docker-compose.yml вставляем:
  ```
    version: '3'
    
    services:
      nginx:
        image: nginx:latest
        volumes:
          - ./:/var/www/
          - ./nginx/conf.d/:/etc/nginx/conf.d/
        ports:
          - "8876:80"
        container_name: app_nginx
        depends_on:
          - app
    
      app:
        image: php:$php_version-fpm
        volumes:
          - ./:/var/www/
        container_name: app_php
  ```
 
- [ ] Прописываем в файле nginx.conf конфигурацию nginx:
  ```
    server {
    
        root /var/www/public;
      
        location / {
            try_files $uri /index.php;
        }
        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass app:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
    
    }
  ```
- [ ] В файл index.php со следующим содержимым:
  ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
            HELLO!!!
    <?php echo 'THIS IS PHP' ?>
    
    </body>
    </html>
  ```
  
- [ ] В командной строке Windows, в папке с созданным файлом, пишем команду запуска Docker
  ```
    docker-compose up -d
  ```

- [ ] Проверяем, запустился ли Nginx по [ссылке](http://localhost:$nginx_port)
Должно вывестись на экран браузера HELLO!!! THIS IS PHP

- [ ] Для перезагрузки процесса и применения изменений в конфигах можно ввести команду:
  ```
    docker exec app_nginx nginx -s reload
  ```

- [ ] Для выгрузки процесса из докера можно ввести команду:
  ```
    docker compose down
  ```

