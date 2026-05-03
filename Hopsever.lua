--[[ 
    STEAL A BRAINROT: DESYNC PANEL
    - Auto Blink Steal: Ngồi nhà, thấy Pet tự giật bóng ma ra lấy rồi về.
    - Custom Tool: Cấp 1 Tool "Bóng Ma Desync" vào balo để bạn tự tạo Clone và đi dạo.
]]

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Danh sách Brainrot VIP của bạn
local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

print("🔥 Nạp hệ thống Desync Control...")

-- ==========================================
-- 1. TẠO TOOL "DESYNC" CHO BẠN TỰ ĐIỀU KHIỂN
-- ==========================================
local function CreateDesyncTool()
    if LocalPlayer.Backpack:FindFirstChild("👻 Bóng Ma Desync") then return end
    
    local tool = Instance.new("Tool")
    tool.Name = "👻 Bóng Ma Desync"
    tool.RequiresHandle = false
    tool.Parent = LocalPlayer.Backpack

    local isGhosting = false
    local savedCFrame = nil
    local clone = nil

    tool.Activated:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if not isGhosting then
            -- BẬT DESYNC: Lưu vị trí, tạo bản sao đứng im
            isGhosting = true
            savedCFrame = root.CFrame
            
            char.Archivable = true
            clone = char:Clone()
            clone.Parent = game.Workspace
            clone:SetPrimaryPartCFrame(savedCFrame)
            
            -- Làm mờ nhân vật thật
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Transparency = 0.5 v.CanCollide = false end
            end
            print("👻 Đã xuất hồn! Tọa độ đã được chốt.")
        else
            -- TẮT DESYNC: Thu hồi xác
            isGhosting = false
            root.CFrame = savedCFrame -- Trở về vị trí Clone
            if clone then clone:Destroy() end
            
            -- Hiện nguyên hình
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
                    v.Transparency = 0 v.CanCollide = true 
                end
            end
            print("👻 Đã hoàn hồn!")
        end
    end)
end

-- Cấp tool mỗi khi nhân vật hồi sinh
CreateDesyncTool()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    CreateDesyncTool()
end)

-- ==========================================
-- 2. TỰ ĐỘNG SĂN BẰNG CƠ CHẾ BLINK (NHÁY)
-- ==========================================
local isStealing = false

local function BlinkSteal(prompt)
    if isStealing then return end
    isStealing = true
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then isStealing = false return end
    
    -- Lưu vị trí an toàn trong Base của bạn
    local safeCFrame = root.CFrame
    
    -- BLINK tới chỗ con Pet
    root.CFrame = prompt.Parent.CFrame
    task.wait(0.05) -- Đợi một chớp mắt để kịp chộp đồ
    
    -- FAST STEAL ÉP BUỘC
    prompt.HoldDuration = 0
    if fireproximityprompt then
        fireproximityprompt(prompt, 1, true)
    end
    prompt:InputBegan()
    task.wait(0.05)
    prompt:InputEnded()
    
    -- BLINK ngược về chỗ an toàn ngay lập tức
    root.CFrame = safeCFrame
    
    print("💎 Đã trộm thành công!")
    task.wait(0.5) -- Đợi Pet ổn định trong túi mới bắt con khác
    isStealing = false
end

-- Quét tự động
task.spawn(function()
    while true do
        for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
            local item = prompt.Parent
            if item and TargetPets[item.Name] then
                BlinkSteal(prompt)
            end
        end
        task.wait(0.5)
    end
end)
