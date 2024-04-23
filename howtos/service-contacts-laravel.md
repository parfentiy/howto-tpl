---
title: Создание сервисов с контрактами в Laravel
tags:
  - Laravel
variables:
  provider_name:
    description: Название провайдера
    required: true
    example: Seeder
  service_name:
    description: Название сервиса
    required: true
    example: MkdSeeder
  service_folder:
    description: Название папки сервиса
    required: true
    example: Seeders
  service_method:
    description: Название первого метода сервиса
    required: true
    example: index
  controller_variable:
    description: Имя переменной, используемой в контроллере, по имени сервиса, но с маленькой буквы
    required: true
    example: mkdSeederService
    
---

# Предварительно
- [ ] Заполняем название провайдера <var>provider_name</var>
- [ ] Заполняем название сервиса <var>service_name</var>
- [ ] Заполняем название папки сервиса <var>service_folder</var>
- [ ] Заполняем название первого метода в сервисе <var>service_method</var>
- [ ] Заполняем имя переменной, используемой в контроллере <var>controller_variable</var>

# Создание и регистрация сервис-провайдера

- [ ] Если еще нет еще своего сервис-провайдера, создаем его
  ```
    php artisan make:provider $provider_nameServiceProvider
  ```
Файл сервис-провайдера создается в папке app/Providers/$provider_nameServiceProvider.php

- [ ] В этом файле в разделе use прописываем:
  ```
    use App\Services\{

    };
    use App\Contacts\Services as ServiceContracts;
  ```
- [ ] В этом же файле после register() use прописываем:
  ```
    public function provides()
    {
        return [

        ];
    }
  ```

- [ ] Регистрируем сервис провайдер в файле config\app.php. Добавляем в раздел 'providers' строчку:
  ```
    App\Providers\$provider_nameServiceProvider::class,
  ```

  # Создание и регистрация сервиса

- [ ] Создаем сервис
  ```
    mkdir app/Services/$service_folder
    touch app/Services/$service_folder/$service_nameService.php
  ```

- [ ] В созданном файле прописываем
  ```
    <?php

    namespace App\Services\$service_folder;

    use App\Contracts\Services\$service_folder\$service_nameService as $service_nameContract;

    class $service_nameService implements $service_nameContract
    {

        public function $service_method(array $fields): bool
        {

        }
    }
  ```

Регистрируем его в сервис-провайдере app/Providers/$provider_nameServiceProvider 
- [ ] В use, в разделе use App\Services\ { добавляем:
  ```
    $service_folder\$service_nameService,
  ```

- [ ] В register() добавляем:
  ```
    $this->app->singleton(ServiceContracts\$service_nameService::class, $service_nameService::class);
  ```

- [ ] В provides() добавляем:
  ```
    ServiceContracts\$service_nameService::class,
  ```

  # Создание и заполнение контракта
- [ ] Создаем контракт
  ```
    mkdir app/Contracts/Services/$service_folder
    touch app/Contracts/Services/$service_folder/$service_nameService.php
  ```

- [ ] Вписываем в него
  ```
    <?php

    namespace App\Contracts\Services\$service_folder;

    interface $service_nameService
    {
        public function $service_method(array $fields): bool;
    }
  ```
  # Создание и заполнение request
- [ ] Создаем request
  ```
    mkdir app/Http/Requests/API/$service_name
    touch app/Http/Requests/API/$service_name/$service_nameRequest.php
  ```

- [ ] Вписываем в него
  ```
    <?php

    namespace App\Http\Requests\API\$service_name;

    use Illuminate\Foundation\Http\FormRequest;

    class $service_nameRequest extends FormRequest
    {
        /**
        * Get the validation rules that apply to the request.
        *
        * @return array
        */
        public function rules(): array
        {
            return [
              // пример валидирования входных данных
                'data' => 'nullable|json',
                'template_settings' => 'nullable|json',
                'model_name' => 'required|string|max:255',
            ];
        }

        public function messages()
        {
            return [
              // это пример описания сообщений в случае непрохождения валидации
                'data.nullable' => 'Поле "data" должно быть в формате JSON или может быть пустым',
                'data.json' => 'Поле "data" должно быть в формате JSON или может быть пустым',
                'template_settings.nullable' => 'Поле "template_settings" должно быть в формате JSON или может быть пустым',
                'template_settings.json' => 'Поле "template_settings" должно быть в формате JSON или может быть пустым',
                'model_name.required' => 'Поле "model" обязательно для заполнения',
                'model_name.string' => 'Поле "model" должно быть строкой',
                'model_name.max' => 'Поле "model" не должно превышать 255 символов',
            ];
        }
    }
  ```

  # Вызов сервиса из контроллера и прочих мест
- [ ] В разделе use добавляем 
  ```
    use App\Services\$service_folder\$service_nameService;
    use App\Http\Requests\API\$service_name\$service_nameRequest;
  ```

- [ ] В соответствующем методе контроллера добавляем 
  ```
    public function index($service_nameRequest $request, $service_nameService $$controller_variable): JsonResponse
    {
        $fields = $request->validated();
        $success = $$controller_variable->$service_method($fields);
    
        return response()->json(['success' => $success]);

    }
  ```