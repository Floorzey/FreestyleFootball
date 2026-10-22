local mouse = (game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer")):GetMouse()
local values = {}

local function is_in_frame(gui_object)
    local x = mouse.X
    local y = mouse.Y

    return gui_object.AbsolutePosition.X < x
        and (
            gui_object.AbsolutePosition.Y < y
            and (
                x < gui_object.AbsolutePosition.X + gui_object.AbsoluteSize.X
                and y < gui_object.AbsolutePosition.Y + gui_object.AbsoluteSize.Y
            )
        )
end

local function check_mouse_exited(argument)
    if not argument.MouseIsInFrame and argument.MouseWasIn then
        argument.MouseWasIn = false
        argument.LeaveEvent:Fire()
    end
end

local function check_mouse_entered(argument)
    if argument.MouseIsInFrame and not argument.MouseWasIn then
        argument.MouseWasIn = true
        argument.EnteredEvent:Fire()
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, item in pairs(values) do
        local ui_obj = item.UIObj
        local x = mouse.X
        local y = mouse.Y
        item.MouseIsInFrame = ui_obj.AbsolutePosition.X < x
            and (
                ui_obj.AbsolutePosition.Y < y
                and (
                    x < ui_obj.AbsolutePosition.X + ui_obj.AbsoluteSize.X
                    and y < ui_obj.AbsolutePosition.Y + ui_obj.AbsoluteSize.Y
                )
            )

        if not item.MouseIsInFrame and item.MouseWasIn then
            item.MouseWasIn = false
            item.LeaveEvent:Fire()
        end
    end

    for _, item_2 in pairs(values) do
        if item_2.MouseIsInFrame and not item_2.MouseWasIn then
            item_2.MouseWasIn = true
            item_2.EnteredEvent:Fire()
        end
    end
end)

return {
    MouseEnterLeaveEvent = function(ui_obj)
        if values[ui_obj] then
            return values[ui_obj].EnteredEvent.Event, values[ui_obj].LeaveEvent.Event
        end

        local values_2 = {
            UIObj = ui_obj,
        }
        local bindable_event = Instance.new("BindableEvent")
        local bindable_event2 = Instance.new("BindableEvent")
        values_2.EnteredEvent = bindable_event
        values_2.LeaveEvent = bindable_event2
        values_2.MouseWasIn = false
        values[ui_obj] = values_2

        ui_obj.AncestryChanged:Connect(function()
            if ui_obj.Parent then
                return
            end

            bindable_event:Destroy()
            bindable_event2:Destroy()
            values[ui_obj] = nil
        end)

        return bindable_event.Event, bindable_event2.Event
    end,
}
