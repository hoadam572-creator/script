repeat task.wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local vUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

pcall(function()
	game.CoreGui:FindFirstChild("MiniCombatHub"):Destroy()
end)

local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "MiniCombatHub"

-- MENU
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,240,0,330)
frame.Position = UDim2.new(0.7,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

-- VIỀN 7 MÀU
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
title.Size = UDim2.new(1,0,0,40)
title.Text = "⚡ MINI COMBAT HUB"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local function makeBtn(text,y)
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

-- BUTTONS
local bandBtn = makeBtn("AUTO BANDAGE: OFF",50)
local moneyBtn = makeBtn("AUTO MONEY AURA: OFF",95)
local farmBtn = makeBtn("FARM CITYNPC: OFF",140)
local weaponBtn = makeBtn("AUTO WEAPON: OFF",185)

-- VARIABLES
local band=false
local moneyAura=false
local farmNPC=false
local autoWeapon=false
local lastHeal=0

local radius=10
local speed=9

-- AUTO BANDAGE
bandBtn.MouseButton1Click:Connect(function()
	band = not band
	bandBtn.Text = band and "AUTO BANDAGE: ON" or "AUTO BANDAGE: OFF"
end)

-- AUTO MONEY
moneyBtn.MouseButton1Click:Connect(function()
	moneyAura = not moneyAura
	moneyBtn.Text = moneyAura and "AUTO MONEY AURA: ON" or "AUTO MONEY AURA: OFF"
end)

task.spawn(function()
	while true do
		if moneyAura then
			for _,v in pairs(workspace:GetDescendants()) do
				if v:IsA("ProximityPrompt") and v.ActionText=="Lụm" then
					fireproximityprompt(v)
				end
			end
		end
		task.wait(0.2)
	end
end)

-- FARM NPC
farmBtn.MouseButton1Click:Connect(function()
	farmNPC = not farmNPC
	farmBtn.Text = farmNPC and "FARM CITYNPC: ON" or "FARM CITYNPC: OFF"
end)

RunService.RenderStepped:Connect(function()

	if farmNPC then

		local char = plr.Character
		if not char then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		for _,npc in pairs(workspace:GetDescendants()) do

			if npc.Name == "CityNPC" then

				local root = npc:FindFirstChild("HumanoidRootPart")
				local hum = npc:FindFirstChild("Humanoid")

				if root and hum and hum.Health > 0 then

					local t = tick()*speed

					local pos = root.Position + Vector3.new(
						math.cos(t)*radius,
						2,
						math.sin(t)*radius
					)

					hrp.CFrame = CFrame.new(pos,root.Position)

					vUser:Button1Down(Vector2.new(),workspace.CurrentCamera.CFrame)
					task.wait()
					vUser:Button1Up(Vector2.new(),workspace.CurrentCamera.CFrame)

					break
				end
			end
		end
	end

end)

-- AUTO WEAPON
weaponBtn.MouseButton1Click:Connect(function()
	autoWeapon = not autoWeapon
	weaponBtn.Text = autoWeapon and "AUTO WEAPON: ON" or "AUTO WEAPON: OFF"
end)

-- DIST
local distLabel = Instance.new("TextLabel",frame)
distLabel.Size = UDim2.new(0.45,0,0,35)
distLabel.Position = UDim2.new(0.05,0,0,230)
distLabel.Text = "DIST"
distLabel.TextScaled = true
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = Color3.new(1,1,1)

local distBox = Instance.new("TextBox",frame)
distBox.Size = UDim2.new(0.4,0,0,35)
distBox.Position = UDim2.new(0.55,0,0,230)
distBox.Text = tostring(radius)
distBox.TextScaled = true
distBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
distBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",distBox)

distBox.FocusLost:Connect(function()
	local num = tonumber(distBox.Text)
	if num then radius=num end
end)

-- SPEED
local speedLabel = Instance.new("TextLabel",frame)
speedLabel.Size = UDim2.new(0.45,0,0,35)
speedLabel.Position = UDim2.new(0.05,0,0,275)
speedLabel.Text = "SPEED"
speedLabel.TextScaled = true
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)

local speedBox = Instance.new("TextBox",frame)
speedBox.Size = UDim2.new(0.4,0,0,35)
speedBox.Position = UDim2.new(0.55,0,0,275)
speedBox.Text = tostring(speed)
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",speedBox)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then speed=num end
end)

-- NÚT TRÒN ★
local hub = Instance.new("TextButton",gui)
hub.Size = UDim2.new(0,55,0,55)
hub.Position = UDim2.new(0,20,0.5,-25)
hub.Text = "★"
hub.TextScaled = true
hub.TextColor3 = Color3.new(1,1,1)
hub.BackgroundColor3 = Color3.fromRGB(20,20,20)

local corner = Instance.new("UICorner",hub)
corner.CornerRadius = UDim.new(1,0)

local hubStroke = Instance.new("UIStroke",hub)
hubStroke.Thickness = 3

task.spawn(function()
	while true do
		for i=0,1,0.01 do
			hubStroke.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

hub.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- ANTI AFK
plr.Idled:Connect(function()
	vUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(1)
	vUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
