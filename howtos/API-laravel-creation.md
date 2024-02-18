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
    use App\Http\Requests\API\$model\StoreRequest;
    use Illuminate\Http\Response;
  ```
  
- [ ] там же в метод index следующую конструкцию
  ```
   public function index()
    {
        $data = $model::orderBy('id', 'DESC')->paginate(15);

        return IndexResource::collection($data);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param StoreRequest $request
     * @return Response
     */
    public function store(StoreRequest $request)
    {
        $input = $request->all();
        $data = $model::create($input);
        return new IndexResource($data);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $data = $this->findModel($id);

        return new $modelResource($data);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param Request $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(StoreRequest $request, $id)
    {
        $data = $this->findModel($id);

        $input = $request->all();
        $data->update($input);

        return new IndexResource($data);
   }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id): \Illuminate\Http\JsonResponse
    {
        $data = $this->findModelWithTrashed($id);

        $data->forceDelete();

        return response()->json(['message' => 'delete']);
    }

    private function findModel($id)
    {
        $data = $model::find($id);
        if (!$data) {
            return abort(404, 'Model not found.');
        }
        return $data;
    }

    private function findModelWithTrashed($id)
    {
        $data = $model::withTrashed()->find($id);
        if (!$data) {
            return abort(404, 'Model not found.');
        }
        return $data;
    }
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

 - [ ] В StoreRequest.php метод authorize закомментировать

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