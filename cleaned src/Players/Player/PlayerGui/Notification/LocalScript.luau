local notice_label = script.Parent.NoticeLabel

local function calculate_size(argument)
    argument.Size = UDim2.new(0, argument.TextBounds.X * 1.25, 0, 22)
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
knit.GetService("KeyHandlerService"):GetKey("NoticeEvent").OnClientEvent:Connect(function(text, argument)
    if text == nil then
        text = "Notice not found error"
    end
    notice_label.Text = text
    notice_label.Size = UDim2.new(0, notice_label.TextBounds.X * 1.25, 0, 22)
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(notice_label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { BackgroundTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            notice_label.LineDivider,
            TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    task.wait(argument)
    local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(notice_label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tween_properties_3)
        :Play()
    local tween_properties_4 = { BackgroundTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            notice_label.LineDivider,
            TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
            tween_properties_4
        )
        :Play()
end)
