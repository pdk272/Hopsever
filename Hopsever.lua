--[[ 
    RAPID FIRE TOOL (ÉP SÚNG LIÊN THANH)
    - Nhấn giữ chuột trái để xả đạn.
    - Ép Tool kích hoạt liên tục bỏ qua độ trễ click chuột.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local isRapidFiring = false
local spamThread = nil

-- Độ trễ giữa các phát bắn (Để 0.05 là nhanh gấp chục lần bình thường)
local FIRE_DELAY = 0.05 

print("🔫 Đã nạp Auto Rapid Fire! Cầm súng lên và giữ chuột trái.")

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    
    -- Khi nhấn giữ chuột trái
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        
        -- Nếu đang cầm súng trên tay thì bắt đầu xả đạn
        if tool then
            isRapidFiring = true
            spamThread = task.spawn(function()
                while isRapidFiring and char:FindFirstChild(tool.Name) do
                    tool:Activate() -- Ép súng bóp cò
                    task.wait(FIRE_DELAY)
                end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    -- Khi nhả chuột trái thì ngừng bắn
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isRapidFiring = false
        if spamThread then
            task.cancel(spamThread)
            spamThread = nil
        end
        
        -- Báo cho súng biết là đã nhả cò (để tránh bị kẹt đạn)
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Deactivate()
        end
    end
end)
