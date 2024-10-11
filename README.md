# Social Network API

Это API для социальной сети, разработанное с использованием Ruby on Rails.

## Требования

- Docker
- Docker Compose

## Настройка

1. Клонируйте репозиторий:
   ```
   git clone https://github.com/your-username/social-network-api.git
   cd social-network-api
   ```

2. Создайте файл .env в корневой директории проекта и заполните его необходимыми переменными окружения (см. пример в файле .env.example).

3. Соберите Docker образы:
   ```
   make build
   ```

4. Запустите контейнеры:
   ```
   make up
   ```

5. Настройте базу данных:
   ```
   make db-setup
   ```

## Использование

- Запуск сервера: `make up`
- Остановка сервера: `make down`
- Просмотр логов: `make logs`
- Запуск тестов: `make test`
- Доступ к консоли Rails: `make shell`

API будет доступно по адресу `http://localhost:3000`.

## Документация API

Документация API доступна по адресу `http://localhost:3000/api-docs` после запуска сервера.

## Разработка

При внесении изменений в код, не забудьте обновить тесты и документацию API.

## Лицензия

[MIT License](LICENSE)