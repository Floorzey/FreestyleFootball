--[[
    Script Path: Game/Players/Player/PlayerGui/Buttons/Handler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local RunService_1 = game:GetService("RunService")
local Frame_upv_1 = script.Parent.Frame
function updateInput()
    --[[
      name: updateInput
      line: 5
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        Frame_upv_1 (copy, index: 2)
    ]]
    local v1 = UserInputService_upv_1:GetLastInputType()
    if v1 == Enum.UserInputType.Focus then
        return
    end
    Frame_upv_1.Visible = v1 == Enum.UserInputType.Touch
    script.Parent.penButtonFrame.Visible = v1 == Enum.UserInputType.Touch
end
updateInput()
UserInputService_upv_1.LastInputTypeChanged:Connect(updateInput)
local _ = game.Players.LocalPlayer:GetMouse()
RunService_1.RenderStepped:Connect(
    function()
        --[[
          line: 22
          upvalues:
            Frame_upv_1 (copy, index: 1)
        ]]
        if Frame_upv_1.Visible then
            local AbsoluteSize_1 = Frame_upv_1.Screen.AbsoluteSize
            local v2 = math.min(AbsoluteSize_1.X, AbsoluteSize_1.Y) <= 500
            local v3
            if v2 then
                v3 = 70
            else
                v3 = 120
            end
            Frame_upv_1.Size = UDim2.new(0, v3, 0, v3)
            Frame_upv_1.Position = v2 and UDim2.new(1, -((v3 * 1.5) - 10), 1, -v3 - 20) or UDim2.new(1, -((v3 * 1.5) - 10), 1, -v3 * 1.75)
        end
    end
)
function doHighlight(a1, a2)
    --[[
      name: doHighlight
      line: 35
    ]]
    if a2 == nil then
        local tbl_1 = {ImageTransparency = 0}
        game:GetService("TweenService"):Create(a1.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_1):Play()
        task.delay(
            0.1,
            function()
                --[[
                  line: 40
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                local tbl_2 = {ImageTransparency = 1}
                game:GetService("TweenService"):Create(a1.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_2):Play()
            end
        )
    elseif a2 == true then
        local tbl_3 = {ImageTransparency = 0}
        game:GetService("TweenService"):Create(a1.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_3):Play()
    elseif a2 == false then
        local tbl_4 = {ImageTransparency = 1}
        game:GetService("TweenService"):Create(a1.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_4):Play()
    end
end
local MobileControlEvents_upv_1 = game.ReplicatedStorage.MobileControlEvents
Frame_upv_1.DribbleLeftButton.InputBegan:Connect(
    function()
        --[[
          line: 59
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.DribbleLeft:Fire(true)
        doHighlight(Frame_upv_1.DribbleLeftButton, true)
    end
)
Frame_upv_1.DribbleLeftButton.InputEnded:Connect(
    function()
        --[[
          line: 64
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.DribbleLeft:Fire(false)
        doHighlight(Frame_upv_1.DribbleLeftButton, false)
    end
)
Frame_upv_1.DribbleRightButton.InputBegan:Connect(
    function()
        --[[
          line: 69
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.DribbleRight:Fire(true)
        doHighlight(Frame_upv_1.DribbleRightButton, true)
    end
)
Frame_upv_1.DribbleRightButton.InputEnded:Connect(
    function()
        --[[
          line: 74
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.DribbleRight:Fire(false)
        doHighlight(Frame_upv_1.DribbleRightButton, false)
    end
)
Frame_upv_1.KickLowButton.InputBegan:Connect(
    function()
        --[[
          line: 79
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.M2:Fire(true)
        doHighlight(Frame_upv_1.KickLowButton, true)
    end
)
Frame_upv_1.KickLowButton.InputEnded:Connect(
    function()
        --[[
          line: 84
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.M2:Fire(false)
        doHighlight(Frame_upv_1.KickLowButton, false)
    end
)
Frame_upv_1.KickHighButton.InputBegan:Connect(
    function()
        --[[
          line: 89
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.M1:Fire(true)
        doHighlight(Frame_upv_1.KickHighButton, true)
    end
)
Frame_upv_1.KickHighButton.InputEnded:Connect(
    function()
        --[[
          line: 94
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.M1:Fire(false)
        doHighlight(Frame_upv_1.KickHighButton, false)
    end
)
Frame_upv_1.PhysicalButton.InputBegan:Connect(
    function()
        --[[
          line: 99
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.Physical:Fire(true)
        doHighlight(Frame_upv_1.PhysicalButton, true)
    end
)
Frame_upv_1.PhysicalButton.InputEnded:Connect(
    function()
        --[[
          line: 104
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.Physical:Fire(false)
        doHighlight(Frame_upv_1.PhysicalButton, false)
    end
)
Frame_upv_1.SlideTackleButton.Activated:Connect(
    function()
        --[[
          line: 109
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.SlideTackle:Fire()
        doHighlight(Frame_upv_1.SlideTackleButton)
    end
)
Frame_upv_1.MarkPass.Activated:Connect(
    function()
        --[[
          line: 114
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.MarkPass:Fire()
        doHighlight(Frame_upv_1.MarkPass)
    end
)
Frame_upv_1.Emote.Activated:Connect(
    function()
        --[[
          line: 119
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.Emote:Fire()
        doHighlight(Frame_upv_1.Emote)
    end
)
Frame_upv_1.Shiftlock.Activated:Connect(
    function()
        --[[
          line: 124
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.shiftLock:Fire()
        doHighlight(Frame_upv_1.Shiftlock)
    end
)
local u1 = false
Frame_upv_1.ToggleSprint.Activated:Connect(
    function()
        --[[
          line: 130
          upvalues:
            u1 (ref,  index: 1)
            MobileControlEvents_upv_1 (copy, index: 2)
            Frame_upv_1 (copy, index: 3)
        ]]
        u1 = not u1
        MobileControlEvents_upv_1.SprintToggle:Fire(u1)
        doHighlight(Frame_upv_1.ToggleSprint, u1)
    end
)
Frame_upv_1.SkillButton.Activated:Connect(
    function()
        --[[
          line: 137
          upvalues:
            MobileControlEvents_upv_1 (copy, index: 1)
            Frame_upv_1 (copy, index: 2)
        ]]
        MobileControlEvents_upv_1.UseSkill:Fire()
        doHighlight(Frame_upv_1.SkillButton)
    end
)
local u2 = false
Frame_upv_1.ToggleControlSprint.Activated:Connect(
    function()
        --[[
          line: 143
          upvalues:
            u2 (ref,  index: 1)
            MobileControlEvents_upv_1 (copy, index: 2)
            Frame_upv_1 (copy, index: 3)
        ]]
        u2 = not u2
        MobileControlEvents_upv_1.ControlSprintToggle:Fire(u2)
        doHighlight(Frame_upv_1.ToggleControlSprint, u2)
    end
)