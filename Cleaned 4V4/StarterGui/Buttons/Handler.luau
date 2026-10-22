local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local frame = script.Parent.Frame

function updateInput()
    local input_type = user_input_service:GetLastInputType()

    if input_type == Enum.UserInputType.Focus then
        return
    end

    frame.Visible = input_type == Enum.UserInputType.Touch
    script.Parent.penButtonFrame.Visible = input_type == Enum.UserInputType.Touch
end

updateInput()
user_input_service.LastInputTypeChanged:Connect(updateInput)

run_service.RenderStepped:Connect(function()
    if not frame.Visible then
        return
    end

    local absolute_size = frame.Screen.AbsoluteSize
    local condition = math.min(absolute_size.X, absolute_size.Y) <= 500
    local control_size

    if condition then
        control_size = 70
    else
        control_size = 120
    end

    frame.Size = UDim2.new(0, control_size, 0, control_size)
    frame.Position = condition and UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size - 20)
        or UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size * 1.75)
end)

function doHighlight(button, enabled_2)
    if enabled_2 == nil then
        local tween_properties = { ImageTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                button.Highlight,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties
            )
            :Play()

        task.delay(0.1, function()
            local tween_properties_4 = { ImageTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    button.Highlight,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_4
                )
                :Play()
        end)
    elseif enabled_2 == true then
        local tween_properties_2 = { ImageTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                button.Highlight,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
    elseif enabled_2 == false then
        local tween_properties_3 = { ImageTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                button.Highlight,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
            )
            :Play()
    end
end

local mobile_control_events = game.ReplicatedStorage.MobileControlEvents

frame.DribbleLeftButton.InputBegan:Connect(function()
    mobile_control_events.DribbleLeft:Fire(true)
    doHighlight(frame.DribbleLeftButton, true)
end)

frame.DribbleLeftButton.InputEnded:Connect(function()
    mobile_control_events.DribbleLeft:Fire(false)
    doHighlight(frame.DribbleLeftButton, false)
end)

frame.DribbleRightButton.InputBegan:Connect(function()
    mobile_control_events.DribbleRight:Fire(true)
    doHighlight(frame.DribbleRightButton, true)
end)

frame.DribbleRightButton.InputEnded:Connect(function()
    mobile_control_events.DribbleRight:Fire(false)
    doHighlight(frame.DribbleRightButton, false)
end)

frame.KickLowButton.InputBegan:Connect(function()
    mobile_control_events.M2:Fire(true)
    doHighlight(frame.KickLowButton, true)
end)

frame.KickLowButton.InputEnded:Connect(function()
    mobile_control_events.M2:Fire(false)
    doHighlight(frame.KickLowButton, false)
end)

frame.KickHighButton.InputBegan:Connect(function()
    mobile_control_events.M1:Fire(true)
    doHighlight(frame.KickHighButton, true)
end)

frame.KickHighButton.InputEnded:Connect(function()
    mobile_control_events.M1:Fire(false)
    doHighlight(frame.KickHighButton, false)
end)

frame.PhysicalButton.InputBegan:Connect(function()
    mobile_control_events.Physical:Fire(true)
    doHighlight(frame.PhysicalButton, true)
end)

frame.PhysicalButton.InputEnded:Connect(function()
    mobile_control_events.Physical:Fire(false)
    doHighlight(frame.PhysicalButton, false)
end)

frame.SlideTackleButton.Activated:Connect(function()
    mobile_control_events.SlideTackle:Fire()
    doHighlight(frame.SlideTackleButton)
end)

frame.MarkPass.Activated:Connect(function()
    mobile_control_events.MarkPass:Fire()
    doHighlight(frame.MarkPass)
end)

frame.Emote.Activated:Connect(function()
    mobile_control_events.Emote:Fire()
    doHighlight(frame.Emote)
end)

frame.Shiftlock.Activated:Connect(function()
    mobile_control_events.shiftLock:Fire()
    doHighlight(frame.Shiftlock)
end)

local enabled = false

frame.ToggleSprint.Activated:Connect(function()
    enabled = not enabled
    mobile_control_events.SprintToggle:Fire(enabled)
    doHighlight(frame.ToggleSprint, enabled)
end)

frame.SkillButton.Activated:Connect(function()
    mobile_control_events.UseSkill:Fire()
    doHighlight(frame.SkillButton)
end)
