--[[
    Script Path: Game/Players/Player/PlayerGui/Notification/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local NoticeLabel_upv_1 = script.Parent.NoticeLabel
local function calculateSize(a1)
    --[[
      name: calculateSize
      line: 4
    ]]
    a1.Size = UDim2.new(0, a1.TextBounds.X * 1.25, 0, 22)
end
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
Knit_1.GetService("KeyHandlerService"):GetKey("NoticeEvent").OnClientEvent:Connect(
    function(a1, a2)
        --[[
          line: 12
          upvalues:
            NoticeLabel_upv_1 (copy, index: 1)
        ]]
        if a1 == nil then
            a1 = "Notice not found error"
        end
        NoticeLabel_upv_1.Text = a1
        NoticeLabel_upv_1.Size = UDim2.new(0, NoticeLabel_upv_1.TextBounds.X * 1.25, 0, 22)
        local tbl_1 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(NoticeLabel_upv_1, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_1):Play()
        local tbl_2 = {BackgroundTransparency = 0}
        game:GetService("TweenService"):Create(NoticeLabel_upv_1.LineDivider, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_2):Play()
        task.wait(a2)
        local tbl_3 = {TextTransparency = 1, TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(NoticeLabel_upv_1, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_3):Play()
        local tbl_4 = {BackgroundTransparency = 1}
        game:GetService("TweenService"):Create(NoticeLabel_upv_1.LineDivider, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_4):Play()
    end
)