--// SERVICES
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ProMaxGUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 270, 0, 230)
Main.Position = UDim2.new(0.5, -135, 0.5, -115)
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

-- BUTTON HOP
local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(0.8,0,0,35)
HopBtn.Position = UDim2.new(0.1,0,0.25,0)
HopBtn.Text = "🚀 Hop Server"
HopBtn.BackgroundColor3 = Color3.fromRGB(40,120,255)
HopBtn.TextColor3 = Color3.new(1,1,1)
HopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", HopBtn)

-- BUTTON RESET
local ResetBtn = Instance.new("TextButton", Main)
ResetBtn.Size = UDim2.new(0.8,0,0,35)
ResetBtn.Position = UDim2.new(0.1,0,0.45,0)
ResetBtn.Text = "💀 Fast Reset"
ResetBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ResetBtn)

-- TOGGLE AUTO PICK
local AutoBtn = Instance.new("TextButton", Main)
AutoBtn.Size = UDim2.new(0.8,0,0,35)
AutoBtn.Position = UDim2.new(0.1,0,0.65,0)
AutoBtn.Text = "🟢 Auto Pick: OFF"
AutoBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
AutoBtn.TextColor3 = Color3.new(1,1,1)
AutoBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AutoBtn)

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
	local response = game:HttpGet(url)
	local data = HttpService:JSONDecode(response)

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

--// AUTO PICK E
local autoPick = false
local pickSpeed = 1/30 -- ~30 lần/giây

task.spawn(function()
	while true do
		if autoPick then
			-- giả lập bấm E (tùy executor)
			pcall(function()
				keypress(0x45) -- E
				task.wait()
				keyrelease(0x45)
			end)
		end
		task.wait(pickSpeed)
	end
end)

--// EVENTS
HopBtn.MouseButton1Click:Connect(function()
	HopBtn.Text = "⏳ Đang tìm..."
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
