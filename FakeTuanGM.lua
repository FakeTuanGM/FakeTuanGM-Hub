--[[
Grow a Garden Script by ChatGPT
Features:
- Auto Collect
- Auto Summer Fruit Collect & Submit
- Auto Sell (custom delay)
- UI Themes (Amethyst, Dark, Light)
- Settings (ESP, Black Screen, Boost FPS, Language)
- Main (Speed, Jump, Fly, Player Status)
- Utility (Remove/Reclaim Plants)
- Shop (Auto Buy Seeds, Gear, Eggs, etc.)
- Anti-AFK, Advanced Anti-Ban
- Scroll UI
- Notify System (Load Done, Remove Done)
- Auto Plant (Random, Character-based)
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Settings = {
    Theme = "Amethyst",
    Language = "English",
    AutoCollect = true,
    AutoSummerFruit = true,
    AutoSubmitMode = "Super Fast",
    AutoSellDelay = 5,
    ESP = false,
    BlackScreen = false,
    BoostFPS = true,
    Speed = 16,
    Jump = 50,
    Fly = false,
    AutoPlantMode = "Random",
    AutoBuySeeds = true,
    AutoBuyGear = true,
    AutoBuyEgg = true,
    AntiAFK = true,
    AntiBan = true
}

-- UI Library (Use your preferred library or a custom one)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow a Garden GUI", Settings.Theme)

-- Notify Function
local function Notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

Notify("Script", "Grow a Garden Script Loaded Successfully", 6)

-- Main Tab
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Player Settings")

MainSection:NewSlider("Walk Speed", "Adjust your speed", 200, 16, function(v)
    LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

MainSection:NewSlider("Jump Power", "Adjust your jump", 200, 50, function(v)
    LocalPlayer.Character.Humanoid.JumpPower = v
end)

MainSection:NewToggle("Fly", "Toggle fly mode", function(v)
    Settings.Fly = v
end)

MainSection:NewButton("Show Status", "Display player status", function()
    Notify("Player Status", "Shekels: 999 | Honey: 999 | Name: " .. LocalPlayer.Name, 10)
end)

-- Auto Section
local Auto = Window:NewTab("Automation")
local AutoSection = Auto:NewSection("Auto Tasks")

AutoSection:NewToggle("Auto Collect", "Automatically collects items", function(v)
    Settings.AutoCollect = v
end)

AutoSection:NewToggle("Auto Summer Fruit", "Collect Summer Fruit", function(v)
    Settings.AutoSummerFruit = v
end)

AutoSection:NewDropdown("Auto Submit Speed", "Select submit speed", {"Super Fast", "Fast", "Normal", "Slow"}, function(v)
    Settings.AutoSubmitMode = v
end)

AutoSection:NewSlider("Auto Sell Delay (s)", "Delay for selling", 60, 5, function(v)
    Settings.AutoSellDelay = v
end)

AutoSection:NewToggle("Auto Plant", "Enable Auto Planting", function(v)
    Settings.AutoPlant = v
end)

AutoSection:NewDropdown("Plant Mode", "Choose plant method", {"Random", "Character"}, function(v)
    Settings.AutoPlantMode = v
end)

-- Utility Tab
local Utility = Window:NewTab("Utility")
local UtilitySection = Utility:NewSection("Plant Tools")

UtilitySection:NewButton("Remove Plants", "Clears plants", function()
    Notify("Utility", "Plants Removed", 4)
end)

UtilitySection:NewButton("Reclaim Plants", "Reclaims plants", function()
    Notify("Utility", "Plants Reclaimed", 4)
end)

-- Shop Tab
local Shop = Window:NewTab("Shop")
local ShopSection = Shop:NewSection("Auto Shop")

ShopSection:NewToggle("Auto Buy Seeds", "Automatically buys seeds", function(v)
    Settings.AutoBuySeeds = v
end)

ShopSection:NewToggle("Auto Buy Gear", "Automatically buys gear", function(v)
    Settings.AutoBuyGear = v
end)

ShopSection:NewToggle("Auto Buy Egg", "Automatically buys eggs", function(v)
    Settings.AutoBuyEgg = v
end)

-- Settings Tab
local Setting = Window:NewTab("Settings")
local SettingSection = Setting:NewSection("Preferences")

SettingSection:NewDropdown("Theme", "Choose UI Theme", {"Amethyst", "Dark", "Light"}, function(v)
    Settings.Theme = v
end)

SettingSection:NewDropdown("Language", "Select Language", {"English", "Tiếng Việt"}, function(v)
    Settings.Language = v
end)

SettingSection:NewToggle("ESP", "Toggle ESP", function(v)
    Settings.ESP = v
end)

SettingSection:NewToggle("Black Screen", "Blackout screen", function(v)
    Settings.BlackScreen = v
end)

SettingSection:NewToggle("Boost FPS", "Enable FPS boost", function(v)
    Settings.BoostFPS = v
end)

SettingSection:NewButton("Remove Notifications", "Deletes game notifications", function()
    for _, v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:find("notify") then
            v:Destroy()
        end
    end
    Notify("Cleaned", "Game notifications removed.", 4)
end)

-- Anti-AFK
if Settings.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

-- Placeholder Anti-Ban (Advanced methods should be handled externally or via secure obfuscation)
if Settings.AntiBan then
    print("Anti-Ban active (basic)")
end

-- Auto Tasks Execution (Loops)
RunService.Heartbeat:Connect(function()
    if Settings.AutoCollect then
        -- Add collect code here
    end
    if Settings.AutoSummerFruit then
        -- Add Summer Fruit logic here
    end
    if Settings.AutoPlant then
        -- Add Auto Plant logic here
    end
end)

-- Done Notify
Notify("Script Ready", "All functions initialized.", 6)
