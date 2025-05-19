-- leo's UI library

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

local exclusionContainer = Instance.new("Frame")
exclusionContainer.Size = UDim2.new(1, -20, 0, 150)
exclusionContainer.Position = UDim2.new(0, 10, 0, 160)
exclusionContainer.BackgroundTransparency = 1
exclusionContainer.Parent = mainSection

-- Title for Exclusion Settings
local exclusionTitle = Instance.new("TextLabel")
exclusionTitle.Size = UDim2.new(1, 0, 0, 20)
exclusionTitle.Position = UDim2.new(0, 0, 0, 0)
exclusionTitle.BackgroundTransparency = 1
exclusionTitle.Text = "Exclusion Settings"
exclusionTitle.TextColor3 = COLORS.text
exclusionTitle.Font = Enum.Font.GothamBold
exclusionTitle.TextSize = 14
exclusionTitle.Parent = exclusionContainer

-- Textbox for manual player exclusion
local excludePlayerInput = Instance.new("TextBox")
excludePlayerInput.Size = UDim2.new(1, 0, 0, 30)
excludePlayerInput.Position = UDim2.new(0, 0, 0, 25)
excludePlayerInput.BackgroundColor3 = COLORS.button
excludePlayerInput.TextColor3 = COLORS.text
excludePlayerInput.Font = Enum.Font.Gotham
excludePlayerInput.TextSize = 14
excludePlayerInput.PlaceholderText = "Enter Player Name to Exclude"
excludePlayerInput.ClearTextOnFocus = false
excludePlayerInput.Parent = exclusionContainer
addCorners(excludePlayerInput, 8)

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
local confirmExcludePlayerBtn
local excludePurpleTeamBtn
local excludeBlueTeamBtn
local excludeGreenTeamBtn
local excludePinkTeamBtn
local excludeStaffBtn
local discordBtn
local youtubeBtn

-- Main Section Buttons
autoAttackBtn = createButton(mainSection, "Auto Attack", UDim2.new(0, 10, 0, 20))
divineBlessingBtn = createButton(mainSection, "Divine Blessing", UDim2.new(0, 10, 0, 70))
doorAttackBtn = createButton(mainSection, "Door Attack (Only Big Monster)", UDim2.new(0, 10, 0, 120))

-- Visuals Section Buttons
showDirtyLinensBtn = createButton(visualsSection, "Show Dirty Linens", UDim2.new(0, 10, 0, 20))
hideInsanityPropsBtn = createButton(visualsSection, "Hide Insanity Props", UDim2.new(0, 10, 0, 70))

-- Settings Section Buttons
unloadGuiBtn = createButton(settingsSection, "Unload GUI", UDim2.new(0, 10, 0, 20))

-- Exclusion Buttons
confirmExcludePlayerBtn = createButton(exclusionContainer, "Add Player", UDim2.new(0, 0, 0, 60))
excludePurpleTeamBtn = createButton(exclusionContainer, "Exclude Purple Team", UDim2.new(0, 0, 0, 100))
excludeBlueTeamBtn = createButton(exclusionContainer, "Exclude Blue Team", UDim2.new(0, 0, 0, 140))
excludeGreenTeamBtn = createButton(exclusionContainer, "Exclude Green Team", UDim2.new(0, 0, 0, 180))
excludePinkTeamBtn = createButton(exclusionContainer, "Exclude Pink Team", UDim2.new(0, 0, 0, 220))
excludeStaffBtn = createButton(exclusionContainer, "Exclude Staff", UDim2.new(0, 0, 0, 260))

-- Credits Buttons
discordBtn = createButton(creditsSection, "Copy Discord", UDim2.new(0, 10, 0, 20))
youtubeBtn = createButton(creditsSection, "Copy YouTube", UDim2.new(0, 10, 0, 70))

-- Variables to store excluded players and teams
local excludedPlayers = {}
local excludedTeams = {}

-- Function to check if a player should be excluded
local function shouldExclude(player)
    if excludedPlayers[player.Name] then
        return true
    end
    local team = player.Character and player.Character:GetAttribute("Team")
    if team and excludedTeams[team] then
        return true
    end
    local trueRank = player:GetAttribute("TrueRank")
    if trueRank and trueRank >= 50 and excludedTeams["Staff"] then
        return true
    end
    return false
end

-- Confirm Player Exclusion Button Logic
confirmExcludePlayerBtn.MouseButton1Click:Connect(function()
    local playerName = excludePlayerInput.Text
    if playerName ~= "" then
        if excludedPlayers[playerName] then
            excludedPlayers[playerName] = nil
            excludePlayerInput.PlaceholderText = "Re-included: " .. playerName
        else
            excludedPlayers[playerName] = true
            excludePlayerInput.PlaceholderText = "Added: " .. playerName
        end
        excludePlayerInput.Text = ""
        task.delay(2, function()
            excludePlayerInput.PlaceholderText = "Enter Player Name to Exclude"
        end)
    end
end)

-- Exclude Teams Button Logic
local function toggleTeamExclusion(teamName, button)
    excludedTeams[teamName] = not excludedTeams[teamName]
    setButtonText(button, excludedTeams[teamName])
end

excludePurpleTeamBtn.MouseButton1Click:Connect(function()
    toggleTeamExclusion("Purple", excludePurpleTeamBtn)
end)

excludeBlueTeamBtn.MouseButton1Click:Connect(function()
    toggleTeamExclusion("Blue", excludeBlueTeamBtn)
end)

excludeGreenTeamBtn.MouseButton1Click:Connect(function()
    toggleTeamExclusion("Green", excludeGreenTeamBtn)
end)

excludePinkTeamBtn.MouseButton1Click:Connect(function()
    toggleTeamExclusion("Pink", excludePinkTeamBtn)
end)

excludeStaffBtn.MouseButton1Click:Connect(function()
    toggleTeamExclusion("Staff", excludeStaffBtn)
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
    setClipboard("https://www.youtube.com/@pridescruelty")
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

-- Return all buttons
return {
    autoAttackBtn = autoAttackBtn,
    divineBlessingBtn = divineBlessingBtn,
    showDirtyLinensBtn = showDirtyLinensBtn,
    hideInsanityPropsBtn = hideInsanityPropsBtn,
    unloadGuiBtn = unloadGuiBtn,
    doorAttackBtn = doorAttackBtn,
    confirmExcludePlayerBtn = confirmExcludePlayerBtn,
    excludePurpleTeamBtn = excludePurpleTeamBtn,
    excludeBlueTeamBtn = excludeBlueTeamBtn,
    excludeGreenTeamBtn = excludeGreenTeamBtn,
    excludePinkTeamBtn = excludePinkTeamBtn,
    excludeStaffBtn = excludeStaffBtn,
    discordBtn = discordBtn,
    youtubeBtn = youtubeBtn
}
