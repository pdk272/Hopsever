--[[ 
    ULTRA-LITE DUPE HELPER (PHIÊN BẢN CHỐNG CRASH)
    - Tự động Favorite khi ông nhấn giữ E.
    - Không can thiệp hệ thống sâu, tránh bị Anti-Cheat quét.
]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("⚡ Helper đã sẵn sàng! Giữ E để đặt Pet, Script sẽ tự lo phần Favorite.")

-- Lắng nghe phím E
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        -- Đợi 0.8 giây (gần lúc thanh E đầy)
        task.wait(0.85) 
        
        -- Nã lệnh chuột phải (Favorite) liên tục 20 lần để gây lag logic
        for i = 1, 20 do
            task.spawn(function()
                -- Lệnh này mô phỏng việc ông bấm chuột phải vào vị trí Pet
                -- Game sẽ nhận tín hiệu Favorite ngay khoảnh khắc đặt đồ
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 1, true, game, 1)
                task.wait()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 1, false, game, 1)
            end)
        end
        print("🚀 Đã nã Favorite! Kiểm tra xem Pet có bị kẹt không.")
    end
end)
