---
title: Поднятие Laravel-проекта на Docker под Windows
tags:
  - docker
variables:
  nginx_container_name:
    description: Имя контейнера с nginx
    required: true
    default: nginx-nginx-1

---

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
          - ./nginx/conf.d/:/etc/nginx/conf.d/
        ports:
          - "8876:80"  
  ```
- [ ] В командной строке Windows, в папке с созданным фалом, пишем команду запуска nginx 
  ```
    docker-compose up -d
  ```
- [ ] Заполняем имя контейнера, который выведется при выполнении команды <var>nginx_container_name</var>
- [ ] Проверяем, запустился ли Nginx по [ссылке](localhost:8876)
  ![Изображение](https://howto.parfentiy.site/nginx_started.png "Это успех")
  
- [ ] Далее, в созданной папке, где лежит docker-compose.yml, создаем папку nginx\conf.d и в ней файл nginx.conf,
и прописываем в нем конфигурацию nginx:
  ```
    server {
  
        location / {
            try_files $uri /index.html;
        }
    
    }
  ```
- [ ] Запускаем команду 
  ```
  docker exec -it $nginx_container_name bash
  ```

- [ ] Получаем реальный IP-адрес сервера

  ```
  curl -4 icanhazip.com
  ```

- [ ] Заполняем <var>server_ip</var>

- [ ] Вводим адрес сервера в браузере

  ```
  http://$server_ip
  ```

- [ ] Если все сделано правильно, то в браузере вы должны увидеть такое сообщение:

![Изображение](https://howto.parfentiy.site/nginx_started.png "Это успех")

# Подключаемся к серверу по SSH с другого компьютера через его командную строку

- [ ] Удаляем лишние ключи, если были

  ```
  ssh-keygen -R $server_local_ip
  ```

- [ ] Подключаемся по SSH к корневому серверу

  ```
  ssh $ubuntu_first_user@$server_local_ip
  ```

- [ ] Переключаемся на root'a

  ```
  sudo su
  ```

# Поднимаем виртуальную машину

- [ ] Первая инициализация LXD (если уже было проделано, переходим к следующему пункту)

  ```
  lxd init
  ```
    __ВАЖНО! При задании параметров LXD все параметры указывать по дефолту, кроме:__

    __- хранилище указываем: dir__

    __- IPV6 указываем: none__

- [ ] Инсталлируем виртуалку нашего проекта

  ```
  lxc launch ubuntu:20.04 $VM_name
  ```

- [ ] Запускаем виртуалку

  ```
  lxc exec $VM_name -- bash
  ```

- [ ] В новой виртуалке проверяем доступность интернета

  ```
  ping 8.8.8.8
  ```
  ```
  ping ya.ru
  ```

- [ ] Обновляем ОС в виртуалке

  ```
  apt update
  ```

- [ ] Создаем SSH-ключ для виртуалки

  ```
  ssh-keygen
  ```
- [ ] Выводим содержимое ключа

  ```
  cat /root/.ssh/id_rsa.pub
  ```
  Копируем выведенное содержимое до первого пробела в буфер и создаем новый SSH-ключ в Git.
  
- [ ] Выходим из виртуалки

  ```
  exit
  ```

- [ ] Получаем ip-адрес новой виртуалки

  ```
  lxc list
  ```

- [ ] Заполняем ip-адрес <var>VM_ip</var>

# Донастраиваем Nginx 

- [ ] В ЛК Хостинг-провайдера добавляем А-запись на субдомен, указывая его параметры:
  - имя: 
    ```
    $VM_name.$main_domain.
    ```
  - ip-адрес: 
    ```
    $server_ip
    ```

- [ ] Создаем новый конфиг для виртуалки

  ```
  echo '
  server {
    server_name $VM_name.$main_domain;
    location / {
      proxy_pass http://$VM_ip;
      include proxy_params;
    }
  }
  ' > /etc/nginx/sites-enabled/$VM_name.conf
  ```

- [ ] Перезапускаем Nginx

  ```
  service nginx reload
  ```

- Готовим сам [проект](https://howto.parfentiy.site/howto.html?pth=howtos/prd-server.md) на виртуалке