---
title: Двусторонний телеграмм-бот в Laravel
tags:
  - telegram
variables:
  bot_name:
    description: Имя бота (можно по-русски)
    required: true
    example: Мой лучший бот
  bot_username:
    description: Название бота (username в Telegram)
    required: true
    example: MySuperBot
  bot_token:
    description: Токен бота
    required: true
    example: 5649872138:AAEH1o1FSuJfjqwvbavQLO3UICL3w
  config_name:
    description: Название файла конфигурации
    default: telegram
  laravel_botname:
    description: Название бота в файле конфигурации
    default: mybot
  site:
    description: Адрес сайта с проектом (без http:// или https://)
    example: myproject.mysite.ru 
  NODEJS_VERSION:
    description: Версия nodejs что нужна
    default: 16

---

# Предварительно
- [ ] Заполняем <var>bot_name</var>
- [ ] Заполняем <var>bot_username</var>
- [ ] Заполняем название файла конфигурации (без .php) <var>config_name</var>
- [ ] Заполняем Название бота в файле конфигурации <var>laravel_botname</var>
- [ ] Заполняем название сайта <var>site</var>

## Создание бота в Телеграмм

- [ ] Идем в Телеграм и в поиске находим бота BotFather

  ```
  https://t.me/BotFather
  ```
- [ ] Заходим в чат с ним и пишем команду

  ```
  /newbot
  ```

- [ ] Вводим имя бота, можно по-русски. Эта надпись будет видна в чате с ботом

  ```
  $bot_name
  ```

- [ ] Затем вводим username бота, он должен быть уникальным. Так он будет виден в Телеграмм в поиске.

  ```
  $bot_username
  ```

- [ ] Бот создан. Создается токен бота, который выведется при его создании. Заполняем <var>bot_token</var>

## Найтройки в проекте Laravel

- [ ] Устанавливаем пакет в Laravel

  ```
  composer require irazasyed/telegram-bot-sdk
  ```

- [ ] Публикуем файл конфигурации. Его можно найти в папке /config

  ```
  php artisan vendor:publish --tag="$config_name-config"
  ```

- [ ] В этом файле в разделе 'bots' вставляем данные своего бота

  ```
  '$laravel_botname' => [
    'token' => env('TELEGRAM_BOT_TOKEN', ''),
    'webhook_url' => env('TELEGRAM_WEBHOOK_URL', ''),
    'commands' => [
      //Acme\Project\Commands\MyTelegramBot\BotCommand::class
    ],
  ],
  ```

- [ ] В файле .env в конце вставляем

  ```
  TELEGRAM_BOT_TOKEN=$bot_token
  TELEGRAM_WEBHOOK_URL="https://$site/webhook"
  ```

- [ ] В файле app\Http\Middleware\VerifyCsrfToken.php вписываем в
  
  protected $except = [

  ];

  строчку: 

  ```
  '/webhook',
  ```

- [ ] Создаем контроллер

  ```
  php artisan make:controller TelegramController
  ```

- [ ] Пишем в контроллере use и 4 метода

  ```
  use Telegram\Bot\Laravel\Facades\Telegram;

  public function setWebHook() {
    $response = Telegram::setWebhook(['url' => env('TELEGRAM_WEBHOOK_URL')]);
    Log::info($response);
    return;
  }
  
  public function getMe() {
    $response = Telegram::bot('mybot')->getMe();
    Log::info($response);
    return;
  }
  
  public function send($message, $chatId) {
    $response = Telegram::sendMessage([
    'chat_id' => $chatId,
    'text' => $message,
    ]);
  
    $messageId = $response->getMessageId();
  }
  
  public function getFromBot() {
    $updates = Telegram::getWebhookUpdate();

    return 'ok';
  }
  ```

- [ ] В routes\web.php (вне middleware('auth')) создаем роуты

  ```
  Route::get('/setwebhook', [TelegramController::class, 'setWebHook']);
  Route::post('/webhook', [TelegramController::class, 'getFromBot']);
  ```

- [ ] В файле app\providers\AppServiceProvider.php в метод boot добавляем

  ```
  if($this->app->environment('production')) {
    \URL::forceScheme('https');
  }
  ```

- [ ] Пушим все в гит и проливаем на боевой сервер
- [ ] На боевом сервере не забываем прописывать в .env такие же настройки телеграм бота

  ```
  TELEGRAM_BOT_TOKEN=$bot_token
  TELEGRAM_WEBHOOK_URL="https://$site/webhook"
  ```

## Запуск и проверка работы бота

- [ ] Сообщаем Telegram URL вашего webhook. Вводим в браузере:

  ```
  https://$site/setwebhook
  ```

- [ ] Пробуем отправить сообщение с телеграм бота и смотрим что пришло в контроллер в getFromBot().
