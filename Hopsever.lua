--[[ 
    ADVANCED GIFT DUPEER (NETWORK.REV EDITION)
    - Nhắm vào hệ thống Network.rev của game.
    - Tạo Race Condition bằng cách nã lệnh tặng liên tục.
]]

local Network = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev
local SendGift = Network.__SendGift

-- THAY THÔNG TIN CỦA ÔNG VÀO ĐÂY
local TargetPlayer = "TenNickCloneCuaOng"
local PetID = "MA_ID_PET_ONG_BAT_DUOC" 

print("🚀 Đang khởi động máy khoan tín hiệu Gift...")

local function StartDupe()
    -- Nã 50 lệnh tặng cùng lúc
    for i = 1, 50 do
        task.spawn(function()
            -- Lưu ý: Thứ tự tham số (Target, ID) phải giống hệt lúc ông bắt được ở Remote Spy
            SendGift:FireServer(TargetPlayer, PetID)
        end)
    end
    print("✅ Đã nã xong! Kiểm tra nick Clone xem có nhận được nhiều hơn 1 con không.")
end

-- Chạy lệnh
StartDupe()
