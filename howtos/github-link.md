---
title: Локальное разворачивание проекта Laravel с привязкой к GitHub 
tags:
  - Laravel
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
- [ ] Задаем название проекта <var>prj_name</var>

## Создание проекта

- [ ] Создаем новую пустую папку с именем $prj_name, где будет размещаться проект

- [ ] Открываем папку в IDE 
  
- [ ] В Терминале создаем проект
  ```
    composer create-project laravel/laravel .
  ```

## Создаем новый репозиторий в GitHub 

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

