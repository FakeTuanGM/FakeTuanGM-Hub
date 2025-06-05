-- Check Game
if game.PlaceId == 2753915549 then
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    
    -- Services
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    
    -- Player Status Variables
    local PlayerStatus = {
        Level = 0,
        Beli = 0,
        Fragments = 0,
        DevilFruit = "None",
        CurrentIsland = "None",
        CurrentQuest = "None",
        CurrentRaid = "None",
        Health = 100,
        Energy = 100
    }
    
    -- Get Player Info
    local function GetPlayerInfo()
        local success, result = pcall(function()
            return HttpService:GetAsync("https://users.roblox.com/v1/users/" .. Player.UserId)
        end)
        
        if success then
            return HttpService:JSONDecode(result)
        end
        return nil
    end
    
    local function GetPlayerAvatar()
        local success, result = pcall(function()
            return HttpService:GetAsync("https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. Player.UserId .. "&size=420x420&format=Png&isCircular=true")
        end)
        
        if success then
            local data = HttpService:JSONDecode(result)
            return data.data[1].imageUrl
        end
        return nil
    end
    
    -- Update Player Status
    local function UpdatePlayerStatus()
        -- Update Basic Stats
        PlayerStatus.Level = Player.Data.Level.Value
        PlayerStatus.Beli = Player.Data.Beli.Value
        PlayerStatus.Fragments = Player.Data.Fragments.Value
        
        -- Update Health and Energy
        if Character and Character:FindFirstChild("Humanoid") then
            PlayerStatus.Health = Character.Humanoid.Health
            PlayerStatus.Energy = Character.Humanoid.Energy
        end
        
        -- Update Devil Fruit
        if Player.Data.DevilFruit.Value ~= "" then
            PlayerStatus.DevilFruit = Player.Data.DevilFruit.Value
        else
            PlayerStatus.DevilFruit = "None"
        end
        
        -- Update Current Island
        local currentIsland = nil
        for _, island in pairs(Workspace:GetChildren()) do
            if island:IsA("Model") and island.Name:find("Island") then
                if (island.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude < 1000 then
                    currentIsland = island.Name
                    break
                end
            end
        end
        PlayerStatus.CurrentIsland = currentIsland or "None"
        
        -- Update Current Quest
        if Player.PlayerGui:FindFirstChild("Quest") then
            local quest = Player.PlayerGui.Quest
            if quest.Visible then
                PlayerStatus.CurrentQuest = quest.Title.Text
            else
                PlayerStatus.CurrentQuest = "None"
            end
        end
        
        -- Update Current Raid
        if Workspace:FindFirstChild("Raid") then
            PlayerStatus.CurrentRaid = "Active"
        else
            PlayerStatus.CurrentRaid = "None"
        end
    end
    
    -- Loading Screen
    local LoadingScreen = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local LoadingBar = Instance.new("Frame")
    local LoadingBarFill = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UICorner2 = Instance.new("UICorner")
    
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.Parent = game.CoreGui
    LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = LoadingScreen
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 400, 0, 200)
    
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 8)
    
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FakeTuanGM HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 32
    
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = MainFrame
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 0, 0, 60)
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "Loading..."
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 16
    
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = MainFrame
    LoadingBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Position = UDim2.new(0.1, 0, 0.8, 0)
    LoadingBar.Size = UDim2.new(0.8, 0, 0, 10)
    
    UICorner2.Parent = LoadingBar
    UICorner2.CornerRadius = UDim.new(0, 5)
    
    LoadingBarFill.Name = "LoadingBarFill"
    LoadingBarFill.Parent = LoadingBar
    LoadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    
    UICorner2:Clone().Parent = LoadingBarFill
    
    -- Notify System
    local Notify = function(title, text, type)
        type = type or "info"
        local colors = {
            info = Color3.fromRGB(0, 170, 255),
            success = Color3.fromRGB(0, 255, 0),
            warning = Color3.fromRGB(255, 170, 0),
            error = Color3.fromRGB(255, 0, 0)
        }
        
        local ScreenGui = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Text = Instance.new("TextLabel")
        local Icon = Instance.new("TextLabel")
        local UICorner = Instance.new("UICorner")
        
        ScreenGui.Parent = game.CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        Frame.Parent = ScreenGui
        Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Frame.Position = UDim2.new(1, 10, 0.8, 0)
        Frame.Size = UDim2.new(0, 300, 0, 100)
        
        UICorner.Parent = Frame
        UICorner.CornerRadius = UDim.new(0, 8)
        
        Icon.Parent = Frame
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 10, 0, 10)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Font = Enum.Font.GothamBold
        Icon.Text = type == "info" and "i" or type == "success" and "✓" or type == "warning" and "!" or "×"
        Icon.TextColor3 = colors[type]
        Icon.TextSize = 16
        
        Title.Parent = Frame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 40, 0, 10)
        Title.Size = UDim2.new(1, -50, 0, 20)
        Title.Font = Enum.Font.GothamBold
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        Text.Parent = Frame
        Text.BackgroundTransparency = 1
        Text.Position = UDim2.new(0, 40, 0, 35)
        Text.Size = UDim2.new(1, -50, 0, 50)
        Text.Font = Enum.Font.Gotham
        Text.Text = text
        Text.TextColor3 = Color3.fromRGB(200, 200, 200)
        Text.TextSize = 14
        Text.TextWrapped = true
        Text.TextXAlignment = Enum.TextXAlignment.Left
        
        local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Tween = TweenService:Create(Frame, TweenInfo, {Position = UDim2.new(1, -310, 0.8, 0)})
        Tween:Play()
        
        task.delay(3, function()
            local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local Tween = TweenService:Create(Frame, TweenInfo, {Position = UDim2.new(1, 10, 0.8, 0)})
            Tween:Play()
            
            Tween.Completed:Connect(function()
                ScreenGui:Destroy()
            end)
        end)
    end
    
    -- Variables
    local Settings = {
        AutoFarm = false,
        AutoFarmNearest = false,
        AutoCollect = false,
        NoClip = false,
        WalkSpeed = 16,
        JumpPower = 50,
        TargetEnemy = nil,
        FarmDistance = 50,
        UIEnabled = true,
        AutoUpdateStatus = true
    }
    
    -- UI Library
    local Amethyst = loadstring(game:HttpGet("https://raw.githubusercontent.com/AmethystHub/AmethystHub/main/AmethystHub.lua"))()
    local Window = Amethyst:CreateWindow({
        Title = "Blox Fruits Hub",
        SubTitle = "by TuanGM",
        TabTitle = "Blox Fruits Hub"
    })
    
    -- Player Status Tab
    local PlayerTab = Window:CreateTab("Player Status", 4483362458)
    local PlayerSection = PlayerTab:CreateSection("Player Information")
    
    -- Create Avatar
    local AvatarFrame = Instance.new("Frame")
    local AvatarImage = Instance.new("ImageLabel")
    local UICorner = Instance.new("UICorner")
    
    AvatarFrame.Name = "AvatarFrame"
    AvatarFrame.Parent = PlayerSection
    AvatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    AvatarFrame.Position = UDim2.new(0.5, -50, 0, 10)
    AvatarFrame.Size = UDim2.new(0, 100, 0, 100)
    
    UICorner.Parent = AvatarFrame
    UICorner.CornerRadius = UDim.new(0, 8)
    
    AvatarImage.Name = "AvatarImage"
    AvatarImage.Parent = AvatarFrame
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.Position = UDim2.new(0, 0, 0, 0)
    AvatarImage.Size = UDim2.new(1, 0, 1, 0)
    AvatarImage.Image = GetPlayerAvatar()
    
    -- Player Info
    local playerInfo = GetPlayerInfo()
    if playerInfo then
        PlayerSection:CreateLabel("Username: " .. playerInfo.name)
        PlayerSection:CreateLabel("Display Name: " .. playerInfo.displayName)
    end
    
    -- Game Stats
    local StatsSection = PlayerTab:CreateSection("Game Statistics")
    
    local LevelLabel = StatsSection:CreateLabel("Level: " .. PlayerStatus.Level)
    local BeliLabel = StatsSection:CreateLabel("Beli: " .. PlayerStatus.Beli)
    local FragmentsLabel = StatsSection:CreateLabel("Fragments: " .. PlayerStatus.Fragments)
    local DevilFruitLabel = StatsSection:CreateLabel("Devil Fruit: " .. PlayerStatus.DevilFruit)
    local IslandLabel = StatsSection:CreateLabel("Current Island: " .. PlayerStatus.CurrentIsland)
    local QuestLabel = StatsSection:CreateLabel("Current Quest: " .. PlayerStatus.CurrentQuest)
    local RaidLabel = StatsSection:CreateLabel("Current Raid: " .. PlayerStatus.CurrentRaid)
    local HealthLabel = StatsSection:CreateLabel("Health: " .. PlayerStatus.Health)
    local EnergyLabel = StatsSection:CreateLabel("Energy: " .. PlayerStatus.Energy)
    
    -- Auto Update Status
    StatsSection:CreateToggle({
        Title = "Auto Update Status",
        Default = true,
        Callback = function(Value)
            Settings.AutoUpdateStatus = Value
            Notify("Status Update", "Auto Update Status has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    -- Update Stats
    RunService.Heartbeat:Connect(function()
        if Settings.AutoUpdateStatus then
            UpdatePlayerStatus()
            
            LevelLabel:Update("Level: " .. PlayerStatus.Level)
            BeliLabel:Update("Beli: " .. PlayerStatus.Beli)
            FragmentsLabel:Update("Fragments: " .. PlayerStatus.Fragments)
            DevilFruitLabel:Update("Devil Fruit: " .. PlayerStatus.DevilFruit)
            IslandLabel:Update("Current Island: " .. PlayerStatus.CurrentIsland)
            QuestLabel:Update("Current Quest: " .. PlayerStatus.CurrentQuest)
            RaidLabel:Update("Current Raid: " .. PlayerStatus.CurrentRaid)
            HealthLabel:Update("Health: " .. math.floor(PlayerStatus.Health))
            EnergyLabel:Update("Energy: " .. math.floor(PlayerStatus.Energy))
        end
    end)
    
    -- Main Tab
    local MainTab = Window:CreateTab("Main Farm", 4483362458)
    local MainSection = MainTab:CreateSection("Main Farm")
    
    MainSection:CreateLabel("Welcome to Blox Fruits Hub")
    MainSection:CreateLabel("Press RightShift to Toggle UI")
    
    MainSection:CreateToggle({
        Title = "Auto Farm Level",
        Default = false,
        Callback = function(Value)
            Settings.AutoFarm = Value
            Notify("Auto Farm", "Auto Farm has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    MainSection:CreateToggle({
        Title = "Auto Farm Nearest",
        Default = false,
        Callback = function(Value)
            Settings.AutoFarmNearest = Value
            Notify("Auto Farm Nearest", "Auto Farm Nearest has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    MainSection:CreateToggle({
        Title = "Auto Collect",
        Default = false,
        Callback = function(Value)
            Settings.AutoCollect = Value
            Notify("Auto Collect", "Auto Collect has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    -- Raid Tab
    local RaidTab = Window:CreateTab("Raid", 4483362458)
    local RaidSection = RaidTab:CreateSection("Raid Settings")
    
    RaidSection:CreateToggle({
        Title = "Auto Raid",
        Default = false,
        Callback = function(Value)
            Notify("Auto Raid", "Auto Raid has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    RaidSection:CreateDropdown({
        Title = "Select Raid",
        Options = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha", "Sand", "Phoenix"},
        Default = "Flame",
        Callback = function(Value)
            Notify("Raid Selection", "Selected Raid: " .. Value, "info")
        end
    })
    
    -- Fruit Tab
    local FruitTab = Window:CreateTab("Fruit", 4483362458)
    local FruitSection = FruitTab:CreateSection("Fruit Settings")
    
    FruitSection:CreateToggle({
        Title = "Auto Buy Random Fruit",
        Default = false,
        Callback = function(Value)
            Notify("Auto Buy Fruit", "Auto Buy Random Fruit has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    FruitSection:CreateToggle({
        Title = "Auto Store Fruit",
        Default = false,
        Callback = function(Value)
            Notify("Auto Store Fruit", "Auto Store Fruit has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    -- Settings Tab
    local SettingsTab = Window:CreateTab("Settings", 4483362458)
    local SettingsSection = SettingsTab:CreateSection("Player Settings")
    
    SettingsSection:CreateSlider({
        Title = "Walk Speed",
        Default = 16,
        Min = 16,
        Max = 500,
        Callback = function(Value)
            Settings.WalkSpeed = Value
            Character:WaitForChild("Humanoid").WalkSpeed = Value
            Notify("Walk Speed", "Walk Speed has been set to " .. Value, "info")
        end
    })
    
    SettingsSection:CreateSlider({
        Title = "Jump Power",
        Default = 50,
        Min = 50,
        Max = 500,
        Callback = function(Value)
            Settings.JumpPower = Value
            Character:WaitForChild("Humanoid").JumpPower = Value
            Notify("Jump Power", "Jump Power has been set to " .. Value, "info")
        end
    })
    
    SettingsSection:CreateToggle({
        Title = "NoClip",
        Default = false,
        Callback = function(Value)
            Settings.NoClip = Value
            if Value then
                RunService.Stepped:Connect(function()
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end
            Notify("NoClip", "NoClip has been " .. (Value and "enabled" or "disabled"), Value and "success" or "info")
        end
    })
    
    -- Discord Tab
    local DiscordTab = Window:CreateTab("Discord", 4483362458)
    local DiscordSection = DiscordTab:CreateSection("Discord")
    
    DiscordSection:CreateButton({
        Title = "Join Discord",
        Callback = function()
            setclipboard("https://discord.gg/gajFPVpSkW")
            Notify("Discord", "Discord link has been copied to clipboard!", "success")
        end
    })
    
    -- Functions
    local function GetNearestEnemy()
        local nearestEnemy = nil
        local shortestDistance = Settings.FarmDistance
        
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local distance = (enemy.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestEnemy = enemy
                end
            end
        end
        
        return nearestEnemy
    end
    
    local function AttackEnemy(enemy)
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0, 0, 3))
            
            local args = {
                [1] = enemy.HumanoidRootPart.Position,
                [2] = enemy
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Z", args)
        end
    end
    
    -- Main Loop
    RunService.Heartbeat:Connect(function()
        if Settings.AutoFarm then
            local enemy = GetNearestEnemy()
            if enemy then
                AttackEnemy(enemy)
            end
        end
        
        if Settings.AutoFarmNearest then
            local enemy = GetNearestEnemy()
            if enemy then
                AttackEnemy(enemy)
            end
        end
        
        if Settings.AutoCollect then
            -- Auto Collect logic here
        end
    end)
    
    -- Loading Animation
    local loadingTime = 2
    local startTime = tick()
    
    RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / loadingTime, 1)
        
        LoadingBarFill.Size = UDim2.new(progress, 0, 1, 0)
        
        if progress >= 1 then
            local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local Tween = TweenService:Create(MainFrame, TweenInfo, {BackgroundTransparency = 1})
            Tween:Play()
            
            Tween.Completed:Connect(function()
                LoadingScreen:Destroy()
                Notify("FakeTuanGM HUB", "Script has been loaded successfully!", "success")
            end)
        end
    end)
end
