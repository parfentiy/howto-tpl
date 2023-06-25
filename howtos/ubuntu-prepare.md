---
title: Настройка нового сервера Ubuntu 
tags:
  - Linux
variables:
  ubuntu_first_user:
    description: Пользователь, заданный при установке ОС Ubuntu
    required: true
    default: peter
  server_ip:
    description: Внешний IP-адрес нового сервера
    required: true
    example: 31.10.55.66
  VM_name:
    description: Название проекта
    example: project-prd
  server_local_ip:
    description: Внутренний IP-адрес нового сервера
    required: true
    example: 192.168.5.95

---

# Предварительно

- [ ] Заполняем <var>VM_name</var>
- [ ] Если ОС уже установлена, то переходим к разделу "Установка Nginx"

- [ ] Устанавливаем чистую ОС на чистый диск отдельного компьютера
- [ ] Логинимся в систему под юзером, введенным при установке ОС
- [ ] Заполняем <var>ubuntu_first_user</var>
- [ ] На новом сервере получаем локальный его ip-адрес

  ```
  ip a
  ```
- [ ] Заполняем <var>server_local_ip</var>

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

# Подключаемся к серверу по SSH с другого компьютера

- [ ] Удаляем лишние ключи, если были

  ```
  ssh-keygen -R $server_ip
  ```

- [ ] Подключаемся по SSH к корневому серверу

  ```
  ssh $ubuntu_first_user@$server_local_ip
  ```



- [ ] Проверяем как оно [работает](http://)