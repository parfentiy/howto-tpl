---
title: Защита API в Swagger L5 в проекте Laravel
tags:
  - api
variables:
  site:
    description: Адрес сайта
    required: true
    example: localhost 
  email:
    description: email зарегистрированного пользователя в вашем приложении
    required: true
    example: test@mail.com
  password:
    description: Его пароль
    required: true
    example: 123123123 
  user_token:
    description: Токен пользователя 
    required: true
    example:

---
# Предварительно
- [ ] Заполняем адрес сайта <var>site</var>
- [ ] Заполняем email пользователя, имеющегося в вашем приложении <var>email</var>
- [ ] Заполняем его пароль <var>password</var>

# Установка и настройка JWT Auth

- [ ] Устанавливаем его с помощью Composer
  ```
    composer require tymon/jwt-auth
  ```
- [ ] Публикуем конфиг
  ```
    php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
  ```
- [ ] Генерим секретный ключ
  ```
    php artisan jwt:secret
  ```
- [ ] Вставляем в модель User следующий use:
  ```
    use Tymon\JWTAuth\Contracts\JWTSubject;
  ```
  
- [ ] и дописываем к классу:
  ```
    implements JWTSubject
  ```
  
- [ ] В конец класса дописываем два метода :
  ```
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
    * Return a key value array, containing any custom claims to be added to the JWT.
    *
    * @return array
    */
    public function getJWTCustomClaims()
    {
        return [];
    }
  ```
  
- [ ] Затем в файле config\auth.php в разделе 'guards' вписываем еще одну конфигурацию:
  ```
    'api' => [
        'driver' => 'jwt',
        'provider' => 'users',
    ],
  ```
  
- [ ] Создаем AuthController
  ```
    php artisan make:controller AuthController
  ```
- [ ] Заменяем в нем все, что есть на:
  ```
    <?php
    
    namespace App\Http\Controllers;
    
    use Illuminate\Support\Facades\Auth;
    use App\Http\Controllers\Controller;
    
    class AuthController extends Controller
    {
        /**
         * Create a new AuthController instance.
         *
         * @return void
         */
        public function __construct()
        {
            $this->middleware('auth:api', ['except' => ['login']]);
        }
    
        /**
         * Get a JWT via given credentials.
         *
         * @return \Illuminate\Http\JsonResponse
         */
        public function login()
        {
            $credentials = request(['email', 'password']);
    
            if (! $token = auth('api')->attempt($credentials)) {
                return response()->json(['error' => 'Unauthorized'], 401);
            }
    
            return $this->respondWithToken($token);
        }
    
        /**
         * Get the authenticated User.
         *
         * @return \Illuminate\Http\JsonResponse
         */
        public function me()
        {
            return response()->json(auth('api')->user());
        }
    
        /**
         * Log the user out (Invalidate the token).
         *
         * @return \Illuminate\Http\JsonResponse
         */
        public function logout()
        {
            auth('api')->logout();
    
            return response()->json(['message' => 'Successfully logged out']);
        }
    
        /**
         * Refresh a token.
         *
         * @return \Illuminate\Http\JsonResponse
         */
        public function refresh()
        {
            return $this->respondWithToken(auth('api')->refresh());
        }
    
        /**
         * Get the token array structure.
         *
         * @param  string $token
         *
         * @return \Illuminate\Http\JsonResponse
         */
        protected function respondWithToken($token)
        {
            return response()->json([
                'access_token' => $token,
                'token_type' => 'bearer',
                'expires_in' => auth('api')->factory()->getTTL() * 60
            ]);
        }
    }
  ```
  
- [ ] В начало файла routes\api.php вставляем:
  ```
    Route::group(['middleware' => 'api', 'prefix' => 'auth'], function () {
        Route::post('login', [\App\Http\Controllers\AuthController::class, 'login']);
        Route::post('logout', [\App\Http\Controllers\AuthController::class, 'logout']);
        Route::post('refresh', [\App\Http\Controllers\AuthController::class, 'refresh']);
        Route::post('me', [\App\Http\Controllers\AuthController::class, 'me']);
    });
  ```
  
- [ ] Далее устанавливаем пакет breeze Auth. См. документацию по Laravel

## Получаем токен с помощью Postman
- [ ] Метод POST
- [ ] В адресную строку прописываем
  ```
    $site/api/auth/login
  ```
- [ ] Во вкладке "Body" выбираем точку "raw" и в "Text" выбираем jSON
- [ ] В поле ввода даем тестовый массив:
    ```
  {
      "email": "$email",
      "password": $password
  }
  ```
- [ ] Во вкладке Headers создаем поле Accept со значением appplication/json
- [ ] Жмем Send и в ответе приходит токен. Сохраняем его <var>user_token</var>.

- [ ] В файле roures\api.php находим все роут-ресурсы на Swagger и добавляем в конец каждого:
  ```
    ->middleware('jwt.auth')
  ```
  
- [ ] В файл app\Http\Controllers\Controller.php добавляем инструкцию 
  (после всех других инструкцийб не забыв поставить запятую после последней инструкции)
  ```
    * @OA\Components(
    *     @OA\SecurityScheme(
    *         securityScheme="bearerAuth",
    *         type="http",
    *         scheme="bearer"
    *     )
    * )
  ```
  
После этого проверяем, появилась ли кнопка Authorize в интерефейсе Swagger
- [ ] Генерим инструкции
  ```
    php artisan l5-swagger:generate
  ```
и обновляем страницу интерфейса

Защищаем все пункты в интерфейсе Swagger.
- [ ] Для этого вставляем эту инструкцию в каждый пункт сваггера в контроллерах 
  (можно после инструкции tags)
  ```
    security={{ "bearerAuth": {} }},  
  ```
- [ ] Снова генерим инструкции
  ```
    php artisan l5-swagger:generate
  ```
- [ ] Теперь обновляем интерфейс Swagger и видим, что справа у каждого пункта появился "замочек".
Данные защищены
  
- [ ] В интерфейсе Swagger авторизуемся с токеном и можем получать данные
  ```
    $user_token
  ```