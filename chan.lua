repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-------------------------------------------------
-- 🔥 LOADING FULL MÀN HÌNH
-------------------------------------------------
local loading = Instance.new("ScreenGui", game.CoreGui)

local bg = Instance.new("Frame", loading)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)

local text = Instance.new("TextLabel", bg)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.TextScaled = true
text.Font = Enum.Font.GothamBlack
text.TextColor3 = Color3.new(1,1,1)

-- đếm 3 2 1
for i = 3,1,-1 do
    text.Text = tostring(i)
    task.wait(0.6)
end

text.Text = ""
task.wait(0.2)

-- chữ rơi từng ký tự
local word = "DIT ME MAY" -- muốn đổi thì sửa ở đây

for i = 1,#word do
    local char = word:sub(i,i)

    local letter = Instance.new("TextLabel", bg)
    letter.Size = UDim2.new(0,50,0,50)
    letter.Position = UDim2.new(0.5,(i-#word/2)*30,-0.3,0)
    letter.BackgroundTransparency = 1
    letter.Text = char
    letter.TextScaled = true
    letter.Font = Enum.Font.GothamBlack
    letter.TextColor3 = Color3.fromHSV(i/#word,1,1)

    task.spawn(function()
        for y = -0.3,0.4,0.035 do
            letter.Position = UDim2.new(0.5,(i-#word/2)*30,y,0)
            task.wait(0.01)
        end
    end)

    task.wait(0.1)
end

task.wait(2)
loading:Destroy()

-------------------------------------------------
-- 🔘 NÚT ☰
-------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0,200)
toggleBtn.Text = "☰"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Active = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- DRAG NÚT
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = toggleBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingBtn = false end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputBtn = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - dragStartBtn
        toggleBtn.Position = UDim2.new(
            startPosBtn.X.Scale,
            startPosBtn.X.Offset + delta.X,
            startPosBtn.Y.Scale,
            startPosBtn.Y.Offset + delta.Y
        )
    end
end)

-------------------------------------------------
-- 💎 MENU
-------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,280)
frame.Position = UDim2.new(0,80,0,100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Visible = false
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- viền RGB
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

task.spawn(function()
    while true do
        for i=0,1,0.01 do
            stroke.Color = Color3.fromHSV(i,1,1)
            task.wait()
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- DRAG MENU
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-------------------------------------------------
-- 🔘 BUTTON
-------------------------------------------------
local function btn(name,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0,160,0,40)
    b.Position = UDim2.new(0.5,-80,0,y)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(0,170,255)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    return b
end

local aimBtn = btn("AIM OFF",30)
local espBtn = btn("ESP OFF",80)
local fovBtn = btn("FOV OFF",130)
local noclipBtn = btn("NOCLIP OFF",180)

-- FOV
local fov = 120
local fovBox = Instance.new("TextBox", frame)
fovBox.Size = UDim2.new(0,160,0,35)
fovBox.Position = UDim2.new(0.5,-80,0,230)
fovBox.PlaceholderText = "Nhập FOV"
Instance.new("UICorner", fovBox).CornerRadius = UDim.new(1,0)

fovBox.FocusLost:Connect(function()
    local n = tonumber(fovBox.Text)
    if n then fov = math.clamp(n,20,500) end
end)

-- STATE
local aiming = false
local esp = false
local showFov = false
local noclip = false

aimBtn.MouseButton1Click:Connect(function()
    aiming = not aiming
    aimBtn.Text = aiming and "AIM ON" or "AIM OFF"
end)

espBtn.MouseButton1Click:Connect(function()
    esp = not esp
    espBtn.Text = esp and "ESP ON" or "ESP OFF"
end)

fovBtn.MouseButton1Click:Connect(function()
    showFov = not showFov
    fovBtn.Text = showFov and "FOV ON" or "FOV OFF"
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "NOCLIP ON" or "NOCLIP OFF"
end)

-------------------------------------------------
-- 🧱 NOCLIP
-------------------------------------------------
RunService.Stepped:Connect(function()
    if noclip then
        local char = LocalPlayer.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-------------------------------------------------
-- 🎯 AIM + ESP
-------------------------------------------------
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.Filled = false

local drawings = {}

local function getClosest()
    local closest, dist = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local root = p.Character:FindFirstChild("HumanoidRootPart")

            if hum and root and hum.Health > 0 then
                local d = (root.Position - myChar.HumanoidRootPart.Position).Magnitude
                local pos,vis = Camera:WorldToViewportPoint(root.Position)

                if vis and d < dist and d <= fov then
                    dist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()

    -- FOV
    circle.Position = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    circle.Radius = fov
    circle.Color = Color3.fromRGB(0,255,0)
    circle.Visible = showFov

    -- AIM
    if aiming then
        local t = getClosest()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position,
                t.Character.HumanoidRootPart.Position)
        end
    end

    -- ESP FULL
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

            if not drawings[p] then
                drawings[p] = {
                    line = Drawing.new("Line"),
                    box = Drawing.new("Square")
                }
            end

            local root = p.Character.HumanoidRootPart
            local pos = Camera:WorldToViewportPoint(root.Position)

            if esp then
                drawings[p].line.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                drawings[p].line.To = Vector2.new(pos.X,pos.Y)
                drawings[p].line.Color = Color3.fromRGB(255,0,0)
                drawings[p].line.Visible = true

                local distance = (root.Position - Camera.CFrame.Position).Magnitude
                local size = math.clamp(3000 / distance, 20, 120)

                drawings[p].box.Size = Vector2.new(size,size)
                drawings[p].box.Position = Vector2.new(pos.X-size/2,pos.Y-size/2)
                drawings[p].box.Color = Color3.fromRGB(0,255,0)
                drawings[p].box.Filled = false
                drawings[p].box.Visible = true
            else
                drawings[p].line.Visible = false
                drawings[p].box.Visible = false
            end
        end
    end
end)
