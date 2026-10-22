local script_parent = script.Parent
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)

for _, child in pairs(script.Parent:GetChildren()) do
    if child:IsA("TextButton") then
        local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(child)

        mouse_enter_leave_event_result:Connect(function()
            if script_parent.Parent.Visible == false then
                return
            end

            local clone = game.ReplicatedStorage.UISounds._click:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 0.5)
            game:GetService("TweenService")
                :Create(child.skillIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 102, 0, 90),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    TextStrokeTransparency = 0,
                })
                :Play()
        end)

        signal:Connect(function()
            if script_parent.Parent.Visible == false then
                return
            end

            game:GetService("TweenService")
                :Create(child.skillIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    TextStrokeTransparency = 1,
                })
                :Play()
        end)
    end
end

script.Parent.ChildAdded:Connect(function(child_2)
    if not (child_2:IsA("TextButton")) then
        return
    end

    local mouse_enter_leave_event_result_2, signal_2 = mouse_hover_module.MouseEnterLeaveEvent(child_2)

    mouse_enter_leave_event_result_2:Connect(function()
        if script_parent.Parent.Visible == false then
            return
        end

        local clone = game.ReplicatedStorage.UISounds._click:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 0.5)
        game:GetService("TweenService")
            :Create(child_2.skillIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 102, 0, 90),
            })
            :Play()
        game:GetService("TweenService")
            :Create(child_2, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextStrokeTransparency = 0,
            })
            :Play()
    end)

    signal_2:Connect(function()
        if script_parent.Parent.Visible == false then
            return
        end

        game:GetService("TweenService")
            :Create(child_2.skillIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 97, 0, 85),
            })
            :Play()
        game:GetService("TweenService")
            :Create(child_2, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextStrokeTransparency = 1,
            })
            :Play()
    end)
end)
