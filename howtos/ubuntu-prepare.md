---
title: Настройка нового сервера Ubuntu с добавлением нового виртуального контейнера для проекта
tags:
  - Linux
variables:
  main_domain:
    description: Ваш основной домен
    required: true
    default: parfentiy.site
  VM_name:
    description: Название проекта
    required: true
    example: project-prd
  ubuntu_first_user:
    description: Пользователь, заданный при установке ОС Ubuntu
    required: true
    default: peter
  server_local_ip:
    description: Внутренний IP-адрес нового сервера
    required: true
    default: 192.168.5.95
  server_ip:
    description: Внешний IP-адрес нового сервера
    required: true
    default: 31.10.65.40
  VM_ip:
    description: IP-адрес новой виртуалки
    required: true
    example: 10.10.3.33

---

# Предварительно

- [ ] Заполняем имя вашего основного домена в <var>main_domain</var>
- [ ] Заполняем имя будущей виртуальной машины в <var>VM_name</var>
- [ ] Заполняем название первого пользователя ОС в <var>ubuntu_first_user</var>
- [ ] Если ОС уже установлена, то следующий пункт пропускаем
- [x] Устанавливаем чистую ОС на чистый диск отдельного компьютера
- [ ] Логинимся в систему под юзером, введенным при установке ОС
- [ ] На новом сервере получаем локальный его ip-адрес

  ```
  ip a
  ```
- [ ] Заполняем полученный локальный ip-адрес в <var>server_local_ip</var>

- [ ] Переходим под root

  ```
  sudo su
  ```

- [ ] Апдейтим ОС

  ```
  apt update
  apt upgrade
  ```

# Установка и запуск Nginx

- [ ] Если Nginx был установлен ранее и уже работает, то переходим к разделу "Создание новой виртуальной машины"
- [ ] Инсталлируем пакет

  ```
  apt install nginx
  ```

- [ ] Проверяем, запустился ли Nginx

  ```
  systemctl status nginx
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