-- blood.c Misc Module
-- Auto Reload, Auto Stomp, Anti AFK

local Misc = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Загружаем утилиты
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/core/utils.lua"))()

-- Настройки
local Settings = {
    AutoReload = {Enabled = false, Loop = nil},
    AutoStomp = {Enabled = false, Loop = nil},
    AntiAFK = {Enabled = false, Connection = nil}
}

-- Auto Reload
local function StartAutoReload()
    if Settings.AutoReload.Loop then return end
    
    Settings.AutoReload.Loop = task.spawn(function()
        while Settings.AutoReload.Enabled do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            local ammo = tool:FindFirstChild("Ammo")
                            if ammo and ammo.Value <= 0 then
                                Utils.PressKey(Enum.KeyCode.R)
                            end
                            break
                        end
                    end
                end
            end)
            task.wait(0.15)
        end
        Settings.AutoReload.Loop = nil
    end)
end

local function StopAutoReload()
    Settings.AutoReload.Enabled = false
    Settings.AutoReload.Loop = nil
end

-- Auto Stomp
local function StartAutoStomp()
    if Settings.AutoStomp.Loop then return end
    
    Settings.AutoStomp.Loop = task.spawn(function()
        while Settings.AutoStomp.Enabled do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local myRoot = char:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local be = player.Character:FindFirstChild("BodyEffects")
                                if be then
                                    local ko = be:FindFirstChild("K.O")
                                    if ko and ko.Value == true then
                                        local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                        if theirRoot then
                                            local dist = (myRoot.Position - theirRoot.Position).Magnitude
                                            if dist <= 12 then
                                                Utils.PressKey(Enum.KeyCode.E)
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.08)
        end
        Settings.AutoStomp.Loop = nil
    end)
end

local function StopAutoStomp()
    Settings.AutoStomp.Enabled = false
    Settings.AutoStomp.Loop = nil
end

-- Anti AFK
local function UpdateAntiAFK()
    if Settings.AntiAFK.Connection then
        Settings.AntiAFK.Connection:Disconnect()
        Settings.AntiAFK.Connection = nil
    end
    
    if Settings.AntiAFK.Enabled then
        local vu = game:GetService("VirtualUser")
        Settings.AntiAFK.Connection = LocalPlayer.Idled:Connect(function()
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    end
end

-- Инициализация
function Misc.Init(ui)
    Utils.AddLog("Misc module loaded")
    
    local tabs = ui.tabs
    local otherTab = tabs.Other
    
    -- Weapons Section
    local weaponsSection = otherTab:addSection({text = "Weapons", side = "left"})
    
    weaponsSection:addToggle({text = "Auto Reload", state = false}):bindToEvent("onToggle", function(state)
        Settings.AutoReload.Enabled = state
        Utils.AddLog("Auto Reload " .. (state and "enabled" or "disabled"))
        if state then
            StartAutoReload()
        else
            StopAutoReload()
        end
    end)
    
    weaponsSection:addToggle({text = "Auto Stomp", state = false}):bindToEvent("onToggle", function(state)
        Settings.AutoStomp.Enabled = state
        Utils.AddLog("Auto Stomp " .. (state and "enabled" or "disabled"))
        if state then
            StartAutoStomp()
        else
            StopAutoStomp()
        end
    end)
    
    -- Misc Section
    local miscSection = otherTab:addSection({text = "Misc", side = "right"})
    
    miscSection:addToggle({text = "Anti AFK", state = false}):bindToEvent("onToggle", function(state)
        Settings.AntiAFK.Enabled = state
        Utils.AddLog("Anti AFK " .. (state and "enabled" or "disabled"))
        UpdateAntiAFK()
    end)
end

function Misc.Destroy()
    Settings.AutoReload.Enabled = false
    Settings.AutoStomp.Enabled = false
    Settings.AntiAFK.Enabled = false
    
    StopAutoReload()
    StopAutoStomp()
    UpdateAntiAFK()
end

return Misc
