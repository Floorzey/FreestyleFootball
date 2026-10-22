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
local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
end)
local result_2 = success and result
local success2, result2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local result2_2 = success2 and result2
local local_player = players.LocalPlayer

if not local_player then
    players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local_player = players.LocalPlayer
end

local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local dynamic_thumbstick = setmetatable({}, base_character_controller)
dynamic_thumbstick.__index = dynamic_thumbstick

function dynamic_thumbstick.new()
    local base_character_controller_2 = base_character_controller.new()
    local instance = setmetatable(base_character_controller_2, dynamic_thumbstick)
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

function dynamic_thumbstick.Enable(argument: table, argument_2: boolean?, target: any)
    if argument_2 == nil then
        return false
    end

    local enabled = argument_2 and true or false

    if argument.enabled == enabled then
        return true
    end

    if enabled then
        if not argument.thumbstickFrame then
            argument:Create(target)
        end

        argument:BindContextActions()
    else
        if result_2 then
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

function dynamic_thumbstick.FadeThumbstick(argument: table, argument_2: boolean?)
    if not argument_2 and argument.moveTouchObject then
        return
    end

    if argument.isFirstTouch then
        return
    end

    if argument.startImageFadeTween then
        argument.startImageFadeTween:Cancel()
    end

    if argument.endImageFadeTween then
        argument.endImageFadeTween:Cancel()
    end

    for index = 1, #argument.middleImages do
        local index_4

        if argument.middleImageFadeTweens[index] then
            argument.middleImageFadeTweens[index]:Cancel()
            index_4 = index
        else
            index_4 = index
        end
    end

    if argument_2 then
        argument.startImageFadeTween = tween_service:Create(argument.startImage, tween_info, {
            ImageTransparency = 0,
        })
        argument.startImageFadeTween:Play()
        argument.endImageFadeTween = tween_service:Create(argument.endImage, tween_info, {
            ImageTransparency = 0.2,
        })
        argument.endImageFadeTween:Play()

        for index_2 = 1, #argument.middleImages do
            argument.middleImageFadeTweens[index_2] = tween_service:Create(argument.middleImages[index_2], tween_info, {
                ImageTransparency = values[index_2],
            })
            argument.middleImageFadeTweens[index_2]:Play()
            local _ = index_2
        end

        return
    end

    argument.startImageFadeTween = tween_service:Create(argument.startImage, tween_info, {
        ImageTransparency = 1,
    })
    argument.startImageFadeTween:Play()
    argument.endImageFadeTween = tween_service:Create(argument.endImage, tween_info, {
        ImageTransparency = 1,
    })
    argument.endImageFadeTween:Play()

    for index_3 = 1, #argument.middleImages do
        argument.middleImageFadeTweens[index_3] = tween_service:Create(argument.middleImages[index_3], tween_info, {
            ImageTransparency = 1,
        })
        argument.middleImageFadeTweens[index_3]:Play()
        local _ = index_3
    end
end

function dynamic_thumbstick.FadeThumbstickFrame(argument: table, argument_2: number, fade_in_and_out_balance: number)
    argument.fadeInAndOutHalfDuration = argument_2 * 0.5
    argument.fadeInAndOutBalance = fade_in_and_out_balance
    argument.tweenInAlphaStart = tick()
end

function dynamic_thumbstick.InputInFrame(argument: table, argument_2: userdata)
    local absolute_position = argument.thumbstickFrame.AbsolutePosition
    local sum = absolute_position + argument.thumbstickFrame.AbsoluteSize
    local position = argument_2.Position

    return position.X >= absolute_position.X
        and (position.Y >= absolute_position.Y and (position.X <= sum.X and position.Y <= sum.Y))
end

function dynamic_thumbstick.DoFadeInBackground(argument)
    local player_gui = local_player:FindFirstChildOfClass("PlayerGui")
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

function dynamic_thumbstick.DoMove(argument: table, vector_2: vector)
    local vector

    if vector_2.Magnitude < argument.radiusOfDeadZone then
        vector = Vector3.new(0, 0, 0)
    else
        local product = vector_2.Unit
            * (1 - math.max(0, (argument.radiusOfMaxSpeed - vector_2.Magnitude) / argument.radiusOfMaxSpeed))
        vector = Vector3.new(product.X, 0, product.Y)
    end

    argument.moveVector = vector
end

function dynamic_thumbstick.LayoutMiddleImages(argument: table, argument_2: vector, argument_3: vector)
    local sum = argument.thumbstickSize / 2 + argument.middleSize
    local vector = argument_3 - argument_2
    local difference = vector.Magnitude - argument.thumbstickRingSize / 2 - argument.middleSize
    local unit = vector.Unit
    local middle_spacing = argument.middleSpacing

    if argument.middleSpacing * values_count < difference then
        middle_spacing = difference / values_count
    end

    for index = 1, values_count do
        local middle_image_entry = argument.middleImages[index]
        local sum_2 = sum + middle_spacing * (index - 1)
        local index_2

        if sum + middle_spacing * (index - 2) < difference then
            local difference_2 = argument_3 - unit * sum_2
            local clamped_value = math.clamp(1 - (sum_2 - difference) / middle_spacing, 0, 1)
            middle_image_entry.Visible = true
            middle_image_entry.Position = UDim2.new(0, difference_2.X, 0, difference_2.Y)
            middle_image_entry.Size =
                UDim2.new(0, argument.middleSize * clamped_value, 0, argument.middleSize * clamped_value)
            index_2 = index
        else
            middle_image_entry.Visible = false
            index_2 = index
        end
    end
end

function dynamic_thumbstick.MoveStick(argument, argument_2)
    local difference = Vector2.new(argument.moveTouchStartPosition.X, argument.moveTouchStartPosition.Y)
        - argument.thumbstickFrame.AbsolutePosition
    local difference_2 = Vector2.new(argument_2.X, argument_2.Y) - argument.thumbstickFrame.AbsolutePosition
    argument.endImage.Position = UDim2.new(0, difference_2.X, 0, difference_2.Y)
    argument:LayoutMiddleImages(difference, difference_2)
end

function dynamic_thumbstick.BindContextActions(argument)
    local function input_began(move_touch_object)
        if argument.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end

        if not argument:InputInFrame(move_touch_object) then
            return Enum.ContextActionResult.Pass
        end

        if argument.isFirstTouch then
            argument.isFirstTouch = false
            local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            tween_service
                :Create(argument.startImage, tween_info_2, {
                    Size = UDim2.new(0, 0, 0, 0),
                })
                :Play()
            tween_service
                :Create(argument.endImage, tween_info_2, {
                    Size = UDim2.new(0, argument.thumbstickSize, 0, argument.thumbstickSize),
                    ImageColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end

        argument.moveTouchLockedIn = false
        argument.moveTouchObject = move_touch_object
        argument.moveTouchStartPosition = move_touch_object.Position
        argument.moveTouchFirstChanged = true
        argument:DoFadeInBackground()

        return Enum.ContextActionResult.Pass
    end

    local function input_changed(argument_2: userdata)
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

    context_action_service:BindActionAtPriority(
        "DynamicThumbstickAction",
        function(argument_2, argument_3, move_touch_object)
            if argument_3 == Enum.UserInputState.Begin then
                return input_began(move_touch_object)
            end

            if argument_3 == Enum.UserInputState.Change then
                if not result_2 then
                    return input_changed(move_touch_object)
                end

                if move_touch_object == argument.moveTouchObject then
                    return Enum.ContextActionResult.Sink
                end

                return Enum.ContextActionResult.Pass
            end

            if argument_3 == Enum.UserInputState.End then
                if move_touch_object == argument.moveTouchObject then
                    argument:OnInputEnded()

                    if argument.moveTouchLockedIn then
                        return Enum.ContextActionResult.Sink
                    end
                end

                return Enum.ContextActionResult.Pass
            end

            if argument_3 == Enum.UserInputState.Cancel then
                argument:OnInputEnded()
            end
        end,
        false,
        value,
        Enum.UserInputType.Touch
    )

    if result_2 then
        argument.TouchMovedCon = user_input_service.TouchMoved:Connect(
            function(argument_2: userdata, argument_3: boolean)
                input_changed(argument_2)
            end
        )
    end
end

function dynamic_thumbstick.UnbindContextActions(argument)
    context_action_service:UnbindAction("DynamicThumbstickAction")

    if argument.TouchMovedCon then
        argument.TouchMovedCon:Disconnect()
    end
end

function dynamic_thumbstick.Create(argument: table, parent: userdata)
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

    local control_size = result2_2 and 100 or 0
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

    local function layout_thumbstick_frame(argument_2: boolean)
        if argument_2 then
            argument.thumbstickFrame.Size = UDim2.new(1, control_size, 0.4, control_size)
            argument.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.6, 0)

            return
        end

        argument.thumbstickFrame.Size = UDim2.new(0.4, control_size, 0.6666666666666666, control_size)
        argument.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.3333333333333333, 0)
    end

    for index = 1, values_count do
        argument.middleImages[index] = Instance.new("ImageLabel")
        argument.middleImages[index].Name = "ThumbstickMiddle"
        argument.middleImages[index].Visible = false
        argument.middleImages[index].BackgroundTransparency = 1
        argument.middleImages[index].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        argument.middleImages[index].ImageRectOffset = Vector2.new(1, 1)
        argument.middleImages[index].ImageRectSize = Vector2.new(144, 144)
        argument.middleImages[index].ImageTransparency = values[index]
        argument.middleImages[index].AnchorPoint = Vector2.new(0.5, 0.5)
        argument.middleImages[index].ZIndex = 9
        argument.middleImages[index].Parent = argument.thumbstickFrame
        local _ = index
    end

    local function resize_thumbstick()
        local absolute_size = parent.AbsoluteSize

        if math.min(absolute_size.X, absolute_size.Y) > 500 then
            argument.thumbstickSize = 90
            argument.thumbstickRingSize = 40
            argument.middleSize = 20
            argument.middleSpacing = 28
            argument.radiusOfDeadZone = 4
            argument.radiusOfMaxSpeed = 40
        else
            argument.thumbstickSize = 45
            argument.thumbstickRingSize = 20
            argument.middleSize = 10
            argument.middleSpacing = 14
            argument.radiusOfDeadZone = 2
            argument.radiusOfMaxSpeed = 20
        end

        argument.startImage.Position = UDim2.new(
            0,
            argument.thumbstickRingSize * 3.3 + control_size,
            1,
            -argument.thumbstickRingSize * 2.8 - control_size
        )
        argument.startImage.Size = UDim2.new(0, argument.thumbstickRingSize * 3.7, 0, argument.thumbstickRingSize * 3.7)
        argument.endImage.Position = argument.startImage.Position
        argument.endImage.Size = UDim2.new(0, argument.thumbstickSize * 0.8, 0, argument.thumbstickSize * 0.8)
    end

    resize_thumbstick()
    argument.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_thumbstick)
    local connection = nil

    local function on_current_camera_changed()
        if connection then
            connection:Disconnect()
            connection = nil
        end

        local workspace_current_camera = workspace.CurrentCamera

        if not workspace_current_camera then
            return
        end

        local function on_viewport_size_changed()
            local viewport_size_2 = workspace_current_camera.ViewportSize
            layout_thumbstick_frame(viewport_size_2.X < viewport_size_2.Y)
        end

        connection = workspace_current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(on_viewport_size_changed)
        local viewport_size = workspace_current_camera.ViewportSize
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
                    - argument.fadeInAndOutHalfDuration * 2 * argument.fadeInAndOutBalance
                argument.thumbstickFrame.BackgroundTransparency = math.min(difference / difference_2, 1) * 0.35 + 0.65

                if difference_2 < difference then
                    argument.tweenOutAlphaStart = nil
                end
            end
        else
            local difference_3 = tick() - argument.tweenInAlphaStart
            local product = argument.fadeInAndOutHalfDuration * 2 * argument.fadeInAndOutBalance
            argument.thumbstickFrame.BackgroundTransparency = 1 - math.min(difference_3 / product, 1) * 0.35

            if product < difference_3 then
                argument.tweenOutAlphaStart = tick()
                argument.tweenInAlphaStart = nil
            end
        end
    end)
    argument.onTouchEndedConn = user_input_service.TouchEnded:connect(function(argument_2: userdata)
        if argument_2 == argument.moveTouchObject then
            argument:OnInputEnded()
        end
    end)

    gui_service.MenuOpened:connect(function()
        if argument.moveTouchObject then
            argument:OnInputEnded()
        end
    end)

    local player_gui = local_player:FindFirstChildOfClass("PlayerGui")

    while not player_gui do
        local_player.ChildAdded:wait()
        player_gui = local_player:FindFirstChildOfClass("PlayerGui")
    end

    local value_2 = nil
    local condition = player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft and true
        or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

    local function long_show_background()
        argument.fadeInAndOutHalfDuration = 2.5
        argument.fadeInAndOutBalance = 0.05
        argument.tweenInAlphaStart = tick()
    end

    value_2 = player_gui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
        if
            (not condition or player_gui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait)
            and (condition or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)
        then
            return
        end

        value_2:disconnect()
        argument.fadeInAndOutHalfDuration = 2.5
        argument.fadeInAndOutBalance = 0.05
        argument.tweenInAlphaStart = tick()

        if condition then
            argument.hasFadedBackgroundInPortrait = true

            return
        end

        argument.hasFadedBackgroundInLandscape = true
    end)
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
