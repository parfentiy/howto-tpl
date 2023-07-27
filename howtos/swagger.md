---
title: Поднятие Swagger L5 в проекте Laravel
tags:
  - laravel
variables:
  site:
    description: Адрес сайта
    required: true
    example: localhost 
  api_name:
    description: Название API
    required: true
    example: MyApi
  model_name:
    description: Имя модели
    required: true
    example: Post 
  routes_path:
    description: Путь для группы роутов в api.php (в множественном числе с маленькой буквы)
    required: true
    example: posts

---
# Предварительно
- [ ] Заполняем адрес сайта <var>site</var>
- [ ] Заполняем название API <var>api_name</var>

# Установка и настройка Swagger L5
#### Если Swagger уже был установлен, пропускаем этот раздел
- [ ] Устанавливаем его с помощью Composer
  ```
    composer require "darkaonline/l5-swagger"
  ```
- [ ] Публикуем конфигурацию
  ```
    php artisan vendor:publish --provider "L5Swagger\L5SwaggerServiceProvider"
  ```
- [ ] В основной контроллер Controller, перед class, вставляем
  ```
    /**
    * @OA\Info(
    *      title="$api_name",
    *      version="1.0.0"
    * ),
    * @OA\PathItem(
    *     path="/api/"
    * )
    */
  ```

- [ ] Проверяем запуск документации Swagger в браузере по [ссылке]($site/api/documentation)
- [ ] В папке storage\api-docs появляется файл api-docs.json.
  
  Сюда будет генерироваться все из всех аннотаций, описанных в соответствующих контроллерах. См. далее...


# Делаем заготовку модели 
### Если модель и миграция были созданы ранее, то пропускаем этот раздел

- [ ] Заполняем имя модели <var>model_name</var>

- [ ] Создаем модель и миграцию. 
  Если модель и миграция были созданы ранее, то пропускаем этот и следующие 2 шага

  ```
  php artisan make:model $model_name -m
  ```
  
- [ ] В созданной миграции создаем необходимые поля для таблицы
- [ ] И выполняем миграции
  ```
  php artisan migrate
  ```
  
- [ ] В созданной модели снимаем защиту, вставляем:
  ```
  protected $guarded = false;
  ```

## Создаем контроллер и ресурс

- [ ] Создаем контроллер, ресурс и привязываем это все к модели $model_name
  ```
  php artisan make:controller $model_nameController -r -m $model_name
  ```
  ```
  php artisan make:resource $model_name/$model_nameResource
  ```

## Настраиваем роуты для API
- [ ] Заполняем название группы роутов <var>routes_path</var>
- [ ] в routes\api.php пишем:
  ```
  Route::resource('$routes_path', \App\Http\Controllers\$model_nameController::class);
  ```
- [ ] Проверяем все ли роуты у нас появились:   
  ```
    php artisan route:list
  ```

## Создаем request'ы для тех CRUD, что будем использовать
- [ ] UpdateRequest
  ```
    php artisan make:request $model_name/UpdateRequest
  ```
- [ ] StoreRequest
  ```
    php artisan make:request $model_name/StoreRequest
  ```
- [ ] В созданных request (app/Http/Requests/$model_name) 
  в методе authorize() в return ставим false

- [ ] В методе rules() в return пишем все поля модели, которые будут учавствовать, например:
  ```
    return [
        'title' => 'required|string',
    ];
  ```
  
## Заполняем контроллер CRUD'ами
  
- [ ] Возвращаемся в контроллер и вставляем все методы CRUD следующим образом:
  ```
    /**
    * Display a listing of the resource.
    */
    public function index()
    {
        $$routes_path = $model_name::all();
        return $model_nameResource::collection($$routes_path);
    }

    /**
    * Show the form for creating a new resource.
    */
    public function create()
    {
      //
    }

    /**
    * Store a newly created resource in storage.
    */
    public function store(StoreRequest $request)
    {
        $data = $request->validated();
        $one$model_name = Brand::create($data);

        return $model_nameResource::make($one$model_name);
    }

    /**
    * Display the specified resource.
    */
    public function show($model_name $one$model_name)
    {
        return $model_nameResource::make($one$model_name);
    }

    /**
    * Show the form for editing the specified resource.
    */
    public function edit(Brand $brand)
    {
      //
    }

    /**
    * Update the specified resource in storage.
    */
    public function update(UpdateRequest $request, $model_name $one$model_name)
    {
        $data = $request->validated();
        $one$model_name->update($data);

        $one$model_name = $one$model_name->fresh();

        return $model_nameResource::make($one$model_name);
    }

    /**
    * Remove the specified resource from storage.
    */
    public function destroy($model_name $one$model_name)
    {
        $one$model_name->delete();

        return response()->json([
            'message' => 'done',
        ]);
    }
  ```
  
- [ ] Затем идем в файл app\Http\Middleware\VerifyCsrfToken.php и в $except добавляем
  ```
    '/api/*',  
  ```
  
## Теперь проверяем с помощью Postman все эти методы CRUD

### Метод index (вывод всех записей)
- [ ] Метод GET
- [ ] В адресную строку прописываем
  ```
    $site/api/$routes_path  
  ```
- [ ] Жмем Send
- [ ] Ответ должен быть такой:
  ```
  {
      "data": []
  }
  ```

### Метод store (создать новую запись)
- [ ] Метод POST
- [ ] В адресную строку прописываем
  ```
    $site/api/$routes_path  
  ```
- [ ] Во вкладке "Body" выбираем точку "raw" и в "Text" выбираем jSON
- [ ] В поле ввода даем тестовый массив:
    ```
  {
      "title": "some title",
  }
  ```
- [ ] Жмем Send
- [ ] Ответ должен быть такой:
  ```
  {
      "data": {
          "id": 1,
          "title": "Some title"
      }
  }
  ```
- [ ] Проверяем, создалась ли запись в таблице БД

### Метод update (обновить конкретную запись)
- [ ] Метод PATCH
- [ ] В адресную строку прописываем
  ```
    $site/api/$routes_path/1  
  ```
- [ ] Во вкладке "Body" выбираем точку "raw" и в "Text" выбираем jSON
- [ ] В поле ввода даем тестовый массив:
    ```
  {
      "title": "some title edited",
  }
  ```
- [ ] Жмем Send
- [ ] Ответ должен быть такой:
  ```
  {
      "data": {
          "id": 1,
          "title": "Some title edited"
      }
  }
  ```
- [ ] Проверяем, обновилась ли запись в таблице БД

### Метод show (вывести конкретную запись)
- [ ] Метод GET
- [ ] В адресную строку прописываем
  ```
    $site/api/$routes_path/1  
  ```
- [ ] Жмем Send
- [ ] Ответ должен быть такой:
  ```
  {
      "data": {
          "id": 1,
          "title": "Some title edited"
      }
  }
  ```

### Метод delete (удалить конкретную запись)
- [ ] Метод DELETE
- [ ] В адресную строку прописываем
  ```
    $site/api/$routes_path/1  
  ```
- [ ] Жмем Send
- [ ] Ответ должен быть такой:
  ```
  {
      "message": "done"
  }
  ```
- [ ] Проверяем, удалилась ли запись в таблице БД


# Пишем документацию на API для контроллера $model_nameController

- [ ] Создаем файл в app\Http\Controllers\Swagger\$model_nameController.php

- [ ] В новом контроллере вставляем 
  ```
    <?php
    
    namespace App\Http\Controllers\Swagger;
    
    use App\Http\Controllers\Controller;
    
    /**
     *
     * @OA\Post(
     *     path="/api/$routes_name",
     *     summary="Создание единичной записи",
     *     tags={"Раздел $model_name"},
     *
     *     @OA\RequestBody(
     *         @OA\JsonContent(
     *             allOf={
     *                 @OA\Schema(
     *                     @OA\Property(property="title", type="string", example="Some title"),
     *                 )
     *             }
     *         )
     *     ),
     *
     *     @OA\Response(
     *         response=200,
     *         description="Ok",
     *         @OA\JsonContent(
     *             @OA\Property(property="data", type="object",
     *                 @OA\Property(property="id", type="integer", example=1),
     *                 @OA\Property(property="title", type="string", example="Some title"),
     *             ),
     *         ),
     *     ),
     * ),
     *
     * @OA\Get(
     *     path="/api/$routes_name",
     *     summary="Список записей",
     *     tags={"Раздел $model_name"},
     *
     *     @OA\Response(
     *         response=200,
     *         description="Ok",
     *         @OA\JsonContent(
     *             @OA\Property(property="data", type="array", @OA\Items(
     *                 @OA\Property(property="id", type="integer", example=1),
     *                 @OA\Property(property="title", type="string", example="Some title"),
     *             )),
     *         ),
     *     ),
     * ),
     *
     * @OA\Get(
     *     path="/api/$routes_name/{one$model_name}",
     *     summary="Получить одну запись",
     *     tags={"Раздел $model_name"},
     *
     *     @OA\Parameter(
     *         description="ID",
     *         in="path",
     *         name="one$model_name",
     *         required=true,
     *         example=1,
     *     ),
     *
     *     @OA\Response(
     *         response=200,
     *         description="Ok",
     *         @OA\JsonContent(
     *             @OA\Property(property="data", type="object",
     *                 @OA\Property(property="id", type="integer", example=1),
     *                 @OA\Property(property="title", type="string", example="Some title"),
     *             ),
     *         ),
     *     ),
     * ),
     *
     * @OA\Patch(
     *     path="/api/$routes_name/{one$model_name}",
     *     summary="Обновление записи",
     *     tags={"Раздел $model_name"},
     *
     *     @OA\Parameter(
     *         description="ID",
     *         in="path",
     *         name="one$model_name",
     *         required=true,
     *         example=2,
     *     ),
     *
     *     @OA\RequestBody(
     *         @OA\JsonContent(
     *             allOf={
     *                 @OA\Schema(
     *                     @OA\Property(property="title", type="string", example="Some title for edit"),
     *                 )
     *             }
     *         )
     *     ),
     *
     *     @OA\Response(
     *         response=200,
     *         description="Ok",
     *         @OA\JsonContent(
     *             @OA\Property(property="data", type="object",
     *                 @OA\Property(property="id", type="integer", example=1),
     *                 @OA\Property(property="title", type="string", example="Some title"),
     *             ),
     *         ),
     *     ),
     * ),
     *
     * @OA\Delete(
     *     path="/api/$routes_name/{one$model_name}",
     *     summary="Удалить запись",
     *     tags={"Раздел $model_name"},
     *
     *     @OA\Parameter(
     *         description="ID",
     *         in="path",
     *         name="one$model_name",
     *         required=true,
     *         example=1,
     *     ),
     *
     *     @OA\Response(
     *         response=200,
     *         description="Ok",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="done"),
     *         ),
     *     ),
     * ),
     */
    class $model_nameController extends Controller
    {
    
    }
  ```
  
- [ ] Генерируем все аннотации
  ```
    php artisan l5-swagger:generate

  ```
- [ ] Проверяем запуск документации Swagger в браузере по [ссылке]($site/api/documentation)
