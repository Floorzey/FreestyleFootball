local script_parent = script.Parent
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)

for _, child in pairs(script.Parent:GetChildren()) do
    if child:IsA("TextButton") then
        local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(child)

        mouse_enter_leave_event_result:Connect(function()
            if script_parent.Visible == false then
                return
            end

            local clone = game.ReplicatedStorage.UISounds._click:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 0.5)
            game:GetService("TweenService")
                :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 50, 0, 50),
                })
                :Play()
        end)

        signal:Connect(function()
            if script_parent.Visible == false then
                return
            end

            game:GetService("TweenService")
                :Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 45, 0, 45),
                })
                :Play()
        end)
    end
end
