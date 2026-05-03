--[[ 
    BRAINROT V22 - TWEEN & OPTIMIZED HUNTER
    - 0% LAG: Chỉ quét 1 lần, không lặp lại ngu ngốc.
    - Tween Fly: Bay lướt như chim, không dịch chuyển tức thời -> Tránh bị Dead.
    - Noclip: Bay xuyên mọi địa hình.
    - Fast Steal: Tới nơi nhặt ngay lập tức.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

-- CHỐNG LAG: Chỉ tạo 1 vòng lặp chậm
local IsHunting = false

-- HÀM BAY XUYÊN TƯỜNG (TWEEN)
local function FlyTo(targetPart)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    
    -- Tắt trọng lượng và xuyên tường
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false 
            part.Massless = true
        end
    end
    
    -- Tính toán thời gian bay (càng xa bay càng lâu để không bị Server kick)
    -- Tốc độ bay: 100 studs / giây (rất nhanh nhưng vẫn an toàn hơn Teleport)
    local distance = (root.Position - targetPart.Position).Magnitude
    local tweenTime = distance / 100 
    
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPart.CFrame})
    
    tween:Play()
    tween.Completed:Wait() -- Đợi bay tới nơi
    
    -- Khôi phục va chạm
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
end

-- HÀM TÌM VÀ SĂN
local function Hunt()
    if IsHunting then return end
    IsHunting = true
    
    local foundPrompt = nil
    local targetPart = nil
    
    -- TÌM KIẾM NHANH (KHÔNG LẶP GÂY LAG)
    for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
        local parent = prompt.Parent
        if parent and TargetPets[parent.Name] then
            foundPrompt = prompt
            targetPart = parent
            break -- Thấy 1 con là dừng quét ngay
        end
    end
    
    if targetPart and foundPrompt then
        print("Đang bay tới: " .. targetPart.Name)
        
        -- Bay tới nơi
        FlyTo(targetPart)
        
        -- Tới nơi là ép nhặt luôn
        task.wait(0.2)
        foundPrompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(foundPrompt)
        end
        foundPrompt:InputBegan()
        task.wait(0.1)
        foundPrompt:InputEnded()
    else
        print("Không có Pet xịn, đang đợi...")
    end
    
    task.wait(1)
    IsHunting = false
end

-- BẬT CHẾ ĐỘ SĂN TỰ ĐỘNG
print("✅ V22 KHÔNG LAG ĐÃ CHẠY! Tự động quét sau mỗi 2 giây...")
task.spawn(function()
    while true do
        Hunt()
        task.wait(2) -- Chỉ quét 2 giây 1 lần để chống Lag 100%
    end
end)
