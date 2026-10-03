--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/ControlModule/DynamicThumbstick
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local Value_upv_1 = Enum.ContextActionPriority.High.Value
local tbl_upv_1 = {0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75}
local u1 = #tbl_upv_1
local u2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local Players_1 = game:GetService("Players")
local GuiService_upv_1 = game:GetService("GuiService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local ContextActionService_upv_1 = game:GetService("ContextActionService")
local RunService_upv_1 = game:GetService("RunService")
local TweenService_upv_1 = game:GetService("TweenService")
local success_1, v1 = pcall(
    function()
        --[[
          line: 37
        ]]
        return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
    end
)
local u3 = success_1 and v1
local u4, v2 = pcall(
    function()
        --[[
          line: 44
        ]]
        return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
    end
)
local u5 = u4 and v2
local LocalPlayer_1 = Players_1.LocalPlayer
if LocalPlayer_1 then
    u4 = LocalPlayer_1
else
    Players_1:GetPropertyChangedSignal("LocalPlayer"):Wait()
    u4 = Players_1.LocalPlayer
end
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u6 = setmetatable({}, BaseCharacterController_upv_1)
u6.__index = u6
function u6.new()
    --[[
      name: new
      line: 61
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u6 (copy, index: 2)
    ]]
    local v3 = setmetatable(BaseCharacterController_upv_1.new(), u6)
    v3.moveTouchObject = nil
    v3.moveTouchLockedIn = false
    v3.moveTouchFirstChanged = false
    v3.moveTouchStartPosition = nil
    v3.startImage = nil
    v3.endImage = nil
    v3.middleImages = {}
    v3.startImageFadeTween = nil
    v3.endImageFadeTween = nil
    v3.middleImageFadeTweens = {}
    v3.isFirstTouch = true
    v3.thumbstickFrame = nil
    v3.onRenderSteppedConn = nil
    v3.fadeInAndOutBalance = 0.5
    v3.fadeInAndOutHalfDuration = 0.3
    v3.hasFadedBackgroundInPortrait = false
    v3.hasFadedBackgroundInLandscape = false
    v3.tweenInAlphaStart = nil
    v3.tweenOutAlphaStart = nil
    return v3
end
function u6.GetIsJumping(a1)
    --[[
      name: GetIsJumping
      line: 96
    ]]
    local isJumping_1 = a1.isJumping
    a1.isJumping = false
    return isJumping_1
end
function u6.Enable(a1, a2, a3)
    --[[
      name: Enable
      line: 102
      upvalues:
        u3 (ref,  index: 1)
        ContextActionService_upv_1 (copy, index: 2)
    ]]
    if a2 ~= nil then
        if a1.enabled ~= a2 then
            if a2 then
                if not (a1.thumbstickFrame) then
                    a1:Create(a3)
                end
                a1:BindContextActions()
            else
                if u3 then
                    a1:UnbindContextActions()
                else
                    ContextActionService_upv_1:UnbindAction("DynamicThumbstickAction")
                end
                a1:OnInputEnded()
            end
            a1.enabled = a2
            a1.thumbstickFrame.Visible = a2
            return nil
        end
        return true
    end
    return false
end
function u6.OnInputEnded(a1)
    --[[
      name: OnInputEnded
      line: 131
    ]]
    a1.moveTouchObject = nil
    a1.moveVector = Vector3.new(0, 0, 0)
    a1:FadeThumbstick(false)
end
function u6.FadeThumbstick(a1, a2)
    --[[
      name: FadeThumbstick
      line: 137
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        u2 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
    ]]
    if ((a2) or not a1.moveTouchObject) and not a1.isFirstTouch then
        if a1.startImageFadeTween then
            a1.startImageFadeTween:Cancel()
        end
        if a1.endImageFadeTween then
            a1.endImageFadeTween:Cancel()
        end
        for n_1 = 1, #a1.middleImages do
            if a1.middleImageFadeTweens[n_1] then
                a1.middleImageFadeTweens[n_1]:Cancel()
            end
        end
        if a2 then
            a1.startImageFadeTween = TweenService_upv_1:Create(a1.startImage, u2, {ImageTransparency = 0})
            a1.startImageFadeTween:Play()
            a1.endImageFadeTween = TweenService_upv_1:Create(a1.endImage, u2, {ImageTransparency = 0.2})
            a1.endImageFadeTween:Play()
            for n_2 = 1, #a1.middleImages do
                a1.middleImageFadeTweens[n_2] = TweenService_upv_1:Create(a1.middleImages[n_2], u2, {ImageTransparency = tbl_upv_1[n_2]})
                a1.middleImageFadeTweens[n_2]:Play()
            end
        else
            a1.startImageFadeTween = TweenService_upv_1:Create(a1.startImage, u2, {ImageTransparency = 1})
            a1.startImageFadeTween:Play()
            a1.endImageFadeTween = TweenService_upv_1:Create(a1.endImage, u2, {ImageTransparency = 1})
            a1.endImageFadeTween:Play()
            for n_3 = 1, #a1.middleImages do
                a1.middleImageFadeTweens[n_3] = TweenService_upv_1:Create(a1.middleImages[n_3], u2, {ImageTransparency = 1})
                a1.middleImageFadeTweens[n_3]:Play()
            end
        end
    end
end
function u6.FadeThumbstickFrame(a1, a2, a3)
    --[[
      name: FadeThumbstickFrame
      line: 180
    ]]
    a1.fadeInAndOutHalfDuration = a2 * 0.5
    a1.fadeInAndOutBalance = a3
    a1.tweenInAlphaStart = tick()
end
function u6.InputInFrame(a1, a2)
    --[[
      name: InputInFrame
      line: 186
    ]]
    local AbsolutePosition_1 = a1.thumbstickFrame.AbsolutePosition
    local v4 = AbsolutePosition_1 + a1.thumbstickFrame.AbsoluteSize
    local Position_1 = a2.Position
    if AbsolutePosition_1.X <= Position_1.X and AbsolutePosition_1.Y <= Position_1.Y and Position_1.X <= v4.X and Position_1.Y <= v4.Y then
        return true
    end
    return false
end
function u6.DoFadeInBackground(a1)
    --[[
      name: DoFadeInBackground
      line: 198
      upvalues:
        u4 (ref, index: 1)
    ]]
    local v5 = u4:FindFirstChildOfClass("PlayerGui")
    local v6 = false
    if v5 then
        if v5.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v5.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            v6 = a1.hasFadedBackgroundInLandscape
            a1.hasFadedBackgroundInLandscape = true
        elseif v5.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            v6 = a1.hasFadedBackgroundInPortrait
            a1.hasFadedBackgroundInPortrait = true
        end
    end
    if (v6) then
        return
    end
    a1.fadeInAndOutHalfDuration = 0.3
    a1.fadeInAndOutBalance = 0.5
    a1.tweenInAlphaStart = tick()
end
function u6.DoMove(a1, a2)
    --[[
      name: DoMove
      line: 221
    ]]
    local v7 = nil
    if a2.Magnitude < a1.radiusOfDeadZone then
        v7 = Vector3.new(0, 0, 0)
    else
        a2 = v7.Unit * (1 - math.max(0, (a1.radiusOfMaxSpeed - v7.Magnitude) / a1.radiusOfMaxSpeed))
        v7 = Vector3.new(v7.X, 0, v7.Y)
    end
    a1.moveVector = v7
end
function u6.LayoutMiddleImages(a1, a2, a3)
    --[[
      name: LayoutMiddleImages
      line: 239
      upvalues:
        u1 (copy, index: 1)
    ]]
    local v8 = a1.thumbstickSize / 2 + a1.middleSize
    local v9 = a3 - a2
    local v10 = v9.Magnitude - (a1.thumbstickRingSize / 2) - a1.middleSize
    local Unit_1 = v9.Unit
    local v11 = ((a1.middleSpacing * u1 < v10) and (v10 / u1)) or a1.middleSpacing
    for n_4 = 1, u1 do
        local v12 = a1.middleImages[n_4]
        local v13 = v8 + v11 * (n_4 - 1)
        if v8 + (v11 * (n_4 - 2)) < v10 then
            local v14 = a3 - Unit_1 * v13
            local v15 = math.clamp(1 - ((v13 - v10) / v11), 0, 1)
            v12.Visible = true
            v12.Position = UDim2.new(0, v14.X, 0, v14.Y)
            v12.Size = UDim2.new(0, a1.middleSize * v15, 0, a1.middleSize * v15)
        else
            v12.Visible = false
        end
    end
end
function u6.MoveStick(a1, a2)
    --[[
      name: MoveStick
      line: 270
    ]]
    local v16 = Vector2.new(a1.moveTouchStartPosition.X, a1.moveTouchStartPosition.Y)
    local v17 = Vector2.new(a2.X, a2.Y) - a1.thumbstickFrame.AbsolutePosition
    a1.endImage.Position = UDim2.new(0, v17.X, 0, v17.Y)
    a1:LayoutMiddleImages(v16 - a1.thumbstickFrame.AbsolutePosition, v17)
end
function u6.BindContextActions(a1)
    --[[
      name: BindContextActions
      line: 278
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        u3 (ref,  index: 2)
        ContextActionService_upv_1 (copy, index: 3)
        Value_upv_1 (copy, index: 4)
        UserInputService_upv_1 (copy, index: 5)
    ]]
    local function inputChanged(a2)
        --[[
          name: inputChanged
          line: 311
          upvalues:
            a1 (copy, index: 1)
        ]]
        if a2 ~= a1.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end
        if a1.moveTouchFirstChanged then
            a1.moveTouchFirstChanged = false
            local v18 = Vector2.new(a2.Position.X - a1.thumbstickFrame.AbsolutePosition.X, a2.Position.Y - a1.thumbstickFrame.AbsolutePosition.Y)
            a1.startImage.Visible = true
            a1.startImage.Position = UDim2.new(0, v18.X, 0, v18.Y)
            a1.endImage.Visible = true
            a1.endImage.Position = a1.startImage.Position
            a1:FadeThumbstick(true)
            a1:MoveStick(a2.Position)
        end
        a1.moveTouchLockedIn = true
        local v19 = Vector2.new(a2.Position.X - a1.moveTouchStartPosition.X, a2.Position.Y - a1.moveTouchStartPosition.Y)
        if math.abs(v19.X) > 0 or math.abs(v19.Y) > 0 then
            a1:DoMove(v19)
            a1:MoveStick(a2.Position)
        end
        return Enum.ContextActionResult.Sink
    end
    local function inputEnded(a3)
        --[[
          name: inputEnded
          line: 344
          upvalues:
            a1 (copy, index: 1)
        ]]
        if a3 == a1.moveTouchObject then
            a1:OnInputEnded()
            if a1.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end
    local function inputBegan(a4)
        --[[
          name: inputBegan
          line: 279
          upvalues:
            a1 (copy, index: 1)
            TweenService_upv_1 (copy, index: 2)
        ]]
        if not a1.moveTouchObject and a1:InputInFrame(a4) then
            if a1.isFirstTouch then
                a1.isFirstTouch = false
                local v20 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
                local tbl_2 = {}
                tbl_2.Size = UDim2.new(0, 0, 0, 0)
                TweenService_upv_1:Create(a1.startImage, v20, tbl_2):Play()
                local tbl_3 = {}
                tbl_3.Size = UDim2.new(0, a1.thumbstickSize, 0, a1.thumbstickSize)
                tbl_3.ImageColor3 = Color3.new(0, 0, 0)
                TweenService_upv_1:Create(a1.endImage, v20, tbl_3):Play()
            end
            a1.moveTouchLockedIn = false
            a1.moveTouchObject = a4
            a1.moveTouchStartPosition = a4.Position
            a1.moveTouchFirstChanged = true
            a1:DoFadeInBackground()
        end
        return Enum.ContextActionResult.Pass
    end
    local function handleInput(a5, a6, a7)
        --[[
          name: handleInput
          line: 354
          upvalues:
            inputBegan (copy, index: 1)
            u3 (ref,  index: 2)
            a1 (copy, index: 3)
            inputChanged (copy, index: 4)
        ]]
        if a6 == Enum.UserInputState.Begin then
            return (inputBegan(a7))
        elseif a6 == Enum.UserInputState.Change then
            if u3 then
                if a7 ~= a1.moveTouchObject then
                    return Enum.ContextActionResult.Pass
                end
                return Enum.ContextActionResult.Sink
            end
            return (inputChanged(a7))
        elseif a6 == Enum.UserInputState.End then
            if a7 == a1.moveTouchObject then
                a1:OnInputEnded()
                if a1.moveTouchLockedIn then
                    return Enum.ContextActionResult.Sink
                end
            end
            return Enum.ContextActionResult.Pass
        elseif a6 == Enum.UserInputState.Cancel then
            a1:OnInputEnded()
        end
    end
    ContextActionService_upv_1:BindActionAtPriority("DynamicThumbstickAction", handleInput, false, Value_upv_1, Enum.UserInputType.Touch)
    if not u3 then
        return
    end
    a1.TouchMovedCon = UserInputService_upv_1.TouchMoved:Connect(
        function(a8, a9)
            --[[
              line: 382
              upvalues:
                inputChanged (copy, index: 1)
            ]]
            inputChanged(a8)
        end
    )
end
function u6.UnbindContextActions(a1)
    --[[
      name: UnbindContextActions
      line: 388
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    ContextActionService_upv_1:UnbindAction("DynamicThumbstickAction")
    if not a1.TouchMovedCon then
        return
    end
    a1.TouchMovedCon:Disconnect()
end
function u6.Create(a1, a2)
    --[[
      name: Create
      line: 396
      upvalues:
        u5 (ref,  index: 1)
        u1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        RunService_upv_1 (copy, index: 4)
        UserInputService_upv_1 (copy, index: 5)
        GuiService_upv_1 (copy, index: 6)
        u4 (ref,  index: 7)
    ]]
    if a1.thumbstickFrame then
        a1.thumbstickFrame:Destroy()
        a1.thumbstickFrame = nil
        if a1.onRenderSteppedConn then
            a1.onRenderSteppedConn:Disconnect()
            a1.onRenderSteppedConn = nil
        end
        if a1.absoluteSizeChangedConn then
            a1.absoluteSizeChangedConn:Disconnect()
            a1.absoluteSizeChangedConn = nil
        end
    end
    local u7 = (u5 and 100) or 0
    a1.thumbstickFrame = Instance.new("Frame")
    a1.thumbstickFrame.BorderSizePixel = 0
    a1.thumbstickFrame.Name = "DynamicThumbstickFrame"
    a1.thumbstickFrame.Visible = false
    a1.thumbstickFrame.BackgroundTransparency = 1
    a1.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    a1.thumbstickFrame.Active = false
    a1.thumbstickFrame.Size = UDim2.new(0.4, u7, 0.6666666666666666, u7)
    a1.thumbstickFrame.Position = UDim2.new(0, -u7, 0.3333333333333333, 0)
    a1.startImage = Instance.new("ImageLabel")
    a1.startImage.Name = "ThumbstickStart"
    a1.startImage.Visible = true
    a1.startImage.BackgroundTransparency = 1
    a1.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    a1.startImage.ImageRectOffset = Vector2.new(1, 1)
    a1.startImage.ImageRectSize = Vector2.new(144, 144)
    a1.startImage.ImageColor3 = Color3.new(0, 0, 0)
    a1.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    a1.startImage.ZIndex = 10
    a1.startImage.Parent = a1.thumbstickFrame
    a1.endImage = Instance.new("ImageLabel")
    a1.endImage.Name = "ThumbstickEnd"
    a1.endImage.Visible = true
    a1.endImage.BackgroundTransparency = 1
    a1.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    a1.endImage.ImageRectOffset = Vector2.new(1, 1)
    a1.endImage.ImageRectSize = Vector2.new(144, 144)
    a1.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    a1.endImage.ZIndex = 10
    a1.endImage.Parent = a1.thumbstickFrame
    for n_5 = 1, u1 do
        a1.middleImages[n_5] = Instance.new("ImageLabel")
        a1.middleImages[n_5].Name = "ThumbstickMiddle"
        a1.middleImages[n_5].Visible = false
        a1.middleImages[n_5].BackgroundTransparency = 1
        a1.middleImages[n_5].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        a1.middleImages[n_5].ImageRectOffset = Vector2.new(1, 1)
        a1.middleImages[n_5].ImageRectSize = Vector2.new(144, 144)
        a1.middleImages[n_5].ImageTransparency = tbl_upv_1[n_5]
        a1.middleImages[n_5].AnchorPoint = Vector2.new(0.5, 0.5)
        a1.middleImages[n_5].ZIndex = 9
        a1.middleImages[n_5].Parent = a1.thumbstickFrame
    end
    local function ResizeThumbstick()
        --[[
          name: ResizeThumbstick
          line: 467
          upvalues:
            a2 (copy, index: 1)
            a1 (copy, index: 2)
            u7 (copy, index: 3)
        ]]
        local AbsoluteSize_1 = a2.AbsoluteSize
        local v21 = math.min(AbsoluteSize_1.X, AbsoluteSize_1.Y) > 500
        if v21 then
            a1.thumbstickSize = 90
            a1.thumbstickRingSize = 40
            a1.middleSize = 20
            a1.middleSpacing = 28
            a1.radiusOfDeadZone = 4
            a1.radiusOfMaxSpeed = 40
        else
            a1.thumbstickSize = 45
            a1.thumbstickRingSize = 20
            a1.middleSize = 10
            a1.middleSpacing = 14
            a1.radiusOfDeadZone = 2
            a1.radiusOfMaxSpeed = 20
        end
        a1.startImage.Position = UDim2.new(0, (a1.thumbstickRingSize * 3.3) + u7, 1, (-a1.thumbstickRingSize * 2.8) - u7)
        a1.startImage.Size = UDim2.new(0, a1.thumbstickRingSize * 3.7, 0, a1.thumbstickRingSize * 3.7)
        a1.endImage.Position = a1.startImage.Position
        a1.endImage.Size = UDim2.new(0, a1.thumbstickSize * 0.8, 0, a1.thumbstickSize * 0.8)
    end
    ResizeThumbstick()
    a1.absoluteSizeChangedConn = a2:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)
    local u8 = nil
    local function layoutThumbstickFrame(a3)
        --[[
          name: layoutThumbstickFrame
          line: 411
          upvalues:
            a1 (copy, index: 1)
            u7 (copy, index: 2)
        ]]
        if a3 then
            a1.thumbstickFrame.Size = UDim2.new(1, u7, 0.4, u7)
            a1.thumbstickFrame.Position = UDim2.new(0, -u7, 0.6, 0)
        else
            a1.thumbstickFrame.Size = UDim2.new(0.4, u7, 0.6666666666666666, u7)
            a1.thumbstickFrame.Position = UDim2.new(0, -u7, 0.3333333333333333, 0)
        end
    end
    local function onCurrentCameraChanged()
        --[[
          name: onCurrentCameraChanged
          line: 505
          upvalues:
            u8 (ref,  index: 1)
            layoutThumbstickFrame (copy, index: 2)
        ]]
        if u8 then
            u8:Disconnect()
            u8 = nil
        end
        local CurrentCamera_upv_1 = workspace.CurrentCamera
        if CurrentCamera_upv_1 then
            local function onViewportSizeChanged_1()
                --[[
                  name: onViewportSizeChanged
                  line: 512
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                    layoutThumbstickFrame (copy, index: 2)
                ]]
                local ViewportSize_1 = CurrentCamera_upv_1.ViewportSize
                layoutThumbstickFrame(ViewportSize_1.X < ViewportSize_1.Y)
            end
            u8 = CurrentCamera_upv_1:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged_1)
            local ViewportSize_2 = CurrentCamera_upv_1.ViewportSize
            layoutThumbstickFrame(ViewportSize_2.X < ViewportSize_2.Y)
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
    if workspace.CurrentCamera then
        onCurrentCameraChanged()
    end
    a1.moveTouchStartPosition = nil
    a1.startImageFadeTween = nil
    a1.endImageFadeTween = nil
    a1.middleImageFadeTweens = {}
    a1.onRenderSteppedConn = RunService_upv_1.RenderStepped:Connect(
        function()
            --[[
              line: 532
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a1.tweenInAlphaStart == nil then
                if a1.tweenOutAlphaStart ~= nil then
                    local v22 = tick() - a1.tweenOutAlphaStart
                    local v23 = a1.fadeInAndOutHalfDuration * 2 - (a1.fadeInAndOutHalfDuration * 2) * a1.fadeInAndOutBalance
                    a1.thumbstickFrame.BackgroundTransparency = (math.min(v22 / v23, 1) * 0.35) + 0.65
                    if not (v23 < v22) then
                        return
                    end
                    a1.tweenOutAlphaStart = nil
                end
            else
                local v24 = tick() - a1.tweenInAlphaStart
                local v25 = a1.fadeInAndOutHalfDuration * 2 * a1.fadeInAndOutBalance
                a1.thumbstickFrame.BackgroundTransparency = 1 - (math.min(v24 / v25, 1) * 0.35)
                if not (v25 < v24) then
                    return
                end
                a1.tweenOutAlphaStart = tick()
                a1.tweenInAlphaStart = nil
            end
        end
    )
    a1.onTouchEndedConn = UserInputService_upv_1.TouchEnded:connect(
        function(a4)
            --[[
              line: 551
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a4 ~= a1.moveTouchObject then
                return
            end
            a1:OnInputEnded()
        end
    )
    GuiService_upv_1.MenuOpened:connect(
        function()
            --[[
              line: 557
              upvalues:
                a1 (copy, index: 1)
            ]]
            if not a1.moveTouchObject then
                return
            end
            a1:OnInputEnded()
        end
    )
    local u9 = u4:FindFirstChildOfClass("PlayerGui")
    while not (u9) do
        u4.ChildAdded:wait()
        u9 = u4:FindFirstChildOfClass("PlayerGui")
    end
    local u10 = nil
    local u11 = true
    local v26 = nil
    if v26.CurrentScreenOrientation ~= Enum.ScreenOrientation.LandscapeLeft then
        u11 = v26.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
    end
    local function longShowBackground()
        --[[
          name: longShowBackground
          line: 573
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.fadeInAndOutHalfDuration = 2.5
        a1.fadeInAndOutBalance = 0.05
        a1.tweenInAlphaStart = tick()
    end
    local v27 = v26:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(
        function()
            --[[
              line: 579
              upvalues:
                u11 (copy, index: 1)
                u9 (ref,  index: 2)
                u10 (ref,  index: 3)
                a1 (copy, index: 4)
            ]]
            if (not u11 or u9.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and ((u11) or u9.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) then
                return
            end
            u10:disconnect()
            a1.fadeInAndOutHalfDuration = 2.5
            a1.fadeInAndOutBalance = 0.05
            a1.tweenInAlphaStart = tick()
            if u11 then
                a1.hasFadedBackgroundInPortrait = true
            else
                a1.hasFadedBackgroundInLandscape = true
            end
        end
    )
    u10 = v27
    a1.thumbstickFrame.Parent = a2
    if game:IsLoaded() then
        a1.fadeInAndOutHalfDuration = 2.5
        a1.fadeInAndOutBalance = 0.05
        a1.tweenInAlphaStart = tick()
    else
        coroutine.wrap(
            function()
                --[[
                  line: 599
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                game.Loaded:Wait()
                a1.fadeInAndOutHalfDuration = 2.5
                a1.fadeInAndOutBalance = 0.05
                a1.tweenInAlphaStart = tick()
            end
        )()
    end
end
return u6