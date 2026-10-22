local tween_service = game:GetService("TweenService")
local dialogue_module = {}
local instance = nil
local values = { letterPopTime = 0.08, typeSpeed = 0.04 }
values.textColor = Color3.fromRGB(255, 255, 255)
values.nameColor = Color3.fromRGB(176, 206, 255)
values.font = Enum.Font.Michroma
values.dialoguePosition = UDim2.new(0.5, 0, 0.85, 0)

local function create(argument, argument_2)
    local instance_2 = Instance.new(argument)
    for key, item in pairs(argument_2) do
        instance_2[key] = item
    end
    return instance_2
end

local function tween(target, tween_properties, argument, argument_2, argument_3)
    local quint = argument_2 or Enum.EasingStyle.Quint
    local tween_2 = tween_service:Create(
        target,
        TweenInfo.new(argument, quint, argument_3 or Enum.EasingDirection.Out),
        tween_properties
    )
    tween_2:Play()
    return tween_2
end

local function clear_dialogue()
    if not instance then
        return
    end
    instance:Destroy()
    instance = nil
end

function dialogue_module.showDialogue(self, parent, name, child_name, argument)
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
            if argument then
                for key_10, item_11 in pairs(argument) do
                    clone_result_2[key_10] = item_11
                end
            end
            local values_6 = { ResetOnSpawn = false, IgnoreGuiInset = true, Name = "flexibleDialogueGui" }
            values_6.Parent = parent
            local screen_gui_2 = Instance.new("ScreenGui")
            for key_11, item_12 in pairs(values_6) do
                screen_gui_2[key_11] = item_12
            end
            instance = screen_gui_2
            local properties_4 = { BackgroundTransparency = 1 }
            properties_4.AnchorPoint = Vector2.new(0.5, 0.5)
            properties_4.Position = clone_result_2.dialoguePosition + UDim2.new(0, 0, 0.04, 0)
            properties_4.Size = UDim2.new(0.85, 0, 0.18, 0)
            properties_4.Parent = screen_gui_2
            local frame_3 = Instance.new("Frame")
            for key_12, item_13 in pairs(properties_4) do
                frame_3[key_12] = item_13
            end
            local values_7 = { Scale = 1 }
            values_7.Parent = frame_3
            local ui_scale_2 = Instance.new("UIScale")
            for key_13, item_14 in pairs(values_7) do
                ui_scale_2[key_13] = item_14
            end
            ui_scale_2.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
            local properties_5 =
                { TextTransparency = 1, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = true }
            properties_5.AnchorPoint = Vector2.new(0.5, 0)
            properties_5.Position = UDim2.new(0.5, 0, 0, 0)
            properties_5.Size = UDim2.new(1, 0, 0.25, 0)
            properties_5.Text = name
            properties_5.Font = clone_result_2.font
            properties_5.TextColor3 = clone_result_2.nameColor
            properties_5.TextXAlignment = Enum.TextXAlignment.Center
            properties_5.Parent = frame_3
            local text_label_3 = Instance.new("TextLabel")
            for key_14, item_15 in pairs(properties_5) do
                text_label_3[key_14] = item_15
            end
            local values_8 = { MaxTextSize = 55, MinTextSize = 8 }
            values_8.Parent = text_label_3
            local ui_text_size_constraint_2 = Instance.new("UITextSizeConstraint")
            for key_15, item_16 in pairs(values_8) do
                ui_text_size_constraint_2[key_15] = item_16
            end
            ui_text_size_constraint_2 = { BackgroundTransparency = 1 }
            ui_text_size_constraint_2.AnchorPoint = Vector2.new(0.5, 0)
            ui_text_size_constraint_2.Position = UDim2.new(0.5, 0, 0.3, 0)
            ui_text_size_constraint_2.Size = UDim2.new(1, 0, 0.7, 0)
            ui_text_size_constraint_2.Parent = frame_3
            local frame_4 = Instance.new("Frame")
            for key_16, item_17 in pairs(ui_text_size_constraint_2) do
                frame_4[key_16] = item_17
            end
            local values_9 = { Wraps = true }
            values_9.FillDirection = Enum.FillDirection.Horizontal
            values_9.HorizontalAlignment = Enum.HorizontalAlignment.Center
            values_9.VerticalAlignment = Enum.VerticalAlignment.Center
            values_9.SortOrder = Enum.SortOrder.LayoutOrder
            values_9.Padding = UDim.new(0, 0)
            values_9.Parent = frame_4
            ui_text_size_constraint_2 = Instance.new("UIListLayout")
            for key_17, item_18 in pairs(values_9) do
                ui_text_size_constraint_2[key_17] = item_18
            end
            local tween_properties_4 = {}
            tween_properties_4.Position = clone_result_2.dialoguePosition
            tween_service
                :Create(
                    frame_3,
                    TweenInfo.new(0.45, Enum.EasingStyle.Quint or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    tween_properties_4
                )
                :Play()
            local tween_properties_5 = { TextTransparency = 0 }
            tween_service
                :Create(
                    text_label_3,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    tween_properties_5
                )
                :Play()
            for _, item_19 in utf8.codes(child_name) do
                local text_2 = utf8.char(item_19)
                local properties_6 = {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.5,
                    BackgroundTransparency = 1,
                    TextScaled = false,
                    TextSize = 8,
                }
                properties_6.AutomaticSize = Enum.AutomaticSize.XY
                properties_6.Size = UDim2.new(0, 0, 0, 0)
                properties_6.Text = text_2
                properties_6.Font = clone_result_2.font
                properties_6.TextColor3 = clone_result_2.textColor
                properties_6.Parent = frame_4
                local text_label_4 = Instance.new("TextLabel")
                for key_18, item_20 in pairs(properties_6) do
                    text_label_4[key_18] = item_20
                end
                local tween_properties_6 = {}
                tween_properties_6.TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32)
                tween_service
                    :Create(
                        text_label_4,
                        TweenInfo.new(
                            clone_result_2.letterPopTime,
                            Enum.EasingStyle.Back or Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ),
                        tween_properties_6
                    )
                    :Play()
                task.wait(clone_result_2.typeSpeed)
            end
        end)
    end
    local clone_result = table.clone(values)
    if argument then
        for key, item in pairs(argument) do
            clone_result[key] = item
        end
    end
    local values_2 = { ResetOnSpawn = false, IgnoreGuiInset = true, Name = "flexibleDialogueGui" }
    values_2.Parent = parent
    local screen_gui = Instance.new("ScreenGui")
    for key_2, item_2 in pairs(values_2) do
        screen_gui[key_2] = item_2
    end
    instance = screen_gui
    local properties = { BackgroundTransparency = 1 }
    properties.AnchorPoint = Vector2.new(0.5, 0.5)
    properties.Position = clone_result.dialoguePosition + UDim2.new(0, 0, 0.04, 0)
    properties.Size = UDim2.new(0.85, 0, 0.18, 0)
    properties.Parent = screen_gui
    local frame = Instance.new("Frame")
    for key_3, item_3 in pairs(properties) do
        frame[key_3] = item_3
    end
    local values_3 = { Scale = 1 }
    values_3.Parent = frame
    local ui_scale = Instance.new("UIScale")
    for key_4, item_4 in pairs(values_3) do
        ui_scale[key_4] = item_4
    end
    ui_scale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
    local properties_2 =
        { TextTransparency = 1, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = true }
    properties_2.AnchorPoint = Vector2.new(0.5, 0)
    properties_2.Position = UDim2.new(0.5, 0, 0, 0)
    properties_2.Size = UDim2.new(1, 0, 0.25, 0)
    properties_2.Text = name
    properties_2.Font = clone_result.font
    properties_2.TextColor3 = clone_result.nameColor
    properties_2.TextXAlignment = Enum.TextXAlignment.Center
    properties_2.Parent = frame
    local text_label = Instance.new("TextLabel")
    for key_5, item_5 in pairs(properties_2) do
        text_label[key_5] = item_5
    end
    local values_4 = { MaxTextSize = 55, MinTextSize = 8 }
    values_4.Parent = text_label
    local ui_text_size_constraint = Instance.new("UITextSizeConstraint")
    for key_6, item_6 in pairs(values_4) do
        ui_text_size_constraint[key_6] = item_6
    end
    ui_text_size_constraint = { BackgroundTransparency = 1 }
    ui_text_size_constraint.AnchorPoint = Vector2.new(0.5, 0)
    ui_text_size_constraint.Position = UDim2.new(0.5, 0, 0.3, 0)
    ui_text_size_constraint.Size = UDim2.new(1, 0, 0.7, 0)
    ui_text_size_constraint.Parent = frame
    local frame_2 = Instance.new("Frame")
    for key_7, item_7 in pairs(ui_text_size_constraint) do
        frame_2[key_7] = item_7
    end
    local values_5 = { Wraps = true }
    values_5.FillDirection = Enum.FillDirection.Horizontal
    values_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
    values_5.VerticalAlignment = Enum.VerticalAlignment.Center
    values_5.SortOrder = Enum.SortOrder.LayoutOrder
    values_5.Padding = UDim.new(0, 0)
    values_5.Parent = frame_2
    ui_text_size_constraint = Instance.new("UIListLayout")
    for key_8, item_8 in pairs(values_5) do
        ui_text_size_constraint[key_8] = item_8
    end
    local tween_properties = {}
    tween_properties.Position = clone_result.dialoguePosition
    tween_service
        :Create(
            frame,
            TweenInfo.new(0.45, Enum.EasingStyle.Quint or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextTransparency = 0 }
    tween_service
        :Create(text_label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), tween_properties_2)
        :Play()
    for _, item_9 in utf8.codes(child_name) do
        local text = utf8.char(item_9)
        local properties_3 = {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
            BackgroundTransparency = 1,
            TextScaled = false,
            TextSize = 8,
        }
        properties_3.AutomaticSize = Enum.AutomaticSize.XY
        properties_3.Size = UDim2.new(0, 0, 0, 0)
        properties_3.Text = text
        properties_3.Font = clone_result.font
        properties_3.TextColor3 = clone_result.textColor
        properties_3.Parent = frame_2
        local text_label_2 = Instance.new("TextLabel")
        for key_9, item_10 in pairs(properties_3) do
            text_label_2[key_9] = item_10
        end
        local tween_properties_3 = {}
        tween_properties_3.TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32)
        tween_service
            :Create(
                text_label_2,
                TweenInfo.new(
                    clone_result.letterPopTime,
                    Enum.EasingStyle.Back or Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                tween_properties_3
            )
            :Play()
        task.wait(clone_result.typeSpeed)
    end
    return screen_gui
end

function dialogue_module.hideDialogue(self)
    if not instance then
        return
    end
    instance:Destroy()
    instance = nil
end

return dialogue_module
