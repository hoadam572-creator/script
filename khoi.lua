local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Menu Hack: Pro Movement & Teleport",
   LoadingTitle = "Đang khởi tạo hệ thống...",
   LoadingSubtitle = "by SANG ĐẸP TRAI SỐ 1 THẾ GIỚI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SangDepTraiConfig",
      FileName = "MenuSettings"
   }
})

---------------------------------------------------------
-- HỆ THỐNG NỀN ẢNH GOJO (IMAGE BACKGROUND)
---------------------------------------------------------
task.spawn(function()
    local MainFrame = game:GetService("CoreGui"):WaitForChild("Rayfield"):WaitForChild("Main")
    
    -- Tạo một lớp ảnh nền phía sau
    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "GojoBackground"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
    -- Sử dụng ID ảnh Gojo Satoru tương tự ảnh bạn gửi
    BackgroundImage.Image = "rbxassetid://16027376629" 
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ImageTransparency = 0.3 -- Chỉnh độ mờ để vẫn thấy rõ các nút
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.ZIndex = 0
    BackgroundImage.Parent = MainFrame
    
    -- Làm trong suốt nền cũ của Rayfield để lộ ảnh
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.1
end)

-- Khởi tạo biến
local _G = {
    Speed = 16,
    JumpPower = 50,
    InfJump = false,
    AutoClick = false,
    AntiAFK = false,
    AntiBan = false,
    Flying = false,
    FlySpeed = 50,
    Noclip = false,
    AutoFarmBlock = false
}

local StartTime = tick()

---------------------------------------------------------
-- TẠO CÁC TAB (GIỮ NGUYÊN 100%)
---------------------------------------------------------
local InfoTab = Window:CreateTab("Thông Tin", 4483362458)
local Tab = Window:CreateTab("Di Chuyển", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)
local TeleTab = Window:CreateTab("TELE ĐẢO", 4483362458)
local SettingTab = Window:CreateTab("Cài Đặt", 4483362458)

---------------------------------------------------------
-- TAB THÔNG TIN
---------------------------------------------------------
InfoTab:CreateSection("Thông Tin Script")
InfoTab:CreateLabel("Tác giả: SANG ĐẸP TRAI SỐ 1 THẾ GIỚI")
InfoTab:CreateLabel("Chủ đề: Gojo Satoru ❄️")
InfoTab:CreateButton({
   Name = "Hủy Menu (Destroy UI)",
   Callback = function() Rayfield:Destroy() end,
})

---------------------------------------------------------
-- TAB DI CHUYỂN
---------------------------------------------------------
Tab:CreateSection("Điều Chỉnh Di Chuyển")
Tab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 16,
   Callback = function(Value) _G.Speed = Value end,
})

Tab:CreateToggle({
   Name = "Nhảy Liên Tục (Inf Jump)",
   CurrentValue = false,
   Callback = function(Value) _G.InfJump = Value end,
})

Tab:CreateSection("Hệ Thống Bay (Fly Camera)")
Tab:CreateToggle({
   Name = "🚀 Bật Bay (Hướng Camera để bay)",
   CurrentValue = false,
   Callback = function(Value) 
      _G.Flying = Value 
      local char = game.Players.LocalPlayer.Character
      if not Value and char and char:FindFirstChild("HumanoidRootPart") then
          pcall(function()
              char.HumanoidRootPart:FindFirstChild("FlyVelocity"):Destroy()
              char.HumanoidRootPart:FindFirstChild("FlyGyro"):Destroy()
          end)
      end
   end,
})

Tab:CreateSlider({
   Name = "Tốc độ bay",
   Range = {10, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value) _G.FlySpeed = Value end,
})

-- Logic Bay theo Camera
task.spawn(function()
    while true do
        task.wait()
        if _G.Flying then
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local root = char.HumanoidRootPart
                local camera = workspace.CurrentCamera
                local bg = root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", root)
                bg.Name = "FlyGyro"
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 9e4
                bg.cframe = camera.CFrame
                local bv = root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", root)
                bv.Name = "FlyVelocity"
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                local moveDir = char.Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.velocity = camera.CFrame.LookVector * _G.FlySpeed
                else
                    bv.velocity = Vector3.new(0, 0.1, 0)
                end
            end)
        end
    end
end)

---------------------------------------------------------
-- TAB FARM
---------------------------------------------------------
FarmTab:CreateSection("Auto Farm Thông Minh")

FarmTab:CreateToggle({
   Name = "⛏️ Auto Farm Block (Tự cầm vũ khí)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarmBlock = Value end,
})

-- Logic Auto Farm & Auto Equip
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarmBlock then
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local backpack = player.Backpack
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                        local gui = v:FindFirstChildOfClass("BillboardGui")
                        if gui then
                            local img = gui:FindFirstChildOfClass("ImageLabel")
                            if img and img.Visible then
                                local id = tostring(img.Image)
                                local toolToEquip = ""
                                if id:find("pick") then toolToEquip = "Pickaxe"
                                elseif id:find("hamm") then toolToEquip = "Hammer"
                                elseif id:find("shov") then toolToEquip = "Shovel"
                                elseif id:find("swor") then toolToEquip = "Sword" end
                                for _, t in pairs(backpack:GetChildren()) do
                                    if t.Name:find(toolToEquip) then
                                        char.Humanoid:EquipTool(t)
                                        t:Activate()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

FarmTab:CreateSection("Vũ Khí Đặc Biệt")
FarmTab:CreateButton({
   Name = "🔥 TẠO TOOL CHỮ NHẬT (DAME QUÁI)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local tool = Instance.new("Tool")
      tool.Name = "SANG RECTANGLE BLADE"
      tool.RequiresHandle = true
      local handle = Instance.new("Part")
      handle.Name = "Handle"
      handle.Size = Vector3.new(10, 0.5, 3)
      handle.BrickColor = BrickColor.new("Really red")
      handle.Material = Enum.Material.Neon
      handle.Transparency = 0.4
      handle.Parent = tool
      handle.Touched:Connect(function(hit)
          if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= player.Name then
              hit.Parent.Humanoid.Health = hit.Parent.Humanoid.Health - 35
          end
      end)
      tool.Parent = player.Backpack
      Rayfield:Notify({Title = "SANG ĐẸP TRAI", Content = "Đã lấy Tool Chữ Nhật Ngang!", Duration = 2})
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Callback = function(Value) _G.AutoClick = Value end,
})

---------------------------------------------------------
-- TAB TELE ĐẢO
---------------------------------------------------------
TeleTab:CreateSection("Dịch Chuyển Nhanh")
TeleTab:CreateButton({
   Name = "🏠 Về Nhà (Spawn Location)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local spawn = game.Workspace:FindFirstChildOfClass("SpawnLocation")
      if spawn and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
          player.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
      end
   end,
})

-- Quét đảo
task.spawn(function()
    local islandPositions = {}
    local count = 0
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Size.X > 45 and v.Name ~= "Baseplate" then
            local isNew = true
            for _, pos in pairs(islandPositions) do
                if (v.Position - pos).Magnitude < 300 then isNew = false break end
            end
            if isNew then
                count = count + 1
                table.insert(islandPositions, v.Position)
                TeleTab:CreateButton({
                   Name = "🏝️ Dịch chuyển Đảo " .. count,
                   Callback = function()
                      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 15, 0)
                   end,
                })
            end
        end
        if count >= 8 then break end
    end
end)

---------------------------------------------------------
-- TAB CÀI ĐẶT
---------------------------------------------------------
SettingTab:CreateSection("🎨 GIAO DIỆN MENU")

SettingTab:CreateSlider({
   Name = "Độ mờ ảnh nền",
   Range = {0, 10},
   Increment = 1,
   CurrentValue = 3,
   Callback = function(Value)
      local bg = game:GetService("CoreGui").Rayfield.Main:FindFirstChild("GojoBackground")
      if bg then bg.ImageTransparency = Value/10 end
   end,
})

SettingTab:CreateSection("⏱️ THỐNG KÊ THỜI GIAN")
local PlayTimeLabel = SettingTab:CreateLabel("Thời gian chơi: 00:00:00")

task.spawn(function()
    while task.wait(1) do
        local Seconds = math.floor(tick() - StartTime)
        local Mins = math.floor(Seconds / 60)
        local Hours = math.floor(Mins / 60)
        PlayTimeLabel:Set(string.format("Thời gian chơi: %02d:%02d:%02d", Hours, Mins % 60, Seconds % 60))
    end
end)

SettingTab:CreateSection("Hệ Thống Gian Lận")
SettingTab:CreateToggle({
   Name = "👻 Đi Xuyên Tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value) _G.Noclip = Value end,
})

SettingTab:CreateSection("Bảo Mật & Tối Ưu")
SettingTab:CreateToggle({Name = "🛡️ Anti Ban", CurrentValue = false, Callback = function(Value) _G.AntiBan = Value end})
SettingTab:CreateToggle({Name = "💤 Anti AFK", CurrentValue = false, Callback = function(Value) _G.AntiAFK = Value end})
SettingTab:CreateButton({
   Name = "🚀 FIX LAG 100%",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("Part") then v.Material = Enum.Material.Plastic end
      end
      Rayfield:Notify({Title = "SANG", Content = "Đã tối ưu FPS!", Duration = 2})
   end,
})

---------------------------------------------------------
-- LOGIC HỆ THỐNG CHẠY NGẦM
---------------------------------------------------------
game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip then
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and not _G.Flying then
            char.Humanoid.WalkSpeed = _G.Speed
        end
    end)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then pcall(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(3) end) end
end)

task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
    while true do
        if _G.AutoClick then
            pcall(function()
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.01)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
        task.wait(0.1)
    end
end)

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)
