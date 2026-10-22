local tween_service = game:GetService("TweenService")
local dialogue_module = {}
local instance = nil
local values = {
    typeSpeed = 0.04,
    letterPopTime = 0.08,
    textColor = Color3.fromRGB(255, 255, 255),
    nameColor = Color3.fromRGB(176, 206, 255),
    font = Enum.Font.Michroma,
    dialoguePosition = UDim2.new(0.5, 0, 0.85, 0),
}

local function create(argument, argument_2)
    local instance_2 = Instance.new(argument)

    for key, item in pairs(argument_2) do
        instance_2[key] = item
    end

    return instance_2
end

local function tween(target, tween_properties, argument, argument_2, argument_3)
    local tween_2 = tween_service:Create(
        target,
        TweenInfo.new(argument, argument_2 or Enum.EasingStyle.Quint, argument_3 or Enum.EasingDirection.Out),
        tween_properties
    )
    tween_2:Play()

    return tween_2
end

local function clear_dialogue()
    if instance then
        instance:Destroy()
        instance = nil
    end
end

function dialogue_module.showDialogue(argument, parent, name, child_name, argument_2)
    if instance then
        instance:Destroy()
        instance = nil
    end

    if script:FindFirstChild(child_name) then
        script:FindFirstChild(child_name):Play()
    end

    if script.Others:FindFirstChild(child_name) then
        task.spawn(function()
            script:FindFirstChild(child_name).Ended:Wait()
            dialogue_module:hideDialogue()
            task.wait(0.05)
            script.Others:FindFirstChild(child_name):Play()
            name = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())].Name
            child_name = script.Others:FindFirstChild(child_name):GetAttribute("text")
            local clone_result_2 = table.clone(values)

            if argument_2 then
                for key_10, item_11 in pairs(argument_2) do
                    clone_result_2[key_10] = item_11
                end
            end

            local values_3 = {
                Name = "flexibleDialogueGui",
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                Parent = parent,
            }
            local screen_gui_2 = Instance.new("ScreenGui")

            for key_11, item_12 in pairs(values_3) do
                screen_gui_2[key_11] = item_12
            end

            instance = screen_gui_2
            local properties_5 = {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = clone_result_2.dialoguePosition + UDim2.new(0, 0, 0.04, 0),
                Size = UDim2.new(0.85, 0, 0.18, 0),
                Parent = screen_gui_2,
            }
            local frame_2 = Instance.new("Frame")

            for key_12, item_13 in pairs(properties_5) do
                frame_2[key_12] = item_13
            end

            local ui_scale_2 = Instance.new("UIScale")

            for key_13, item_14 in pairs({
                Scale = 1,
                Parent = frame_2,
            }) do
                ui_scale_2[key_13] = item_14
            end

            ui_scale_2.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
            local properties_6 = {
                BackgroundTransparency = 1,
                TextTransparency = 1,
                TextScaled = true,
                TextStrokeTransparency = 0.5,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, 0, 0.25, 0),
                Text = name,
                Font = clone_result_2.font,
                TextColor3 = clone_result_2.nameColor,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = frame_2,
            }
            local text_label_2 = Instance.new("TextLabel")

            for key_14, item_15 in pairs(properties_6) do
                text_label_2[key_14] = item_15
            end

            local ui_text_size_constraint_2 = Instance.new("UITextSizeConstraint")

            for key_15, item_16 in pairs({
                MaxTextSize = 55,
                MinTextSize = 8,
                Parent = text_label_2,
            }) do
                ui_text_size_constraint_2[key_15] = item_16
            end

            local properties_7 = {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0.3, 0),
                Size = UDim2.new(1, 0, 0.7, 0),
                Parent = frame_2,
            }
            local frame2_2 = Instance.new("Frame")

            for key_16, item_17 in pairs(properties_7) do
                frame2_2[key_16] = item_17
            end

            local values_4 = {
                Wraps = true,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 0),
                Parent = frame2_2,
            }
            local ui_list_layout_2 = Instance.new("UIListLayout")

            for key_17, item_18 in pairs(values_4) do
                ui_list_layout_2[key_17] = item_18
            end

            local tween_properties_3 = {
                Position = clone_result_2.dialoguePosition,
            }
            tween_service
                :Create(
                    frame_2,
                    TweenInfo.new(0.45, Enum.EasingStyle.Quint or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()
            tween_service
                :Create(text_label_2, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                })
                :Play()

            for _, item_19 in utf8.codes(child_name) do
                local text_2 = utf8.char(item_19)
                local properties_8 = {
                    BackgroundTransparency = 1,
                    TextSize = 8,
                    TextScaled = false,
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.5,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Size = UDim2.new(0, 0, 0, 0),
                    Text = text_2,
                    Font = clone_result_2.font,
                    TextColor3 = clone_result_2.textColor,
                    Parent = frame2_2,
                }
                local text_label2_2 = Instance.new("TextLabel")

                for key_18, item_20 in pairs(properties_8) do
                    text_label2_2[key_18] = item_20
                end

                local tween_properties_4 = {
                    TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32),
                }
                tween_service
                    :Create(
                        text_label2_2,
                        TweenInfo.new(
                            clone_result_2.letterPopTime,
                            Enum.EasingStyle.Back or Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ),
                        tween_properties_4
                    )
                    :Play()
                task.wait(clone_result_2.typeSpeed)
            end
        end)
    end

    local clone_result = table.clone(values)

    if argument_2 then
        for key, item in pairs(argument_2) do
            clone_result[key] = item
        end
    end

    local screen_gui = Instance.new("ScreenGui")

    for key_2, item_2 in pairs({
        Name = "flexibleDialogueGui",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Parent = parent,
    }) do
        screen_gui[key_2] = item_2
    end

    instance = screen_gui
    local properties = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = clone_result.dialoguePosition + UDim2.new(0, 0, 0.04, 0),
        Size = UDim2.new(0.85, 0, 0.18, 0),
        Parent = screen_gui,
    }
    local frame = Instance.new("Frame")

    for key_3, item_3 in pairs(properties) do
        frame[key_3] = item_3
    end

    local ui_scale = Instance.new("UIScale")

    for key_4, item_4 in pairs({
        Scale = 1,
        Parent = frame,
    }) do
        ui_scale[key_4] = item_4
    end

    ui_scale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
    local properties_2 = {
        BackgroundTransparency = 1,
        TextTransparency = 1,
        TextScaled = true,
        TextStrokeTransparency = 0.5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 0.25, 0),
        Text = name,
        Font = clone_result.font,
        TextColor3 = clone_result.nameColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = frame,
    }
    local text_label = Instance.new("TextLabel")

    for key_5, item_5 in pairs(properties_2) do
        text_label[key_5] = item_5
    end

    local ui_text_size_constraint = Instance.new("UITextSizeConstraint")

    for key_6, item_6 in pairs({
        MaxTextSize = 55,
        MinTextSize = 8,
        Parent = text_label,
    }) do
        ui_text_size_constraint[key_6] = item_6
    end

    local properties_3 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        Size = UDim2.new(1, 0, 0.7, 0),
        Parent = frame,
    }
    local frame2 = Instance.new("Frame")

    for key_7, item_7 in pairs(properties_3) do
        frame2[key_7] = item_7
    end

    local values_2 = {
        Wraps = true,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        Parent = frame2,
    }
    local ui_list_layout = Instance.new("UIListLayout")

    for key_8, item_8 in pairs(values_2) do
        ui_list_layout[key_8] = item_8
    end

    local tween_properties = {
        Position = clone_result.dialoguePosition,
    }
    tween_service
        :Create(
            frame,
            TweenInfo.new(0.45, Enum.EasingStyle.Quint or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    tween_service
        :Create(text_label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 0,
        })
        :Play()

    for _, item_9 in utf8.codes(child_name) do
        local text = utf8.char(item_9)
        local properties_4 = {
            BackgroundTransparency = 1,
            TextSize = 8,
            TextScaled = false,
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.new(0, 0, 0, 0),
            Text = text,
            Font = clone_result.font,
            TextColor3 = clone_result.textColor,
            Parent = frame2,
        }
        local text_label2 = Instance.new("TextLabel")

        for key_9, item_10 in pairs(properties_4) do
            text_label2[key_9] = item_10
        end

        local tween_properties_2 = {
            TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32),
        }
        tween_service
            :Create(
                text_label2,
                TweenInfo.new(
                    clone_result.letterPopTime,
                    Enum.EasingStyle.Back or Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                tween_properties_2
            )
            :Play()
        task.wait(clone_result.typeSpeed)
    end

    return screen_gui
end

function dialogue_module.hideDialogue(argument)
    if instance then
        instance:Destroy()
        instance = nil
    end
end

return dialogue_module
