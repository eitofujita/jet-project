# Mini Instagram

Учебный клон Instagram на Ruby on Rails. Приложение поддерживает регистрацию, публикацию изображений, подписки, персональную ленту, комментарии и отметки «Нравится».

[Русский](#русский) · [日本語](#日本語)

---

## Русский

### О проекте

Mini Instagram — серверное веб-приложение, созданное в рамках учебной программы Ruby / Rails. HTML генерируется Rails с помощью ERB, интерактивные обновления реализованы через Turbo и Stimulus. Отдельный frontend на React не используется.

Интерфейс приложения, уведомления и сообщения об ошибках представлены на русском языке.

### Возможности

- Регистрация, вход и выход
- URL профиля в формате `/users/@name`
- Поиск зарегистрированных пользователей
- Подписка и отписка
- Просмотр подписчиков и подписок
- Персональная лента из своих публикаций и публикаций подписок
- Просмотр всех публикаций
- Создание публикации с изображением
- Редактирование и удаление собственной публикации
- Отдельная страница публикации
- Создание и удаление собственных комментариев
- Добавление и удаление отметки «Нравится»
- Отображение количества комментариев и отметок
- Частичное обновление комментариев и отметок через Turbo Stream
- Проверка прав доступа с помощью Pundit

### Технологии

| Категория | Технология |
|---|---|
| Язык | Ruby 3.2.3 |
| Фреймворк | Rails 8.1.3 |
| База данных | SQLite 3 |
| Шаблоны | ERB |
| Стили | Tailwind CSS |
| Интерактивность | Turbo / Stimulus |
| Файлы | Active Storage |
| Аутентификация | `has_secure_password` / bcrypt |
| Авторизация | Pundit |
| Тестирование | RSpec / Capybara / FactoryBot |
| Проверка кода | RuboCop / Brakeman |

### Требования

- Ruby 3.2.3
- Bundler 2.4 или новее
- SQLite

Версии gem зафиксированы в `Gemfile.lock`.

### Установка и запуск

```bash
git clone https://github.com/eitofujita/jet-project.git
cd jet-project
bundle config set --local path .bundle/gems
bundle install
bin/rails db:prepare
bin/dev
```

После запуска откройте:

```text
http://localhost:3000
```

`bin/dev` одновременно запускает Rails и наблюдение за Tailwind CSS.

### Основные URL

| URL | Назначение |
|---|---|
| `/signup` | Регистрация |
| `/login` | Вход |
| `/` | Персональная лента |
| `/posts` | Все публикации |
| `/posts/:id` | Отдельная публикация |
| `/users` | Поиск пользователей |
| `/users/@name` | Профиль |
| `/users/@name/followers` | Подписчики |
| `/users/@name/following` | Подписки |

### Тесты и проверка качества

```bash
bundle exec rspec
RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bin/rubocop
bin/brakeman --no-pager
```

Тесты покрывают модели, политики доступа, HTTP-запросы и основной сценарий регистрации.

### Структура проекта

```text
jet-project/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb  # текущий пользователь и проверка входа
│   │   ├── users_controller.rb        # регистрация, профиль и списки подписок
│   │   ├── sessions_controller.rb     # вход и выход
│   │   ├── posts_controller.rb        # CRUD публикаций
│   │   ├── feeds_controller.rb        # персональная лента
│   │   ├── comments_controller.rb     # создание и удаление комментариев
│   │   ├── likes_controller.rb        # отметка «Нравится» и её удаление
│   │   └── follows_controller.rb      # подписка и отписка
│   ├── models/
│   │   ├── user.rb                    # аккаунт, пароль и связи пользователя
│   │   ├── post.rb                    # публикация и проверка изображения
│   │   ├── comment.rb                 # комментарий к публикации
│   │   ├── like.rb                    # уникальная отметка пользователя
│   │   └── follow.rb                  # связь подписчик → пользователь
│   ├── policies/
│   │   ├── post_policy.rb             # права на изменение публикации
│   │   ├── comment_policy.rb          # права на удаление комментария
│   │   └── user_policy.rb             # доступ к профилям и подпискам
│   ├── services/
│   │   └── feed_query.rb              # запрос публикаций для ленты
│   ├── views/
│   │   ├── layouts/                   # общий HTML и навигация
│   │   ├── users/                     # регистрация, профиль и списки
│   │   ├── sessions/                  # форма входа
│   │   ├── posts/                     # список, форма и страница публикации
│   │   ├── feeds/                     # персональная лента
│   │   ├── comments/                  # partial и Turbo Stream
│   │   └── likes/                     # кнопка и Turbo Stream
│   ├── javascript/controllers/
│   │   ├── file_input_controller.js   # русское поле выбора изображения
│   │   └── form_validation_controller.js # русские сообщения браузера
│   └── assets/                        # Tailwind source и собранный CSS
├── config/
│   ├── routes.rb                      # URL и HTTP-методы
│   ├── application.rb                 # locale и конфигурация Rails
│   ├── database.yml                   # SQLite для development/test/production
│   ├── storage.yml                    # Active Storage
│   └── locales/ru.yml                 # русские названия и ошибки
├── db/
│   ├── migrate/                       # миграции таблиц и ограничений
│   ├── schema.rb                      # актуальная структура базы данных
│   └── seeds.rb                       # начальные данные
├── spec/
│   ├── factories/                     # тестовые User, Post, Comment и связи
│   ├── models/                        # проверки моделей
│   ├── policies/                      # проверки прав доступа
│   ├── requests/                      # маршруты, HTTP и изменение базы
│   ├── system/                        # сценарии в браузере
│   └── support/                       # общий helper входа
├── bin/dev                            # Rails + Tailwind
├── Procfile.dev                       # процессы development
├── Gemfile / Gemfile.lock             # зависимости и версии
├── Dockerfile                         # production container
└── README.md
```

Поток обычного запроса: `routes.rb → Controller → Policy → Model/Service → ERB`. Изменения комментариев и отметок возвращаются как Turbo Stream, поэтому обновляется только нужная часть страницы.

### Docker

`Dockerfile` и конфигурация Kamal были созданы стандартной командой Rails 8. Они предназначены для production-развёртывания и не требуются для локального запуска через `bin/dev`.

### Известные ограничения

- Ruby 3.2.3 больше не поддерживается. Планируется обновление до Ruby 3.3 или новее.
- В текущей среде используется SQLite. Перед production-развёртыванием рекомендуется перейти на PostgreSQL.
- Лента ограничена 30 публикациями; интерфейс следующей страницы пока не реализован.
- Изображения сохраняются локально. Для production необходимо настроить S3-совместимое хранилище.
- Docker image пока не проверен.

---

## 日本語

### プロジェクト概要

Mini Instagramは、Ruby / Railsカリキュラムの学習用に作成したInstagramクローンです。RailsとERBでHTMLを生成し、TurboとStimulusで部分更新を実装しています。Reactなどの独立したフロントエンドは使用していません。

アプリケーションの画面、通知、入力エラーはロシア語で表示されます。

### 実装機能

- ユーザー登録・ログイン・ログアウト
- `/users/@name`形式のプロフィールURL
- ユーザー検索
- フォロー・フォロー解除
- フォロワー一覧・フォロー中一覧
- 自分とフォロー中ユーザーの投稿を表示するフィード
- 全ユーザーの投稿一覧
- 画像付き投稿
- 自分の投稿の編集・削除
- 個別投稿画面
- コメントの作成・自分のコメントの削除
- Like・Like解除・件数表示
- Turbo StreamによるコメントとLikeの部分更新
- Punditによるサーバー側の認可

### 技術構成

| 分類 | 技術 |
|---|---|
| 言語 | Ruby 3.2.3 |
| フレームワーク | Rails 8.1.3 |
| データベース | SQLite 3 |
| テンプレート | ERB |
| スタイル | Tailwind CSS |
| 画面更新 | Turbo / Stimulus |
| 画像管理 | Active Storage |
| 認証 | `has_secure_password` / bcrypt |
| 認可 | Pundit |
| テスト | RSpec / Capybara / FactoryBot |
| 品質・セキュリティ | RuboCop / Brakeman |

### 必要環境

- Ruby 3.2.3
- Bundler 2.4以降
- SQLite

gemのバージョンは`Gemfile.lock`に固定されています。

### セットアップと起動

```bash
git clone https://github.com/eitofujita/jet-project.git
cd jet-project
bundle config set --local path .bundle/gems
bundle install
bin/rails db:prepare
bin/dev
```

起動後、次のURLを開きます。

```text
http://localhost:3000
```

`bin/dev`はRailsサーバーとTailwind CSSの監視を同時に起動します。

### 主要URL

| URL | 用途 |
|---|---|
| `/signup` | ユーザー登録 |
| `/login` | ログイン |
| `/` | フィード |
| `/posts` | 全投稿 |
| `/posts/:id` | 個別投稿 |
| `/users` | ユーザー検索 |
| `/users/@name` | プロフィール |
| `/users/@name/followers` | フォロワー一覧 |
| `/users/@name/following` | フォロー中一覧 |

### テストと品質確認

```bash
bundle exec rspec
RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bin/rubocop
bin/brakeman --no-pager
```

モデル、認可、HTTPリクエスト、ユーザー登録の主要操作をRSpecで検証しています。

### ディレクトリ構成

```text
jet-project/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb  # current_user、認証要求、認可エラー
│   │   ├── users_controller.rb        # 登録、プロフィール、フォロー一覧
│   │   ├── sessions_controller.rb     # ログイン・ログアウト
│   │   ├── posts_controller.rb        # 投稿CRUD
│   │   ├── feeds_controller.rb        # 個人フィード
│   │   ├── comments_controller.rb     # コメント作成・削除
│   │   ├── likes_controller.rb        # Like・Like解除
│   │   └── follows_controller.rb      # フォロー・解除
│   ├── models/
│   │   ├── user.rb                    # アカウント、パスワード、ユーザー関連
│   │   ├── post.rb                    # 投稿、画像、ファイル検証
│   │   ├── comment.rb                 # 投稿へのコメント
│   │   ├── like.rb                    # ユーザーごとの一意なLike
│   │   └── follow.rb                  # follower → followedの自己参照関連
│   ├── policies/
│   │   ├── post_policy.rb             # 投稿の編集・削除権限
│   │   ├── comment_policy.rb          # コメント削除権限
│   │   └── user_policy.rb             # プロフィールとフォロー関連権限
│   ├── services/
│   │   └── feed_query.rb              # フィード用投稿検索
│   ├── views/
│   │   ├── layouts/                   # 共通HTMLとナビゲーション
│   │   ├── users/                     # 登録、プロフィール、ユーザー一覧
│   │   ├── sessions/                  # ログインフォーム
│   │   ├── posts/                     # 投稿一覧、フォーム、個別投稿
│   │   ├── feeds/                     # 個人フィード
│   │   ├── comments/                  # partialとTurbo Stream
│   │   └── likes/                     # LikeボタンとTurbo Stream
│   ├── javascript/controllers/
│   │   ├── file_input_controller.js   # ロシア語のファイル選択UI
│   │   └── form_validation_controller.js # ロシア語のブラウザ検証
│   └── assets/                        # Tailwind入力CSSと生成CSS
├── config/
│   ├── routes.rb                      # URLとHTTPメソッド
│   ├── application.rb                 # localeなどRails全体設定
│   ├── database.yml                   # 環境別SQLite設定
│   ├── storage.yml                    # Active Storage設定
│   └── locales/ru.yml                 # ロシア語の属性名・エラー
├── db/
│   ├── migrate/                       # テーブル・制約のmigration
│   ├── schema.rb                      # 現在のDB構造
│   └── seeds.rb                       # 初期データ
├── spec/
│   ├── factories/                     # User、Postなどのテストデータ
│   ├── models/                        # モデルspec
│   ├── policies/                      # 認可spec
│   ├── requests/                      # route、HTTP、DB変更のspec
│   ├── system/                        # ブラウザ操作spec
│   └── support/                       # 共通ログインhelper
├── bin/dev                            # RailsとTailwindの同時起動
├── Procfile.dev                       # developmentプロセス定義
├── Gemfile / Gemfile.lock             # gemと固定バージョン
├── Dockerfile                         # 本番用コンテナ定義
└── README.md
```

通常のリクエストは`routes.rb → Controller → Policy → Model/Service → ERB`の順に処理されます。コメントとLikeの変更はTurbo Streamを返し、画面全体ではなく対象部分だけを更新します。

### Dockerについて

`Dockerfile`とKamal設定はRails 8の標準生成物です。本番デプロイ用であり、`bin/dev`によるローカル起動には必要ありません。

### 既知の制約

- Ruby 3.2.3は保守期間を終了しています。Ruby 3.3以降への更新が必要です。
- 現在はSQLiteを使用しています。本番運用前にPostgreSQLへの移行を推奨します。
- フィードは最大30件で、次ページを取得するUIは未実装です。
- 画像はローカルストレージへ保存します。本番ではS3互換ストレージなどの設定が必要です。
- Docker imageは未検証です。
