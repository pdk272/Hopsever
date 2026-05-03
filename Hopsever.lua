--[[ 
    BRAINROT V16 - EXPERIMENTAL
    - Speed 30: Giữ nguyên công thức bạn thấy ổn.
    - Fast Steal: Thử nghiệm cơ chế giả lập Input mới.
    - Finder: Quét 14 Pet, thấy là dừng nhảy + Báo động.
    - Server Hop: Chỉ vào phòng còn trống ít nhất 2 chỗ.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- DANH SÁCH 14 PET VIP
local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

-- GUI
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V16") then LocalPlayer.PlayerGui.Brainrot_V16:Destroy() end
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "Brainrot_V16"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 150)
Main.Position = UDim2.new(0, 20, 0, 20)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Draggable = true
Main.Active = true

local LogLabel = Instance.new("TextLabel", Main)
LogLabel.Size = UDim2.new(1, 0, 1, 0)
LogLabel.Text = "Đang kiểm tra Server..."
LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogLabel.BackgroundTransparency = 1
LogLabel.Font = Enum.Font.GothamBold
LogLabel.TextSize = 14
LogLabel.TextWrapped = true

-- --- SPEED 30 (GIỮ NGUYÊN CÔNG THỨC ỔN ĐỊNH) ---
local SpeedValue = 30
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            -- Đây là công thức giúp bạn thấy mượt và không bị delay
            root.CFrame = root.CFrame + (hum.MoveDirection * (SpeedValue - 16) * 0.015)
        end
    end)
end)

-- --- CƠ CHẾ FAST STEAL MỚI (EXPERIMENTAL) ---
-- Thay vì chỉnh HoldDuration, ta ép Prompt phải kết thúc ngay khi vừa bắt đầu
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    pcall(function()
        -- Ép thời gian giữ về con số cực nhỏ thay vì 0 (đôi khi 0 bị server chặn)
        prompt.HoldDuration = 0.01 
        
        -- Giả lập chuỗi hành động hoàn tất
        prompt:InputBegan()
        task.wait(0.05)
        prompt:InputEnded()
        
        -- Nếu executor Xeno hỗ trợ, nó sẽ ép server nhận lệnh
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
end)

-- --- FINDER & SERVER HOP ---
local function ServerHop()
    LogLabel.Text = "Phòng trống Pet.\nĐang tìm phòng mới..."
    local PlaceId = game.PlaceId
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"))
    end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            -- Chỉ vào server còn ít nhất 2 chỗ trống để tránh lỗi Full
            if s.playing < (s.maxPlayers - 2) and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                return
            end
        end
    end
    task.wait(3)
    ServerHop()
end

local function Scan()
    local found = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            found = v
            break
        end
    end
    
    if found then
        -- DỪNG NHẢY VÀ BÁO ĐỘNG
        LogLabel.Text = "!!! TÌM THẤY: " .. found.Name .. " !!!\nHÃY LẤY NGAY!"
        LogLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        local hl = Instance.new("Highlight", found)
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        
        for i = 1, 5 do
            local s = Instance.new("Sound", game.Workspace)
            s.SoundId = "rbxassetid://138090596"
            s.Volume = 3
            s:Play()
            task.wait(0.5)
        end
    else
        task.wait(2)
        ServerHop()
    end
end

-- Khởi chạy
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1.5)
    Scan()
end)
