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
    description: Название первого методв сервиса
    required: true
    example: index
  controller_variable:
    description: Имя переменной, используемой в контроллере, по имени сервиса, но с маленькой буквы
    required: true
    example: mkdService
    
---

# Предварительно
- [ ] Заполняем имя сервиса <var>service_name</var>

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
    touch app/Services/$service_folder/$service_nameService.php
  ```

- В созданном файле прописываем
  ```
    <?php

    namespace App\Services\$service_folder;

    use App\Contracts\Services\$service_folder\$service_nameService as $service_nameContract;

    class $service_nameService implements $service_nameContract
    {

        public function $service_method(array $arguments): bool
        {

        }
    }
  ```

Регистрируем его в сервис-провайдере app/Providers\$service_nameServiceProvider 
- [ ] В use, в разделе use App\Services\{ добавляем:
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
- [ ] Создаем сервис
  ```
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

  # Вызов сервиса из контроллера и прочих мест
- [ ] В разделе use добавляем 
  ```
    use App\Services\Seeders\$service_nameService;
  ```

- [ ] В соответствующем методе контролеера добавляем 
  ```
    public function index(MkdSeederRequest $request, $service_nameService $$controller_variableService): JsonResponse
    {
        $fields = $request->validated();
        $success = $$controller_variableService->$service_method($fields);
    
        return response()->json(['success' => $success]);

    }
  ```