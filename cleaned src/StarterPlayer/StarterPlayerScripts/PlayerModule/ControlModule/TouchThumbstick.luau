local _ = game:GetService("Players")
local gui_service = game:GetService("GuiService")
local user_input_service = game:GetService("UserInputService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClampClassicThumbstick")
end)
local success_2 = success and value
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local touch_thumbstick = setmetatable({}, base_character_controller)
touch_thumbstick.__index = touch_thumbstick

function touch_thumbstick.new()
    local instance = setmetatable(base_character_controller.new(), touch_thumbstick)
    instance.isFollowStick = false
    instance.thumbstickFrame = nil
    instance.moveTouchObject = nil
    instance.onTouchMovedConn = nil
    instance.onTouchEndedConn = nil
    instance.screenPos = nil
    instance.stickImage = nil
    instance.thumbstickSize = nil
    return instance
end

function touch_thumbstick.Enable(self, enabled, target)
    if enabled == nil then
        return false
    elseif self.enabled ~= enabled then
        self.moveVector = Vector3.new(0, 0, 0)
        self.isJumping = false
        if enabled then
            if not self.thumbstickFrame then
                self:Create(target)
            end
            self.thumbstickFrame.Visible = true
        else
            self.thumbstickFrame.Visible = false
            self:OnInputEnded()
        end
        self.enabled = enabled
    else
        return true
    end
end

function touch_thumbstick.OnInputEnded(self)
    self.thumbstickFrame.Position = self.screenPos
    self.stickImage.Position = UDim2.new(
        0,
        (self.thumbstickFrame.Size.X.Offset / 2) - (self.thumbstickSize / 4),
        0,
        (self.thumbstickFrame.Size.Y.Offset / 2) - (self.thumbstickSize / 4)
    )
    self.moveVector = Vector3.new(0, 0, 0)
    self.isJumping = false
    self.thumbstickFrame.Position = self.screenPos
    self.moveTouchObject = nil
end

function touch_thumbstick.Create(self, parent)
    if self.thumbstickFrame then
        self.thumbstickFrame:Destroy()
        self.thumbstickFrame = nil
        if self.onTouchMovedConn then
            self.onTouchMovedConn:Disconnect()
            self.onTouchMovedConn = nil
        end
        if self.onTouchEndedConn then
            self.onTouchEndedConn:Disconnect()
            self.onTouchEndedConn = nil
        end
        if self.absoluteSizeChangedConn then
            self.absoluteSizeChangedConn:Disconnect()
            self.absoluteSizeChangedConn = nil
        end
    end
    self.thumbstickFrame = Instance.new("Frame")
    self.thumbstickFrame.Name = "ThumbstickFrame"
    self.thumbstickFrame.Active = true
    self.thumbstickFrame.Visible = false
    self.thumbstickFrame.BackgroundTransparency = 1
    local image_label = Instance.new("ImageLabel")
    image_label.Name = "OuterImage"
    image_label.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    image_label.ImageRectOffset = Vector2.new()
    image_label.ImageRectSize = Vector2.new(220, 220)
    image_label.BackgroundTransparency = 1
    image_label.Position = UDim2.new(0, 0, 0, 0)
    self.stickImage = Instance.new("ImageLabel")
    self.stickImage.Name = "StickImage"
    self.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    self.stickImage.ImageRectOffset = Vector2.new(220, 0)
    self.stickImage.ImageRectSize = Vector2.new(111, 111)
    self.stickImage.BackgroundTransparency = 1
    self.stickImage.ZIndex = 2
    local function resize_thumbstick()
        local is_minimum = math.min(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) <= 500
        local thumbstick_size
        if is_minimum then
            thumbstick_size = 70
        else
            thumbstick_size = 120
        end
        self.thumbstickSize = thumbstick_size
        thumbstick_size = (is_minimum and (UDim2.new(0, (self.thumbstickSize / 2) - 10, 1, -self.thumbstickSize - 20)))
            or (UDim2.new(0, self.thumbstickSize / 2, 1, -self.thumbstickSize * 1.75))
        self.screenPos = thumbstick_size
        self.thumbstickFrame.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
        self.thumbstickFrame.Position = self.screenPos
        image_label.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
        self.stickImage.Size = UDim2.new(0, self.thumbstickSize / 2, 0, self.thumbstickSize / 2)
        self.stickImage.Position = UDim2.new(
            0,
            (self.thumbstickSize / 2) - (self.thumbstickSize / 4),
            0,
            (self.thumbstickSize / 2) - (self.thumbstickSize / 4)
        )
    end
    resize_thumbstick()
    self.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_thumbstick)
    image_label.Parent = self.thumbstickFrame
    self.stickImage.Parent = self.thumbstickFrame
    local value_2 = nil
    local function do_move(argument)
        local move_vector = argument / (self.thumbstickSize / 2)
        local magnitude = move_vector.magnitude
        if magnitude < 0.05 then
            move_vector = Vector3.new()
        else
            move_vector = success_2 and move_vector.unit * math.min(1, (magnitude - 0.05) / 0.95)
                or move_vector.unit * ((magnitude - 0.05) / 0.95)
            move_vector = Vector3.new(move_vector.X, 0, move_vector.Y)
        end
        self.moveVector = move_vector
    end
    local function move_stick(argument)
        local vector = Vector2.new(argument.X - value_2.X, argument.Y - value_2.Y)
        local magnitude = vector.magnitude
        local x_offset = self.thumbstickFrame.AbsoluteSize.X / 2
        if self.isFollowStick and (x_offset < magnitude) then
            local unit_offset = vector.unit * x_offset
            self.thumbstickFrame.Position = UDim2.new(
                0,
                (argument.X - (self.thumbstickFrame.AbsoluteSize.X / 2)) - unit_offset.X,
                0,
                (argument.Y - (self.thumbstickFrame.AbsoluteSize.Y / 2)) - unit_offset.Y
            )
        else
            vector = vector.unit * math.min(magnitude, x_offset)
        end
        self.stickImage.Position = UDim2.new(
            0,
            vector.X + (self.stickImage.AbsoluteSize.X / 2),
            0,
            vector.Y + (self.stickImage.AbsoluteSize.Y / 2)
        )
    end
    self.thumbstickFrame.InputBegan:Connect(function(input)
        if self.moveTouchObject or input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if input.UserInputState == Enum.UserInputState.Begin then
            self.moveTouchObject = input
            self.thumbstickFrame.Position = UDim2.new(
                0,
                input.Position.X - (self.thumbstickFrame.Size.X.Offset / 2),
                0,
                input.Position.Y - (self.thumbstickFrame.Size.Y.Offset / 2)
            )
            value_2 = Vector2.new(
                self.thumbstickFrame.AbsolutePosition.X + (self.thumbstickFrame.AbsoluteSize.X / 2),
                self.thumbstickFrame.AbsolutePosition.Y + (self.thumbstickFrame.AbsoluteSize.Y / 2)
            )
            local _ = Vector2.new(input.Position.X - value_2.X, input.Position.Y - value_2.Y)
        end
    end)
    self.onTouchMovedConn = user_input_service.TouchMoved:Connect(function(argument, argument_2)
        if argument == self.moveTouchObject then
            value_2 = Vector2.new(
                self.thumbstickFrame.AbsolutePosition.X + (self.thumbstickFrame.AbsoluteSize.X / 2),
                self.thumbstickFrame.AbsolutePosition.Y + (self.thumbstickFrame.AbsoluteSize.Y / 2)
            )
            local move_vector = Vector2.new(argument.Position.X - value_2.X, argument.Position.Y - value_2.Y)
                / (self.thumbstickSize / 2)
            local magnitude = move_vector.magnitude
            if magnitude < 0.05 then
                move_vector = Vector3.new()
            else
                move_vector = success_2 and move_vector.unit * math.min(1, (magnitude - 0.05) / 0.95)
                    or move_vector.unit * ((magnitude - 0.05) / 0.95)
                move_vector = Vector3.new(move_vector.X, 0, move_vector.Y)
            end
            self.moveVector = move_vector
            move_stick(argument.Position)
        end
    end)
    self.onTouchEndedConn = user_input_service.TouchEnded:Connect(function(hit, argument)
        if hit ~= self.moveTouchObject then
            return
        end
        self:OnInputEnded()
    end)
    gui_service.MenuOpened:Connect(function()
        if not self.moveTouchObject then
            return
        end
        self:OnInputEnded()
    end)
    self.thumbstickFrame.Parent = parent
end

return touch_thumbstick
