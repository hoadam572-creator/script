repeat task.wait() until game:IsLoaded()

-- SERVICES
local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local vUser = game:GetService("VirtualUser")

-- VARIABLES
local farming=false
local bandage=false
local radius=22
local speed=25
local lastHeal=0
local lastWeapon=nil

-- ANTI AFK
plr.Idled:Connect(function()
vUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
task.wait(1)
vUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

pcall(function()
game.CoreGui:FindFirstChild("SANGLYDO"):Destroy()
game.CoreGui:FindFirstChild("BossHP"):Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name="SANGLYDO"

-- OPEN BUTTON
local open = Instance.new("TextButton",gui)
open.Size=UDim2.new(0,55,0,55)
open.Position=UDim2.new(0.02,0,0.55,0)
open.Text="≡"
open.TextScaled=true
open.BackgroundColor3=Color3.fromRGB(0,0,0)
open.TextColor3=Color3.new(1,1,1)
open.Active=true
open.Draggable=true
Instance.new("UICorner",open).CornerRadius=UDim.new(1,0)

-- MENU
local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,280,0,260)
frame.Position=UDim2.new(0.75,0,0.3,0)
frame.BackgroundColor3=Color3.fromRGB(0,0,0)
frame.BackgroundTransparency=0.35
frame.Visible=false
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

open.MouseButton1Click:Connect(function()
frame.Visible=not frame.Visible
end)

-- RAINBOW BORDER
local stroke=Instance.new("UIStroke",frame)
stroke.Thickness=3

task.spawn(function()
while true do
for i=0,1,0.01 do
stroke.Color=Color3.fromHSV(i,1,1)
task.wait()
end
end
end)

-- TITLE
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,30)
title.Text="SANGLYDO"
title.TextScaled=true
title.BackgroundTransparency=1
title.TextColor3=Color3.fromRGB(0,255,120)

-- CREDIT
local credit=Instance.new("TextLabel",frame)
credit.Size=UDim2.new(1,0,0,20)
credit.Position=UDim2.new(0,0,0,30)
credit.Text="TT: trumscript5"
credit.TextScaled=true
credit.BackgroundTransparency=1
credit.TextColor3=Color3.fromRGB(200,200,200)

-- FARM BUTTON
local farmBtn=Instance.new("TextButton",frame)
farmBtn.Size=UDim2.new(0.9,0,0,35)
farmBtn.Position=UDim2.new(0.05,0,0,60)
farmBtn.Text="TẮT: Farm Boss"
farmBtn.TextScaled=true
farmBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
farmBtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",farmBtn)

farmBtn.MouseButton1Click:Connect(function()
farming=not farming
farmBtn.Text=farming and "BẬT: Farm Boss" or "TẮT: Farm Boss"
end)

-- BANDAGE BUTTON
local bandageBtn=Instance.new("TextButton",frame)
bandageBtn.Size=UDim2.new(0.9,0,0,35)
bandageBtn.Position=UDim2.new(0.05,0,0,100)
bandageBtn.Text="TẮT: Auto Bandage"
bandageBtn.TextScaled=true
bandageBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
bandageBtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",bandageBtn)

bandageBtn.MouseButton1Click:Connect(function()
bandage=not bandage
bandageBtn.Text=bandage and "BẬT: Auto Bandage" or "TẮT: Auto Bandage"
end)

-- AUTO PICKUP BUTTON (GIỮ NGUYÊN MENU)
local pickup = false

local pickupBtn = Instance.new("TextButton", frame)
pickupBtn.Size = UDim2.new(0.9,0,0,35)
pickupBtn.Position = UDim2.new(0.05,0,0,140) -- 👈 ngay dưới bandage
pickupBtn.Text = "TẮT: Auto Nhặt"
pickupBtn.TextScaled = true
pickupBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
pickupBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", pickupBtn)

pickupBtn.MouseButton1Click:Connect(function()
    pickup = not pickup
    pickupBtn.Text = pickup and "BẬT: Auto Nhặt" or "TẮT: Auto Nhặt"
end)

-- RADIUS INPUT
local radiusBox=Instance.new("TextBox",frame)
radiusBox.Size=UDim2.new(0.9,0,0,30)
radiusBox.Position=UDim2.new(0.05,0,0,185)
radiusBox.PlaceholderText="Khoảng cách (Radius)"
radiusBox.Text=""
radiusBox.TextScaled=true
radiusBox.BackgroundColor3=Color3.fromRGB(40,40,40)
radiusBox.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",radiusBox) 

radiusBox.FocusLost:Connect(function()
local num=tonumber(radiusBox.Text)
if num then
radius=num
end
end)

-- SPEED INPUT
local speedBox=Instance.new("TextBox",frame)
speedBox.Size=UDim2.new(0.9,0,0,30)
speedBox.Position=UDim2.new(0.05,0,0,225)
speedBox.PlaceholderText="Tốc độ (Speed)"
speedBox.Text=""
speedBox.TextScaled=true
speedBox.BackgroundColor3=Color3.fromRGB(40,40,40)
speedBox.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",speedBox)

speedBox.FocusLost:Connect(function()
local num=tonumber(speedBox.Text)
if num then
speed=num
end
end)

-- ===== BOSS HP BAR =====

local hpGui = Instance.new("ScreenGui",game.CoreGui)
hpGui.Name="BossHP"

local back = Instance.new("Frame",hpGui)
back.Size = UDim2.new(0,520,0,32)
back.Position = UDim2.new(0.5,-260,0.08,0)
back.BackgroundTransparency = 1
back.BorderSizePixel = 0
Instance.new("UICorner",back)

local stroke2 = Instance.new("UIStroke",back)
stroke2.Thickness=3

task.spawn(function()
while true do
for i=0,1,0.01 do
stroke2.Color=Color3.fromHSV(i,1,1)
task.wait()
end
end
end)

local bar = Instance.new("Frame",back)
bar.Size=UDim2.new(1,0,1,0)
bar.BackgroundColor3=Color3.fromRGB(0,255,120)
bar.BorderSizePixel=0
Instance.new("UICorner",bar)

local text=Instance.new("TextLabel",back)
text.Size=UDim2.new(1,0,1,0)
text.BackgroundTransparency=1
text.TextScaled=true
text.Font=Enum.Font.GothamBold
text.TextColor3=Color3.fromRGB(120,0,255)

RunService.RenderStepped:Connect(function()

for _,v in pairs(workspace:GetDescendants()) do

if v:FindFirstChild("Humanoid") and v~=plr.Character then

local hum=v:FindFirstChild("Humanoid")

if hum and hum.Health>0 then

local hp=hum.Health
local maxhp=hum.MaxHealth
local percent=hp/maxhp

bar.Size=UDim2.new(percent,0,1,0)
text.Text=math.floor(hp).." / "..math.floor(maxhp)

break
end
end
end

end)

-- AUTO ATTACK
task.spawn(function()
while true do
if farming then
vUser:Button1Down(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)
task.wait(0.07)
vUser:Button1Up(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)
end
task.wait()
end
end)

-- AUTO BANDAGE
task.spawn(function()
while true do
if bandage then
local char=plr.Character
if char then
local hum=char:FindFirstChildOfClass("Humanoid")
if hum and hum.Health < hum.MaxHealth*0.6 and tick()-lastHeal>2 then

local tool=plr.Backpack:FindFirstChild("băng gạc") or plr.Backpack:FindFirstChild("Bandage")

if tool then
lastWeapon=char:FindFirstChildOfClass("Tool")
hum:EquipTool(tool)

vUser:Button1Down(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)
task.wait(0.2)
vUser:Button1Up(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)

task.wait(1)

if lastWeapon then
hum:EquipTool(lastWeapon)
end

lastHeal=tick()

end
end
end
end
task.wait(0.5)
end
end)

-- FARM NPC2
RunService.RenderStepped:Connect(function()

if farming then

local char=plr.Character
if not char then return end

local hrp=char:FindFirstChild("HumanoidRootPart")
if not hrp then return end

for _,v in pairs(workspace:GetDescendants()) do

if v.Name=="NPC2" then

local root=v:FindFirstChild("HumanoidRootPart")
local hum=v:FindFirstChild("Humanoid")

if root and hum and hum.Health>0 then

local t=tick()*speed
local x=math.cos(t)*radius
local z=math.sin(t)*radius

local pos=root.Position+Vector3.new(x,3,z)

hrp.CFrame=CFrame.new(pos,root.Position)

break
end
end
end
end

end) task.spawn(function()
    while true do
        if pickup then
            local char = plr.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then

                    for _,v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Enabled then
                            local part = v.Parent
                            if part and part:IsA("BasePart") then
                                if (part.Position - hrp.Position).Magnitude <= 12 then
                                    pcall(function()
                                        fireproximityprompt(v)
                                    end)
                                    task.wait(0.2) -- 👈 giảm lag
                                end
                            end
                        end
                    end

                end
            end
        end
        task.wait(1)
    end
end) 
