local value = Enum.ContextActionPriority.High.Value
local values = { 0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75 }
local values_count = #values
local tween_info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local players = game:GetService("Players")
local gui_service = game:GetService("GuiService")
local user_input_service = game:GetService("UserInputService")
local context_action_service = game:GetService("ContextActionService")
local run_service = game:GetService("RunService")
local tween_service = game:GetService("TweenService")
local success, value_2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
end)
local value_3 = success and value_2
local pcall_result, value_4 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local value_5 = pcall_result and value_4
local local_player = players.LocalPlayer

if local_player then
    pcall_result = local_player
else
    players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    pcall_result = players.LocalPlayer
end

local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local dynamic_thumbstick = setmetatable({}, base_character_controller)
dynamic_thumbstick.__index = dynamic_thumbstick

function dynamic_thumbstick.new()
    local instance = setmetatable(base_character_controller.new(), dynamic_thumbstick)
    instance.moveTouchObject = nil
    instance.moveTouchLockedIn = false
    instance.moveTouchFirstChanged = false
    instance.moveTouchStartPosition = nil
    instance.startImage = nil
    instance.endImage = nil
    instance.middleImages = {}
    instance.startImageFadeTween = nil
    instance.endImageFadeTween = nil
    instance.middleImageFadeTweens = {}
    instance.isFirstTouch = true
    instance.thumbstickFrame = nil
    instance.onRenderSteppedConn = nil
    instance.fadeInAndOutBalance = 0.5
    instance.fadeInAndOutHalfDuration = 0.3
    instance.hasFadedBackgroundInPortrait = false
    instance.hasFadedBackgroundInLandscape = false
    instance.tweenInAlphaStart = nil
    instance.tweenOutAlphaStart = nil

    return instance
end

function dynamic_thumbstick.GetIsJumping(argument)
    local is_jumping = argument.isJumping
    argument.isJumping = false

    return is_jumping
end

function dynamic_thumbstick.Enable(argument, enabled, target)
    if enabled == nil then
        return false
    end

    if argument.enabled == enabled then
        return true
    end

    if enabled then
        if not argument.thumbstickFrame then
            argument:Create(target)
        end

        argument:BindContextActions()
    else
        if value_3 then
            argument:UnbindContextActions()
        else
            context_action_service:UnbindAction("DynamicThumbstickAction")
        end

        argument:OnInputEnded()
    end

    argument.enabled = enabled
    argument.thumbstickFrame.Visible = enabled

    return nil
end

function dynamic_thumbstick.OnInputEnded(argument)
    argument.moveTouchObject = nil
    argument.moveVector = Vector3.new(0, 0, 0)
    argument:FadeThumbstick(false)
end

function dynamic_thumbstick.FadeThumbstick(argument, argument_2)
    if not ((argument_2 or not argument.moveTouchObject) and not argument.isFirstTouch) then
        return
    end

    if argument.startImageFadeTween then
        argument.startImageFadeTween:Cancel()
    end

    if argument.endImageFadeTween then
        argument.endImageFadeTween:Cancel()
    end

    for n = 1, #argument.middleImages do
        if argument.middleImageFadeTweens[n] then
            argument.middleImageFadeTweens[n]:Cancel()
        end
    end

    if argument_2 then
        argument.startImageFadeTween = tween_service:Create(argument.startImage, tween_info, { ImageTransparency = 0 })
        argument.startImageFadeTween:Play()
        argument.endImageFadeTween = tween_service:Create(argument.endImage, tween_info, { ImageTransparency = 0.2 })
        argument.endImageFadeTween:Play()

        for n_2 = 1, #argument.middleImages do
            argument.middleImageFadeTweens[n_2] =
                tween_service:Create(argument.middleImages[n_2], tween_info, { ImageTransparency = values[n_2] })
            argument.middleImageFadeTweens[n_2]:Play()
        end
    else
        argument.startImageFadeTween = tween_service:Create(argument.startImage, tween_info, { ImageTransparency = 1 })
        argument.startImageFadeTween:Play()
        argument.endImageFadeTween = tween_service:Create(argument.endImage, tween_info, { ImageTransparency = 1 })
        argument.endImageFadeTween:Play()

        for n_3 = 1, #argument.middleImages do
            argument.middleImageFadeTweens[n_3] =
                tween_service:Create(argument.middleImages[n_3], tween_info, { ImageTransparency = 1 })
            argument.middleImageFadeTweens[n_3]:Play()
        end
    end
end

function dynamic_thumbstick.FadeThumbstickFrame(argument, argument_2, fade_in_and_out_balance)
    argument.fadeInAndOutHalfDuration = argument_2 * 0.5
    argument.fadeInAndOutBalance = fade_in_and_out_balance
    argument.tweenInAlphaStart = tick()
end

function dynamic_thumbstick.InputInFrame(argument, argument_2)
    local absolute_position = argument.thumbstickFrame.AbsolutePosition
    local sum = absolute_position + argument.thumbstickFrame.AbsoluteSize
    local position = argument_2.Position

    return if absolute_position.X <= position.X
            and absolute_position.Y <= position.Y
            and position.X <= sum.X
            and position.Y <= sum.Y
        then true
        else false
end

function dynamic_thumbstick.DoFadeInBackground(argument)
    local player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")
    local enabled = false

    if player_gui then
        if
            player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft
            or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
        then
            enabled = argument.hasFadedBackgroundInLandscape
            argument.hasFadedBackgroundInLandscape = true
        elseif player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            enabled = argument.hasFadedBackgroundInPortrait
            argument.hasFadedBackgroundInPortrait = true
        end
    end

    if enabled then
        return
    end

    argument.fadeInAndOutHalfDuration = 0.3
    argument.fadeInAndOutBalance = 0.5
    argument.tweenInAlphaStart = tick()
end

function dynamic_thumbstick.DoMove(argument, vector_2)
    local vector

    if vector_2.Magnitude < argument.radiusOfDeadZone then
        vector = Vector3.new(0, 0, 0)
    else
        vector_2 = vector_2.Unit
            * (1 - math.max(0, (argument.radiusOfMaxSpeed - vector_2.Magnitude) / argument.radiusOfMaxSpeed))
        vector = Vector3.new(vector_2.X, 0, vector_2.Y)
    end

    argument.moveVector = vector
end

function dynamic_thumbstick.LayoutMiddleImages(argument, argument_2, argument_3)
    local sum = argument.thumbstickSize / 2 + argument.middleSize
    local vector = argument_3 - argument_2
    local difference = vector.Magnitude - (argument.thumbstickRingSize / 2) - argument.middleSize
    local unit = vector.Unit
    local middle_spacing = ((argument.middleSpacing * values_count < difference) and (difference / values_count))
        or argument.middleSpacing

    for n = 1, values_count do
        local middle_image_entry = argument.middleImages[n]
        local sum_2 = sum + middle_spacing * (n - 1)

        if sum + (middle_spacing * (n - 2)) < difference then
            local difference_2 = argument_3 - unit * sum_2
            local clamped_value = math.clamp(1 - ((sum_2 - difference) / middle_spacing), 0, 1)
            middle_image_entry.Visible = true
            middle_image_entry.Position = UDim2.new(0, difference_2.X, 0, difference_2.Y)
            middle_image_entry.Size =
                UDim2.new(0, argument.middleSize * clamped_value, 0, argument.middleSize * clamped_value)
        else
            middle_image_entry.Visible = false
        end
    end
end

function dynamic_thumbstick.MoveStick(argument, argument_2)
    local vector = Vector2.new(argument.moveTouchStartPosition.X, argument.moveTouchStartPosition.Y)
    local difference = Vector2.new(argument_2.X, argument_2.Y) - argument.thumbstickFrame.AbsolutePosition
    argument.endImage.Position = UDim2.new(0, difference.X, 0, difference.Y)
    argument:LayoutMiddleImages(vector - argument.thumbstickFrame.AbsolutePosition, difference)
end

function dynamic_thumbstick.BindContextActions(argument)
    local function input_changed(argument_2)
        if argument_2 ~= argument.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end

        if argument.moveTouchFirstChanged then
            argument.moveTouchFirstChanged = false
            local vector = Vector2.new(
                argument_2.Position.X - argument.thumbstickFrame.AbsolutePosition.X,
                argument_2.Position.Y - argument.thumbstickFrame.AbsolutePosition.Y
            )
            argument.startImage.Visible = true
            argument.startImage.Position = UDim2.new(0, vector.X, 0, vector.Y)
            argument.endImage.Visible = true
            argument.endImage.Position = argument.startImage.Position
            argument:FadeThumbstick(true)
            argument:MoveStick(argument_2.Position)
        end

        argument.moveTouchLockedIn = true
        local vector_2 = Vector2.new(
            argument_2.Position.X - argument.moveTouchStartPosition.X,
            argument_2.Position.Y - argument.moveTouchStartPosition.Y
        )

        if math.abs(vector_2.X) > 0 or math.abs(vector_2.Y) > 0 then
            argument:DoMove(vector_2)
            argument:MoveStick(argument_2.Position)
        end

        return Enum.ContextActionResult.Sink
    end

    local function input_ended(argument_2)
        if argument_2 == argument.moveTouchObject then
            argument:OnInputEnded()

            if argument.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end

        return Enum.ContextActionResult.Pass
    end

    local function input_began(move_touch_object)
        if not argument.moveTouchObject and argument:InputInFrame(move_touch_object) then
            if argument.isFirstTouch then
                argument.isFirstTouch = false
                local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
                local tween_properties = {}
                tween_properties.Size = UDim2.new(0, 0, 0, 0)
                tween_service:Create(argument.startImage, tween_info_2, tween_properties):Play()
                local tween_properties_2 = {}
                tween_properties_2.Size = UDim2.new(0, argument.thumbstickSize, 0, argument.thumbstickSize)
                tween_properties_2.ImageColor3 = Color3.new(0, 0, 0)
                tween_service:Create(argument.endImage, tween_info_2, tween_properties_2):Play()
            end

            argument.moveTouchLockedIn = false
            argument.moveTouchObject = move_touch_object
            argument.moveTouchStartPosition = move_touch_object.Position
            argument.moveTouchFirstChanged = true
            argument:DoFadeInBackground()
        end

        return Enum.ContextActionResult.Pass
    end

    local function handle_input(argument_2, argument_3, move_touch_object)
        if argument_3 == Enum.UserInputState.Begin then
            return (input_began(move_touch_object))
        elseif argument_3 == Enum.UserInputState.Change then
            if value_3 then
                if move_touch_object ~= argument.moveTouchObject then
                    return Enum.ContextActionResult.Pass
                end

                return Enum.ContextActionResult.Sink
            end

            return (input_changed(move_touch_object))
        elseif argument_3 == Enum.UserInputState.End then
            if move_touch_object == argument.moveTouchObject then
                argument:OnInputEnded()

                if argument.moveTouchLockedIn then
                    return Enum.ContextActionResult.Sink
                end
            end

            return Enum.ContextActionResult.Pass
        elseif argument_3 == Enum.UserInputState.Cancel then
            argument:OnInputEnded()
        end
    end

    context_action_service:BindActionAtPriority(
        "DynamicThumbstickAction",
        handle_input,
        false,
        value,
        Enum.UserInputType.Touch
    )

    if not value_3 then
        return
    end

    argument.TouchMovedCon = user_input_service.TouchMoved:Connect(function(argument_2, argument_3)
        input_changed(argument_2)
    end)
end

function dynamic_thumbstick.UnbindContextActions(argument)
    context_action_service:UnbindAction("DynamicThumbstickAction")

    if not argument.TouchMovedCon then
        return
    end

    argument.TouchMovedCon:Disconnect()
end

function dynamic_thumbstick.Create(argument, parent)
    if argument.thumbstickFrame then
        argument.thumbstickFrame:Destroy()
        argument.thumbstickFrame = nil

        if argument.onRenderSteppedConn then
            argument.onRenderSteppedConn:Disconnect()
            argument.onRenderSteppedConn = nil
        end

        if argument.absoluteSizeChangedConn then
            argument.absoluteSizeChangedConn:Disconnect()
            argument.absoluteSizeChangedConn = nil
        end
    end

    local control_size = (value_5 and 100) or 0
    argument.thumbstickFrame = Instance.new("Frame")
    argument.thumbstickFrame.BorderSizePixel = 0
    argument.thumbstickFrame.Name = "DynamicThumbstickFrame"
    argument.thumbstickFrame.Visible = false
    argument.thumbstickFrame.BackgroundTransparency = 1
    argument.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    argument.thumbstickFrame.Active = false
    argument.thumbstickFrame.Size = UDim2.new(0.4, control_size, 0.6666666666666666, control_size)
    argument.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.3333333333333333, 0)
    argument.startImage = Instance.new("ImageLabel")
    argument.startImage.Name = "ThumbstickStart"
    argument.startImage.Visible = true
    argument.startImage.BackgroundTransparency = 1
    argument.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    argument.startImage.ImageRectOffset = Vector2.new(1, 1)
    argument.startImage.ImageRectSize = Vector2.new(144, 144)
    argument.startImage.ImageColor3 = Color3.new(0, 0, 0)
    argument.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    argument.startImage.ZIndex = 10
    argument.startImage.Parent = argument.thumbstickFrame
    argument.endImage = Instance.new("ImageLabel")
    argument.endImage.Name = "ThumbstickEnd"
    argument.endImage.Visible = true
    argument.endImage.BackgroundTransparency = 1
    argument.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    argument.endImage.ImageRectOffset = Vector2.new(1, 1)
    argument.endImage.ImageRectSize = Vector2.new(144, 144)
    argument.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    argument.endImage.ZIndex = 10
    argument.endImage.Parent = argument.thumbstickFrame

    for n = 1, values_count do
        argument.middleImages[n] = Instance.new("ImageLabel")
        argument.middleImages[n].Name = "ThumbstickMiddle"
        argument.middleImages[n].Visible = false
        argument.middleImages[n].BackgroundTransparency = 1
        argument.middleImages[n].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        argument.middleImages[n].ImageRectOffset = Vector2.new(1, 1)
        argument.middleImages[n].ImageRectSize = Vector2.new(144, 144)
        argument.middleImages[n].ImageTransparency = values[n]
        argument.middleImages[n].AnchorPoint = Vector2.new(0.5, 0.5)
        argument.middleImages[n].ZIndex = 9
        argument.middleImages[n].Parent = argument.thumbstickFrame
    end

    local function resize_thumbstick()
        local absolute_size = parent.AbsoluteSize

        if math.min(absolute_size.X, absolute_size.Y) > 500 then
            argument.thumbstickSize = 90
            argument.thumbstickRingSize = 40
            argument.middleSize = 20
            argument.middleSpacing = 28
            argument.radiusOfDeadZone = 4
            argument.radiusOfMaxSpeed = 60
        else
            argument.thumbstickSize = 45
            argument.thumbstickRingSize = 20
            argument.middleSize = 10
            argument.middleSpacing = 14
            argument.radiusOfDeadZone = 2
            argument.radiusOfMaxSpeed = 30
        end

        argument.startImage.Position = UDim2.new(
            0,
            (argument.thumbstickRingSize * 3.3) + control_size,
            1,
            (-argument.thumbstickRingSize * 2.8) - control_size
        )
        argument.startImage.Size = UDim2.new(0, argument.thumbstickRingSize * 3.7, 0, argument.thumbstickRingSize * 3.7)
        argument.endImage.Position = argument.startImage.Position
        argument.endImage.Size = UDim2.new(0, argument.thumbstickSize * 0.8, 0, argument.thumbstickSize * 0.8)
    end

    resize_thumbstick()
    argument.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_thumbstick)
    local connection_2 = nil

    local function layout_thumbstick_frame(argument_2)
        if argument_2 then
            argument.thumbstickFrame.Size = UDim2.new(1, control_size, 0.4, control_size)
            argument.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.6, 0)
        else
            argument.thumbstickFrame.Size = UDim2.new(0.4, control_size, 0.6666666666666666, control_size)
            argument.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.3333333333333333, 0)
        end
    end

    local function on_current_camera_changed()
        if connection_2 then
            connection_2:Disconnect()
            connection_2 = nil
        end

        local current_camera = workspace.CurrentCamera

        if not current_camera then
            return
        end

        local function on_viewport_size_changed()
            local viewport_size_2 = current_camera.ViewportSize
            layout_thumbstick_frame(viewport_size_2.X < viewport_size_2.Y)
        end

        connection_2 = current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(on_viewport_size_changed)
        local viewport_size = current_camera.ViewportSize
        layout_thumbstick_frame(viewport_size.X < viewport_size.Y)
    end

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(on_current_camera_changed)

    if workspace.CurrentCamera then
        on_current_camera_changed()
    end

    argument.moveTouchStartPosition = nil
    argument.startImageFadeTween = nil
    argument.endImageFadeTween = nil
    argument.middleImageFadeTweens = {}
    argument.onRenderSteppedConn = run_service.RenderStepped:Connect(function()
        if argument.tweenInAlphaStart == nil then
            if argument.tweenOutAlphaStart ~= nil then
                local difference = tick() - argument.tweenOutAlphaStart
                local difference_2 = argument.fadeInAndOutHalfDuration * 2
                    - (argument.fadeInAndOutHalfDuration * 2) * argument.fadeInAndOutBalance
                argument.thumbstickFrame.BackgroundTransparency = (math.min(difference / difference_2, 1) * 0.35) + 0.65

                if not (difference_2 < difference) then
                    return
                end

                argument.tweenOutAlphaStart = nil
            end
        else
            local difference_3 = tick() - argument.tweenInAlphaStart
            local product = argument.fadeInAndOutHalfDuration * 2 * argument.fadeInAndOutBalance
            argument.thumbstickFrame.BackgroundTransparency = 1 - (math.min(difference_3 / product, 1) * 0.35)

            if not (product < difference_3) then
                return
            end

            argument.tweenOutAlphaStart = tick()
            argument.tweenInAlphaStart = nil
        end
    end)
    argument.onTouchEndedConn = user_input_service.TouchEnded:connect(function(argument_2)
        if argument_2 ~= argument.moveTouchObject then
            return
        end

        argument:OnInputEnded()
    end)

    gui_service.MenuOpened:connect(function()
        if not argument.moveTouchObject then
            return
        end

        argument:OnInputEnded()
    end)

    local player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")

    while not player_gui do
        pcall_result.ChildAdded:wait()
        player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")
    end

    local value_6 = nil
    local enabled = true
    local value_7, value_8 = nil, nil

    if value_7.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft then
        value_8 = enabled
    else
        value_8 = value_7.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
    end

    local function long_show_background()
        argument.fadeInAndOutHalfDuration = 2.5
        argument.fadeInAndOutBalance = 0.05
        argument.tweenInAlphaStart = tick()
    end

    local connection = value_7:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
        if
            (not value_8 or player_gui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait)
            and (value_8 or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)
        then
            return
        end

        value_6:disconnect()
        argument.fadeInAndOutHalfDuration = 2.5
        argument.fadeInAndOutBalance = 0.05
        argument.tweenInAlphaStart = tick()

        if value_8 then
            argument.hasFadedBackgroundInPortrait = true
        else
            argument.hasFadedBackgroundInLandscape = true
        end
    end)
    value_6 = connection
    argument.thumbstickFrame.Parent = parent

    if game:IsLoaded() then
        argument.fadeInAndOutHalfDuration = 2.5
        argument.fadeInAndOutBalance = 0.05
        argument.tweenInAlphaStart = tick()
    else
        coroutine.wrap(function()
            game.Loaded:Wait()
            argument.fadeInAndOutHalfDuration = 2.5
            argument.fadeInAndOutBalance = 0.05
            argument.tweenInAlphaStart = tick()
        end)()
    end
end

return dynamic_thumbstick
