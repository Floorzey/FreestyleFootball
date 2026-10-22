local local_player = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer")
local mouse = local_player:GetMouse()
local values = {}

local function is_in_frame(gui_object)
    local x = mouse.X
    local y = mouse.Y

    return if gui_object.AbsolutePosition.X < x
            and gui_object.AbsolutePosition.Y < y
            and x < gui_object.AbsolutePosition.X + gui_object.AbsoluteSize.X
            and y < gui_object.AbsolutePosition.Y + gui_object.AbsoluteSize.Y
        then true
        else false
end

local function check_mouse_exited(argument)
    if argument.MouseIsInFrame or not argument.MouseWasIn then
        return
    end

    argument.MouseWasIn = false
    argument.LeaveEvent:Fire()
end

local function check_mouse_entered(argument)
    if not argument.MouseIsInFrame or argument.MouseWasIn then
        return
    end

    argument.MouseWasIn = true
    argument.EnteredEvent:Fire()
end

game:GetService("RunService").Heartbeat:Connect(function()
    local mouse_is_in_frame = nil

    for _, item in pairs(values) do
        local ui_obj = item.UIObj
        local x = mouse.X
        local y = mouse.Y

        if
            ui_obj.AbsolutePosition.X < x
            and ui_obj.AbsolutePosition.Y < y
            and x < ui_obj.AbsolutePosition.X + ui_obj.AbsoluteSize.X
            and y < ui_obj.AbsolutePosition.Y + ui_obj.AbsoluteSize.Y
        then
            mouse_is_in_frame = true
        else
            mouse_is_in_frame = false
        end

        item.MouseIsInFrame = mouse_is_in_frame

        if item.MouseIsInFrame then
            continue
        end

        if item.MouseWasIn then
            item.MouseWasIn = false
            item.LeaveEvent:Fire()
        end
    end

    for _, item_2 in pairs(values) do
        if not item_2.MouseIsInFrame then
            continue
        end

        if not item_2.MouseWasIn then
            item_2.MouseWasIn = true
            item_2.EnteredEvent:Fire()
        end
    end
end)

local mouse_hover_module = {}

function mouse_hover_module.MouseEnterLeaveEvent(ui_obj)
    if values[ui_obj] then
        return values[ui_obj].EnteredEvent.Event, values[ui_obj].LeaveEvent.Event
    end

    local bindable_event = Instance.new("BindableEvent")
    local bindable_event_2 = Instance.new("BindableEvent")
    values[ui_obj] =
        { UIObj = ui_obj, EnteredEvent = bindable_event, LeaveEvent = bindable_event_2, MouseWasIn = false }

    ui_obj.AncestryChanged:Connect(function()
        if ui_obj.Parent then
            return
        end

        bindable_event:Destroy()
        bindable_event_2:Destroy()
        values[ui_obj] = nil
    end)

    return bindable_event.Event, bindable_event_2.Event
end

return mouse_hover_module
