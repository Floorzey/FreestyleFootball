local parent = script.Parent
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value in pairs(script.Parent:GetChildren()) do
    if value:IsA("TextButton") then
        local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(value)
        mouse_enter_leave_event_result:Connect(function()
            if parent.Visible == false then
                return
            end
            local clone = game.ReplicatedStorage.UISounds._click:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 0.5)
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Size = UDim2.new(0, 50, 0, 50)
            tween_service:Create(value, tween_info, tween_properties):Play()
        end)
        signal:Connect(function()
            if parent.Visible == false then
                return
            end
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Size = UDim2.new(0, 45, 0, 45)
            tween_service:Create(value, tween_info, tween_properties):Play()
        end)
    end
end
