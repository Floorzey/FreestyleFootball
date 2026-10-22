local notice_label = script.Parent.NoticeLabel

local function calculate_size(argument: userdata)
    argument.Size = UDim2.new(0, argument.TextBounds.X * 1.25, 0, 22)
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()

knit.GetService("KeyHandlerService")
    :GetKey("NoticeEvent").OnClientEvent
    :Connect(function(text: string, argument: number)
        notice_label.Text = text == nil and "Notice not found error" or text
        local notice_label_2 = notice_label
        notice_label_2.Size = UDim2.new(0, notice_label_2.TextBounds.X * 1.25, 0, 22)
        game:GetService("TweenService")
            :Create(notice_label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                TextStrokeTransparency = 0.5,
            })
            :Play()
        game:GetService("TweenService")
            :Create(notice_label.LineDivider, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0,
            })
            :Play()
        task.wait(argument)
        game:GetService("TweenService")
            :Create(notice_label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(notice_label.LineDivider, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
            })
            :Play()
    end)
