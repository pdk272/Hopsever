--[[ 
    BRAINROT V14 - THE ENDGAME HUNTER
    - Auto Hop liên tục nếu không có Pet
    - Teleport thẳng tới Pet nếu tìm thấy
    - Autoexec thân thiện
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

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
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V14") then
    LocalPlayer.PlayerGui.Brainrot_V14:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V14"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 150)
Main.Position = UDim2.new(0.5, -130, 0.4, -75)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local LogLabel = Instance.new("TextLabel")
LogLabel.Size = UDim2.new(1, 0, 1, 0)
LogLabel.Text = "Đang khởi động Máy Quét..."
LogLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
LogLabel.BackgroundTransparency = 1
LogLabel.Font = Enum.Font.GothamBold
LogLabel.TextSize = 16
LogLabel.TextWrapped = true
LogLabel.Parent = Main

-- --- HÀM NHẢY SERVER ---
local function ServerHop()
    LogLabel.Text = "Không có mục tiêu!\nĐang tìm Server mới..."
    LogLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local PlaceId = game.PlaceId
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
            break
        end
    end
end

-- --- HÀM QUÉT VÀ DỊCH CHUYỂN ---
local function ExecuteHunter()
    local foundPet = nil
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            foundPet = v
            break 
        end
    end
    
    if foundPet then
        LogLabel.Text = "MỤC TIÊU XUẤT HIỆN:\n" .. foundPet.Name .. "\nĐANG DỊCH CHUYỂN..."
        LogLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Báo động
        local s = Instance.new("Sound", game.Workspace)
        s.SoundId = "rbxassetid://138090596"
        s.Volume = 3
        s:Play()
        
        -- DỊCH CHUYỂN NHÂN VẬT ĐẾN NGAY CHỖ PET
        pcall(function()
            local root = LocalPlayer.Character.HumanoidRootPart
            if foundPet:IsA("BasePart") then
                root.CFrame = foundPet.CFrame
            elseif foundPet:IsA("Model") and foundPet.PrimaryPart then
                root.CFrame = foundPet.PrimaryPart.CFrame
            end
        end)
    else
        -- Trễ 1 chút để tránh bị game kick vì spam nhảy quá nhanh
        task.wait(1.5) 
        ServerHop()
    end
end

-- --- FAST STEAL (LUÔN BẬT) ---
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt.HoldDuration = 0
        prompt:InputBegan()
    end
end)

-- Tự động chạy ngay khi load vào server
task.spawn(function()
    -- Đợi game load xong hẳn địa hình (rất quan trọng để không bị lỗi xuyên map)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    task.wait(2) 
    ExecuteHunter()
end)
