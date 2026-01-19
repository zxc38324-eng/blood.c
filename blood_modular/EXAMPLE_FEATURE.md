# 📚 Пример: Как добавить свою функцию

## Пример 1: Добавить Silent Aim в Combat модуль

### Шаг 1: Открой `modules/combat.lua`

### Шаг 2: Добавь настройки в начало файла

```lua
-- После других настроек (Camlock, FOV, Hitbox...)
local SilentAim = {
    Enabled = false,
    FOV = 200,
    Prediction = 0.13,
    TargetPart = "HumanoidRootPart"
}
```

### Шаг 3: Создай функцию

```lua
-- Добавь перед function Combat.Init()
local function GetSilentAimTarget()
    if not SilentAim.Enabled then return nil end
    
    local closestPlayer = Utils.GetClosestPlayer(SilentAim.FOV)
    if not closestPlayer or not closestPlayer.Character then return nil end
    
    local targetPart = closestPlayer.Character:FindFirstChild(SilentAim.TargetPart)
    if not targetPart then return nil end
    
    -- Применяем предсказание
    local velocity = targetPart.Velocity
    local prediction = velocity * SilentAim.Prediction
    
    return targetPart.Position + prediction
end

-- Хук для изменения аргументов выстрела
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and self.Name == "SHOOT_REMOTE" then -- Замени на имя ремоута твоей игры
        local target = GetSilentAimTarget()
        if target then
            args[1] = target -- Заменяем позицию выстрела
        end
    end
    
    return OldNamecall(self, unpack(args))
end)
```

### Шаг 4: Добавь UI в функцию Init()

```lua
-- В function Combat.Init(ui), после других секций:

-- Silent Aim Section
local silentAimSection = tabs.Legit:addSection({text = "Silent Aim", side = "right"})

silentAimSection:addToggle({text = "Enable Silent Aim", state = false}):bindToEvent("onToggle", function(state)
    SilentAim.Enabled = state
    Utils.AddLog("Silent Aim " .. (state and "enabled" or "disabled"))
end)

silentAimSection:addSlider({text = "FOV", min = 50, max = 500, step = 10, val = 200}):bindToEvent("onNewValue", function(v)
    SilentAim.FOV = v
end)

silentAimSection:addSlider({text = "Prediction", min = 0, max = 0.5, step = 0.01, val = 0.13}):bindToEvent("onNewValue", function(v)
    SilentAim.Prediction = v
end)
```

### Шаг 5: Добавь очистку в Destroy()

```lua
-- В function Combat.Destroy():
SilentAim.Enabled = false
```

---

## Пример 2: Создать новый модуль "Exploits"

### Шаг 1: Создай файл `modules/exploits.lua`

```lua
-- blood.c Exploits Module
local Exploits = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Загружаем утилиты
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/blood.c/main/blood_modular/core/utils.lua"))()

-- Настройки
local Settings = {
    InfiniteCash = {Enabled = false},
    GodMode = {Enabled = false},
    InfiniteAmmo = {Enabled = false}
}

-- Infinite Cash
local function ToggleInfiniteCash(state)
    if state then
        -- Твой код для бесконечных денег
        Utils.AddLog("Infinite Cash enabled")
    else
        Utils.AddLog("Infinite Cash disabled")
    end
end

-- God Mode
local function ToggleGodMode(state)
    if state then
        -- Твой код для бессмертия
        Utils.AddLog("God Mode enabled")
    else
        Utils.AddLog("God Mode disabled")
    end
end

-- Infinite Ammo
local function ToggleInfiniteAmmo(state)
    if state then
        -- Твой код для бесконечных патронов
        Utils.AddLog("Infinite Ammo enabled")
    else
        Utils.AddLog("Infinite Ammo disabled")
    end
end

-- Инициализация
function Exploits.Init(ui)
    Utils.AddLog("Exploits module loaded")
    
    local tabs = ui.tabs
    local otherTab = tabs.Other
    
    -- Exploits Section
    local exploitsSection = otherTab:addSection({text = "Exploits", side = "left"})
    
    exploitsSection:addToggle({text = "Infinite Cash", state = false}):bindToEvent("onToggle", function(state)
        Settings.InfiniteCash.Enabled = state
        ToggleInfiniteCash(state)
    end)
    
    exploitsSection:addToggle({text = "God Mode", state = false}):bindToEvent("onToggle", function(state)
        Settings.GodMode.Enabled = state
        ToggleGodMode(state)
    end)
    
    exploitsSection:addToggle({text = "Infinite Ammo", state = false}):bindToEvent("onToggle", function(state)
        Settings.InfiniteAmmo.Enabled = state
        ToggleInfiniteAmmo(state)
    end)
end

function Exploits.Destroy()
    Settings.InfiniteCash.Enabled = false
    Settings.GodMode.Enabled = false
    Settings.InfiniteAmmo.Enabled = false
    
    ToggleInfiniteCash(false)
    ToggleGodMode(false)
    ToggleInfiniteAmmo(false)
end

return Exploits
```

### Шаг 2: Добавь модуль в `loader.lua`

Найди:
```lua
-- Загружаем игровые модули
print("Loading game modules...")
Blood.Modules.Combat = LoadModule("modules/combat.lua")
Blood.Modules.Movement = LoadModule("modules/movement.lua")
Blood.Modules.Visuals = LoadModule("modules/visuals.lua")
Blood.Modules.Misc = LoadModule("modules/misc.lua")
```

Добавь:
```lua
Blood.Modules.Exploits = LoadModule("modules/exploits.lua")
```

Найди в функции `Blood.Init()`:
```lua
if Blood.Modules.Misc then
    Blood.Modules.Misc.Init(Blood.UI)
end
```

Добавь после:
```lua
if Blood.Modules.Exploits then
    Blood.Modules.Exploits.Init(Blood.UI)
end
```

### Шаг 3: Загрузи на GitHub и тестируй!

---

## Пример 3: Добавить новую вкладку

### В `core/ui.lua` найди:

```lua
local tabs = {
    Legit = window:addMenu({text = "Legit"}),
    Star = window:addMenu({text = "Star"}),
    Visuals = window:addMenu({text = "Visuals"}),
    Movement = window:addMenu({text = "Movement"}),
    Other = window:addMenu({text = "Other"}),
    Settings = window:addMenu({text = "Settings"}),
    Logs = window:addMenu({text = "Logs"})
}
```

### Добавь свою вкладку:

```lua
local tabs = {
    Legit = window:addMenu({text = "Legit"}),
    Star = window:addMenu({text = "Star"}),
    Visuals = window:addMenu({text = "Visuals"}),
    Movement = window:addMenu({text = "Movement"}),
    Other = window:addMenu({text = "Other"}),
    Exploits = window:addMenu({text = "Exploits"}), -- Новая вкладка
    Settings = window:addMenu({text = "Settings"}),
    Logs = window:addMenu({text = "Logs"})
}
```

### Теперь можешь использовать в модулях:

```lua
local exploitsTab = tabs.Exploits
local section = exploitsTab:addSection({text = "My Features"})
```

---

## 💡 Советы

1. **Всегда используй pcall()** для безопасности:
```lua
pcall(function()
    -- твой код
end)
```

2. **Логируй действия** через Utils:
```lua
Utils.AddLog("Feature enabled")
```

3. **Очищай соединения** в Destroy():
```lua
if MyConnection then
    MyConnection:Disconnect()
    MyConnection = nil
end
```

4. **Используй Utils функции**:
```lua
Utils.GetCharacter()
Utils.GetHumanoid()
Utils.GetRootPart()
Utils.IsKnockedOut(character)
Utils.SimulateMouseClick()
Utils.PressKey(Enum.KeyCode.E)
```

5. **Тестируй в безопасной среде** перед загрузкой на GitHub!

---

**Готово!** Теперь ты знаешь как добавлять свои функции в blood.c v2.0
