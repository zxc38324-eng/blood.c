-- blood.c Movement Module
-- Флай, Спид, Телепорт

local Movement = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Загружаем утилиты
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/core/utils.lua"))()

-- Настройки
local Settings = {
    Walkspeed = {Enabled = false, Value = 16, Connection = nil},
    JumpPower = {Enabled = false, Value = 50, Connection = nil},
    Fly = {Enabled = false, Speed = 50, Connection = nil},
    Noclip = {Enabled = false, Connection = nil},
    InfinityJump = {Enabled = false, Connection = nil}
}

local DefaultWalkSpeed = 16
local DefaultJumpPower = 50

-- Walkspeed
local function ApplyWalkspeed()
    if Settings.Walkspeed.Connection then
        Settings.Walkspeed.Connection:Disconnect()
        Settings.Walkspeed.Connection = nil
    end
    
    if Settings.Walkspeed.Enabled then
        Settings.Walkspeed.Connection = RunService.RenderStepped:Connect(function(dt)
            local hum = Utils.GetHumanoid()
            local root = Utils.GetRootPart()
            if not hum or not root then return end
            
            if hum.MoveDirection.Magnitude > 0 then
                local boost = (Settings.Walkspeed.Value - DefaultWalkSpeed) * dt
                root.CFrame = root.CFrame + (hum.MoveDirection * boost)
            end
        end)
    end
end

-- JumpPower
local function ApplyJumpPower()
    if Settings.JumpPower.Connection then
        Settings.JumpPower.Connection:Disconnect()
        Settings.JumpPower.Connection = nil
    end
    
    if Settings.JumpPower.Enabled then
        Settings.JumpPower.Connection = RunService.RenderStepped:Connect(function()
            local hum = Utils.GetHumanoid()
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = Settings.JumpPower.Value
            end
        end)
    else
        pcall(function()
            local hum = Utils.GetHumanoid()
            if hum then
                hum.JumpPower = DefaultJumpPower
            end
        end)
    end
end

-- Fly
local function ApplyFly()
    if Settings.Fly.Connection then
        Settings.Fly.Connection:Disconnect()
        Settings.Fly.Connection = nil
    end
    
    local hum = Utils.GetHumanoid()
    local root = Utils.GetRootPart()
    
    if Settings.Fly.Enabled and root and hum then
        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.Name = "BloodGyro"
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 9e4
        BodyGyro.Parent = root
        
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Name = "BloodVelocity"
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = root
        
        hum.PlatformStand = true
        
        Settings.Fly.Connection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly.Enabled then return end
            local root = Utils.GetRootPart()
            if not root then return end
            
            local gyro = root:FindFirstChild("BloodGyro")
            local vel = root:FindFirstChild("BloodVelocity")
            if not gyro or not vel then return end
            
            local cam = workspace.CurrentCamera
            gyro.CFrame = cam.CFrame
            
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                vel.Velocity = moveDir.Unit * Settings.Fly.Speed
            else
                vel.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if root then
            local gyro = root:FindFirstChild("BloodGyro")
            local vel = root:FindFirstChild("BloodVelocity")
            if gyro then gyro:Destroy() end
            if vel then vel:Destroy() end
        end
        if hum then
            hum.PlatformStand = false
        end
    end
end

-- Noclip
local function ApplyNoclip()
    if Settings.Noclip.Connection then
        Settings.Noclip.Connection:Disconnect()
        Settings.Noclip.Connection = nil
    end
    
    if Settings.Noclip.Enabled then
        Settings.Noclip.Connection = RunService.Stepped:Connect(function()
            local char = Utils.GetCharacter()
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- Infinity Jump
local function ApplyInfinityJump()
    if Settings.InfinityJump.Connection then
        Settings.InfinityJump.Connection:Disconnect()
        Settings.InfinityJump.Connection = nil
    end
    
    if Settings.InfinityJump.Enabled then
        Settings.InfinityJump.Connection = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local hum = Utils.GetHumanoid()
                local root = Utils.GetRootPart()
                if hum and root then
                    local jumpVel = Settings.JumpPower.Enabled and Settings.JumpPower.Value or 50
                    root.Velocity = Vector3.new(root.Velocity.X, jumpVel, root.Velocity.Z)
                end
            end)
        end)
    end
end

-- Инициализация
function Movement.Init(ui)
    Utils.AddLog("Movement module loaded")
    
    local tabs = ui.tabs
    local movementTab = tabs.Movement
    
    -- Speed Section
    local speedSection = movementTab:addSection({text = "Speed", side = "left"})
    
    speedSection:addToggle({text = "Walkspeed", state = false}):bindToEvent("onToggle", function(state)
        Settings.Walkspeed.Enabled = state
        ApplyWalkspeed()
        Utils.AddLog("Walkspeed " .. (state and "enabled" or "disabled"))
    end)
    
    speedSection:addSlider({text = "Speed", min = 16, max = 350, step = 1, val = 50}):bindToEvent("onNewValue", function(value)
        Settings.Walkspeed.Value = value
    end)
    
    -- Jump Section
    local jumpSection = movementTab:addSection({text = "Jump", side = "right"})
    
    jumpSection:addToggle({text = "JumpPower", state = false}):bindToEvent("onToggle", function(state)
        Settings.JumpPower.Enabled = state
        ApplyJumpPower()
        Utils.AddLog("JumpPower " .. (state and "enabled" or "disabled"))
    end)
    
    jumpSection:addSlider({text = "Power", min = 50, max = 350, step = 1, val = 100}):bindToEvent("onNewValue", function(value)
        Settings.JumpPower.Value = value
        if Settings.JumpPower.Enabled then
            ApplyJumpPower()
        end
    end)
    
    jumpSection:addToggle({text = "Infinity Jump", state = false}):bindToEvent("onToggle", function(state)
        Settings.InfinityJump.Enabled = state
        ApplyInfinityJump()
        Utils.AddLog("Infinity Jump " .. (state and "enabled" or "disabled"))
    end)
    
    -- Misc Section
    local miscSection = movementTab:addSection({text = "Misc", side = "left"})
    
    miscSection:addToggle({text = "Fly", state = false}):bindToEvent("onToggle", function(state)
        Settings.Fly.Enabled = state
        ApplyFly()
        Utils.AddLog("Fly " .. (state and "enabled" or "disabled"))
    end)
    
    miscSection:addSlider({text = "Fly Speed", min = 10, max = 200, step = 1, val = 50}):bindToEvent("onNewValue", function(value)
        Settings.Fly.Speed = value
    end)
    
    miscSection:addToggle({text = "Noclip", state = false}):bindToEvent("onToggle", function(state)
        Settings.Noclip.Enabled = state
        ApplyNoclip()
        Utils.AddLog("Noclip " .. (state and "enabled" or "disabled"))
    end)
end

function Movement.Destroy()
    Settings.Walkspeed.Enabled = false
    Settings.JumpPower.Enabled = false
    Settings.Fly.Enabled = false
    Settings.Noclip.Enabled = false
    Settings.InfinityJump.Enabled = false
    
    ApplyWalkspeed()
    ApplyJumpPower()
    ApplyFly()
    ApplyNoclip()
    ApplyInfinityJump()
end

return Movement
