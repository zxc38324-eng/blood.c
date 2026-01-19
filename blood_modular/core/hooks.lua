-- blood.c Hooks Module
-- Обход античита

local Hooks = {}

local OldNamecall
local OldIndex
local OldNewIndex

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки спуфинга
local SpoofSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Enabled = true
}

function Hooks.Init()
    print("Installing anti-cheat bypass hooks...")
    
    -- Namecall Hook
    OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- Блокируем античит ремоуты
            if method == "FireServer" or method == "InvokeServer" then
                local remoteName = self.Name:lower()
                
                -- Список блокируемых ремоутов (добавь свои)
                if remoteName:find("anticheat") or 
                   remoteName:find("kick") or 
                   remoteName:find("ban") or
                   remoteName:find("log") then
                    warn("Blocked remote:", self.Name)
                    return
                end
            end
        end
        
        return OldNamecall(self, ...)
    end)
    
    -- Index Hook (спуфинг значений)
    OldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and SpoofSettings.Enabled then
            -- Спуфим Humanoid значения
            if self:IsA("Humanoid") then
                if key == "WalkSpeed" then
                    return SpoofSettings.WalkSpeed
                elseif key == "JumpPower" or key == "JumpHeight" then
                    return SpoofSettings.JumpPower
                end
            end
        end
        
        return OldIndex(self, key)
    end)
    
    -- NewIndex Hook (блокируем изменения)
    OldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
        if not checkcaller() then
            -- Разрешаем нашему скрипту менять значения
            return OldNewIndex(self, key, value)
        end
        
        return OldNewIndex(self, key, value)
    end)
    
    print("Hooks installed successfully!")
end

function Hooks.SetSpoof(walkspeed, jumppower)
    SpoofSettings.WalkSpeed = walkspeed or 16
    SpoofSettings.JumpPower = jumppower or 50
end

function Hooks.ToggleSpoof(enabled)
    SpoofSettings.Enabled = enabled
end

function Hooks.Destroy()
    print("Removing hooks...")
    
    if OldNamecall then
        hookmetamethod(game, "__namecall", OldNamecall)
    end
    
    if OldIndex then
        hookmetamethod(game, "__index", OldIndex)
    end
    
    if OldNewIndex then
        hookmetamethod(game, "__newindex", OldNewIndex)
    end
end

return Hooks
