--[[ 
    CỖ MÁY KHOAN TÍN HIỆU (TÌM LỖ HỔNG DUPE)
    Công dụng: Ép Máy Chủ nhận 1 lệnh hàng trăm lần trong tích tắc để xem nó có bị lỗi Logic không.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Tùy chỉnh số lần spam (Đừng để quá 500 kẻo văng game)
local SPAM_AMOUNT = 100 

local function TestDupeGlitches()
    print("⚠️ ĐANG KHOAN TÍN HIỆU VÀO MÁY CHỦ...")
    
    for i = 1, SPAM_AMOUNT do
        task.spawn(function()
            -- ==============================================================
            -- BƯỚC QUAN TRỌNG: ÔNG PHẢI BẮT ĐƯỢC LỆNH BẰNG F9 RỒI DÁN VÀO ĐÂY
            -- Ví dụ ông bắt được lệnh cất Pet vào kho:
            -- ReplicatedStorage.Remotes.DepositPet:FireServer("ID_CUA_CON_PET")
            
            -- Dán lệnh của ông thay cho dòng bên dưới:
            -- game:GetService("ReplicatedStorage").TenRemoteCuaGame:FireServer("ThamSo")
            -- ==============================================================
        end)
    end
    print("✅ Đã gửi " .. SPAM_AMOUNT .. " lệnh cùng lúc. Kiểm tra hòm đồ xem có lỗi rớt ra thêm con nào không!")
end

-- Đợi ông sẵn sàng thì chạy
TestDupeGlitches()
