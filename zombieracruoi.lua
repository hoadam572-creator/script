local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ để tránh trùng lặp
if CoreGui:FindFirstChild("SangKeySystem") then CoreGui.SangKeySystem:Destroy() end

-- =================================================================
-- HỆ THỐNG NHẬP KEY GỐC (Đảm bảo hoạt động độc lập mượt mà)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local CheckBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Name = "SangKeySystem"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.Size = UDim2.new(0, 250, 0, 150)

UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MCHIEN IOS - KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

KeyBox.Name = "KeyBox"
KeyBox.Parent = MainFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.Font = Enum.Font.SourceSans
KeyBox.PlaceholderText = "Nhập Key tại đây..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 16

UICorner2.Parent = KeyBox

CheckBtn.Name = "CheckBtn"
CheckBtn.Parent = MainFrame
CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
CheckBtn.Position = UDim2.new(0.1, 0, 0.65, 5)
CheckBtn.Size = UDim2.new(0.8, 0, 0, 35)
CheckBtn.Font = Enum.Font.SourceSansBold
CheckBtn.Text = "ĐĂNG NHẬP"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.TextSize = 16

UICorner3.Parent = CheckBtn

-- =================================================================
-- HÀM KHỞI TẠO MENU KING RUA HUB (Chỉ chạy khi nhập đúng Key)
-- =================================================================
local function LoadKingRuaMenu()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mamafoni281/KingRua-Library/refs/heads/main/Source"))()

    local Window = Library:NewWindow({
        Title = "Mchien Hub",
        Description = "Survive Zombie Arena"
    })

    -- Tạo các Tabs
    local MainTab = Window:T("Main")
    local UpgradesTab = Window:T("Upgrades & Skills")
    local CreditsTab = Window:T("Credits")

    -- Các Sections thuộc Main Tab
    local CombatSection = MainTab:AddSection("Combat Settings")
    local PlayerSection = MainTab:AddSection("Player Settings")

    -- Các Sections thuộc Upgrades Tab
    local AutoPurchaseSection = UpgradesTab:AddSection("Auto Purchase")
    local AutoSkillSection = UpgradesTab:AddSection("Spam Skills")

    -- Section thuộc Credits Tab
    local InfoSection = CreditsTab:AddSection("Information")

    -- -------------------------------------------------------------
    -- [COMBAT SETTINGS]
    -- -------------------------------------------------------------
    local function runKillAura()
        spawn(function()
            _G.Kill = true
            while _G.Kill do
                task.wait()
                pcall(function()
                    local character = LocalPlayer.Character
                    if character then
                        local backpack = LocalPlayer.Backpack
                        local equippedTool = character:FindFirstChildOfClass("Tool")
                        
                        if not equippedTool then
                            local tools = backpack:GetChildren()
                            for _, tool in pairs(tools) do
                                if tool:IsA("Tool") then
                                    tool.Parent = character
                                    break
                                end
                            end
                        end
                        
                        local currentTool = character:FindFirstChildOfClass("Tool")
                        if currentTool then
                            local zombies = workspace:FindFirstChild("Zombies_Local")
                            if zombies then
                                local gunHitRemote = ReplicatedStorage:FindFirstChild("GunRemotes") and ReplicatedStorage.GunRemotes:FindFirstChild("GunHit")
                                if gunHitRemote then
                                    for _, zombie in pairs(zombies:GetChildren()) do
                                        local root = zombie:FindFirstChild("HumanoidRootPart")
                                        if root then
                                            local id = tonumber(string.match(zombie.Name, "%d+"))
                                            gunHitRemote:FireServer(currentTool.Name, id, root.Position)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        LocalPlayer.CharacterAdded:Wait()
                    end
                end)
            end
        end)
    end

    CombatSection:AddToggle({
        Title = "Kill Aura",
        Description = "Tự động tiêu diệt tất cả zombie xung quanh",
        Default = false,
        Callback = function(state)
            _G.Kill = state
            if state then
                runKillAura()
            end
        end
    })

    CombatSection:AddToggle({
        Title = "SafeZone",
        Description = "Độn thổ/Bay lên cao để né zombie",
        Default = false,
        Callback = function(state)
            _G.Safe = state
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.HipHeight = state and 20 or 2
            end
        end
    })

    local cachedCFrame = nil
    CombatSection:AddToggle({
        Title = "Instant ClearWave (Solo)",
        Description = "Dịch chuyển tới vùng an toàn để tự động qua màn",
        Default = false,
        Callback = function(state)
            _G.Wave = state
            local character = LocalPlayer.Character
            local root = character and character:WaitForChild("HumanoidRootPart")
            if root then
                if state then
                    cachedCFrame = root.CFrame
                    root.CFrame = CFrame.new(31, -67, -145)
                    task.wait(0.2)
                    root.Anchored = true
                else
                    root.Anchored = false
                    if cachedCFrame then
                        root.CFrame = cachedCFrame
                    end
                end
            end
        end
    })

    -- -------------------------------------------------------------
    -- [PLAYER SETTINGS]
    -- -------------------------------------------------------------
    PlayerSection:AddSlider({
        Title = "Walk Speed",
        Description = "Thay đổi tốc độ di chuyển của nhân vật",
        Min = 16,
        Max = 100,
        Increment = 1,
        Default = 16,
        Callback = function(value)
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = value
            end
        end
    })

    -- -------------------------------------------------------------
    -- [AUTO PURCHASE]
    -- -------------------------------------------------------------
    AutoPurchaseSection:AddToggle({
        Title = "Auto Heal Upgrade",
        Description = "Tự động nâng cấp máu liên tục",
        Default = false,
        Callback = function(state)
            _G.Heal = state
            if state then
                spawn(function()
                    while _G.Heal do
                        task.wait(1)
                        pcall(function()
                            ReplicatedStorage.UpgradeRemotes.PurchaseHealthUpgrade:FireServer()
                        end)
                    end
                end)
            end
        end
    })

    AutoPurchaseSection:AddToggle({
        Title = "Auto Weapon Upgrade",
        Description = "Tự động nâng cấp vũ khí liên tục",
        Default = false,
        Callback = function(state)
            _G.Weapon = state
            if state then
                spawn(function()
                    while _G.Weapon do
                        task.wait(1)
                        pcall(function()
                            ReplicatedStorage.UpgradeRemotes.PurchaseWeaponUpgrade:FireServer()
                        end)
                    end
                end)
            end
        end
    })

    -- -------------------------------------------------------------
    -- [SPAM SKILLS]
    -- -------------------------------------------------------------
    AutoSkillSection:AddToggle({
        Title = "Spam E Skill",
        Description = "Tự động kích hoạt kỹ năng E",
        Default = false,
        Callback = function(state)
            _G.SkillE = state
            if state then
                spawn(function()
                    while _G.SkillE do
                        task.wait(1)
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end)
            end
        end
    })

    AutoSkillSection:AddToggle({
        Title = "Spam R Skill",
        Description = "Tự động kích hoạt kỹ năng R",
        Default = false,
        Callback = function(state)
            _G.SkillR = state
            if state then
                spawn(function()
                    while _G.SkillR do
                        task.wait(1)
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                    end
                end)
            end
        end
    })

    AutoSkillSection:AddToggle({
        Title = "Spam Q Skill",
        Description = "Tự động kích hoạt kỹ năng Q",
        Default = false,
        Callback = function(state)
            _G.SkillQ = state
            if state then
                spawn(function()
                    while _G.SkillQ do
                        task.wait(1)
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                end)
            end
        end
    })

    -- -------------------------------------------------------------
    -- [CREDITS TAB]
    -- -------------------------------------------------------------
    InfoSection:AddParagraph({
        Title = "Script Information",
        Content = "Tên: Mchien Hub\nPhiên bản: Premium v2.0\nTác giả: SANG ĐẸP TRAI SỐ 1 THẾ GIỚI"
    })
    
    InfoSection:AddParagraph({
        Title = "Yêu cầu hệ thống",
        Content = "• Key hiện tại: sang\n• Hỗ trợ tối ưu chống lag tốt trên iOS/Mobile."
    })
end

-- Xử lý sự kiện bấm nút kiểm tra Key để mở Menu KingRua
CheckBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "sang" then
        ScreenGui:Destroy()       -- Xóa bảng nhập Key
        LoadKingRuaMenu()        -- Khởi tạo và tải Menu KingRua chính thức
    else
        Title.Text = "SAI KEY! VUI LÒNG THỬ LẠI"
        Title.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        Title.Text = "MCHIEN IOS - KEY SYSTEM"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
