---
title: Создание API-контроллера, ресурса и запроса для модели в Laravel
tags:
  - Laravel
variables:
  model:
    description: Название модели
    required: true
    example: User
  httpquery:
    description: api-запрос
    required: true
    example: users
  host:
    description: Адрес сервера, где будет запущена проверка CRUD
    required: true
    example: localhost:8000
---

# Предварительно
- [ ] Вводим название модели <var>model</var>
- [ ] Вводим конечную строку api-запроса <var>httpquery</var>
- [ ] Вводим адрес сервера, где будет запущена проверка CRUD <var>host</var>

# Создание контроллера, ресурсов и request'ов

- [ ] Создаем Api-контроллер
  ```
    php artisan make:controller Api/$modelController --api
  ```

- [ ] Создаем Ресурсы
  ```
    php artisan make:resource $model/IndexResource
  ```
  ```
    php artisan make:resource $model/$modelResource
  ```

- [ ] Создаем Request для валидации при сохранении
  ```
    php artisan make:request API/$model/StoreRequest
  ```

# Дополнения в Модель

- [ ] В Модели в разделе use, на всякий случай, добавляем:
  ```
    use Illuminate\Database\Eloquent\SoftDeletes;
    use App\Models\Traits\Filterable;
  ```
  
- [ ] А также добавляем трейты:
  ```
    use Filterable, SoftDeletes;
  ```
  
# Наполнение контроллера

- [ ] В созданном контроллере вносим в раздел use
  ```
    use App\Http\Resources\$model\$modelResource;
    use App\Http\Resources\$model\IndexResource;
    use App\Models\$model;
    use Illuminate\Support\Facades\Validator;
  ```
  
- [ ] там же в метод index следующую конструкцию
  ```
    $data = $model::orderBy('id', 'DESC')->paginate(15);

    return IndexResource::collection($data);  
  ```

- [ ] там же в метод store следующую конструкцию
  ```
    $validator = Validator::make(request()->all(), [
        'title' => 'required',
        'description' => 'required',
        // .... остальные поля
    ]);

    // Проверяем успешность валидации
    if ($validator->passes()) {
        $input = $request->all();
        $obj = $model::create($input);

        return new IndexResource($obj);
    } else {
      // Обработка ошибок валидации
      $errors = $validator->errors();
      // TODO: дальнейшая логика обработки ошибок валидации

      return abort('403');
    } 
  ```

- [ ] там же в метод show следующую конструкцию
  ```
    $obj = $model::find($id);

    return new $modelResource($obj);
  ```

- [ ] там же в метод update следующую конструкцию
  ```
    $obj = $model::find($id);

    // Валидация
    $validator = Validator::make(request()->all(), [
        'title' => 'required',
        'description' => 'required',
        // .... остальные поля
    ]);

    // Проверяем успешность валидации
    if ($validator->passes()) {
        $input = $request->all();
        $obj->update($input);

        return new IndexResource($obj);

    } else {
        // Обработка ошибок валидации
        $errors = $validator->errors();
        // TODO: дальнейшая логика обработки ошибок валидации

        return abort('403');
    }
  ```

- [ ] там же в метод destroy следующую конструкцию
  ```
    $obj = $model::withTrashed()->find($id);

    $obj->forceDelete();

    return response()->json(['message' => 'delete']);
  ```

# Наполнение ресурсов

- [ ] В IndexResource ничего не меняем

- [ ] В $modelResource в методе toArray вместо return parent::toArray($request);
  ```
    return [
        'id' => $this->id,
        'title' => $this->title,
        // ... прочие поля по необходимости
    ];
  ```

# Наполнение Request'ов для настройки валидации запросов

- [ ] В StoreRequest.php в методе rules вместо return []; вставляем
  ```
    return [
        'title' => 'required',
        'description' => 'required',
        // ... прочие поля по необходимости
    ];
  ```

# Наполнение файла routes/api.php

- [ ] В разделе use вставляем
  ```
    use App\Http\Controllers\Api\$modelController;
  ```

- [ ] В разделе Route::apiResources([ вставляем
  ```
      '$httpquery' => $modelController::class,
  ```

- [ ] Очищаем все, что можно в проекте
  ```
    php artisan optimize
  ```

# Проверка работы CRUD (например, Postman)

- [ ] В Postman в разделе params создаем имена полей и их значения для новой записи

- [ ] метод index (получить все записи). Запрос - GET
  ```
    $host/api/$httpquery
  ```

- [ ] метод store (создать новую запись). Запрос - POST
  ```
    $host/api/$httpquery
  ```

- [ ] метод show (показать одну запись). Запрос - GET
  ```
    $host/api/$httpquery/1
  ```

- [ ] метод update (изменить запись). Запрос - PUT
  ```
    $host/api/$httpquery/1
  ```

- [ ] метод destroy (удалить запись). Запрос - DELETE
  ```
    $host/api/$httpquery/1
  ```