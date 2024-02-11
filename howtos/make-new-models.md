---
title: Создание новой модели, миграции, сидера в Laravel
tags:
  - Laravel
variables:
  model:
    description: Название модели
    required: true
    example: User
---

# Предварительно
- [ ] Вводим название модели <var>model</var>


- [ ] Создаем модель
  ```
    php artisan make:model $model -mfcs
  ```

- [ ] В созданной миграции создаем нужные поля

- [ ] Выполняем миграцию
  ```
    php artisan migrate
  ```
  
- [ ] При необходимости создаем relaitions. См. [инструкцию](https://howto.parfentiy.site/howto.html?pth=howtos/relations-laravel.md)

- [ ] В модели прописываем:
  ```
    protected $table = 'название_таблицы';
  
    protected $fillable = [
        'title', // нужные поля из миграции
    ];
  ```
- [ ] В DatabaseSeeder в методе run прописываем:
  ```
    $this->call($modelSeeder::class);
  ```

- [ ] В созданном $modelSeeder в use прописываем:
  ```
    use App\Models\$model;
    use Illuminate\Support\Facades\Schema;
  ```
  
- [ ] В созданном $modelSeeder в методе run прописываем:
  ```
    Schema::disableForeignKeyConstraints();
    $model::truncate();

    $model::create([
        'name' => 'Жилой проект', // Задаем значения нужным полям
    ]);
  
    // Повторяем, если надо

    Schema::enableForeignKeyConstraints();
  ```

- [ ] Выполняем сидинг:
  ```
    php artisan db:seed --class=DatabaseSeeder
  ```
  Или отдельно сеем данные только этой модели:
  ```
    php artisan db:seed --class=$modelSeeder
  ```