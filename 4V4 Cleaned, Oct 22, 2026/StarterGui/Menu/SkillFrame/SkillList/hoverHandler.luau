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
            tween_properties.Size = UDim2.new(0, 102, 0, 90)
            tween_service:Create(value.skillIcon, tween_info, tween_properties):Play()
            local tween_properties_2 = { TextStrokeTransparency = 0 }
            game:GetService("TweenService")
                :Create(value, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties_2)
                :Play()
        end)

        signal:Connect(function()
            if parent.Parent.Visible == false then
                return
            end

            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Size = UDim2.new(0, 97, 0, 85)
            tween_service:Create(value.skillIcon, tween_info, tween_properties):Play()
            local tween_properties_2 = { TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(value, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties_2)
                :Play()
        end)
    end
end

script.Parent.ChildAdded:Connect(function(child)
    if not (child:IsA("TextButton")) then
        return
    end

    local mouse_enter_leave_event_result_2, signal_2 = mouse_hover_module.MouseEnterLeaveEvent(child)

    mouse_enter_leave_event_result_2:Connect(function()
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
        tween_properties.Size = UDim2.new(0, 102, 0, 90)
        tween_service:Create(child.skillIcon, tween_info, tween_properties):Play()
        local tween_properties_2 = { TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties_2)
            :Play()
    end)

    signal_2:Connect(function()
        if parent.Parent.Visible == false then
            return
        end

        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Size = UDim2.new(0, 97, 0, 85)
        tween_service:Create(child.skillIcon, tween_info, tween_properties):Play()
        local tween_properties_2 = { TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties_2)
            :Play()
    end)
end)
