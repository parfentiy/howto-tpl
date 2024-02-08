---
title: Настройка новой Ubuntu Desktop со всеми установками нужного софта 
tags:
  - Linux
variables:
  prj_name:
    description: Название проекта
    required: true
    example: myproject 
  git_repo_link:
    description: HTTP-ссылка на репозиторий
    required: true
    example: https://github.com/user/my_project.git
    
---

# Предварительно
- [ ] Идем в настройки Ubuntu и настраиваем там под себя все, что нужно

## Обновление системы

- [ ] Обновляем систему до самой последней версии.
  ```
    sudo apt update
  ```
  
- [ ] Затем для обновления системы выполните:
  ```
    sudo apt full-upgrade
  ```
## Специальные предварительные настройки

- [ ] Задаем пароль пользователю root
  ```
    sudo passwd root
  ```
  и два раза вводим нужный пароль
- 
- [ ] Ubuntu всё ещё поставляется с устаревшей версией редактора Vi. 
- Вы можете установить новую версию Vim с помощью команды:
  ```
    sudo apt install vim
  ```
  
- [ ] Чтобы при следующем клике в доке на приложение оно сворачивалось:
  ```
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
  ```
  
- [ ] Если вы не используете драйвер видеокарты Nvidia, то по умолчанию в Ubuntu будет использоваться Wayland. Он работает неплохо, но с некоторыми приложениями могут возникнуть проблемы. Например, с приложениями записи видео с экрана или удалённого доступа. Вы можете отключить Wayland если хотите. Для этого откройте файл /etc/gdm3/custom.conf, найдите там параметр WaylandEnable и установите его значение в false:
  ```
    sudo vi /etc/gdm3/custom.conf
  ```
  ```
    WaylandEnable=false
  ```
  
- [ ] После этого надо перезапустить компьютер или перелогинится в системе. Проверить какой графический сервер сейчас используется можно с помощью команды:
  ```
    echo $XDG_SESSION_TYPE
  ```

- [ ] Для того чтобы воспроизводить различные медиа файлы вам понадобится установить медиа кодеки. Для установки кодеков необходимо установить пакет ubuntu-restricted-extras:
  ```
    sudo apt install ubuntu-restricted-extras
  ```

- [ ] Теперь система управления расширениями была переработана и создана специальная утилита gnome-shell-extension-manager. Для её установки выполните команду:
  ```
    sudo apt install gnome-shell-extension-manager
  ```
    
## Установка приложений (по списку)

### Сначала ставим все приложения из магазина

- [ ] Krusader
- [ ] Mozilla FireFox (уже установлен в пакете Ubuntu)
- [ ] Google Chrome (с сайта google)
- [ ] q4wine
- [ ] Microsoft VS Code
- [ ] Whatsapp (магазин) ищем whatsapp for linux unofficial version
- [ ] Telegram
- [ ] WireGuard
- [ ] OBS Studio
- [ ] FileZilla FTP Client
- [ ] DBeaver
- [ ] Figma
- [ ] MySQL Workbench 8.0
- [ ] Postman
- [ ] Xsane
- [ ] VLC player
- [ ] Xarchiver
- [ ] Tick Tick
- [ ] BitWarden
- [ ] Gnome tweak

### Далее ставим из магазина, но при этом отдельно взламываем или активируем

- [ ] PHP Storm 

Активируем:
коды активации можно найти [тут](https://key.words.run/en?aid=65029352ef46bdfc83201103). 
Если не работает сайт , то гуглить коды активации для php storm

### Затем остальное с помощью командной строки
Установочные файлы с расширением .deb устанавливаются командой
sudo dpkg -i имя_файла.deb

- [ ] Zoho Notebook (с офф. сайта скачать [.deb](https://notebook.zoho.com/linuxApp.do))



Переходим в свой ЛК в GitHub по [ссылке](https://github.com/new)

В Repository name вводим название проекта $prj_name

Выбираем тип доступа - Public или Private

- [ ] и нажимаем Создать 

На следующей странице копируем http-ссылку на репозиторий и заполняем в <var>git_repo_link</var>

- [ ] В терминале IDE вводим комманды
  ```
    git init
    git add .
    git commit -m "first commit"
    git branch -M main
    git remote add origin $git_repo_link
    git push -u origin main
  ```
  
Все, проект в GitHub, проверяем в ЛК

