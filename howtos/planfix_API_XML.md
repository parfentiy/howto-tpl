---
title: Обработка запросов в ПланФикс через АПИ с помощью токена
tags:
  - API
variables:
  api_key:
    description: api_key
    required: false
    default: 46840a1d681a707520f639800e82d3b7
  token:
    description: токен
    required: false
    default: 7b4fd2da8e0902abd228422ed20e0fd4
  account:
    description: Аккаунт
    required: false
    default: fatfox
  url:
    description: URL адрес API
    required: false
    default: https://apiru.planfix.ru/xml/
  controller_name:
    description: Имя контроллера API
    required: false
    default: Api/PlanfixController
  pf_query:
    description: Запрос в API Планфикс
    required: false
    example: <request method=\"contact.getList\"><account></account><target>contact</target></request>

---

# Предварительно

- [ ] Заполняем api_key <var>api_key</var>
- [ ] Заполняем токен <var>token</var>
- [ ] Заполняем аккаунт <var>account</var>
- [ ] Заполняем URL-адрес <var>url</var>
- [ ] Заполняем название контроллера API <var>controller_name</var>
- [ ] Заполняем запрос для API Планфикс <var>pf_query</var>

- [ ] Создаем контроллер API

  ```
  php artisan make:controller $controller_name
  ```

- [ ] В контроллере в классе $controller_name создаем массив аутентификационных данных
  
  ```
      private $authData = [
        'api_key' => '$api_key',
        'token' => '$token',
        'account' => '$account',
        'url' => "$url",       
      ];
  ```

- [ ] Создаем метод, осуществляющий запрос к Планфикс через API с помощью XML
  
  ```
      private function queryXml($requestBody) {
          $requestXml = new \SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?>' .
              $requestBody);

          $requestXml->account = $this->authData['account'];
          $ch = curl_init($this->authData['url']); 

          curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
          curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
          curl_setopt($ch, CURLOPT_HEADER, 1);   // получаем заголовки
          // не проверять SSL сертификат
          curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
          // не проверять Host SSL сертификата
          curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

          curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
          curl_setopt($ch, CURLOPT_USERPWD, $this->authData['api_key'] . ':' . $this->authData['token']);
          curl_setopt($ch, CURLOPT_POST, true);

          curl_setopt($ch, CURLOPT_POSTFIELDS, $requestXml->asXML());

          $response = curl_exec($ch); 
          $error = curl_error($ch);

          $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
          $responseBody = substr($response, $header_size);

          curl_close($ch);

          return $responseBody;
      }

  ```
Для осуществления запроса необходимо использовать метод query_xml с параметром в виде строки запроса. Строку запроса можно составить с помощью
документации от Планфикс. Документация [здесь](https://planfix.com/ru/help/Список_функций)
- [ ] Используем следующую конструкцию

  ```  
      $requestXml = "$pf_query";
      $response = $this->queryXml($requestXml);
  ```
На выходе метод возвращает ответ по выполнению запроса в виде json. Если ответ вернул ошибку, то ее можно обработать, например, так:
- [ ] Использовать код
  ``` 
      if ($response['@attributes']['status'] === 'error') {

          return [
              'message' => 'Ошибка загрузки данных', 
              'status' => 500,
          ];
      }
  ``` 

Успешный ответ можно обработать как обычный json. Для просмотра содержимого ответа можно воспользоваться 
[онлайн-конвертером](https://online-json.com/).

Структуру ответа можно найти в той же [документации](https://planfix.com/ru/help/Список_функций) Планфикс