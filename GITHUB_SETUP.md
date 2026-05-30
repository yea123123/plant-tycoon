# GitHub Setup Instructions

## Шаг 1: Создать репозиторий на GitHub

1. Откройте https://github.com/new
2. Заполните:
   - **Repository name**: `plant-tycoon`
   - **Description**: `🌱 Plant Tycoon - iOS idle/tycoon game built with SwiftUI`
   - **Visibility**: Public (или Private)
   - ❌ НЕ добавляйте README, .gitignore, license (уже есть локально)
3. Нажмите **Create repository**

## Шаг 2: Подключить локальный репозиторий

Скопируйте URL вашего репозитория (например: `https://github.com/USERNAME/plant-tycoon.git`)

Затем выполните команды:

```bash
cd /c/Users/pc/Desktop/tycoon

# Добавить remote
git remote add origin https://github.com/USERNAME/plant-tycoon.git

# Переименовать ветку в main (если нужно)
git branch -M main

# Отправить код на GitHub
git push -u origin main
```

## Шаг 3: Проверить загрузку

Обновите страницу репозитория на GitHub. Вы должны увидеть:
- ✅ 27 файлов
- ✅ README.md отображается на главной странице
- ✅ 2 коммита в истории
- ✅ GitHub Actions workflow в `.github/workflows/ios.yml`

## Шаг 4: Настроить GitHub Actions (для IPA сборки)

### Важно: Сначала создайте Xcode проект!

GitHub Actions не может собрать IPA без файла `.xcodeproj`. Выполните:

1. Откройте Xcode
2. Создайте проект (см. `XCODE_SETUP.md`)
3. Добавьте `.xcodeproj` в Git:

```bash
git add PlantTycoon.xcodeproj
git commit -m "Add Xcode project file"
git push
```

### Настройка Code Signing (для реальной IPA)

Для сборки IPA на GitHub Actions нужны сертификаты:

1. **Создать App ID** в Apple Developer Portal
2. **Создать сертификаты** (Development/Distribution)
3. **Создать Provisioning Profile**
4. **Добавить секреты в GitHub**:
   - Settings → Secrets and variables → Actions
   - Добавить:
     - `CERTIFICATES_P12` (base64 сертификата)
     - `CERTIFICATES_PASSWORD` (пароль сертификата)
     - `PROVISIONING_PROFILE` (base64 профиля)
     - `KEYCHAIN_PASSWORD` (любой пароль)

### Упрощенный вариант (без code signing)

Workflow уже настроен для сборки без подписи (только для симулятора).
После push кода, GitHub Actions автоматически:
- ✅ Проверит код
- ✅ Соберет для симулятора
- ⚠️ Попытается создать IPA (может не получиться без подписи)

## Шаг 5: Проверить GitHub Actions

1. Перейдите на вкладку **Actions** в репозитории
2. Вы увидите workflow "iOS Build and Archive"
3. Кликните на последний запуск
4. Проверьте логи сборки

## Альтернатива: Использовать GitHub CLI

Если установлен `gh` CLI:

```bash
# Создать репозиторий и загрузить код одной командой
gh repo create plant-tycoon --public --source=. --remote=origin --push

# Или для приватного репозитория
gh repo create plant-tycoon --private --source=. --remote=origin --push
```

## Структура репозитория на GitHub

```
plant-tycoon/
├── .github/
│   └── workflows/
│       └── ios.yml              ← GitHub Actions workflow
├── PlantTycoon/                 ← Исходный код
│   ├── Models/
│   ├── ViewModels/
│   ├── Views/
│   └── Services/
├── README.md                    ← Главная страница
├── README_RU.md                 ← Русская версия
├── QUICKSTART.md
├── XCODE_SETUP.md
├── CONTRIBUTING.md
├── JSON_FIX.md                  ← Документация исправлений
├── .gitignore
└── build.sh

Всего: 27 файлов, ~3600 строк
```

## Что делать после загрузки

1. ✅ Добавить темы (Topics) в репозиторий:
   - `swift`, `swiftui`, `ios`, `game`, `tycoon`, `idle-game`

2. ✅ Настроить About секцию:
   - Description: "🌱 Plant Tycoon - iOS idle/tycoon game"
   - Website: (если есть)
   - Topics: (см. выше)

3. ✅ Создать Release (опционально):
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. ✅ Добавить бейдж в README:
   ```markdown
   ![iOS Build](https://github.com/USERNAME/plant-tycoon/workflows/iOS%20Build%20and%20Archive/badge.svg)
   ```

## Troubleshooting

### "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/USERNAME/plant-tycoon.git
```

### "failed to push some refs"
```bash
git pull origin main --rebase
git push -u origin main
```

### "Permission denied"
Используйте Personal Access Token вместо пароля:
1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Выберите scopes: `repo`
4. Используйте token как пароль при push

---

**Готово! Ваш проект на GitHub! 🎉**
