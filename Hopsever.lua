--// SERVICES
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ProMaxFull"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 270, 0, 300) -- tăng size để đủ nút
Main.Position = UDim2.new(0.5, -135, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "⚡ PRO MAX TOOL"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- HOP BUTTON
local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(0.8,0,0,35)
HopBtn.Position = UDim2.new(0.1,0,0.18,0)
HopBtn.Text = "🚀 Hop Server"
HopBtn.BackgroundColor3 = Color3.fromRGB(40,120,255)
HopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", HopBtn)

-- RESET BUTTON
local ResetBtn = Instance.new("TextButton", Main)
ResetBtn.Size = UDim2.new(0.8,0,0,35)
ResetBtn.Position = UDim2.new(0.1,0,0.35,0)
ResetBtn.Text = "💀 Fast Reset"
ResetBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
ResetBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ResetBtn)

-- AUTO PICK BUTTON
local AutoBtn = Instance.new("TextButton", Main)
AutoBtn.Size = UDim2.new(0.8,0,0,35)
AutoBtn.Position = UDim2.new(0.1,0,0.52,0)
AutoBtn.Text = "🔴 Auto Pick: OFF"
AutoBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
AutoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AutoBtn)

-- SPEED BUTTON
local SpeedBtn = Instance.new("TextButton", Main)
SpeedBtn.Size = UDim2.new(0.8,0,0,35)
SpeedBtn.Position = UDim2.new(0.1,0,0.69,0)
SpeedBtn.Text = "🔴 Speed 30: OFF"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
SpeedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SpeedBtn)

--// DRAG
local dragging, dragInput, dragStart, startPos

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// HOP SERVER
local function HopServer()
	local PlaceID = game.PlaceId
	local JobID = game.JobId

	local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
	local data = HttpService:JSONDecode(game:HttpGet(url))

	for _, v in pairs(data.data) do
		if v.playing < v.maxPlayers and v.id ~= JobID then
			TeleportService:TeleportToPlaceInstance(PlaceID, v.id, player)
			task.wait(1)
			break
		end
	end
end

--// RESET
local function FastReset()
	if player.Character then
		player.Character:BreakJoints()
	end
end

--// AUTO PICK (HOLD E FIX)
local autoPick = false

task.spawn(function()
	while true do
		if autoPick and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ProximityPrompt") then
					
					local part = v.Parent
					if part and part:IsA("BasePart") then
						
						local distance = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
						
						if distance <= 15 then
							pcall(function()
								v.HoldDuration = 1
								fireproximityprompt(v)
							end)
						end
						
					end
				end
			end
		end
		
		task.wait(0.1)
	end
end)

--// SPEED SYSTEM
local speedOn = false
local normalSpeed = 16
local boostSpeed = 30

task.spawn(function()
	while true do
		if speedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			
			if hum.WalkSpeed ~= boostSpeed then
				hum.WalkSpeed = boostSpeed
			end
		end
		
		task.wait(0.2)
	end
end)

--// EVENTS
HopBtn.MouseButton1Click:Connect(function()
	HopBtn.Text = "⏳ Loading..."
	HopServer()
	task.wait(1)
	HopBtn.Text = "🚀 Hop Server"
end)

ResetBtn.MouseButton1Click:Connect(function()
	FastReset()
end)

AutoBtn.MouseButton1Click:Connect(function()
	autoPick = not autoPick
	
	if autoPick then
		AutoBtn.Text = "🟢 Auto Pick: ON"
		AutoBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
	else
		AutoBtn.Text = "🔴 Auto Pick: OFF"
		AutoBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	end
end)

SpeedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	
	if speedOn then
		SpeedBtn.Text = "🟢 Speed 30: ON"
		SpeedBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
		
		if hum then hum.WalkSpeed = boostSpeed end
	else
		SpeedBtn.Text = "🔴 Speed 30: OFF"
		SpeedBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
		
		if hum then hum.WalkSpeed = normalSpeed end
	end
end)
