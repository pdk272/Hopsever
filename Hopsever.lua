--[[ 
    BRAINROT V18 - PHIÊN BẢN CHUẨN HÓA
    - Speed 30: Chuẩn công thức ổn định.
    - Fast Steal: Ép 0.1s (nhanh nhất có thể).
    - Finder: Tìm 14 pet, thấy là dừng nhảy + báo động.
    - GUI: Hiện chắc chắn trong PlayerGui, không mất khi chết.
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

-- KHỞI TẠO GUI (Vào PlayerGui để tránh lỗi CoreGui)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("Brainrot_V18") then PlayerGui.Brainrot_V18:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "Brainrot_V18"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 220)
Main.Position = UDim2.new(0.5, -130, 0.4, -110)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BRAINROT V18 - CHUẨN"
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -20, 0, 50)
Status.Position = UDim2.new(0, 10, 0, 40)
Status.Text = "Trạng thái: Sẵn sàng"
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.BackgroundTransparency = 1
Status.TextWrapped = true

-- --- SPEED 30 (ỔN ĐỊNH) ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (30 - 16) * 0.015)
        end
    end)
end)

-- --- FAST STEAL (0.1 GIÂY) ---
task.spawn(function()
    while true do
        pcall(function()
            for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                prompt.HoldDuration = 0.1
            end
        end)
        task.wait(1)
    end
end)

-- --- HÀM NHẢY SERVER ---
local function ServerHop()
    Status.Text = "Đang tìm phòng trống..."
    local PlaceId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                task.wait(5)
                ServerHop() -- Thử lại nếu kẹt
                return
            end
        end
    end
    task.wait(2)
    ServerHop()
end

-- --- HÀM QUÉT PET ---
local function StartScan()
    local found = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            found = v
            break 
        end
    end
    
    if found then
        Status.Text = "TÌM THẤY: " .. found.Name
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        local hl = Instance.new("Highlight", found)
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        
        -- Báo động
        for i = 1, 3 do
            local s = Instance.new("Sound", game.Workspace)
            s.SoundId = "rbxassetid://138090596"
            s.Volume = 2
            s:Play()
            task.wait(0.5)
        end
    else
        ServerHop()
    end
end

-- --- NÚT BẤM TRÊN GUI ---
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 200, 0, 45)
StartBtn.Position = UDim2.new(0.5, -100, 0, 100)
StartBtn.Text = "BẮT ĐẦU SĂN & NHẢY SV"
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.MouseButton1Click:Connect(StartScan)

local CheckBtn = Instance.new("TextButton", Main)
CheckBtn.Size = UDim2.new(0, 200, 0, 45)
CheckBtn.Position = UDim2.new(0.5, -100, 0, 155)
CheckBtn.Text = "CHỈ QUÉT TẠI CHỖ"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.MouseButton1Click:Connect(function()
    local found = false
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then found = true break end
    end
    Status.Text = found and "Có Pet VIP!" or "Phòng này không có gì."
end)

print("Brainrot V18 đã tải xong.")
