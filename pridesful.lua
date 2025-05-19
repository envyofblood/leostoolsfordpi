local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Keybind Variables
local currentKeybind = Enum.KeyCode.Insert -- Default key
local keybindText = "Insert" -- Displayed key name

-- Color Theme
local COLORS = {
    background = Color3.fromRGB(30, 30, 35),
    sidebar = Color3.fromRGB(25, 25, 30),
    content = Color3.fromRGB(35, 35, 40),
    button = Color3.fromRGB(60, 60, 70),
    buttonHover = Color3.fromRGB(80, 80, 95),
    buttonActive = Color3.fromRGB(90, 90, 110),
    accent = Color3.fromRGB(100, 120, 255),
    text = Color3.fromRGB(255, 255, 255),
    subtext = Color3.fromRGB(180, 180, 190)
}

-- Prevent duplicate GUI creation
local guiName = "Pridesful"
if PlayerGui:FindFirstChild(guiName) then
    return {} -- Don't load again
end

-- Create Corner and Stroke utility functions
local function addCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.accent
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = 0.7
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function addGlow(instance, color, size)
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970" -- Radial gradient
    glow.ImageColor3 = color or COLORS.accent
    glow.ImageTransparency = 0.85
    glow.Size = UDim2.new(1, size or 20, 1, size or 20)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.ZIndex = instance.ZIndex - 1
    glow.Parent = instance
    return glow
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
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
addCorners(mainFrame, 12)
addStroke(mainFrame, COLORS.accent, 2)
addGlow(mainFrame, COLORS.accent, 40)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = COLORS.accent
titleBar.BackgroundTransparency = 0.8
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
addCorners(titleBar, 12)

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Pridesful"
title.TextColor3 = COLORS.text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = COLORS.sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
addCorners(sidebar, 8)

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, -60)
contentArea.Position = UDim2.new(0, 100, 0, 40)
contentArea.BackgroundColor3 = COLORS.content
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame
addCorners(contentArea, 8)

-- Subtitle - Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -20)
credits.BackgroundTransparency = 1
credits.Text = "by Leo"
credits.TextColor3 = COLORS.subtext
credits.Font = Enum.Font.Gotham
credits.TextSize = 12
credits.Parent = mainFrame

-- Button Template Function with Animation
local function createButton(parent, name, position)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 0, 35)
    buttonContainer.Position = position
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = parent
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = name
    button.BackgroundColor3 = COLORS.button
    button.TextColor3 = COLORS.text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = buttonContainer
    addCorners(button, 8)
    local buttonGlow = addGlow(button, COLORS.accent, 15)
    buttonGlow.ImageTransparency = 1 -- Start invisible
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = COLORS.buttonHover}):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 0.7}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = COLORS.button}):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 1}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = COLORS.buttonActive, Size = UDim2.new(0.98, 0, 0.95, 0), Position = UDim2.new(0.01, 0, 0.025, 0)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = COLORS.buttonHover, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    return button
end

-- Sidebar Buttons
local mainSectionBtn = createButton(sidebar, "Main", UDim2.new(0, 10, 0, 10))
local visualsSectionBtn = createButton(sidebar, "Visuals", UDim2.new(0, 10, 0, 60))
local settingsSectionBtn = createButton(sidebar, "Settings", UDim2.new(0, 10, 0, 110))
local creditsSectionBtn = createButton(sidebar, "Credits", UDim2.new(0, 10, 0, 160))

-- Create Sections Inside Content Area
local mainSection = Instance.new("Frame")
mainSection.Size = UDim2.new(1, 0, 1, 0)
mainSection.Position = UDim2.new(0, 0, 0, 0)
mainSection.BackgroundTransparency = 1
mainSection.Parent = contentArea

local exclusionSection = Instance.new("Frame")
exclusionSection.Size = UDim2.new(1, 0, 1, 0)
exclusionSection.Position = UDim2.new(0, 0, 0, 0)
exclusionSection.BackgroundTransparency = 1
exclusionSection.Parent = contentArea

-- Horizontal Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -20)
container.Position = UDim2.new(0, 10, 0, 10)
container.BackgroundTransparency = 1
container.Parent = exclusionSection


-- Status Panel
local statusPanel = Instance.new("Frame")
statusPanel.Size = UDim2.new(1, -20, 0, 40)
statusPanel.Position = UDim2.new(0, 10, 0, 190)
statusPanel.BackgroundColor3 = COLORS.background
statusPanel.BackgroundTransparency = 0.5
statusPanel.Parent = mainSection
addCorners(statusPanel, 8)
addStroke(statusPanel, COLORS.accent, 1)
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.BackgroundTransparency = 1
statusText.TextColor3 = COLORS.text
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.Text = "Time: Loading... | Blurs: Loading..."
statusText.Parent = statusPanel

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

local creditsSection = Instance.new("Frame")
creditsSection.Size = UDim2.new(1, 0, 1, 0)
creditsSection.Position = UDim2.new(0, 0, 0, 0)
creditsSection.BackgroundTransparency = 1
creditsSection.Parent = contentArea

-- Function to update the status text
local function updateStatusText()
    local LocalPlayer = Players.LocalPlayer
    local character = game.Players.LocalPlayer
    local insanityValue = character:GetAttribute("Insanity") or "Blur value not found, check F9"
    local currentTime = game.Lighting.TimeOfDay -- Get current time in HH:MM:SS format
    statusText.Text = string.format("Time: %s | Blurs: %s", currentTime, insanityValue)
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
    for _, btn in pairs({mainSectionBtn, visualsSectionBtn, settingsSectionBtn, creditsSectionBtn}) do
        if btn then
            btn.BackgroundColor3 = COLORS.button
        end
    end
    if frameToShow == mainSection then
        TweenService:Create(mainSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent}):Play()
    elseif frameToShow == visualsSection then
        TweenService:Create(visualsSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent}):Play()
    elseif frameToShow == settingsSection then
        TweenService:Create(settingsSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent}):Play()
    elseif frameToShow == creditsSection then
        TweenService:Create(creditsSectionBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent}):Play()
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
local discordBtn
local youtubeBtn

local nightVisionEnabled = false
local nightVisionLoop    = nil     -- will hold the task for the loop

-- Main Section Buttons
autoAttackBtn = createButton(mainSection, "Auto Attack", UDim2.new(0, 10, 0, 20))
divineBlessingBtn = createButton(mainSection, "Divine Blessing", UDim2.new(0, 10, 0, 70))
doorAttackBtn = createButton(mainSection, "Door Attack (Only Big Monster)", UDim2.new(0, 10, 0, 120))

-- Visuals Section Buttons
showDirtyLinensBtn = createButton(visualsSection, "Show Dirty Linens", UDim2.new(0, 10, 0, 20))
hideInsanityPropsBtn = createButton(visualsSection, "Hide Insanity Props", UDim2.new(0, 10, 0, 60))

-- Settings Section Buttons
unloadGuiBtn = createButton(settingsSection, "Unload GUI", UDim2.new(0, 10, 0, 10))

-- Credits Buttons
discordBtn = createButton(creditsSection, "Copy Discord", UDim2.new(0, 10, 0, 20))
youtubeBtn = createButton(creditsSection, "Copy YouTube", UDim2.new(0, 10, 0, 60))

local exclusionSectionBtn = createButton(sidebar, "Exclusions", UDim2.new(0, 10, 0, 210))

local nightVisionBtn = createButton(visualsSection, "Night-Vision : OFF", UDim2.new(0, 10, 0, 100))

exclusionSectionBtn.MouseButton1Click:Connect(function()
    showSection(exclusionSection)
end)


local function setNightVision(on)
    nightVisionEnabled = on
    nightVisionBtn.Text = on and "Night-Vision : ON" or "Night-Vision : OFF"

    -- stop previous loop if it exists
    if nightVisionLoop then
        nightVisionLoop:Disconnect()
        nightVisionLoop = nil
    end

    if on then
        nightVisionLoop = game:GetService("RunService").Heartbeat:Connect(function(step)
            game.Lighting.TimeOfDay = "14:00:00"   -- bright afternoon
        end)
    end
end

nightVisionBtn.MouseButton1Click:Connect(function()
    setNightVision(not nightVisionEnabled)
end)

-- Exclusion Lists
excludedPlayers = {}
excludedTeams = {}
excludeStaff = false

-- LEFT scroll column (replace any old inputFrame / scroll variable)
local inputScroll = Instance.new("ScrollingFrame")
inputScroll.Size               = UDim2.new(0.5, -5, 1, 0)
inputScroll.Position           = UDim2.new(0, 0, 0, 0)
inputScroll.CanvasSize         = UDim2.new(0, 0, 0, 0) -- auto-expands via AutomaticCanvasSize
inputScroll.AutomaticCanvasSize= Enum.AutomaticSize.Y
inputScroll.ScrollBarThickness = 6
inputScroll.BackgroundTransparency = 1
inputScroll.Parent             = container   -- container is the left/right splitter

local inputLayout = Instance.new("UIListLayout")
inputLayout.Padding   = UDim.new(0, 8)
inputLayout.SortOrder = Enum.SortOrder.LayoutOrder
inputLayout.Parent    = inputScroll

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- RIGHT: Excluded List
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.5, -5, 1, 0)
listFrame.Position = UDim2.new(0.5, 5, 0, 0)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
listFrame.ScrollBarThickness = 6
listFrame.BackgroundColor3 = COLORS.sidebar
addCorners(listFrame, 8)
addStroke(listFrame, COLORS.accent, 1)
listFrame.Parent = container

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listFrame

local function refreshExclusionList()
    -- keep a reference to the layout so we don’t delete it
    local layout = listLayout   -- the one we created earlier

    -- destroy everything except the layout
    for _, child in ipairs(listFrame:GetChildren()) do
        if child ~= layout then
            child:Destroy()
        end
    end

    -- Helper for adding buttons to the listFrame
    local function addListButton(text, onClick)
        local btn = createButton(listFrame, text, UDim2.new()) -- parent is listFrame
        btn.MouseButton1Click:Connect(onClick)
    end

    -- Users
    for name in pairs(excludedPlayers) do
        addListButton("[User]  " .. name, function()
            excludedPlayers[name] = nil
            refreshExclusionList()
        end)
    end

    -- Teams
    for team in pairs(excludedTeams) do
        addListButton("[Team]  " .. team, function()
            excludedTeams[team] = nil
            refreshExclusionList()
        end)
    end

    -- Staff
    if excludeStaff then
        addListButton("[Staff]  TrueRank ≥ 50", function()
            excludeStaff = false
            refreshExclusionList()
        end)
    end
end


-- Username TextBox
local nameBox = Instance.new("TextBox")
nameBox.Size               = UDim2.new(1, -10, 0, 32)
nameBox.TextXAlignment     = Enum.TextXAlignment.Left
nameBox.TextYAlignment     = Enum.TextYAlignment.Center
nameBox.ClearTextOnFocus   = false
nameBox.PlaceholderText    = "Enter username to exclude"
nameBox.BackgroundColor3   = COLORS.button
nameBox.TextColor3         = COLORS.text
nameBox.Font               = Enum.Font.Gotham
nameBox.TextSize           = 14
nameBox.Text               = ""
nameBox.Parent             = inputScroll      -- <- scrolling frame that holds all controls
addCorners(nameBox, 8)
addStroke(nameBox, COLORS.accent, 1)

-- padding object
local pad = Instance.new("UIPadding")
pad.PaddingLeft  = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)
pad.Parent = nameBox

refreshExclusionList()

-- Exclude/Include Username Button
local nameToggleBtn = createButton(inputScroll, "Exclude User", UDim2.new())

nameToggleBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text
    if name ~= "" and Players:FindFirstChild(name) then
        excludedPlayers[name] = true
    end
    nameBox.Text = ""
    refreshExclusionList()
end)

local function makeToggle(teamName)
    local btn = createButton(inputScroll, "Toggle Team " .. teamName, UDim2.new())
    btn.MouseButton1Click:Connect(function()
        if excludedTeams[teamName] then
            excludedTeams[teamName] = nil
        else
            excludedTeams[teamName] = true
        end
        refreshExclusionList()
    end)
end
makeToggle("Pink")
makeToggle("Green")
makeToggle("Blue")
makeToggle("Purple")

-- Staff Toggle Button
local staffBtn = createButton(inputScroll, "Toggle Staff", UDim2.new())

staffBtn.MouseButton1Click:Connect(function()
    excludeStaff = not excludeStaff
    refreshExclusionList()
end)

-- Add Keybind Input
local keybindContainer = Instance.new("Frame")
keybindContainer.Size = UDim2.new(1, -20, 0, 35)
keybindContainer.Position = UDim2.new(0, 10, 0, 50)
keybindContainer.BackgroundTransparency = 1
keybindContainer.Parent = settingsSection

local keybindInput = Instance.new("TextBox")
keybindInput.Size = UDim2.new(1, 0, 1, 0)
keybindInput.BackgroundColor3 = COLORS.button
keybindInput.TextColor3 = COLORS.text
keybindInput.Font = Enum.Font.Gotham
keybindInput.TextSize = 14
keybindInput.Text = "Change Keybind (Current: " .. keybindText .. ")"
keybindInput.Parent = keybindContainer
addCorners(keybindInput, 8)
addStroke(keybindInput, COLORS.accent, 1)

local confirmKeybindBtn = createButton(settingsSection, "Confirm Keybind", UDim2.new(0, 10, 0, 90))

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

creditsSectionBtn.MouseButton1Click:Connect(function()
    showSection(creditsSection)
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5pnBUBrtnZ")
    discordBtn.Text = "Copied!"
    task.delay(2, function()
        discordBtn.Text = "Copy Discord"
    end)
end)

youtubeBtn.MouseButton1Click:Connect(function()
    setclipboard("https://www.youtube.com/@pridescruelty")
    youtubeBtn.Text = "Copied!"
    task.delay(2, function()
        youtubeBtn.Text = "Copy YouTube"
    end)
end)

-- Confirm Keybind Button Logic
confirmKeybindBtn.MouseButton1Click:Connect(function()
    local userInput = string.upper(keybindInput.Text) -- Get user input and normalize to uppercase
    local newKey = Enum.KeyCode[userInput] -- Check if the input corresponds to a valid KeyCode
    if newKey then
        currentKeybind = newKey -- Update the keybind
        keybindText = userInput -- Update the displayed key name
        keybindInput.Text = "Change Keybind (Current: " .. keybindText .. ")"
        keybindInput.BackgroundColor3 = COLORS.button -- Reset color
        -- Success animation
        local successStroke = addStroke(keybindInput, Color3.fromRGB(0, 255, 100), 2)
        TweenService:Create(successStroke, TweenInfo.new(1), {Transparency = 1}):Play()
        game.Debris:AddItem(successStroke, 1)
    else
        keybindInput.Text = "Invalid Key! Try again."
        keybindInput.BackgroundColor3 = Color3.fromRGB(255, 70, 70) -- Highlight invalid input
        -- Error shake animation
        local originalPos = keybindInput.Position
        for i = 1, 5 do
            TweenService:Create(keybindInput, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, (i % 2 == 0) and 5 or -5, 0, 0)}):Play()
            task.wait(0.05)
        end
        TweenService:Create(keybindInput, TweenInfo.new(0.05), {Position = originalPos}):Play()
        -- Reset after 2 seconds
        task.delay(2, function()
            keybindInput.Text = "Change Keybind (Current: " .. keybindText .. ")"
            keybindInput.BackgroundColor3 = COLORS.button
        end)
    end
end)

-- GUI Visibility Toggle with animation
local guiVisible = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == currentKeybind then
        guiVisible = not guiVisible
        if guiVisible then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 400 * 0.8, 0, 300 * 0.8)
            mainFrame.BackgroundTransparency = 1
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 400, 0, 300),
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 400 * 0.8, 0, 300 * 0.8),
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.3, function()
                mainFrame.Visible = false
            end)
        end
    end
end)

-- Status update loop
task.spawn(function()
    while true do
        updateStatusText()
        task.wait(1)
    end
end)


-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")

local attackEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("30")
local doorsFolder = workspace:WaitForChild("Essentials"):WaitForChild("Interactables"):WaitForChild("Doors")

local isAutoAttackEnabled = false
local isAttributeLoopEnabled = false
local isESPEnabled = false
local isHideInsanityPropsEnabled = false
local isDoorAttackEnabled = false
local attackRange = 15 -- Adjust range as needed

local attributesList = {"Hunger", "Hygiene", "Stamina", "MaxStamina", "MaxHunger"}

-- Nearby check
local function isNear(otherChar, range)
    local otherHRP = otherChar:FindFirstChild("HumanoidRootPart")
    if otherHRP then
        local distance = (HumanoidRootPart.Position - otherHRP.Position).Magnitude
        return distance <= range
    end
    return false
end

-- Button State Management
function setButtonText(button, state)
    button.Text = button.Text:match(".*: ") and button.Text:gsub(": .*", ": " .. (state and "ON" or "OFF")) or button.Text .. ": " .. (state and "ON" or "OFF")
end

-- Auto Attack Button
autoAttackBtn.MouseButton1Click:Connect(function()
    isAutoAttackEnabled = not isAutoAttackEnabled
    setButtonText(autoAttackBtn, isAutoAttackEnabled)
end)

-- Divine Blessing Button
divineBlessingBtn.MouseButton1Click:Connect(function()
    isAttributeLoopEnabled = not isAttributeLoopEnabled
    setButtonText(divineBlessingBtn, isAttributeLoopEnabled)

    if not isAttributeLoopEnabled then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        for _, attr in pairs(attributesList) do
            character:SetAttribute(attr, 100)
        end
    end
end)

-- Destroy insanity props
local function destroyInsanityProps()
    local insanityFolder = Workspace:FindFirstChild("Essentials") and Workspace.Essentials:FindFirstChild("Insanity")
    if not insanityFolder then return end

    for _, obj in ipairs(insanityFolder:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("ImageLabel") or obj:IsA("TextLabel") then
            obj:Destroy()
        end
    end
end


-- Door Attack Button
doorAttackBtn.MouseButton1Click:Connect(function()
    isDoorAttackEnabled = not isDoorAttackEnabled
    setButtonText(doorAttackBtn, isDoorAttackEnabled)
end)

-- Show Dirty Linens Button
showDirtyLinensBtn.MouseButton1Click:Connect(function()
    isESPEnabled = not isESPEnabled
    setButtonText(showDirtyLinensBtn, isESPEnabled)
end)

-- Hide Insanity Props Button
hideInsanityPropsBtn.MouseButton1Click:Connect(function()
    isHideInsanityPropsEnabled = not isHideInsanityPropsEnabled

    if isHideInsanityPropsEnabled then
        spawn(destroyInsanityProps)
        hideInsanityPropsBtn.Text = "Done!"
        wait(1)
        hideInsanityPropsBtn.Text = "Hide Insanity Props"
    end
end)

-- Unload GUI Button
unloadGuiBtn.MouseButton1Click:Connect(function()
    -- Turn off all features
    isAutoAttackEnabled = false
    isAttributeLoopEnabled = false
    isESPEnabled = false
    isHideInsanityPropsEnabled = false

    -- Reset button texts
    setButtonText(autoAttackBtn, false)
    setButtonText(divineBlessingBtn, false)
    setButtonText(showDirtyLinensBtn, false)
    setButtonText(hideInsanityPropsBtn, false)

    -- Destroy GUI
    local gui = PlayerGui:FindFirstChild(guiName)
    if gui then
        gui:Destroy()
    end
end)

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Auto Attack Loop
task.spawn(function()
    while true do
        if isAutoAttackEnabled then
            local targets = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not excludedPlayers[player.Name] then
                    local character = player.Character
                    if character then
                        local team = character:GetAttribute("Team")
                        local isTeamExcluded = team and excludedTeams[team]

                        local trueRank = player:GetAttribute("TrueRank")
                        local isStaff = excludeStaff and trueRank and trueRank >= 50

                        if not isTeamExcluded and not isStaff and isNear(character, 5) then
                            table.insert(targets, character)
                        end
                    end
                end
            end
            if #targets > 0 then
                attackEvent:FireServer("AttackPlayers", targets)
            end
        end
        task.wait(0.5)
    end
end)


-- Attribute Refill Loop
task.spawn(function()
    while true do
        if isAttributeLoopEnabled then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            for _, attr in pairs(attributesList) do
                if character:GetAttribute(attr) == nil then
                    character:SetAttribute(attr, 9999999)
                end
                character:SetAttribute(attr, 9999999)
            end
        end
        task.wait(0.7)
    end
end)

-- DOOR ATTACK LOOP
task.spawn(function()
    while true do
        if isDoorAttackEnabled then
            local targets = {}
            for _, door in ipairs(doorsFolder:GetChildren()) do
                local canBreak = door:GetAttribute("canBreak")
                local currentHealth = door:GetAttribute("currentHealth")

                -- Handle Model position via PrimaryPart
                local hrpPos = HumanoidRootPart.Position
                local doorPos = nil

                if door:IsA("Model") and door.PrimaryPart then
                    local primaryPart = door:FindFirstChild(door.PrimaryPart.Name)
                    if primaryPart then
                        doorPos = primaryPart.Position
                    end
                elseif door:IsA("BasePart") then
                    doorPos = door.Position
                end

                -- Validate and collect valid targets
                if canBreak == true and currentHealth and currentHealth > 0 and doorPos then
                    if (hrpPos - doorPos).Magnitude <= attackRange then
                        table.insert(targets, door)
                    end
                end
            end

            if #targets > 0 then
                attackEvent:FireServer("AttackPlayers", targets)
            end
        end

        task.wait(isDoorAttackEnabled and 0.2 or 0.1)
    end
end)

-- ESP Folder
local linenESPFolder = Instance.new("Folder")
linenESPFolder.Name = "LinenESP"
linenESPFolder.Parent = PlayerGui

-- ESP Loop
task.spawn(function()
    while true do
        if isESPEnabled then
            for _, gui in ipairs(linenESPFolder:GetChildren()) do
                gui:Destroy()
            end

            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local beds = Workspace:WaitForChild("Essentials", 10):WaitForChild("Interactables", 10):WaitForChild("BedFolder", 10):GetChildren()
                for _, bed in ipairs(beds) do
                    if bed:IsA("Model") and not bed:GetAttribute("NoLinen") and (bed:GetAttribute("Dirtiness") or 0) >= 2 then
                        local bedPart = bed.PrimaryPart or bed:FindFirstChildWhichIsA("BasePart")
                        if bedPart then
                            local distance = (bedPart.Position - root.Position).Magnitude

                            local adorn = Instance.new("BillboardGui")
                            adorn.Name = "ESP_" .. bed.Name
                            adorn.AlwaysOnTop = true
                            adorn.Size = UDim2.new(0, 200, 0, 50)
                            adorn.Adornee = bedPart
                            adorn.Parent = linenESPFolder

                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = Color3.new(1, 1, 1)
                            textLabel.TextStrokeTransparency = 0.5
                            textLabel.TextSize = 16
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Text = "Dirty Linen\n" .. math.floor(distance) .. " studs"
                            textLabel.Parent = adorn
                        end
                    end
                end
            end
        else
            for _, gui in ipairs(linenESPFolder:GetChildren()) do
                gui:Destroy()
            end
        end

        task.wait(1)
    end
end)
