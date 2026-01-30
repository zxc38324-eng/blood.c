# 📋 blood.c v2.0 - Шпаргалка

## 🚀 Быстрый запуск

```lua
-- Загрузка
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood-cheat/main/blood_modular/loader.lua"))()

-- Узнать PlaceId
print(game.PlaceId)

-- Выгрузить
getgenv().BloodCheat.Destroy()
```

## 📁 Структура файлов

```
blood_modular/
├── loader.lua          → Главный файл (запускать этот)
├── core/
│   ├── hooks.lua       → Обход античита
│   ├── ui.lua          → Интерфейс
│   └── utils.lua       → Общие функции
└── modules/
    ├── combat.lua      → Камлок, Хитбокс, Автошот
    ├── movement.lua    → Флай, Спид
    ├── visuals.lua     → ESP, Кроссхейр
    └── misc.lua        → Авто-функции
```

## ⚙️ Настройка

### 1. Добавить игру (loader.lua)
```lua
local ALLOWED_GAMES = {
    [ТВОЙ_PLACE_ID] = "Название игры",
}
```

### 2. Заменить username (все файлы)
```lua
-- Было:
"https://raw.githubusercontent.com/YOUR_USERNAME/..."

-- Стало:
"https://raw.githubusercontent.com/ТВОЙ_USERNAME/..."
```

### 3. Настроить хуки (core/hooks.lua)
```lua
if remoteName:find("anticheat") or 
   remoteName:find("ТВОЙ_РЕМОУТ") then
    return -- блокируем
end
```

## 🎮 Команды

```lua
local Blood = getgenv().BloodCheat

-- Информация
print(Blood.Version)      -- "2.0.0"
print(Blood.Game)         -- "Da Hood"
print(Blood.PlaceId)      -- 2788229376

-- Модули
Blood.Modules.Combat
Blood.Modules.Movement
Blood.Modules.Visuals
Blood.Modules.Misc

-- Выгрузка
Blood.Destroy()
```

## 🔧 Добавить функцию

### В существующий модуль (combat.lua)

```lua
-- 1. Настройки
local MyFeature = {
    Enabled = false,
    Value = 10
}

-- 2. Функция
local function UpdateMyFeature()
    if MyFeature.Enabled then
        -- код
    end
end

-- 3. UI (в Init())
local section = tabs.Legit:addSection({text = "My Feature"})
section:addToggle({text = "Enable", state = false}):bindToEvent("onToggle", function(state)
    MyFeature.Enabled = state
    UpdateMyFeature()
end)

-- 4. Очистка (в Destroy())
MyFeature.Enabled = false
UpdateMyFeature()
```

### Новый модуль (modules/mymodule.lua)

```lua
local MyModule = {}

function MyModule.Init(ui)
    -- код
end

function MyModule.Destroy()
    -- очистка
end

return MyModule
```

Добавить в loader.lua:
```lua
Blood.Modules.MyModule = LoadModule("modules/mymodule.lua")

-- В Init():
if Blood.Modules.MyModule then
    Blood.Modules.MyModule.Init(Blood.UI)
end
```

## 🛠️ Utils функции

```lua
local Utils = loadstring(game:HttpGet("URL/core/utils.lua"))()

-- Персонаж
Utils.GetCharacter()
Utils.GetHumanoid()
Utils.GetRootPart()

-- Проверки
Utils.IsKnockedOut(character)

-- Игроки
Utils.GetClosestPlayer(maxDistance)

-- Действия
Utils.SimulateMouseClick()
Utils.PressKey(Enum.KeyCode.E)

-- Уведомления
Utils.Notify("Title", "Message", 3)
Utils.AddLog("Message")
```

## 🎯 UI элементы

```lua
-- Toggle
section:addToggle({text = "Name", state = false}):bindToEvent("onToggle", function(state)
    -- код
end)

-- Slider
section:addSlider({text = "Name", min = 0, max = 100, step = 1, val = 50}):bindToEvent("onNewValue", function(v)
    -- код
end)

-- Button
section:addButton({text = "Name", style = "small"}):bindToEvent("onClick", function()
    -- код
end)

-- Hotkey
local hotkey = section:addHotkey({text = "Name"})
if hotkey:getHotkey() and input.KeyCode == hotkey:getHotkey() then
    -- код
end

-- Label
section:addLabel({text = "Text"})

-- Color Picker
section:addColorPicker({text = "Name"}):bindToEvent("onNewColor", function(color)
    -- код
end)
```

## 🔒 Хуки

```lua
-- Namecall Hook
local Old
Old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" then
        -- изменить args
    end
    
    return Old(self, unpack(args))
end)

-- Index Hook
local Old
Old = hookmetamethod(game, "__index", function(self, key)
    if key == "WalkSpeed" then
        return 16 -- спуфим
    end
    return Old(self, key)
end)
```

## 🎨 Drawing API

```lua
-- Circle
local circle = Drawing.new("Circle")
circle.Radius = 100
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 2
circle.Visible = true
circle.Position = Vector2.new(x, y)

-- Line
local line = Drawing.new("Line")
line.From = Vector2.new(x1, y1)
line.To = Vector2.new(x2, y2)
line.Color = Color3.fromRGB(255, 255, 255)
line.Thickness = 2
line.Visible = true

-- Text
local text = Drawing.new("Text")
text.Text = "Hello"
text.Size = 14
text.Color = Color3.fromRGB(255, 255, 255)
text.Center = true
text.Outline = true
text.Visible = true
text.Position = Vector2.new(x, y)

-- Square
local square = Drawing.new("Square")
square.Size = Vector2.new(100, 100)
square.Position = Vector2.new(x, y)
square.Color = Color3.fromRGB(255, 255, 255)
square.Thickness = 2
square.Filled = false
square.Visible = true

-- Удалить
drawing:Remove()
```

## 🐛 Отладка

```lua
-- Логирование
print("Debug:", value)
warn("Warning:", value)
Utils.AddLog("Log: " .. value)

-- Безопасное выполнение
pcall(function()
    -- код который может упасть
end)

-- С обработкой ошибок
local success, error = pcall(function()
    -- код
end)
if not success then
    warn("Error:", error)
end

-- Проверка существования
if game:GetService("ServiceName") then
    -- код
end

if player.Character then
    -- код
end
```

## ⌨️ Горячие клавиши

| Клавиша | Действие |
|---------|----------|
| DELETE | Выгрузить скрипт |
| Right Click | Забиндить toggle |
| ESC (в биндинге) | Удалить бинд |

## 📊 Производительность

```lua
-- FPS
local fps = 0
local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = tick()
    end
end)

-- Ping
local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()

-- Memory
local memory = gcinfo()
```

## 🔗 Полезные ссылки

- [Lua Manual](https://www.lua.org/manual/5.1/)
- [Roblox API](https://create.roblox.com/docs/reference/engine)
- [GitHub](https://github.com)

## ❓ Частые ошибки

```lua
-- ❌ Неправильно
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)

-- ✅ Правильно
local player = game.Players.LocalPlayer
if player and player.Character then
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(0, 100, 0)
    end
end

-- ❌ Неправильно
for i = 1, 1000 do
    wait()
end

-- ✅ Правильно
for i = 1, 1000 do
    task.wait()
end

-- ❌ Неправильно
game:GetService("Players").LocalPlayer

-- ✅ Правильно
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
```

---

**Сохрани эту шпаргалку!** Она поможет тебе быстро работать с blood.c v2.0
