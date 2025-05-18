-- leo's UI library
-- V1.7.3

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplicate GUI creation
local guiName = "LeoToolsGUI"
if PlayerGui:FindFirstChild(guiName) then
    return {} -- Don't load again
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

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 30)
statusText.Position = UDim2.new(0, 10, 0, 200) -- moved 30px up
statusText.BackgroundTransparency = 1
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.Text = "Time: Loading... | Blurs: Loading..."
statusText.Parent = mainSection

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

-- Function to update the status text
local function updateStatusText()
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local insanityValue = character:GetAttribute("Insanity") or "Blur value not found, check F9"
    local currentTime = game.Lighting.TimeOfDay -- Get current time in HH:MM:SS format

    statusText.Text = string.format("Time: " .. currentTime .. " | Blurs: " .. insanityValue)
end

-- Clear content area and show selected section
local function showSection(frameToShow)
    for _, child in ipairs(contentArea:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = (child == frameToShow)
        end
    end

    -- Animate content area
    contentArea.Position = UDim2.new(1, -100, 0, 40)
    contentArea.BackgroundTransparency = 1
    TweenService:Create(contentArea, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 100, 0, 40),
        BackgroundTransparency = 0
    }):Play()

    -- Highlight selected tab
    for _, btn in pairs({mainSectionBtn, visualsSectionBtn, settingsSectionBtn}) do
        if btn then
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    if frameToShow == mainSection then
        TweenService:Create(mainSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    elseif frameToShow == visualsSection then
        TweenService:Create(visualsSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    elseif frameToShow == settingsSection then
        TweenService:Create(settingsSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end
end

-- Show Main by default
showSection(mainSection)

-- Declare buttons locally so we can return them
local autoAttackBtn
local divineBlessingBtn
local showDirtyLinensBtn
local hideInsanityPropsBtn
local unloadGuiBtn

-- Main Section Buttons
autoAttackBtn = createButton(mainSection, "Auto Attack", UDim2.new(0, 10, 0, 20))
divineBlessingBtn = createButton(mainSection, "Divine Blessing", UDim2.new(0, 10, 0, 70))

-- Door Attack Button
doorAttackBtn = createButton(mainSection, "Door Attack (Only Big Monster)", UDim2.new(0, 10, 0, 120))

-- Visuals Section Buttons
showDirtyLinensBtn = createButton(visualsSection, "Show Dirty Linens", UDim2.new(0, 10, 0, 20))
hideInsanityPropsBtn = createButton(visualsSection, "Hide Insanity Props", UDim2.new(0, 10, 0, 70))

-- Settings Section Buttons
unloadGuiBtn = createButton(settingsSection, "Unload GUI", UDim2.new(0, 10, 0, 20))

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

-- GUI Visibility Toggle (Insert key)
local guiVisible = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        guiVisible = not guiVisible
        mainFrame.Visible = guiVisible
    end
end)

task.spawn(function()
    while true do
        updateStatusText()
        task.wait(1)
    end
end)

-- Return all buttons
return {
    autoAttackBtn = autoAttackBtn,
    divineBlessingBtn = divineBlessingBtn,
    showDirtyLinensBtn = showDirtyLinensBtn,
    hideInsanityPropsBtn = hideInsanityPropsBtn,
    unloadGuiBtn = unloadGuiBtn,
    doorAttackBtn = doorAttackBtn -- Add this line
}
