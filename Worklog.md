# Worklog — Русифицированный Fizzy

## Что сделано
- Клонирован open-source проект basecamp/fizzy в локальный каталог.
- Полностью переведён на русский язык: все ERB-шаблоны, хелперы, контроллеры, модели, мейлеры, JavaScript и сид-данные. Настроена локаль `ru` по умолчанию, подключён `rails-i18n` (валидации, даты, числа).
- В `config/application.rb` установлены `default_locale = :ru`, `available_locales = [:en, :ru]`, `fallbacks = true`.
- Добавлена возможность показывать magic-link код на странице входа через переменную `SHOW_MAGIC_LINK_CODE=true` (для self-host без SMTP), обновлены `via_magic_link.rb` и `sessions/magic_links/show.html.erb`.
- Собран Docker-образ `fizzy-ru:latest` и запущен контейнер `fizzy-ru` с `--restart unless-stopped`.
- Сервис опубликован только на внутреннем интерфейсе; наружу не выставлен.
- База данных и вложения персистятся в Docker-томе.

## Доступ
- Параметры конкретного развёртывания (адреса, интерфейсы, порты) намеренно не публикуются.
- Magic-link код отображается на странице входа (блок «DEV»).

## Управление контейнером
- Остановить: `docker stop fizzy-ru`
- Запустить: `docker start fizzy-ru`
- Логи: `docker logs -f fizzy-ru`
- Секреты передаются через переменные окружения и не коммитятся.

## Примечания
- SMTP не настроен; при необходимости задать `SMTP_ADDRESS`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `MAILER_FROM_ADDRESS` и отключить `SHOW_MAGIC_LINK_CODE`.
- Для домена и SSL поставить reverse-proxy перед контейнером.

## Обновление из оригинального Fizzy
- `main` — чистое зеркало `basecamp/fizzy`, сюда не коммитить переводы.
- `ru` — ветка с русской локализацией.
- Обновить зеркало и открыть PR:
  ```sh
  git fetch upstream
  git switch main
  git merge --ff-only upstream/main
  git push origin main
  gh pr create --repo 88srzh/fizzy-ru --base ru --head main \
    --title "Обновление из upstream" \
    --body "Автоматически синхронизированный main из basecamp/fizzy."
  ```
- Либо в GitHub: «Sync fork» для `main`, затем Pull request `main` → `ru`.
- Если PR конфликтует, разрешить конфликты локально:
  ```sh
  git switch ru
  git merge main
  # исправить конфликты, затем
  git add -A
  git commit
  git push origin ru
  ```
- После мержа PR — пересобрать образ и перезапустить контейнер.
