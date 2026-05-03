--// SERVICES
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)

ScreenGui.Name = "ProMaxFinal"
Main.Size = UDim2.new(0, 300, 0, 360)
Main.Position = UDim2.new(0.5, -150, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", Main)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "⚡ PRO TOOL"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)

-- BUTTON TEMPLATE
local function makeBtn(text, y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(0.8,0,0,30)
	b.Position = UDim2.new(0.1,0,y,0)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local HopBtn = makeBtn("🚀 Hop Server",0.12)
local ResetBtn = makeBtn("💀 Reset",0.22)
local AutoBtn = makeBtn("🔴 Auto Pick OFF",0.32)

-- SPEED TITLE
local SpeedLabel = Instance.new("TextLabel", Main)
SpeedLabel.Size = UDim2.new(1,0,0,30)
SpeedLabel.Position = UDim2.new(0,0,0.42,0)
SpeedLabel.Text = "⚡ SPEED SELECT"
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1,1,1)

-- SPEED BUTTONS
local speeds = {10,20,30,35,40,45,50}
local speedOn = false
local currentSpeed = 16

for i,v in ipairs(speeds) do
	local btn = makeBtn("Speed "..v, 0.42 + (i*0.06))
	
	btn.MouseButton1Click:Connect(function()
		speedOn = true
		currentSpeed = v
		btn.Text = "🟢 Speed "..v
	end)
end

-- DRAG
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- HOP
HopBtn.MouseButton1Click:Connect(function()
	local PlaceID = game.PlaceId
	local JobID = game.JobId
	local data = HttpService:JSONDecode(game:HttpGet(
		"https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?limit=100"
	))
	for _,v in pairs(data.data) do
		if v.id ~= JobID then
			TeleportService:TeleportToPlaceInstance(PlaceID,v.id,player)
			break
		end
	end
end)

-- RESET
ResetBtn.MouseButton1Click:Connect(function()
	if player.Character then
		player.Character:BreakJoints()
	end
end)

-- AUTO PICK (OPTIMIZED)
local autoPick = false

AutoBtn.MouseButton1Click:Connect(function()
	autoPick = not autoPick
	AutoBtn.Text = autoPick and "🟢 Auto Pick ON" or "🔴 Auto Pick OFF"
end)

task.spawn(function()
	while true do
		if autoPick and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local closest, dist = nil, 15
				
				for _,v in pairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
						local d = (v.Parent.Position - hrp.Position).Magnitude
						if d < dist then
							dist = d
							closest = v
						end
					end
				end
				
				if closest then
					pcall(function()
						fireproximityprompt(closest)
					end)
				end
			end
		end
		task.wait(0.2)
	end
end)

-- SPEED LOOP
task.spawn(function()
	while true do
		if speedOn and player.Character then
			local hum = player.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = currentSpeed
			end
		end
		task.wait(0.1)
	end
end)
