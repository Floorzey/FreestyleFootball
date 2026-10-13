local parent = script.Parent
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, ui_obj in pairs(script.Parent:GetChildren()) do
    if ui_obj:IsA("TextButton") then
        local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(ui_obj)
        mouse_enter_leave_event_result:Connect(function()
            if parent.Parent.Visible == false then
                return
            end
            local clone = game.ReplicatedStorage.UISounds._click:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 0.5)
        end)
        signal:Connect(function()
            if parent.Parent.Visible ~= false then
                return
            end
        end)
    end
end
