-- V1.3
-- By leothesavior aka @pridescruelty
-- https://www.youtube.com/@pridescruelty/

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Prevent duplicate GUI creation
local guiName = "LeoToolsGUI"
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild(guiName) then
    return {} -- Don't load again if already exists
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main Container
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, -60)
contentArea.Position = UDim2.new(0, 100, 0, 40)
contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

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
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = position
    button.Text = name
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

-- Sidebar Buttons
local mainSectionBtn = createButton(sidebar, "Main", UDim2.new(0, 5, 0, 10))
local visualsSectionBtn = createButton(sidebar, "Visuals", UDim2.new(0, 5, 0, 60))
local settingsSectionBtn = createButton(sidebar, "Settings", UDim2.new(0, 5, 0, 110))

-- Create Sections Inside Content Area
local mainSection = Instance.new("Frame")
mainSection.Size = UDim2.new(1, 0, 1, 0)
mainSection.Position = UDim2.new(0, 0, 0, 0)
mainSection.BackgroundTransparency = 1
mainSection.Parent = contentArea

local visualsSection = Instance.new("Frame")
visualsSection.Size = UDim2.new(1, 0, 1, 0)
visualsSection.Position = UDim2.new(0, 0, 0, 0)
visualsSection.BackgroundTransparency = 1
visualsSection.Parent = contentArea

local settingsSection = Instance.new("Frame")
settingsSection.Size = UDim2.new(1, 0, 1, 0)
settingsSection.Position = UDim2.new(0, 0, 0, 0)
settingsSection.BackgroundTransparency = 1
settingsSection.Parent = contentArea

-- Clear content area and show selected section
local function showSection(frameToShow)
    for _, child in ipairs(contentArea:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = (child == frameToShow)
        end
    end
end

-- Show Main by default
showSection(mainSection)

-- Declare buttons locally so we can return them
local autoAttackBtn
local divineBlessingBtn
local showDirtyLinensBtn
local removeInsanityBlurBtn
local hideInsanityPropsBtn

-- Main Section Buttons
autoAttackBtn = createButton(mainSection, "Auto Attack", UDim2.new(0, 10, 0, 20))
divineBlessingBtn = createButton(mainSection, "Divine Blessing", UDim2.new(0, 10, 0, 70))

-- Visuals Section Buttons
showDirtyLinensBtn = createButton(visualsSection, "Show Dirty Linens", UDim2.new(0, 10, 0, 20))
removeInsanityBlurBtn = createButton(visualsSection, "Remove Insanity Blur", UDim2.new(0, 10, 0, 70))
hideInsanityPropsBtn = createButton(visualsSection, "Hide Insanity Props", UDim2.new(0, 10, 0, 120))

-- Settings Section Buttons
local unloadGuiBtn = createButton(settingsSection, "Unload GUI", UDim2.new(0, 10, 0, 20))

-- Sidebar Button Actions
mainSectionBtn.MouseButton1Click:Connect(function()
    showSection(mainSection)
end)

visualsSectionBtn.MouseButton1Click:Connect(function()
    showSection(visualsSection)
end)

settingsSectionBtn.MouseButton1Click:Connect(function()
    showSection(settingsSection)
end)

-- Return all buttons
return {
    autoAttackBtn = autoAttackBtn,
    divineBlessingBtn = divineBlessingBtn,
    showDirtyLinensBtn = showDirtyLinensBtn,
    removeInsanityBlurBtn = removeInsanityBlurBtn,
    hideInsanityPropsBtn = hideInsanityPropsBtn,
    unloadGuiBtn = unloadGuiBtn
}
