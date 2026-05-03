--[[ 
    BRAINROT V15 - STABLE HUNTER
    - Fix Server Hop: Tránh server full
    - Stop & Alert: Thấy Pet là dừng nhảy, báo động (Không Tele)
    - Improved Speed: Tốc độ mượt, không gây dead
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- DANH SÁCH PET VIP
local TargetPets = {
    ["La Secret Combinasion"] = true,
    ["Lavadorito Spinito"] = true,
    ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Ketupat Kepat"] = true,
    ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true,
    ["Money Money Puggy"] = true,
    ["Cerberus"] = true,
    ["Money Money Reindeer"] = true,
    ["Pretzo Robo"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true,
    ["La Casa Boo"] = true
}

-- KHỞI TẠO GUI
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V15") then
    LocalPlayer.PlayerGui.Brainrot_V15:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V15"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 150)
Main.Position = UDim2.new(0, 20, 0, 20) -- Đưa lên góc cho đỡ vướng
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Draggable = true
Main.Active = true
Main.Parent = ScreenGui

local LogLabel = Instance.new("TextLabel")
LogLabel.Size = UDim2.new(1, 0, 1, 0)
LogLabel.Text = "Đang quét server..."
LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogLabel.BackgroundTransparency = 1
LogLabel.Font = Enum.Font.GothamBold
LogLabel.TextSize = 14
LogLabel.TextWrapped = true
LogLabel.Parent = Main

-- --- HÀM NHẢY SERVER THÔNG MINH ---
local function ServerHop()
    LogLabel.Text = "Không có Pet.\nĐang tìm phòng trống..."
    local PlaceId = game.PlaceId
    
    -- Lấy danh sách server và lọc những server còn ít nhất 3 chỗ trống
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            -- s.playing là số người hiện có, s.maxPlayers là tối đa. 
            -- Chỉ vào server có ít nhất 2 chỗ trống để tránh bị Full khi đang vào.
            if s.playing < (s.maxPlayers - 2) and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                return
            end
        end
    end
    -- Nếu không tìm được server đẹp, thử lại sau 3 giây
    task.wait(3)
    ServerHop()
end

-- --- HÀM THỰC THI (QUÉT VÀ DỪNG) ---
local function StartHunting()
    local foundPet = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            foundPet = v
            break 
        end
    end
    
    if foundPet then
        -- KHI THẤY PET: DỪNG NHẢY SERVER VÀ BÁO ĐỘNG
        LogLabel.Text = "!!! PHÁT HIỆN !!!\n" .. foundPet.Name .. "\nHÃY ĐI LẤY NGAY!"
        LogLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        -- Tạo Highlight cho Pet
        local hl = Instance.new("Highlight", foundPet)
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        
        -- Phát chuông báo động liên tục 5 lần
        for i = 1, 5 do
            local s = Instance.new("Sound", game.Workspace)
            s.SoundId = "rbxassetid://138090596"
            s.Volume = 2
            s:Play()
            task.wait(0.5)
        end
    else
        -- Không có pet thì đợi 2 giây rồi nhảy phòng
        task.wait(2)
        ServerHop()
    end
end

-- --- SPEED VELOCITY (FIXED) ---
local Speed = 25 -- Mức an toàn để không bị dead
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            -- Ép lực di chuyển vào Vector Velocity
            root.Velocity = Vector3.new(hum.MoveDirection.X * Speed, root.Velocity.Y, hum.MoveDirection.Z * Speed)
        end
    end)
end)

-- --- FAST STEAL ---
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt.HoldDuration = 0
        prompt:InputBegan()
    end
end)

-- Chạy khi load xong
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1)
    StartHunting()
end)
