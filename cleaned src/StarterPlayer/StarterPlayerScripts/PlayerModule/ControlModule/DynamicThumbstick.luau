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
local success_2 = success and value_2
local pcall_result, value_3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local pcall_result_2 = pcall_result and value_3
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

function dynamic_thumbstick.GetIsJumping(self)
    local is_jumping = self.isJumping
    self.isJumping = false
    return is_jumping
end

function dynamic_thumbstick.Enable(self, enabled, target)
    if enabled ~= nil then
        if self.enabled ~= enabled then
            if enabled then
                if not self.thumbstickFrame then
                    self:Create(target)
                end
                self:BindContextActions()
            else
                if success_2 then
                    self:UnbindContextActions()
                else
                    context_action_service:UnbindAction("DynamicThumbstickAction")
                end
                self:OnInputEnded()
            end
            self.enabled = enabled
            self.thumbstickFrame.Visible = enabled
            return nil
        end
        return true
    end
    return false
end

function dynamic_thumbstick.OnInputEnded(self)
    self.moveTouchObject = nil
    self.moveVector = Vector3.new(0, 0, 0)
    self:FadeThumbstick(false)
end

function dynamic_thumbstick.FadeThumbstick(self, argument)
    if (argument or not self.moveTouchObject) and not self.isFirstTouch then
        if self.startImageFadeTween then
            self.startImageFadeTween:Cancel()
        end
        if self.endImageFadeTween then
            self.endImageFadeTween:Cancel()
        end
        for n = 1, #self.middleImages do
            if self.middleImageFadeTweens[n] then
                self.middleImageFadeTweens[n]:Cancel()
            end
        end
        if argument then
            self.startImageFadeTween = tween_service:Create(self.startImage, tween_info, { ImageTransparency = 0 })
            self.startImageFadeTween:Play()
            self.endImageFadeTween = tween_service:Create(self.endImage, tween_info, { ImageTransparency = 0.2 })
            self.endImageFadeTween:Play()
            for n_2 = 1, #self.middleImages do
                self.middleImageFadeTweens[n_2] =
                    tween_service:Create(self.middleImages[n_2], tween_info, { ImageTransparency = values[n_2] })
                self.middleImageFadeTweens[n_2]:Play()
            end
        else
            self.startImageFadeTween = tween_service:Create(self.startImage, tween_info, { ImageTransparency = 1 })
            self.startImageFadeTween:Play()
            self.endImageFadeTween = tween_service:Create(self.endImage, tween_info, { ImageTransparency = 1 })
            self.endImageFadeTween:Play()
            for n_3 = 1, #self.middleImages do
                self.middleImageFadeTweens[n_3] =
                    tween_service:Create(self.middleImages[n_3], tween_info, { ImageTransparency = 1 })
                self.middleImageFadeTweens[n_3]:Play()
            end
        end
    end
end

function dynamic_thumbstick.FadeThumbstickFrame(self, argument, fade_in_and_out_balance)
    self.fadeInAndOutHalfDuration = argument * 0.5
    self.fadeInAndOutBalance = fade_in_and_out_balance
    self.tweenInAlphaStart = tick()
end

function dynamic_thumbstick.InputInFrame(self, argument)
    local absolute_position = self.thumbstickFrame.AbsolutePosition
    local absolute_position_offset = absolute_position + self.thumbstickFrame.AbsoluteSize
    local position = argument.Position
    if
        absolute_position.X <= position.X
        and absolute_position.Y <= position.Y
        and position.X <= absolute_position_offset.X
        and position.Y <= absolute_position_offset.Y
    then
        return true
    end
    return false
end

function dynamic_thumbstick.DoFadeInBackground(self)
    local player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")
    local enabled = false
    if player_gui then
        if
            player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft
            or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
        then
            enabled = self.hasFadedBackgroundInLandscape
            self.hasFadedBackgroundInLandscape = true
        elseif player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            enabled = self.hasFadedBackgroundInPortrait
            self.hasFadedBackgroundInPortrait = true
        end
    end
    if enabled then
        return
    end
    self.fadeInAndOutHalfDuration = 0.3
    self.fadeInAndOutBalance = 0.5
    self.tweenInAlphaStart = tick()
end

function dynamic_thumbstick.DoMove(self, vector)
    local move_vector = nil
    if vector.Magnitude < self.radiusOfDeadZone then
        move_vector = Vector3.new(0, 0, 0)
    else
        vector = move_vector.Unit
            * (1 - math.max(0, (self.radiusOfMaxSpeed - move_vector.Magnitude) / self.radiusOfMaxSpeed))
        move_vector = Vector3.new(move_vector.X, 0, move_vector.Y)
    end
    self.moveVector = move_vector
end

function dynamic_thumbstick.LayoutMiddleImages(self, argument, argument_2)
    local thumbstick_size_offset_offset = self.thumbstickSize / 2 + self.middleSize
    local vector = argument_2 - argument
    local magnitude_offset_offset = vector.Magnitude - (self.thumbstickRingSize / 2) - self.middleSize
    local unit = vector.Unit
    local middle_spacing = (
        (self.middleSpacing * values_count < magnitude_offset_offset) and (magnitude_offset_offset / values_count)
    ) or self.middleSpacing
    for n = 1, values_count do
        local middle_image_entry = self.middleImages[n]
        local thumbstick_size_offset_offset_offset = thumbstick_size_offset_offset + middle_spacing * (n - 1)
        if thumbstick_size_offset_offset + (middle_spacing * (n - 2)) < magnitude_offset_offset then
            local argument_offset = argument_2 - unit * thumbstick_size_offset_offset_offset
            local clamped_value = math.clamp(
                1 - ((thumbstick_size_offset_offset_offset - magnitude_offset_offset) / middle_spacing),
                0,
                1
            )
            middle_image_entry.Visible = true
            middle_image_entry.Position = UDim2.new(0, argument_offset.X, 0, argument_offset.Y)
            middle_image_entry.Size = UDim2.new(0, self.middleSize * clamped_value, 0, self.middleSize * clamped_value)
        else
            middle_image_entry.Visible = false
        end
    end
end

function dynamic_thumbstick.MoveStick(self, argument)
    local vector = Vector2.new(self.moveTouchStartPosition.X, self.moveTouchStartPosition.Y)
    local vector_offset = Vector2.new(argument.X, argument.Y) - self.thumbstickFrame.AbsolutePosition
    self.endImage.Position = UDim2.new(0, vector_offset.X, 0, vector_offset.Y)
    self:LayoutMiddleImages(vector - self.thumbstickFrame.AbsolutePosition, vector_offset)
end

function dynamic_thumbstick.BindContextActions(self)
    local function input_changed(argument)
        if argument ~= self.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end
        if self.moveTouchFirstChanged then
            self.moveTouchFirstChanged = false
            local vector = Vector2.new(
                argument.Position.X - self.thumbstickFrame.AbsolutePosition.X,
                argument.Position.Y - self.thumbstickFrame.AbsolutePosition.Y
            )
            self.startImage.Visible = true
            self.startImage.Position = UDim2.new(0, vector.X, 0, vector.Y)
            self.endImage.Visible = true
            self.endImage.Position = self.startImage.Position
            self:FadeThumbstick(true)
            self:MoveStick(argument.Position)
        end
        self.moveTouchLockedIn = true
        local vector_2 = Vector2.new(
            argument.Position.X - self.moveTouchStartPosition.X,
            argument.Position.Y - self.moveTouchStartPosition.Y
        )
        if math.abs(vector_2.X) > 0 or math.abs(vector_2.Y) > 0 then
            self:DoMove(vector_2)
            self:MoveStick(argument.Position)
        end
        return Enum.ContextActionResult.Sink
    end
    local function input_ended(argument)
        if argument == self.moveTouchObject then
            self:OnInputEnded()
            if self.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end
    local function input_began(move_touch_object)
        if not self.moveTouchObject and self:InputInFrame(move_touch_object) then
            if self.isFirstTouch then
                self.isFirstTouch = false
                local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
                local tween_properties = {}
                tween_properties.Size = UDim2.new(0, 0, 0, 0)
                tween_service:Create(self.startImage, tween_info_2, tween_properties):Play()
                local tween_properties_2 = {}
                tween_properties_2.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
                tween_properties_2.ImageColor3 = Color3.new(0, 0, 0)
                tween_service:Create(self.endImage, tween_info_2, tween_properties_2):Play()
            end
            self.moveTouchLockedIn = false
            self.moveTouchObject = move_touch_object
            self.moveTouchStartPosition = move_touch_object.Position
            self.moveTouchFirstChanged = true
            self:DoFadeInBackground()
        end
        return Enum.ContextActionResult.Pass
    end
    local function handle_input(argument, argument_2, move_touch_object)
        if argument_2 == Enum.UserInputState.Begin then
            return (input_began(move_touch_object))
        elseif argument_2 == Enum.UserInputState.Change then
            if success_2 then
                if move_touch_object ~= self.moveTouchObject then
                    return Enum.ContextActionResult.Pass
                end
                return Enum.ContextActionResult.Sink
            end
            return (input_changed(move_touch_object))
        elseif argument_2 == Enum.UserInputState.End then
            if move_touch_object == self.moveTouchObject then
                self:OnInputEnded()
                if self.moveTouchLockedIn then
                    return Enum.ContextActionResult.Sink
                end
            end
            return Enum.ContextActionResult.Pass
        elseif argument_2 == Enum.UserInputState.Cancel then
            self:OnInputEnded()
        end
    end
    context_action_service:BindActionAtPriority(
        "DynamicThumbstickAction",
        handle_input,
        false,
        value,
        Enum.UserInputType.Touch
    )
    if not success_2 then
        return
    end
    self.TouchMovedCon = user_input_service.TouchMoved:Connect(function(argument, argument_2)
        input_changed(argument)
    end)
end

function dynamic_thumbstick.UnbindContextActions(self)
    context_action_service:UnbindAction("DynamicThumbstickAction")
    if not self.TouchMovedCon then
        return
    end
    self.TouchMovedCon:Disconnect()
end

function dynamic_thumbstick.Create(self, parent)
    if self.thumbstickFrame then
        self.thumbstickFrame:Destroy()
        self.thumbstickFrame = nil
        if self.onRenderSteppedConn then
            self.onRenderSteppedConn:Disconnect()
            self.onRenderSteppedConn = nil
        end
        if self.absoluteSizeChangedConn then
            self.absoluteSizeChangedConn:Disconnect()
            self.absoluteSizeChangedConn = nil
        end
    end
    local control_size = (pcall_result_2 and 100) or 0
    self.thumbstickFrame = Instance.new("Frame")
    self.thumbstickFrame.BorderSizePixel = 0
    self.thumbstickFrame.Name = "DynamicThumbstickFrame"
    self.thumbstickFrame.Visible = false
    self.thumbstickFrame.BackgroundTransparency = 1
    self.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.thumbstickFrame.Active = false
    self.thumbstickFrame.Size = UDim2.new(0.4, control_size, 0.6666666666666666, control_size)
    self.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.3333333333333333, 0)
    self.startImage = Instance.new("ImageLabel")
    self.startImage.Name = "ThumbstickStart"
    self.startImage.Visible = true
    self.startImage.BackgroundTransparency = 1
    self.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.startImage.ImageRectOffset = Vector2.new(1, 1)
    self.startImage.ImageRectSize = Vector2.new(144, 144)
    self.startImage.ImageColor3 = Color3.new(0, 0, 0)
    self.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    self.startImage.ZIndex = 10
    self.startImage.Parent = self.thumbstickFrame
    self.endImage = Instance.new("ImageLabel")
    self.endImage.Name = "ThumbstickEnd"
    self.endImage.Visible = true
    self.endImage.BackgroundTransparency = 1
    self.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.endImage.ImageRectOffset = Vector2.new(1, 1)
    self.endImage.ImageRectSize = Vector2.new(144, 144)
    self.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    self.endImage.ZIndex = 10
    self.endImage.Parent = self.thumbstickFrame
    for n = 1, values_count do
        self.middleImages[n] = Instance.new("ImageLabel")
        self.middleImages[n].Name = "ThumbstickMiddle"
        self.middleImages[n].Visible = false
        self.middleImages[n].BackgroundTransparency = 1
        self.middleImages[n].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        self.middleImages[n].ImageRectOffset = Vector2.new(1, 1)
        self.middleImages[n].ImageRectSize = Vector2.new(144, 144)
        self.middleImages[n].ImageTransparency = values[n]
        self.middleImages[n].AnchorPoint = Vector2.new(0.5, 0.5)
        self.middleImages[n].ZIndex = 9
        self.middleImages[n].Parent = self.thumbstickFrame
    end
    local function resize_thumbstick()
        local absolute_size = parent.AbsoluteSize
        local is_minimum = math.min(absolute_size.X, absolute_size.Y) > 500
        if is_minimum then
            self.thumbstickSize = 90
            self.thumbstickRingSize = 40
            self.middleSize = 20
            self.middleSpacing = 28
            self.radiusOfDeadZone = 4
            self.radiusOfMaxSpeed = 40
        else
            self.thumbstickSize = 45
            self.thumbstickRingSize = 20
            self.middleSize = 10
            self.middleSpacing = 14
            self.radiusOfDeadZone = 2
            self.radiusOfMaxSpeed = 20
        end
        self.startImage.Position = UDim2.new(
            0,
            (self.thumbstickRingSize * 3.3) + control_size,
            1,
            (-self.thumbstickRingSize * 2.8) - control_size
        )
        self.startImage.Size = UDim2.new(0, self.thumbstickRingSize * 3.7, 0, self.thumbstickRingSize * 3.7)
        self.endImage.Position = self.startImage.Position
        self.endImage.Size = UDim2.new(0, self.thumbstickSize * 0.8, 0, self.thumbstickSize * 0.8)
    end
    resize_thumbstick()
    self.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_thumbstick)
    local connection_2 = nil
    local function layout_thumbstick_frame(argument)
        if argument then
            self.thumbstickFrame.Size = UDim2.new(1, control_size, 0.4, control_size)
            self.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.6, 0)
        else
            self.thumbstickFrame.Size = UDim2.new(0.4, control_size, 0.6666666666666666, control_size)
            self.thumbstickFrame.Position = UDim2.new(0, -control_size, 0.3333333333333333, 0)
        end
    end
    local function on_current_camera_changed()
        if connection_2 then
            connection_2:Disconnect()
            connection_2 = nil
        end
        local current_camera = workspace.CurrentCamera
        if current_camera then
            local function on_viewport_size_changed()
                local viewport_size_2 = current_camera.ViewportSize
                layout_thumbstick_frame(viewport_size_2.X < viewport_size_2.Y)
            end
            connection_2 = current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(on_viewport_size_changed)
            local viewport_size = current_camera.ViewportSize
            layout_thumbstick_frame(viewport_size.X < viewport_size.Y)
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(on_current_camera_changed)
    if workspace.CurrentCamera then
        on_current_camera_changed()
    end
    self.moveTouchStartPosition = nil
    self.startImageFadeTween = nil
    self.endImageFadeTween = nil
    self.middleImageFadeTweens = {}
    self.onRenderSteppedConn = run_service.RenderStepped:Connect(function()
        if self.tweenInAlphaStart == nil then
            if self.tweenOutAlphaStart ~= nil then
                local timestamp_offset = tick() - self.tweenOutAlphaStart
                local fade_in_and_out_half_duration_offset_offset = self.fadeInAndOutHalfDuration * 2
                    - (self.fadeInAndOutHalfDuration * 2) * self.fadeInAndOutBalance
                self.thumbstickFrame.BackgroundTransparency = (
                    math.min(timestamp_offset / fade_in_and_out_half_duration_offset_offset, 1) * 0.35
                ) + 0.65
                if not (fade_in_and_out_half_duration_offset_offset < timestamp_offset) then
                    return
                end
                self.tweenOutAlphaStart = nil
            end
        else
            local timestamp_offset_2 = tick() - self.tweenInAlphaStart
            local fade_in_and_out_half_duration_offset_offset_2 = self.fadeInAndOutHalfDuration
                * 2
                * self.fadeInAndOutBalance
            self.thumbstickFrame.BackgroundTransparency = 1
                - (math.min(timestamp_offset_2 / fade_in_and_out_half_duration_offset_offset_2, 1) * 0.35)
            if not (fade_in_and_out_half_duration_offset_offset_2 < timestamp_offset_2) then
                return
            end
            self.tweenOutAlphaStart = tick()
            self.tweenInAlphaStart = nil
        end
    end)
    self.onTouchEndedConn = user_input_service.TouchEnded:connect(function(argument)
        if argument ~= self.moveTouchObject then
            return
        end
        self:OnInputEnded()
    end)
    gui_service.MenuOpened:connect(function()
        if not self.moveTouchObject then
            return
        end
        self:OnInputEnded()
    end)
    local player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")
    while not player_gui do
        pcall_result.ChildAdded:wait()
        player_gui = pcall_result:FindFirstChildOfClass("PlayerGui")
    end
    local value_4 = nil
    local enabled = true
    local value_5 = nil
    if value_5.CurrentScreenOrientation ~= Enum.ScreenOrientation.LandscapeLeft then
        enabled = value_5.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
    end
    local function long_show_background()
        self.fadeInAndOutHalfDuration = 2.5
        self.fadeInAndOutBalance = 0.05
        self.tweenInAlphaStart = tick()
    end
    local connection = value_5:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
        if
            (not enabled or player_gui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait)
            and (enabled or player_gui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)
        then
            return
        end
        value_4:disconnect()
        self.fadeInAndOutHalfDuration = 2.5
        self.fadeInAndOutBalance = 0.05
        self.tweenInAlphaStart = tick()
        if enabled then
            self.hasFadedBackgroundInPortrait = true
        else
            self.hasFadedBackgroundInLandscape = true
        end
    end)
    value_4 = connection
    self.thumbstickFrame.Parent = parent
    if game:IsLoaded() then
        self.fadeInAndOutHalfDuration = 2.5
        self.fadeInAndOutBalance = 0.05
        self.tweenInAlphaStart = tick()
    else
        coroutine.wrap(function()
            game.Loaded:Wait()
            self.fadeInAndOutHalfDuration = 2.5
            self.fadeInAndOutBalance = 0.05
            self.tweenInAlphaStart = tick()
        end)()
    end
end

return dynamic_thumbstick
