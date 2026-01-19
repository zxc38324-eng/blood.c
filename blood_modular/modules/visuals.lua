-- blood.c Visuals Module
-- ESP, Crosshair, Drochka

local Visuals = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Загружаем утилиты
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/core/utils.lua"))()

-- Настройки ESP
local ESP = {
    Enabled = false,
    Boxes = false,
    Names = false,
    Distance = false,
    Health = false,
    Color = Color3.fromRGB(255, 255, 255),
    Connection = nil,
    Data = {}
}

-- Настройки Crosshair
local Crosshair = {
    Enabled = false,
    Size = 10,
    Gap = 5,
    Thickness = 2,
    Color = Color3.fromRGB(255, 255, 255),
    Lines = {},
    Connection = nil
}

-- Настройки Drochka
local Drochka = {
    Enabled = false,
    Connection = nil,
    OriginalC0 = {}
}

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer or ESP.Data[player] then return end
    
    local data = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        health = Drawing.new("Text")
    }
    
    data.box.Thickness = 1
    data.box.Filled = false
    data.box.Visible = false
    data.box.Color = ESP.Color
    
    data.name.Size = 13
    data.name.Center = true
    data.name.Outline = true
    data.name.Visible = false
    data.name.Color = ESP.Color
    
    data.distance.Size = 12
    data.distance.Center = true
    data.distance.Outline = true
    data.distance.Visible = false
    data.distance.Color = ESP.Color
    
    data.health.Size = 12
    data.health.Center = true
    data.health.Outline = true
    data.health.Visible = false
    data.health.Color = Color3.fromRGB(0, 255, 0)
    
    ESP.Data[player] = data
end

local function RemoveESP(player)
    local data = ESP.Data[player]
    if data then
        for _, drawing in pairs(data) do
            pcall(function() drawing:Remove() end)
        end
        ESP.Data[player] = nil
    end
end

local function UpdateESP()
    if not ESP.Enabled then return end
    
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    for player, data in pairs(ESP.Data) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        local hide = not root or not hum or hum.Health <= 0
        if not hide then
            local pos, onScreen = cam:WorldToViewportPoint(root.Position)
            hide = not onScreen
        end
        
        if hide then
            data.box.Visible = false
            data.name.Visible = false
            data.distance.Visible = false
            data.health.Visible = false
        else
            local pos = cam:WorldToViewportPoint(root.Position)
            local headY = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0)).Y
            local legY = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0)).Y
            local h = math.abs(headY - legY)
            local w = h * 0.6
            local x, y = pos.X - w/2, headY
            
            -- Box
            if ESP.Boxes then
                data.box.Size = Vector2.new(w, h)
                data.box.Position = Vector2.new(x, y)
                data.box.Color = ESP.Color
                data.box.Visible = true
            else
                data.box.Visible = false
            end
            
            -- Name
            if ESP.Names then
                data.name.Text = player.Name
                data.name.Position = Vector2.new(pos.X, y - 15)
                data.name.Color = ESP.Color
                data.name.Visible = true
            else
                data.name.Visible = false
            end
            
            -- Distance
            if ESP.Distance then
                local myRoot = Utils.GetRootPart()
                if myRoot then
                    local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                    data.distance.Text = dist .. "m"
                    data.distance.Position = Vector2.new(pos.X, y + h + 5)
                    data.distance.Color = ESP.Color
                    data.distance.Visible = true
                end
            else
                data.distance.Visible = false
            end
            
            -- Health
            if ESP.Health then
                local healthPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
                data.health.Text = healthPercent .. "%"
                data.health.Position = Vector2.new(pos.X, y + h + 20)
                data.health.Color = Color3.fromRGB(255 - (healthPercent * 2.55), healthPercent * 2.55, 0)
                data.health.Visible = true
            else
                data.health.Visible = false
            end
        end
    end
end

-- Crosshair Functions
local function CreateCrosshair()
    for _, line in pairs(Crosshair.Lines) do
        pcall(function() line:Remove() end)
    end
    Crosshair.Lines = {}
    
    if not Crosshair.Enabled then
        UserInputService.MouseIconEnabled = true
        return
    end
    
    UserInputService.MouseIconEnabled = false
    
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Color = Crosshair.Color
        line.Thickness = Crosshair.Thickness
        line.Visible = true
        table.insert(Crosshair.Lines, line)
    end
end

local function UpdateCrosshair()
    if not Crosshair.Enabled or #Crosshair.Lines < 4 then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local x, y = mousePos.X, mousePos.Y
    local S = Crosshair
    
    S.Lines[1].From = Vector2.new(x, y - S.Gap - S.Size)
    S.Lines[1].To = Vector2.new(x, y - S.Gap)
    S.Lines[2].From = Vector2.new(x, y + S.Gap)
    S.Lines[2].To = Vector2.new(x, y + S.Gap + S.Size)
    S.Lines[3].From = Vector2.new(x - S.Gap - S.Size, y)
    S.Lines[3].To = Vector2.new(x - S.Gap, y)
    S.Lines[4].From = Vector2.new(x + S.Gap, y)
    S.Lines[4].To = Vector2.new(x + S.Gap + S.Size, y)
end

-- Drochka Animation
local function UpdateDrochka()
    if Drochka.Connection then
        Drochka.Connection:Disconnect()
        Drochka.Connection = nil
    end
    
    if Drochka.Enabled then
        Drochka.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local torso = char:FindFirstChild("UpperTorso")
                if torso then
                    local rightShoulder = torso:FindFirstChild("RightShoulder")
                    
                    if rightShoulder and rightShoulder:IsA("Motor6D") then
                        if not Drochka.OriginalC0.RightShoulder then
                            Drochka.OriginalC0.RightShoulder = rightShoulder.C0
                        end
                        
                        local time = tick()
                        local upDown = math.sin(time * 5) * 0.4
                        
                        rightShoulder.C0 = CFrame.new(1, 0.5, 0) 
                            * CFrame.Angles(math.rad(45), math.rad(0), math.rad(-15))
                            * CFrame.new(-0.2, -0.8 + upDown, 0.5)
                    end
                end
            end)
        end)
    else
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local torso = char:FindFirstChild("UpperTorso")
                if torso then
                    local rightShoulder = torso:FindFirstChild("RightShoulder")
                    if rightShoulder and Drochka.OriginalC0.RightShoulder then
                        rightShoulder.C0 = Drochka.OriginalC0.RightShoulder
                    end
                end
            end
        end)
        Drochka.OriginalC0 = {}
    end
end

-- Инициализация
function Visuals.Init(ui)
    Utils.AddLog("Visuals module loaded")
    
    local tabs = ui.tabs
    local visualsTab = tabs.Visuals
    
    -- ESP Section
    local espSection = visualsTab:addSection({text = "ESP", side = "left"})
    
    espSection:addToggle({text = "Enable ESP", state = false}):bindToEvent("onToggle", function(state)
        ESP.Enabled = state
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                CreateESP(player)
            end
        end
    end)
    
    espSection:addToggle({text = "Boxes", state = false}):bindToEvent("onToggle", function(state)
        ESP.Boxes = state
    end)
    
    espSection:addToggle({text = "Names", state = false}):bindToEvent("onToggle", function(state)
        ESP.Names = state
    end)
    
    espSection:addToggle({text = "Distance", state = false}):bindToEvent("onToggle", function(state)
        ESP.Distance = state
    end)
    
    espSection:addToggle({text = "Health", state = false}):bindToEvent("onToggle", function(state)
        ESP.Health = state
    end)
    
    -- Crosshair Section
    local crosshairSection = visualsTab:addSection({text = "Crosshair", side = "right"})
    
    crosshairSection:addToggle({text = "Enable Crosshair", state = false}):bindToEvent("onToggle", function(state)
        Crosshair.Enabled = state
        CreateCrosshair()
    end)
    
    crosshairSection:addSlider({text = "Size", min = 5, max = 30, step = 1, val = 10}):bindToEvent("onNewValue", function(v)
        Crosshair.Size = v
        CreateCrosshair()
    end)
    
    crosshairSection:addSlider({text = "Gap", min = 0, max = 20, step = 1, val = 5}):bindToEvent("onNewValue", function(v)
        Crosshair.Gap = v
        CreateCrosshair()
    end)
    
    -- Drochka Section
    local drochkaSection = visualsTab:addSection({text = "Drochka", side = "right"})
    
    drochkaSection:addToggle({text = "Enable Drochka", state = false}):bindToEvent("onToggle", function(state)
        Drochka.Enabled = state
        UpdateDrochka()
    end)
    
    -- Setup ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    
    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(RemoveESP)
    
    -- Update loops
    RunService.RenderStepped:Connect(function()
        UpdateESP()
        UpdateCrosshair()
    end)
end

function Visuals.Destroy()
    ESP.Enabled = false
    Crosshair.Enabled = false
    Drochka.Enabled = false
    
    for player, _ in pairs(ESP.Data) do
        RemoveESP(player)
    end
    
    for _, line in pairs(Crosshair.Lines) do
        pcall(function() line:Remove() end)
    end
    
    UpdateDrochka()
    
    UserInputService.MouseIconEnabled = true
end

return Visuals
