
-- By leothesavior aka @pridescruelty
-- https://www.youtube.com/ @pridescruelty/

local uiUrl = "https://raw.githubusercontent.com/envyofblood/leostoolsfordpi/refs/heads/main/lib.lua"
local uiModule = nil
local guiName = "Pridesful"

repeat
    task.wait()
    local success, result = pcall(function()
        return loadstring(game:HttpGetAsync(uiUrl), "UI_SCRIPT")()
    end)
    if success then
        uiModule = result
    else
        warn("Failed to load UI:", result)
    end
until uiModule and uiModule.autoAttackBtn

-- Extract buttons from UI module
local autoAttackBtn = uiModule.autoAttackBtn
local divineBlessingBtn = uiModule.divineBlessingBtn
local showDirtyLinensBtn = uiModule.showDirtyLinensBtn
local hideInsanityPropsBtn = uiModule.hideInsanityPropsBtn
local unloadGuiBtn = uiModule.unloadGuiBtn
local doorAttackBtn = uiModule.doorAttackBtn
local confirmExcludePlayerBtn = uiModule.confirmExcludePlayerBtn
local excludePurpleTeamBtn = uiModule.excludePurpleTeamBtn
local excludeBlueTeamBtn = uiModule.excludeBlueTeamBtn
local excludeGreenTeamBtn = uiModule.excludeGreenTeamBtn
local excludePinkTeamBtn = uiModule.excludePinkTeamBtn
local excludeStaffBtn = uiModule.excludeStaffBtn

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

-- Auto Attack Loop
task.spawn(function()
    while true do
        if isAutoAttackEnabled then
            local targets = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not uiModule.shouldExclude(player) then
                    local character = player.Character
                    if character and isNear(character, attackRange) then
                        table.insert(targets, character)
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

-- Divine Blessing Button
divineBlessingBtn.MouseButton1Click:Connect(function()
    isAttributeLoopEnabled = not isAttributeLoopEnabled
    uiModule.setButtonText(divineBlessingBtn, isAttributeLoopEnabled)
    if not isAttributeLoopEnabled then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        for _, attr in pairs(attributesList) do
            character:SetAttribute(attr, 100)
        end
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

-- Door Attack Button
doorAttackBtn.MouseButton1Click:Connect(function()
    isDoorAttackEnabled = not isDoorAttackEnabled
    uiModule.setButtonText(doorAttackBtn, isDoorAttackEnabled)
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

-- Show Dirty Linens Button
showDirtyLinensBtn.MouseButton1Click:Connect(function()
    isESPEnabled = not isESPEnabled
    uiModule.setButtonText(showDirtyLinensBtn, isESPEnabled)
end)

-- Hide Insanity Props Button
hideInsanityPropsBtn.MouseButton1Click:Connect(function()
    isHideInsanityPropsEnabled = not isHideInsanityPropsEnabled
    uiModule.setButtonText(hideInsanityPropsBtn, isHideInsanityPropsEnabled)
    if isHideInsanityPropsEnabled then
        spawn(uiModule.destroyInsanityProps)
        hideInsanityPropsBtn.Text = "Done! Destroying this button now."
        wait(1)
        hideInsanityPropsBtn:Destroy()
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
    uiModule.setButtonText(autoAttackBtn, false)
    uiModule.setButtonText(divineBlessingBtn, false)
    uiModule.setButtonText(showDirtyLinensBtn, false)
    uiModule.setButtonText(hideInsanityPropsBtn, false)
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
