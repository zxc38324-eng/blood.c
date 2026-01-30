-- blood.c Modular Loader
-- Привязка к конкретной игре

print("blood.c: Starting loader...")

local ALLOWED_GAMES = {
    [120822170036689] = "Boom Hood", -- Твоя игра
    [2788229376] = "Da Hood",
    [7213786345] = "Da Hood VC",
    [9825515356] = "Hood Customs",
}

local currentPlaceId = game.PlaceId
print("blood.c: Current PlaceId:", currentPlaceId)

-- Проверка игры
if not ALLOWED_GAMES[currentPlaceId] then
    warn("blood.c: This game is not supported!")
    warn("Current PlaceId:", currentPlaceId)
    warn("Supported games:")
    for id, name in pairs(ALLOWED_GAMES) do
        warn("  -", name, "(PlaceId:", id .. ")")
    end
    return
end

print("blood.c: Loading for", ALLOWED_GAMES[currentPlaceId])

-- Главный модуль
local Blood = {
    Version = "2.0.0",
    Game = ALLOWED_GAMES[currentPlaceId],
    PlaceId = currentPlaceId,
    Modules = {}
}

-- Базовый URL для загрузки модулей
local BASE_URL = "https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/"

-- Функция загрузки модулей
local function LoadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. path))()
    end)
    
    if success then
        return result
    else
        warn("Failed to load module:", path, result)
        return nil
    end
end

-- Загружаем ядро
print("Loading core modules...")
Blood.Modules.Hooks = LoadModule("core/hooks.lua")
Blood.Modules.UI = LoadModule("core/ui_new.lua")
Blood.Modules.Utils = LoadModule("core/utils.lua")

-- Загружаем игровые модули
print("Loading game modules...")
Blood.Modules.Combat = LoadModule("modules/combat.lua")
Blood.Modules.Movement = LoadModule("modules/movement.lua")
Blood.Modules.Visuals = LoadModule("modules/visuals.lua")
Blood.Modules.Misc = LoadModule("modules/misc.lua")

-- Инициализация
function Blood.Init()
    print("Initializing blood.c...")
    
    -- Устанавливаем хуки для обхода античита
    if Blood.Modules.Hooks then
        Blood.Modules.Hooks.Init()
    end
    
    -- Создаем UI
    if Blood.Modules.UI then
        Blood.UI = Blood.Modules.UI.Create()
        
        if not Blood.UI then
            warn("Failed to create UI! Check your internet connection.")
            return
        end
    else
        warn("UI module not loaded!")
        return
    end
    
    -- Инициализируем модули
    if Blood.Modules.Combat then
        Blood.Modules.Combat.Init(Blood.UI)
    end
    
    if Blood.Modules.Movement then
        Blood.Modules.Movement.Init(Blood.UI)
    end
    
    if Blood.Modules.Visuals then
        Blood.Modules.Visuals.Init(Blood.UI)
    end
    
    if Blood.Modules.Misc then
        Blood.Modules.Misc.Init(Blood.UI)
    end
    
    print("blood.c loaded successfully!")
    print("Version:", Blood.Version)
    print("Game:", Blood.Game)
end

-- Выгрузка
function Blood.Destroy()
    print("Unloading blood.c...")
    
    for name, module in pairs(Blood.Modules) do
        if module and module.Destroy then
            pcall(function()
                module.Destroy()
            end)
        end
    end
    
    if Blood.UI and Blood.UI.Destroy then
        Blood.UI.Destroy()
    end
    
    print("blood.c unloaded!")
end

-- Сохраняем в глобальную переменную
getgenv().BloodCheat = Blood

-- Запускаем
Blood.Init()

return Blood
