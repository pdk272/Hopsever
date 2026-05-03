-- FAST STEAL NGUYÊN CHẤT (BRUTE FORCE)
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

print("⏳ Đang nạp Fast Steal...")

-- 1. Ép thời gian chờ về 0 liên tục
RunService.Stepped:Connect(function()
    pcall(function()
        for _, prompt in pairs(game.Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
                prompt.MaxActivationDistance = 20 -- Tăng tầm với tay
            end
        end
    end)
end)

-- 2. Spam lệnh nhặt ngay khi nút E vừa hiện lên màn hình
ProximityPromptService.PromptShown:Connect(function(prompt)
    pcall(function()
        if fireproximityprompt then
            -- Spam lệnh 5 lần cực nhanh để ép Server phải nhận
            task.spawn(function()
                for i = 1, 5 do
                    fireproximityprompt(prompt, 1, true)
                    task.wait(0.05)
                end
            end)
        end
    end)
end)

-- 3. Hỗ trợ khi bạn tự bấm tay (Chạm E là nhặt)
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt, 1, true)
    else
        prompt:InputBegan()
        task.wait(0.01)
        prompt:InputEnded()
    end
end)

print("✅ Kích hoạt thành công! Hãy lại gần vật phẩm.")
