repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AimMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,170,0,100)
frame.Position = UDim2.new(0.6,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🎯 Aim Skill"
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.TextColor3 = Color3.new(1,1,1)

local aim = false

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8,0,0,35)
btn.Position = UDim2.new(0.1,0,0.45,0)
btn.Text = "Aim OFF"

btn.MouseButton1Click:Connect(function()
    aim = not aim
    btn.Text = aim and "Aim ON" or "Aim OFF"
end)

-- TÌM ĐỊCH KHÁC TEAM
function getEnemy()

    local closest = nil
    local dist = math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Team ~= player.Team then

            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then

                local mag = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude

                if mag < dist then
                    dist = mag
                    closest = v
                end

            end

        end
    end

    return closest

end

RunService.RenderStepped:Connect(function()

    if aim then

        local target = getEnemy()

        if target and target.Character and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end

    end

end)
