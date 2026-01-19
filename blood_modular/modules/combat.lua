-- blood.c Combat Module
-- Камлок, Хитбокс, Автошот

local Combat = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Загружаем утилиты
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/core/utils.lua"))()

-- Настройки Camlock
local Camlock = {
    Enabled = false,
    Target = nil,
    Smoothness = 100,
    Prediction = 0,
    Connection = nil
}

-- Настройки FOV
local FOV = {
    Enabled = false,
    Size = 200,
    Circle = nil
}

-- Настройки Hitbox
local Hitbox = {
    Enabled = false,
    Size = 5,
    Transparency = 0.5,
    Connection = nil,
    OriginalSizes = {}
}

-- Настройки Auto Shot
local AutoShot = {
    Enabled = false,
    Delay = 0,
    Targets = {},
    Connections = {}
}

-- Настройки Fast Rev
local FastRev = {
    Enabled = false,
    Connection = nil,
    IsMouseDown = false,
    LastShotTime = 0
}

-- FOV Circle
local function CreateFOVCircle()
    if FOV.Circle then
        pcall(function() FOV.Circle:Remove() end)
        FOV.Circle = nil
    end
    
    if FOV.Enabled then
        FOV.Circle = Drawing.new("Circle")
        FOV.Circle.Thickness = 2
        FOV.Circle.NumSides = 64
        FOV.Circle.Radius = FOV.Size
        FOV.Circle.Filled = false
        FOV.Circle.Visible = true
        FOV.Circle.Color = Color3.fromRGB(160, 130, 255)
        FOV.Circle.Transparency = 1
    end
end

local function UpdateFOVCircle()
    if FOV.Circle and FOV.Enabled then
        local mousePos = UserInputService:GetMouseLocation()
        FOV.Circle.Position = mousePos
        FOV.Circle.Radius = FOV.Size
        FOV.Circle.Visible = true
    end
end

RunService.RenderStepped:Connect(function()
    if FOV.Enabled then
        UpdateFOVCircle()
    end
end)

-- Camlock
local function UpdateCamlock()
    if Camlock.Connection then
        Camlock.Connection:Disconnect()
        Camlock.Connection = nil
    end
    
    if Camlock.Enabled and Camlock.Target then
        Camlock.Connection = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not Camlock.Target or not Camlock.Target.Character then
                    Camlock.Target = nil
                    if Camlock.Connection then
                        Camlock.Connection:Disconnect()
                        Camlock.Connection = nil
                    end
                    Utils.AddLog("Camlock: Target lost")
                    return
                end
                
                local char = Camlock.Target.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or not rootPart or Utils.IsKnockedOut(char) then
                    local targetName = Camlock.Target.Name
                    Camlock.Target = nil
                    if Camlock.Connection then
                        Camlock.Connection:Disconnect()
                        Camlock.Connection = nil
                    end
                    Utils.AddLog("Camlock: Target eliminated (" .. targetName .. ")")
                    return
                end
                
                local cam = workspace.CurrentCamera
                local velocity = rootPart.Velocity
                local prediction = velocity * Camlock.Prediction
                local targetPos = rootPart.Position + prediction
                local targetCFrame = CFrame.new(cam.CFrame.Position, targetPos)
                
                if Camlock.Smoothness >= 100 then
                    cam.CFrame = targetCFrame
                else
                    local smoothFactor = (100 - Camlock.Smoothness) / 100
                    cam.CFrame = cam.CFrame:Lerp(targetCFrame, 1 - smoothFactor)
                end
            end)
        end)
    end
end

-- Hitbox Expander
local function UpdateHitbox()
    if Hitbox.Connection then
        Hitbox.Connection:Disconnect()
        Hitbox.Connection = nil
    end
    
    for player, data in pairs(Hitbox.OriginalSizes) do
        pcall(function()
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and data.size then
                    hrp.Size = data.size
                    hrp.Transparency = data.transparency
                    hrp.CanCollide = data.canCollide
                end
            end
        end)
    end
    Hitbox.OriginalSizes = {}
    
    if Hitbox.Enabled then
        Hitbox.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        
                        if hrp and humanoid and humanoid.Health > 0 then
                            if not Hitbox.OriginalSizes[player] then
                                Hitbox.OriginalSizes[player] = {
                                    size = hrp.Size,
                                    transparency = hrp.Transparency,
                                    canCollide = hrp.CanCollide
                                }
                            end
                            
                            hrp.Size = Vector3.new(Hitbox.Size, Hitbox.Size, Hitbox.Size)
                            hrp.Transparency = Hitbox.Transparency
                            hrp.CanCollide = false
                        end
                    end
                end
            end)
        end)
    end
end

-- Auto Shot
local function UpdateAutoShot()
    for _, conn in pairs(AutoShot.Connections) do
        if conn then conn:Disconnect() end
    end
    AutoShot.Connections = {}
    
    if not AutoShot.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and AutoShot.Targets[player.Name] then
            local function setupCharacter(char)
                task.wait(0.5)
                
                local conn = char.ChildAdded:Connect(function(tool)
                    if tool:IsA("Tool") then
                        local activateConn = tool.Activated:Connect(function()
                            pcall(function()
                                task.wait(AutoShot.Delay / 1000)
                                Utils.SimulateMouseClick()
                                Utils.AddLog("Auto Shot: Responded to " .. player.Name)
                            end)
                        end)
                        table.insert(AutoShot.Connections, activateConn)
                    end
                end)
                table.insert(AutoShot.Connections, conn)
            end
            
            if player.Character then
                setupCharacter(player.Character)
            end
            
            local charConn = player.CharacterAdded:Connect(setupCharacter)
            table.insert(AutoShot.Connections, charConn)
        end
    end
end

-- Fast Rev
local function UpdateFastRev()
    if FastRev.Connection then
        FastRev.Connection:Disconnect()
        FastRev.Connection = nil
    end
    
    if FastRev.Enabled then
        FastRev.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if not FastRev.IsMouseDown then return end
                
                local currentTime = tick()
                if (currentTime - FastRev.LastShotTime) < 0.025 then return end
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    FastRev.LastShotTime = currentTime
                end
            end)
        end)
    end
end

-- Mouse tracking for Fast Rev
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        FastRev.IsMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        FastRev.IsMouseDown = false
    end
end)

-- Инициализация модуля
function Combat.Init(ui)
    Utils.AddLog("Combat module loaded")
    
    local tabs = ui.tabs
    
    -- Legit Tab - Camlock
    local camlockSection = tabs.Legit:addSection({text = "Camlock", side = "left"})
    
    camlockSection:addToggle({text = "Enable Camlock", state = false}):bindToEvent("onToggle", function(state)
        Camlock.Enabled = state
        Utils.AddLog("Camlock " .. (state and "enabled" or "disabled"))
        if not state then
            Camlock.Target = nil
            UpdateCamlock()
        end
    end)
    
    camlockSection:addSlider({text = "Smoothness", min = 1, max = 100, step = 1, val = 100}):bindToEvent("onNewValue", function(v)
        Camlock.Smoothness = v
    end)
    
    camlockSection:addSlider({text = "Prediction", min = 0, max = 0.5, step = 0.01, val = 0}):bindToEvent("onNewValue", function(v)
        Camlock.Prediction = v
    end)
    
    local camlockHotkey = camlockSection:addHotkey({text = "Camlock Bind"})
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if camlockHotkey:getHotkey() and input.KeyCode == camlockHotkey:getHotkey() then
                if Camlock.Enabled then
                    if Camlock.Target then
                        Camlock.Target = nil
                        UpdateCamlock()
                        Utils.AddLog("Camlock: Target released")
                    else
                        local target = Utils.GetClosestPlayer(FOV.Enabled and FOV.Size or math.huge)
                        if target then
                            Camlock.Target = target
                            UpdateCamlock()
                            Utils.AddLog("Camlock: Locked onto " .. Camlock.Target.Name)
                        else
                            Utils.AddLog("Camlock: No target found")
                        end
                    end
                end
            end
        end
    end)
    
    -- FOV Section
    local fovSection = tabs.Legit:addSection({text = "FOV Circle", side = "right"})
    
    fovSection:addToggle({text = "Show FOV", state = false}):bindToEvent("onToggle", function(state)
        FOV.Enabled = state
        CreateFOVCircle()
    end)
    
    fovSection:addSlider({text = "FOV Size", min = 50, max = 500, step = 10, val = 200}):bindToEvent("onNewValue", function(v)
        FOV.Size = v
        if FOV.Enabled then
            CreateFOVCircle()
        end
    end)
    
    -- Hitbox Section
    local hitboxSection = tabs.Legit:addSection({text = "Hitbox Expander", side = "right"})
    
    hitboxSection:addToggle({text = "Enable Hitbox", state = false}):bindToEvent("onToggle", function(state)
        Hitbox.Enabled = state
        UpdateHitbox()
    end)
    
    hitboxSection:addSlider({text = "Size", min = 1, max = 20, step = 1, val = 5}):bindToEvent("onNewValue", function(value)
        Hitbox.Size = value
        if Hitbox.Enabled then
            UpdateHitbox()
        end
    end)
    
    -- Star Tab - Auto Shot
    local autoShotSection = tabs.Star:addSection({text = "Auto Shot", side = "left"})
    
    autoShotSection:addToggle({text = "Enable Auto Shot", state = false}):bindToEvent("onToggle", function(state)
        AutoShot.Enabled = state
        UpdateAutoShot()
    end)
    
    autoShotSection:addSlider({text = "Delay (ms)", min = 0, max = 500, step = 10, val = 0}):bindToEvent("onNewValue", function(v)
        AutoShot.Delay = v
    end)
    
    -- Fast Rev
    local fastRevSection = tabs.Star:addSection({text = "Fast Rev", side = "left"})
    
    fastRevSection:addToggle({text = "Enable Fast Rev", state = false}):bindToEvent("onToggle", function(state)
        FastRev.Enabled = state
        UpdateFastRev()
    end)
end

function Combat.Destroy()
    Camlock.Enabled = false
    FOV.Enabled = false
    Hitbox.Enabled = false
    AutoShot.Enabled = false
    FastRev.Enabled = false
    
    UpdateCamlock()
    UpdateHitbox()
    UpdateAutoShot()
    UpdateFastRev()
    
    if FOV.Circle then
        pcall(function() FOV.Circle:Remove() end)
    end
end

return Combat
