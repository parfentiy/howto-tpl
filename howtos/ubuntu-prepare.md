---
title: Настройка нового сервера Ubuntu 
tags:
  - Linux
variables:
  server_ip:
    description: Внешний IP-адрес нового сервера
    required: true
    example: 31.10.55.66
  VM_name:
    description: Название проекта
    example: project-prd

---

# Предварительно
- [ ] Заполняем <var>server_ip</var>
- [ ] Заполняем <var>VM_name</var>
- [ ] Устанавливаем чистую ОС на чистый диск отдельного компьютера


# Основная настройка

- [ ] Заходим на сервер

  ```
  ssh root@
  ```

- [ ] Создаём пользователя

  ```
  adduser --disabled-password --gecos "" $guest_main_user
  rm /home/$guest_main_user/.bash_logout
  ```


- [ ] Проверяем как оно [работает](http://)