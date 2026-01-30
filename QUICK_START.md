# 🚀 Быстрый старт blood.c v2.0

## Шаг 1: Узнай PlaceId своей игры

Зайди в игру и выполни в консоли эксплойта:
```lua
print(game.PlaceId)
```

Скопируй число (например: `2788229376`)

## Шаг 2: Добавь PlaceId в loader.lua

Открой `loader.lua` и найди:
```lua
local ALLOWED_GAMES = {
    [2788229376] = "Da Hood",
    -- Добавь свою игру здесь:
    [ТВОЙ_PLACE_ID] = "Название игры",
}
```

## Шаг 3: Загрузи на GitHub

1. Создай репозиторий на GitHub (например: `blood-cheat`)
2. Загрузи всю папку `blood_modular`
3. Структура должна быть:
```
твой-репозиторий/
└── blood_modular/
    ├── loader.lua
    ├── core/
    └── modules/
```

## Шаг 4: Замени YOUR_USERNAME

Во ВСЕХ файлах замени `YOUR_USERNAME` на свой GitHub username:

**В loader.lua:**
```lua
local BASE_URL = "https://raw.githubusercontent.com/ТВОЙ_USERNAME/blood-cheat/main/blood_modular/"
```

**В каждом модуле (combat.lua, movement.lua, visuals.lua, misc.lua):**
```lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_USERNAME/blood-cheat/main/blood_modular/core/utils.lua"))()
```

## Шаг 5: Запусти скрипт

В эксплойте выполни:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_USERNAME/blood-cheat/main/blood_modular/loader.lua"))()
```

## ✅ Готово!

Если всё правильно, ты увидишь:
```
blood.c: Loading for Da Hood
Loading core modules...
Loading game modules...
Initializing blood.c...
Installing anti-cheat bypass hooks...
Hooks installed successfully!
Creating UI...
Combat module loaded
Movement module loaded
Visuals module loaded
Misc module loaded
blood.c loaded successfully!
Version: 2.0.0
Game: Da Hood
```

## ❌ Ошибки

### "This game is not supported!"
- Проверь, что добавил PlaceId в `ALLOWED_GAMES`
- Убедись, что PlaceId правильный

### "Failed to load module: ..."
- Проверь, что заменил `YOUR_USERNAME` на свой GitHub username
- Убедись, что файлы загружены на GitHub правильно
- Проверь структуру папок

### "attempt to call a nil value"
- Убедись, что все модули загружены
- Проверь консоль на ошибки загрузки

## 🎯 Быстрые команды

**Выгрузить скрипт:**
```lua
getgenv().BloodCheat.Destroy()
```

**Проверить версию:**
```lua
print(getgenv().BloodCheat.Version)
```

**Проверить игру:**
```lua
print(getgenv().BloodCheat.Game)
```

## 📝 Следующие шаги

1. Настрой хуки под свою игру (`core/hooks.lua`)
2. Добавь свои функции в модули
3. Кастомизируй UI цвета
4. Добавь свои игры в `ALLOWED_GAMES`

---

**Нужна помощь?** Проверь полный README.md
