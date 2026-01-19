# 📤 Как загрузить blood.c v2.0 на GitHub

## Шаг 1: Создай репозиторий на GitHub

1. Зайди на [github.com](https://github.com)
2. Нажми **"New repository"** (зеленая кнопка)
3. Заполни:
   - **Repository name**: `blood-cheat` (или любое другое имя)
   - **Description**: `blood.c v2.0 - Modular Roblox Cheat`
   - **Public** или **Private** (на твой выбор)
   - ✅ **Add a README file** (можно не ставить, у нас уже есть)
4. Нажми **"Create repository"**

## Шаг 2: Загрузи файлы

### Вариант A: Через веб-интерфейс (проще)

1. На странице репозитория нажми **"Add file"** → **"Upload files"**
2. Перетащи **всю папку** `blood_modular` в окно
3. Подожди пока все файлы загрузятся
4. Внизу напиши commit message: `Initial commit - blood.c v2.0`
5. Нажми **"Commit changes"**

### Вариант B: Через Git (для продвинутых)

```bash
# 1. Клонируй репозиторий
git clone https://github.com/YOUR_USERNAME/blood-cheat.git
cd blood-cheat

# 2. Скопируй папку blood_modular в репозиторий
cp -r /path/to/blood_modular .

# 3. Добавь файлы
git add .

# 4. Сделай commit
git commit -m "Initial commit - blood.c v2.0"

# 5. Загрузи на GitHub
git push origin main
```

## Шаг 3: Проверь структуру

Твой репозиторий должен выглядеть так:

```
blood-cheat/
└── blood_modular/
    ├── loader.lua
    ├── README.md
    ├── QUICK_START.md
    ├── MIGRATION_GUIDE.md
    ├── EXAMPLE_FEATURE.md
    ├── CHEATSHEET.md
    ├── SUMMARY.txt
    ├── INDEX.txt
    ├── GITHUB_UPLOAD.md
    ├── core/
    │   ├── hooks.lua
    │   ├── ui.lua
    │   └── utils.lua
    └── modules/
        ├── combat.lua
        ├── movement.lua
        ├── visuals.lua
        └── misc.lua
```

## Шаг 4: Получи ссылки на файлы

### Для loader.lua:
```
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/loader.lua
```

### Для модулей:
```
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/hooks.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/ui.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/utils.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/modules/combat.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/modules/movement.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/modules/visuals.lua
https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/modules/misc.lua
```

**ВАЖНО:** Замени `YOUR_USERNAME` на свой GitHub username!

## Шаг 5: Обнови ссылки в файлах

Теперь нужно заменить `YOUR_USERNAME` во ВСЕХ файлах на свой GitHub username.

### Файлы для редактирования:

1. **loader.lua** (строка ~30):
```lua
local BASE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/"
```

2. **core/utils.lua** - не требует изменений

3. **modules/combat.lua** (строка ~15):
```lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/utils.lua"))()
```

4. **modules/movement.lua** (строка ~10):
```lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/utils.lua"))()
```

5. **modules/visuals.lua** (строка ~10):
```lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/utils.lua"))()
```

6. **modules/misc.lua** (строка ~10):
```lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/core/utils.lua"))()
```

### Как быстро заменить:

**Windows:**
1. Открой все файлы в Notepad++
2. Нажми Ctrl+H (Find & Replace)
3. Find: `YOUR_USERNAME`
4. Replace: `твой_github_username`
5. Нажми "Replace All in All Opened Documents"

**VS Code:**
1. Открой папку blood_modular
2. Нажми Ctrl+Shift+H (Find & Replace in Files)
3. Find: `YOUR_USERNAME`
4. Replace: `твой_github_username`
5. Нажми "Replace All"

**Вручную:**
Открой каждый файл и замени `YOUR_USERNAME` на свой username.

## Шаг 6: Загрузи изменения

### Через веб-интерфейс:
1. Открой файл на GitHub
2. Нажми иконку карандаша (Edit)
3. Замени `YOUR_USERNAME`
4. Нажми "Commit changes"
5. Повтори для всех файлов

### Через Git:
```bash
git add .
git commit -m "Updated URLs with username"
git push origin main
```

## Шаг 7: Протестируй

Запусти в эксплойте:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/loader.lua"))()
```

Если всё правильно, ты увидишь:
```
blood.c: Loading for [Game Name]
Loading core modules...
Loading game modules...
...
blood.c loaded successfully!
```

## ❌ Частые ошибки

### "404: Not Found"
- Проверь, что файлы загружены в правильную структуру
- Убедись, что репозиторий публичный (или используешь токен для приватного)
- Проверь правильность URL

### "Failed to load module"
- Проверь, что заменил `YOUR_USERNAME` во ВСЕХ файлах
- Убедись, что путь к файлу правильный
- Проверь, что файл существует на GitHub

### "This game is not supported"
- Добавь PlaceId своей игры в `loader.lua`
- Проверь, что PlaceId правильный

## 🔒 Приватный репозиторий

Если хочешь сделать репозиторий приватным:

1. Settings → Danger Zone → Change visibility → Make private
2. Создай Personal Access Token:
   - Settings → Developer settings → Personal access tokens → Generate new token
   - Выбери scope: `repo`
   - Скопируй токен
3. Используй токен в URL:
```lua
loadstring(game:HttpGet("https://YOUR_TOKEN@raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/loader.lua"))()
```

**ВАЖНО:** Не делись токеном с другими!

## 📝 Обновление файлов

Когда ты изменишь код:

### Через веб-интерфейс:
1. Открой файл на GitHub
2. Нажми иконку карандаша
3. Внеси изменения
4. Commit changes

### Через Git:
```bash
git add .
git commit -m "Updated [что изменил]"
git push origin main
```

Изменения применятся сразу - просто перезапусти скрипт!

## 🎉 Готово!

Теперь твой blood.c v2.0 доступен на GitHub!

Поделись ссылкой с друзьями:
```
https://github.com/YOUR_USERNAME/blood-cheat
```

Или прямая ссылка для загрузки:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/loader.lua"))()
```

---

## 💡 Советы

1. **Используй .gitignore** для исключения ненужных файлов
2. **Делай commits** с понятными сообщениями
3. **Создавай branches** для экспериментов
4. **Используй Issues** для отслеживания багов
5. **Создавай Releases** для версий

## 🔗 Полезные ссылки

- [GitHub Docs](https://docs.github.com)
- [Git Tutorial](https://git-scm.com/docs/gittutorial)
- [Markdown Guide](https://www.markdownguide.org)

---

**Удачи с загрузкой!** 🚀
