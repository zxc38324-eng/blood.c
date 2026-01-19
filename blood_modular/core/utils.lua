-- blood.c Utils Module
-- Общие функции

local Utils = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Логирование
Utils.Logs = {}
Utils.MaxLogs = 100

function Utils.AddLog(message)
    local timestamp = os.date("%H:%M:%S")
    local entry = string.format("[%s] %s", timestamp, message)
    table.insert(Utils.Logs, entry)
    
    if #Utils.Logs > Utils.MaxLogs then
        table.remove(Utils.Logs, 1)
    end
    
    print(entry)
end

-- Получение персонажа
function Utils.GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

function Utils.GetHumanoid()
    local char = Utils.GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils.GetRootPart()
    local char = Utils.GetCharacter()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

-- Проверка на K.O./смерть
function Utils.IsKnockedOut(character)
    if not character then return false end
    
    local be = character:FindFirstChild("BodyEffects")
    if be then
        local ko = be:FindFirstChild("K.O")
        if ko and ko.Value == true then
            return true
        end
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Dead or 
           state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll then
            return true
        end
        if humanoid.Health <= 0 then
            return true
        end
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local grab = rootPart:FindFirstChild("GRABBING_CONSTRAINT")
        if grab then
            return true
        end
    end
    
    return false
end

-- Получение ближайшего игрока
function Utils.GetClosestPlayer(maxDistance)
    local closestPlayer = nil
    local shortestDistance = maxDistance or math.huge
    local camera = workspace.CurrentCamera
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart and not Utils.IsKnockedOut(char) then
                local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Симуляция клика мыши
function Utils.SimulateMouseClick()
    task.spawn(function()
        pcall(function()
            if mouse1click then
                mouse1click()
            end
        end)
        
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end)
    end)
end

-- Нажатие клавиши
function Utils.PressKey(keyCode)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true, keyCode, false, game)
        task.defer(function()
            VIM:SendKeyEvent(false, keyCode, false, game)
        end)
    end)
end

-- Уведомления
function Utils.Notify(title, message, duration)
    duration = duration or 3
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration
        })
    end)
end

function Utils.Destroy()
    -- Очистка
end

return Utils
