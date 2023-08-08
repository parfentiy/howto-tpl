---
title: Поднятие Laravel-проекта на Docker под Windows
tags:
  - docker 
  variables:
    disk:
      description: Диск, где будет проект Laravel
      required: true
      default: D
    folder:
      description: Название папки с проектом Laravel
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
- [ ] Заполняем номер версии PHP в виртуальном контейнере 
  (см. [тут](https://howto.parfentiy.site/howto.html?pth=howtos/docker-windows-Nginx-PHP.md)) <var>php_version</var>

# Установка чистого проекта Laravel в Docker 

- [ ] Создаем папку и всю структуру, где будут лежать докерские файлы
  ```
    $disk:
    cd $disk:\ 
    mkdir $folder
    mkdir $folder\_docker
    mkdir $folder\_docker\nginx
    mkdir $folder\_docker\nginx\conf.d
    mkdir $folder\_docker\app
    copy NUL $folder\docker-compose.yml
    copy NUL $folder\_docker\nginx\conf.d\nginx.conf
    copy NUL $$folder\_docker\app\Dockerfile
    copy NUL $$folder\_docker\app\php.ini
    cd $folder
  ```  
  
- [ ] В этом Dockerfile вставляем:
  ```
    FROM php:$php_version-fpm

    RUN apt-get update && apt-get install -y \
        apt-utils \
        libpq-dev \
        libpng-dev \
        libzip-dev \
        zip unzip \
        git && \
        docker-php-ext-install pdo_mysql && \
        docker-php-ext-install bcmath && \
        docker-php-ext-install gd && \
        docker-php-ext-install zip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
    COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini
    
    # Install composer
    ENV COMPOSER_ALLOW_SUPERUSER=1
    RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin
    
    WORKDIR /var/www
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
  
- [ ] В php.ini вставляем:
  ```
    cgi.fix_pathinfo=0
    max_execution_time = 1000
    max_input_time = 1000
    memory_limit=4G
  ```
  
- [ ] В docker-compose.yml вставляем:
  ```
    version: '3'

    services:
      nginx:
        image: nginx:latest
        volumes:
          - ./:/var/www/
          - ./_docker/nginx/conf.d/:/etc/nginx/conf.d/
        ports:
          - "8876:80"
        container_name: laravel_nginx
        depends_on:
          - app
  
      app:
        build:
            context: .
            dockerfile: _docker/app/Dockerfile
        volumes:
          - ./:/var/www/
        container_name: laravel_app
  ```

- [ ] В командной строке Windows, в папке с созданным файлом, пишем команду запуска docker
  ```
    docker-compose up -d
  ```

- [ ] Заходим в bash-строку
  ```
    docker exec -it app_php bash
  
  ```
- [ ] Временно все убираем из папки проекта Laravel
  ```
    cd ..
    mkdir temp
    cd www
    mv * /var/temp
  ```
  
- [ ] Создаем чистый проект на Laravel в любой папке
  ```
    composer create-project laravel/laravel .
  ```

- [ ] Возвращаем из временной папки все для Docker
  ```
    &&&&&&&&&&&&&&&&&
  ```

- [ ] Делаем права на запись на папку Storage
  ```
    chmod -R 777 storage
  ```
  
Проверяем запуск проекта в браузере
