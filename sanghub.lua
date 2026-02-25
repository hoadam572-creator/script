repeat task.wait()until game:IsLoaded()p=game.Players.LocalPlayer
g=Instance.new("ScreenGui",game.CoreGui)
f=Instance.new("Frame",g)f.Size=UDim2.new(0,220,0,140)f.Position=UDim2.new(.4,0,.3,0)f.BackgroundColor3=Color3.fromRGB(30,30,30)f.Active=1 f.Draggable=1
t=Instance.new("TextLabel",f)t.Size=UDim2.new(1,0,0,30)t.Text="MENUANTI✈️"t.BackgroundColor3=Color3.fromRGB(50,50,50)t.TextColor3=Color3.new(1,1,1)

b=Instance.new("TextBox",f)b.Size=UDim2.new(.8,0,0,30)b.Position=UDim2.new(.1,0,.3,0)
o=Instance.new("TextButton",f)o.Size=UDim2.new(.8,0,0,30)o.Position=UDim2.new(.1,0,.55,0)o.Text="OK"
l=Instance.new("TextButton",f)l.Size=UDim2.new(.6,0,0,25)l.Position=UDim2.new(.2,0,.8,0)l.Text="KEY"

l.MouseButton1Click:Connect(function()setclipboard("https://link4m.com/gZTh7")end)

o.MouseButton1Click:Connect(function()
if b.Text~="SANGHUB"then return end g:Destroy()

g=Instance.new("ScreenGui",game.CoreGui)
f=Instance.new("Frame",g)f.Size=UDim2.new(0,200,0,100)f.Position=UDim2.new(.1,0,.3,0)f.BackgroundColor3=Color3.fromRGB(30,30,30)f.Active=1 f.Draggable=1
t=Instance.new("TextLabel",f)t.Size=UDim2.new(1,0,0,25)t.Text="MENUANTI✈️"t.BackgroundColor3=Color3.fromRGB(50,50,50)t.TextColor3=Color3.new(1,1,1)

o=Instance.new("TextButton",f)o.Size=UDim2.new(.8,0,0,40)o.Position=UDim2.new(.1,0,.4,0)o.Text="OFF"

x=0 o.MouseButton1Click:Connect(function()x=not x o.Text=x and"ON"or"OFF"end)

while task.wait(.1)do
if x then
h=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if h then
q=Instance.new("Part",workspace)
q.Size=Vector3.new(10,1,10)
q.Position=h.Position-Vector3.new(0,3,0)
q.Anchored=1
q.Transparency=.3
q.Material="Neon"
q.Color=Color3.fromRGB(0,255,0)
game.Debris:AddItem(q,2)
end
end
end
end)
