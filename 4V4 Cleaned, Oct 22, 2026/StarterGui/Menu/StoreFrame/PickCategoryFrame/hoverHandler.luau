local parent = script.Parent
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)

for _, value in pairs(script.Parent:GetChildren()) do
    if value:IsA("TextButton") then
        local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(value)

        mouse_enter_leave_event_result:Connect(function()
            if parent.Parent.Visible == false then
                return
            end

            local clone = game.ReplicatedStorage.UISounds._click:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 0.5)
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Size = UDim2.new(0.3, 0, 1, 0)
            tween_service:Create(value, tween_info, tween_properties):Play()

            for _, child in pairs(script.Parent:GetChildren()) do
                if not (child:IsA("TextButton")) then
                    continue
                end

                if child ~= value then
                    local tween_service_2 = game:GetService("TweenService")
                    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    local tween_properties_2 = {}
                    tween_properties_2.Size = UDim2.new(0.22, 0, 1, 0)
                    tween_service_2:Create(child, tween_info_2, tween_properties_2):Play()
                end
            end
        end)

        signal:Connect(function()
            if parent.Parent.Visible == false then
                return
            end

            for _, child in pairs(script.Parent:GetChildren()) do
                if child:IsA("TextButton") then
                    local tween_service = game:GetService("TweenService")
                    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    local tween_properties = {}
                    tween_properties.Size = UDim2.new(0.24, 0, 1, 0)
                    tween_service:Create(child, tween_info, tween_properties):Play()
                end
            end
        end)
    end
end
