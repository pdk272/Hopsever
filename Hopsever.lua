--[[ 
    GIFT SNIPER LITE (FIX LỖI CORE GUI)
    - Nhắm thẳng vào Network.rev.__SendGift
    - Dùng PlayerGui để hiển thị thông báo thay vì CoreGui
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 1. Tìm đường dẫn đến lệnh Gift (Dựa trên ảnh ông chụp)
local Network = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev")
local SendGift = Network:FindFirstChild("__SendGift")

-- 2. THAY THÔNG TIN CỦA ÔNG VÀO ĐÂY
local TargetName = "anhlin2010" -- Tên người nhận
local PetUID = "1x1x1x1" -- Cái dãy mã ID ông bắt được trong Remote Spy

if not SendGift then
    print("❌ Không tìm thấy lệnh __SendGift. Check lại đường dẫn!")
    return
end

print("🔥 Đã nạp đạn! Đang chuẩn bị nã Gift vào: " .. TargetName)

-- 3. Hàm thực hiện cú chốt (Nã 10 phát cùng lúc để tạo lag)
local function ExecuteDupe()
    print("🚀 ĐANG THỰC HIỆN RACE CONDITION...")
    for i = 1, 10 do
        task.spawn(function()
            -- FireServer gửi tín hiệu tặng đồ liên tục
            SendGift:FireServer(TargetName, PetUID)
        end)
    end
    print("✅ Đã nã xong 10 lệnh. Check nick clone ngay!")
end

-- Tự động chạy sau 2 giây để ông kịp chuẩn bị
task.wait(2)
ExecuteDupe()
