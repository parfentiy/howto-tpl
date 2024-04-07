---
title: Экспорт и импорт файлов в формате Excel
tags:
  - Laravel
variables:
  model:
    description: Модель для импорта и экспорта
    required: true
    example: Area
  class_prefix:
    description: Префикс класса
    required: true
    example: Areas
    
---

# Предварительно
- [ ] Устанавливаем пакет maatwebsite/excel
  ```
    composer require maatwebsite/excel
  ```

Добавляем провайдер сервиса и фасады в config/app.php
- [ ] В раздел 'providers' вот это:
  ```
    Maatwebsite\Excel\ExcelServiceProvider::class,
  ```

- [ ] В раздел 'aliases' вот это:
  ```
    'Excel' => Maatwebsite\Excel\Facades\Excel::class,
  ```

- [ ] Публикуем конфигурацию 
  ```
    php artisan vendor:publish --provider="Maatwebsite\Excel\ExcelServiceProvider" --tag=config
  ```
- [ ] Добавляем пространство имен в composer.json
  ```
    "App\\": "app/",
    "App\\Excel\\": "app/Excel/"
  ```
- [ ] Обновляем автозагрузку
  ```
    composer dump-autoload
  ```

## Создание необходимых папок и файлов

- [ ] Создаем в /app новую папку c именем Excel

- [ ] Создаем в /app/Excel новую папку c именем Exports

- [ ] Создаем в /app/Excel новую папку c именем Imports

- [ ] Создаем в папке /app/Excel/Exports файл $class_prefixExports.php для экспорта данных

- [ ] Создаем в папке /app/Excel/Imports файл $class_prefixImports.php для экспорта данных

- [ ] Наполняем файл $class_prefixExports.php:

  ```
    <?php

    namespace App\Excel;

    use Maatwebsite\Excel\Concerns\FromCollection;
    use Maatwebsite\Excel\Concerns\WithHeadings;
    use App\Models\$model;

    class $class_prefixExport implements FromCollection, WithHeadings
    {
        public function collection()
        {
            // здесь формируется коллекция полей модели
        }

        public function headings(): array
        {
            return [
                'ID',
                'Name',
                // Другие поля, которые нужно экспортировать
            ];
        }
    }
  ```


