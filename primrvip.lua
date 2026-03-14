repeat task.wait() until game:IsLoaded()

-- ANTI AFK
local VirtualUser = game:GetService("VirtualUser")

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local vUser = game:GetService("VirtualUser")

pcall(function()
	game.CoreGui.PrimeVip:Destroy()
end)

local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name="PrimeVip"

-- NÚT TRÒN MỞ MENU (NỀN ĐEN)
local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,55,0,55)
open.Position = UDim2.new(0.02,0,0.55,0)
open.Text = "♣"
open.TextScaled = true
open.BackgroundColor3 = Color3.fromRGB(0,0,0)
open.TextColor3 = Color3.new(1,1,1)
open.Active=true
open.Draggable=true

local corner = Instance.new("UICorner",open)
corner.CornerRadius = UDim.new(1,0)

-- VIỀN 7 MÀU NÚT
local strokeOpen = Instance.new("UIStroke",open)
strokeOpen.Thickness = 3

task.spawn(function()
	while true do
		for i=0,1,0.01 do
			strokeOpen.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

-- FRAME MENU
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,320,0,370)
frame.Position = UDim2.new(0.72,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.35
frame.Visible=false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

open.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- VIỀN 7 MÀU MENU
local stroke = Instance.new("UIStroke",frame)
stroke.Thickness = 3

task.spawn(function()
	while true do
		for i=0,1,0.01 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,45)
title.Text = "Prime Vip"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,255,120)
title.BackgroundTransparency = 1

local function btn(text,y)
	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0.9,0,0,35)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
	return b
end

local orbitBtn = btn("TẮT: Đánh Boss",50)

local distMinus = btn("-",95)
distMinus.Size = UDim2.new(0.2,0,0,35)

local distText = btn("12",95)
distText.Size = UDim2.new(0.4,0,0,35)
distText.Position = UDim2.new(0.3,0,0,95)

local distPlus = btn("+",95)
distPlus.Size = UDim2.new(0.2,0,0,35)
distPlus.Position = UDim2.new(0.75,0,0,95)

local speedMinus = btn("-",135)
speedMinus.Size = UDim2.new(0.2,0,0,35)

local speedText = btn("20",135)
speedText.Size = UDim2.new(0.4,0,0,35)
speedText.Position = UDim2.new(0.3,0,0,135)

local speedPlus = btn("+",135)
speedPlus.Size = UDim2.new(0.2,0,0,35)
speedPlus.Position = UDim2.new(0.75,0,0,135)

local hpLabel = btn("Máu mục tiêu: ...",175)

local autoBtn = btn("TẮT: Auto Đánh",215)
local moneyBtn = btn("TẮT: Auto Nhặt",255)
local bandageBtn = btn("TẮT: Auto Bandage",295)
local noclipBtn = btn("TẮT: Noclip",335)

local orbit=false
local auto=false
local money=false
local noclip=false
local bandage=false

local radius=12
local speed=20
local lastHeal=0
local lastWeapon=nil

distPlus.MouseButton1Click:Connect(function()
	radius=radius+1
	distText.Text=radius
end)

distMinus.MouseButton1Click:Connect(function()
	radius=math.max(3,radius-1)
	distText.Text=radius
end)

speedPlus.MouseButton1Click:Connect(function()
	speed=speed+2
	speedText.Text=speed
end)

speedMinus.MouseButton1Click:Connect(function()
	speed=math.max(1,speed-2)
	speedText.Text=speed
end)

orbitBtn.MouseButton1Click:Connect(function()
	orbit=not orbit
	orbitBtn.Text = orbit and "BẬT: Đánh Boss" or "TẮT: Đánh Boss"
end)

autoBtn.MouseButton1Click:Connect(function()
	auto=not auto
	autoBtn.Text = auto and "BẬT: Auto Đánh" or "TẮT: Auto Đánh"
end)

task.spawn(function()
	while true do
		if auto then
			vUser:Button1Down(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)
			task.wait(0.07)
			vUser:Button1Up(Vector2.new(-1000,-1000),workspace.CurrentCamera.CFrame)
		end
		task.wait()
	end
end)

moneyBtn.MouseButton1Click:Connect(function()
	money=not money
	moneyBtn.Text = money and "BẬT: Auto Nhặt" or "TẮT: Auto Nhặt"
end)

task.spawn(function()
	while true do
		if money then
			for _,v in pairs(workspace:GetDescendants()) do
				if v:IsA("ProximityPrompt") then
					fireproximityprompt(v)
				end
			end
		end
		task.wait(0.3)
	end
end)

bandageBtn.MouseButton1Click:Connect(function()
	bandage=not bandage
	bandageBtn.Text = bandage and "BẬT: Auto Bandage" or "TẮT: Auto Bandage"
end)

task.spawn(function()
	while true do
		if bandage then
			local char = plr.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health < hum.MaxHealth*0.6 and tick()-lastHeal>2 then
					local tool = plr.Backpack:FindFirstChildOfClass("Tool")
					if tool then
						lastWeapon = char:FindFirstChildOfClass("Tool")
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

noclipBtn.MouseButton1Click:Connect(function()
	noclip=not noclip
	noclipBtn.Text = noclip and "BẬT: Noclip" or "TẮT: Noclip"
end)

RunService.Stepped:Connect(function()
	if noclip and plr.Character then
		for _,v in pairs(plr.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide=false
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()

	if orbit then

		local char=plr.Character
		if not char then return end

		local hrp=char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		for _,v in pairs(workspace:GetDescendants()) do

			if v:FindFirstChild("Humanoid") and v~=char then

				local root=v:FindFirstChild("HumanoidRootPart")
				local hum=v:FindFirstChild("Humanoid")

				if root and hum and hum.Health>0 then

					hpLabel.Text="Máu mục tiêu: "..math.floor(hum.Health)

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
end) 
