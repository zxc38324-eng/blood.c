-- blood.c UI Module

local UI = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function UI.Create()
    print("Creating UI...")
    
    -- Загружаем UI библиотеку
    local uiLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua"))
    local ui = uiLoader({rounding = false, theme = "cherry", smoothDragging = true})
    ui.autoDisableToggles = true
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local window = ui.newWindow({
        text = "blood.c v2.0", 
        resize = false, 
        size = Vector2.new(550, 400),
        position = Vector2.new((screenSize.X - 550) / 2, (screenSize.Y - 400) / 2)
    })
    
    -- Создаем вкладки
    local tabs = {
        Legit = window:addMenu({text = "Legit"}),
        Star = window:addMenu({text = "Star"}),
        Visuals = window:addMenu({text = "Visuals"}),
        Movement = window:addMenu({text = "Movement"}),
        Other = window:addMenu({text = "Other"}),
        Settings = window:addMenu({text = "Settings"}),
        Logs = window:addMenu({text = "Logs"})
    }
    
    -- Watermark
    local watermark = UI.CreateWatermark()
    
    return {
        ui = ui,
        window = window,
        tabs = tabs,
        watermark = watermark,
        Destroy = function()
            pcall(function()
                ui.destroy()
            end)
            pcall(function()
                if watermark then
                    watermark:Destroy()
                end
            end)
        end
    }
end

function UI.CreateWatermark()
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "BloodWatermark"
    WatermarkGui.ResetOnSpawn = false
    WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then 
        WatermarkGui.Parent = gethui() 
    else 
        WatermarkGui.Parent = CoreGui 
    end
    
    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Name = "Watermark"
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    WatermarkFrame.AnchorPoint = Vector2.new(1, 0)
    WatermarkFrame.Position = UDim2.new(1, -10, 0, 10)
    WatermarkFrame.Size = UDim2.new(0, 200, 0, 28)
    WatermarkFrame.BorderSizePixel = 0
    WatermarkFrame.ZIndex = 1
    WatermarkFrame.Parent = WatermarkGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = WatermarkFrame
    
    local TopLine = Instance.new("Frame")
    TopLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TopLine.BorderSizePixel = 0
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.ZIndex = 2
    TopLine.Parent = WatermarkFrame
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 30))
    })
    Gradient.Parent = TopLine
    
    local Text = Instance.new("TextLabel")
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.new(0, 0, 0, 2)
    Text.Size = UDim2.new(1, 0, 1, -2)
    Text.Font = Enum.Font.Gotham
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 13
    Text.Text = "blood.c v2.0 | " .. LocalPlayer.Name
    Text.ZIndex = 2
    Text.Parent = WatermarkFrame
    
    return WatermarkGui
end

return UI
