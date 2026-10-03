--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/ControlModule/TouchThumbstick
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local _ = game:GetService("Players")
local GuiService_upv_1 = game:GetService("GuiService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local v2 = UserSettings():GetService("UserGameSettings")
local success_1, v1 = pcall(
    function()
        --[[
          line: 13
        ]]
        return UserSettings():IsUserFeatureEnabled("UserClampClassicThumbstick")
    end
)
local u1 = success_1 and v1
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u2 = setmetatable({}, BaseCharacterController_upv_1)
u2.__index = u2
function u2.new()
    --[[
      name: new
      line: 26
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u2 (copy, index: 2)
    ]]
    local v2 = setmetatable(BaseCharacterController_upv_1.new(), u2)
    v2.isFollowStick = false
    v2.thumbstickFrame = nil
    v2.moveTouchObject = nil
    v2.onTouchMovedConn = nil
    v2.onTouchEndedConn = nil
    v2.screenPos = nil
    v2.stickImage = nil
    v2.thumbstickSize = nil
    return v2
end
function u2.Enable(a1, a2, a3)
    --[[
      name: Enable
      line: 41
    ]]
    if a2 == nil then
        return false
    elseif a1.enabled ~= a2 then
        a1.moveVector = Vector3.new(0, 0, 0)
        a1.isJumping = false
        if a2 then
            if not (a1.thumbstickFrame) then
                a1:Create(a3)
            end
            a1.thumbstickFrame.Visible = true
        else
            a1.thumbstickFrame.Visible = false
            a1:OnInputEnded()
        end
        a1.enabled = a2
    else
        return true
    end
end
function u2.OnInputEnded(a1)
    --[[
      name: OnInputEnded
      line: 62
    ]]
    a1.thumbstickFrame.Position = a1.screenPos
    a1.stickImage.Position = UDim2.new(0, (a1.thumbstickFrame.Size.X.Offset / 2) - (a1.thumbstickSize / 4), 0, (a1.thumbstickFrame.Size.Y.Offset / 2) - (a1.thumbstickSize / 4))
    a1.moveVector = Vector3.new(0, 0, 0)
    a1.isJumping = false
    a1.thumbstickFrame.Position = a1.screenPos
    a1.moveTouchObject = nil
end
function u2.Create(a1, a2)
    --[[
      name: Create
      line: 71
      upvalues:
        u1 (ref,  index: 1)
        UserInputService_upv_1 (copy, index: 2)
        GuiService_upv_1 (copy, index: 3)
    ]]
    if a1.thumbstickFrame then
        a1.thumbstickFrame:Destroy()
        a1.thumbstickFrame = nil
        if a1.onTouchMovedConn then
            a1.onTouchMovedConn:Disconnect()
            a1.onTouchMovedConn = nil
        end
        if a1.onTouchEndedConn then
            a1.onTouchEndedConn:Disconnect()
            a1.onTouchEndedConn = nil
        end
        if a1.absoluteSizeChangedConn then
            a1.absoluteSizeChangedConn:Disconnect()
            a1.absoluteSizeChangedConn = nil
        end
    end
    a1.thumbstickFrame = Instance.new("Frame")
    a1.thumbstickFrame.Name = "ThumbstickFrame"
    a1.thumbstickFrame.Active = true
    a1.thumbstickFrame.Visible = false
    a1.thumbstickFrame.BackgroundTransparency = 1
    local u3 = Instance.new("ImageLabel")
    u3.Name = "OuterImage"
    u3.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    u3.ImageRectOffset = Vector2.new()
    u3.ImageRectSize = Vector2.new(220, 220)
    u3.BackgroundTransparency = 1
    u3.Position = UDim2.new(0, 0, 0, 0)
    a1.stickImage = Instance.new("ImageLabel")
    a1.stickImage.Name = "StickImage"
    a1.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    a1.stickImage.ImageRectOffset = Vector2.new(220, 0)
    a1.stickImage.ImageRectSize = Vector2.new(111, 111)
    a1.stickImage.BackgroundTransparency = 1
    a1.stickImage.ZIndex = 2
    local function ResizeThumbstick()
        --[[
          name: ResizeThumbstick
          line: 111
          upvalues:
            a2 (copy, index: 1)
            a1 (copy, index: 2)
            u3 (copy, index: 3)
        ]]
        local v3 = math.min(a2.AbsoluteSize.X, a2.AbsoluteSize.Y) <= 500
        local v4
        if v3 then
            v4 = 70
        else
            v4 = 120
        end
        a1.thumbstickSize = v4
        v4 = (v3 and (UDim2.new(0, (a1.thumbstickSize / 2) - 10, 1, -a1.thumbstickSize - 20))) or (UDim2.new(0, a1.thumbstickSize / 2, 1, -a1.thumbstickSize * 1.75))
        a1.screenPos = v4
        a1.thumbstickFrame.Size = UDim2.new(0, a1.thumbstickSize, 0, a1.thumbstickSize)
        a1.thumbstickFrame.Position = a1.screenPos
        u3.Size = UDim2.new(0, a1.thumbstickSize, 0, a1.thumbstickSize)
        a1.stickImage.Size = UDim2.new(0, a1.thumbstickSize / 2, 0, a1.thumbstickSize / 2)
        a1.stickImage.Position = UDim2.new(0, (a1.thumbstickSize / 2) - (a1.thumbstickSize / 4), 0, (a1.thumbstickSize / 2) - (a1.thumbstickSize / 4))
    end
    ResizeThumbstick()
    a1.absoluteSizeChangedConn = a2:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)
    u3.Parent = a1.thumbstickFrame
    a1.stickImage.Parent = a1.thumbstickFrame
    local u4 = nil
    local function DoMove(a3)
        --[[
          name: DoMove
          line: 133
          upvalues:
            a1 (copy, index: 1)
            u1 (ref,  index: 2)
        ]]
        local v5 = a3 / (a1.thumbstickSize / 2)
        local magnitude_1 = v5.magnitude
        if magnitude_1 < 0.05 then
            v5 = Vector3.new()
        else
            v5 = u1 and v5.unit * math.min(1, (magnitude_1 - 0.05) / 0.95) or v5.unit * ((magnitude_1 - 0.05) / 0.95)
            v5 = Vector3.new(v5.X, 0, v5.Y)
        end
        a1.moveVector = v5
    end
    local function MoveStick(a4)
        --[[
          name: MoveStick
          line: 155
          upvalues:
            u4 (ref,  index: 1)
            a1 (copy, index: 2)
        ]]
        local v6 = Vector2.new(a4.X - u4.X, a4.Y - u4.Y)
        local magnitude_2 = v6.magnitude
        local v7 = a1.thumbstickFrame.AbsoluteSize.X / 2
        if (a1.isFollowStick) and (v7 < magnitude_2) then
            local v8 = v6.unit * v7
            a1.thumbstickFrame.Position = UDim2.new(0, (a4.X - (a1.thumbstickFrame.AbsoluteSize.X / 2)) - v8.X, 0, (a4.Y - (a1.thumbstickFrame.AbsoluteSize.Y / 2)) - v8.Y)
        else
            v6 = v6.unit * math.min(magnitude_2, v7)
        end
        a1.stickImage.Position = UDim2.new(0, v6.X + (a1.stickImage.AbsoluteSize.X / 2), 0, v6.Y + (a1.stickImage.AbsoluteSize.Y / 2))
    end
    a1.thumbstickFrame.InputBegan:Connect(
        function(a5)
            --[[
              line: 172
              upvalues:
                a1 (copy, index: 1)
                u4 (ref,  index: 2)
            ]]
            if (a1.moveTouchObject) or a5.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if a5.UserInputState == Enum.UserInputState.Begin then
                a1.moveTouchObject = a5
                a1.thumbstickFrame.Position = UDim2.new(0, a5.Position.X - (a1.thumbstickFrame.Size.X.Offset / 2), 0, a5.Position.Y - (a1.thumbstickFrame.Size.Y.Offset / 2))
                u4 = Vector2.new(a1.thumbstickFrame.AbsolutePosition.X + (a1.thumbstickFrame.AbsoluteSize.X / 2), a1.thumbstickFrame.AbsolutePosition.Y + (a1.thumbstickFrame.AbsoluteSize.Y / 2))
                local _ = Vector2.new(a5.Position.X - u4.X, a5.Position.Y - u4.Y)
            end
        end
    )
    a1.onTouchMovedConn = UserInputService_upv_1.TouchMoved:Connect(
        function(a6, a7)
            --[[
              line: 187
              upvalues:
                a1 (copy, index: 1)
                u4 (ref,  index: 2)
                u1 (ref,  index: 3)
                MoveStick (copy, index: 4)
            ]]
            if a6 == a1.moveTouchObject then
                u4 = Vector2.new(a1.thumbstickFrame.AbsolutePosition.X + (a1.thumbstickFrame.AbsoluteSize.X / 2), a1.thumbstickFrame.AbsolutePosition.Y + (a1.thumbstickFrame.AbsoluteSize.Y / 2))
                local v9 = Vector2.new(a6.Position.X - u4.X, a6.Position.Y - u4.Y) / (a1.thumbstickSize / 2)
                local magnitude_3 = v9.magnitude
                if magnitude_3 < 0.05 then
                    v9 = Vector3.new()
                else
                    v9 = u1 and v9.unit * math.min(1, (magnitude_3 - 0.05) / 0.95) or v9.unit * ((magnitude_3 - 0.05) / 0.95)
                    v9 = Vector3.new(v9.X, 0, v9.Y)
                end
                a1.moveVector = v9
                MoveStick(a6.Position)
            end
        end
    )
    a1.onTouchEndedConn = UserInputService_upv_1.TouchEnded:Connect(
        function(a8, a9)
            --[[
              line: 197
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a8 ~= a1.moveTouchObject then
                return
            end
            a1:OnInputEnded()
        end
    )
    GuiService_upv_1.MenuOpened:Connect(
        function()
            --[[
              line: 203
              upvalues:
                a1 (copy, index: 1)
            ]]
            if not a1.moveTouchObject then
                return
            end
            a1:OnInputEnded()
        end
    )
    a1.thumbstickFrame.Parent = a2
end
return u2