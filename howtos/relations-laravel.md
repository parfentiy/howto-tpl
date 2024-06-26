---
title: Отношения в Laravel (один к многим)
tags:
  - Laravel
variables:
  main_model:
    description: Ведущая модель
    required: true
    example: Category
  second_model:
    description: Ведомая модель
    required: true
    example: Post
  main_field:
    description: Поле по имени главной модели с МАЛЕНЬКОЙ БУКВЫ
    required: true
    example: category
  second_field:
    description: Поле по имени ведомой модели с МАЛЕНЬКОЙ БУКВЫ
    required: true
    example: post
  main_table:
    description: Ведущая таблица 
    required: true
    example: categories 
  second_table:
    description: Ведомая таблица
    required: true
    example: posts

    

---

# Предварительно
- [ ] Задаем название главной модели <var>main_model</var>
- [ ] Задаем название ведомой модели <var>second_model</var>
- [ ] Задаем название поля по имени главной модели <var>main_field</var>
- [ ] Задаем название поля по имени ведомой модели <var>second_field</var>

## Создание моделей и миграций 

- [ ] Создаем главную модель и миграцию
  ```
    php artisan make:model $main_model -m
  ```

- [ ] Создаем ведомую модель и миграцию
  ```
    php artisan make:model $second_model -m
  ```


## Редактируем миграции

- [ ] В главной миграции делаем те поля, что должны быть в таблице БД
- [ ] Если главная таблица еще не была создана, выполняем миграции
  ```
    php artisan migrate
  ```
- [ ] Заполняем название созданной главной таблицы <var>main_table</var>
  
- [ ] В !!ведомой!! миграции в методе up вставляем вдобавок: 
  ```
    Schema::table('$second_table', function (Blueprint $table) {
        $table->unsignedBigInteger('$main_field_id')->nullable();
        $table->index('$main_field_id', '$second_field_$main_field_idx');
        $table->foreign('$main_field_id', '$second_field_$main_field_fk')
          ->on('$main_table')->references('id');
    });
  ```

- [ ] В !!ведомой!! миграции в методе down вставляем вдобавок: 
  ```
    Schema::table('$second_table', function (Blueprint $table) {
        //
        $table->dropForeign('$second_field_$main_field_fk');
        $table->dropIndex('$second_field_$main_field_idx');
        $table->dropColumn('$main_field_id');
    });
  ```
  
- [ ] Выполняем миграции
  ```
    php artisan migrate
  ```

- [ ] Заполняем название созданной ведомой таблицы <var>second_table</var>

## Создание методов в моделях

- [ ] В главную модель $main_model добавляем метод.
 
  ```
    public function $second_table()
    {
        return $this->hasMany($second_model::class);
    }
  ```
  
- [ ] В ведомую модель $second_model добавляем метод.
  
  ```
    public function $main_field()
    {
        return $this->belongsTo($main_model::class);
    }
  ```

## Применение

- [ ] Получаем все записи из таблицы $second_table, 
  принадлежащие указанной записи в таблице $main_table

  ```
    $$main_field = $main_model::find(1);
  
    $$second_table = $$main_field->$second_table;
  ```

- [ ] Получаем запись из таблицы $main_table,
  содержащую указанную запись в таблице $second_table

  ```
    $$second_field = $second_model::find(1);
  
    $$main_field = $$second_field->$main_field;
  ```