local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Random ScreenGui name
local function generateRandomName(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        name = name .. charset:sub(rand, rand)
    end
    return name
end

local guiName = generateRandomName(16)

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 260)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Leo's Tools for DPI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Subtitle - Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -20)
credits.BackgroundTransparency = 1
credits.Text = "by Leo"
credits.TextColor3 = Color3.fromRGB(170, 170, 170)
credits.Font = Enum.Font.Gotham
credits.TextSize = 12
credits.Parent = mainFrame

-- Button Template Function with Animation
local function createButton(parent, name, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = position
    button.Text = name .. ": OFF"
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = parent

    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)

    return button
end

-- Main Section Buttons
local autoAttackBtn = createButton(mainFrame, "Auto Attack", UDim2.new(0, 10, 0, 50))
local divineBlessingBtn = createButton(mainFrame, "Divine Blessing", UDim2.new(0, 10, 0, 95))

-- Visuals Frame
local visualsFrame = Instance.new("Frame")
visualsFrame.Size = UDim2.new(0, 240, 0, 200)
visualsFrame.Position = UDim2.new(0, 50, 0, 320)
visualsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
visualsFrame.BorderSizePixel = 0
visualsFrame.Active = true
visualsFrame.Draggable = true
visualsFrame.Parent = screenGui

-- Visuals Title
local visualsTitle = Instance.new("TextLabel")
visualsTitle.Size = UDim2.new(1, 0, 0, 40)
visualsTitle.BackgroundTransparency = 1
visualsTitle.Text = "VISUALS"
visualsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
visualsTitle.Font = Enum.Font.GothamBold
visualsTitle.TextSize = 18
visualsTitle.Parent = visualsFrame

-- Visuals Section Buttons
local showDirtyLinensBtn = createButton(visualsFrame, "Show Dirty Linens", UDim2.new(0, 10, 0, 50))
local removeInsanityBlurBtn = createButton(visualsFrame, "Remove Insanity Blur", UDim2.new(0, 10, 0, 90))
local hideInsanityPropsBtn = createButton(visualsFrame, "Hide Insanity Props", UDim2.new(0, 10, 0, 130))
