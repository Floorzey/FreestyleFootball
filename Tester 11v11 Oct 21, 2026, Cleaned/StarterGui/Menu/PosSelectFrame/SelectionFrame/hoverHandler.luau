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
        end)

        signal:Connect(function()
            if script_parent.Parent.Visible == false then
            end
        end)
    end
end
