--// SERVICES
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ProHopGUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 180)
Main.Position = UDim2.new(0.5, -130, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0

-- bo góc
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- tiêu đề
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "⚡ PRO SERVER TOOL"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- button hop
local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(0.8,0,0,35)
HopBtn.Position = UDim2.new(0.1,0,0.35,0)
HopBtn.Text = "🚀 Hop Server"
HopBtn.BackgroundColor3 = Color3.fromRGB(40,120,255)
HopBtn.TextColor3 = Color3.new(1,1,1)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.TextSize = 14
Instance.new("UICorner", HopBtn)

-- button reset
local ResetBtn = Instance.new("TextButton", Main)
ResetBtn.Size = UDim2.new(0.8,0,0,35)
ResetBtn.Position = UDim2.new(0.1,0,0.6,0)
ResetBtn.Text = "💀 Fast Reset"
ResetBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 14
Instance.new("UICorner", ResetBtn)

-- drag GUI
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// FUNCTION HOP
local function HopServer()
	local PlaceID = game.PlaceId
	local JobID = game.JobId

	local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
	local response = game:HttpGet(url)
	local data = HttpService:JSONDecode(response)

	for i, v in pairs(data.data) do
		if v.playing < v.maxPlayers and v.id ~= JobID then
			TeleportService:TeleportToPlaceInstance(PlaceID, v.id, player)
			task.wait(1)
			break
		end
	end
end

--// FUNCTION RESET
local function FastReset()
	if player.Character then
		player.Character:BreakJoints()
	end
end

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
