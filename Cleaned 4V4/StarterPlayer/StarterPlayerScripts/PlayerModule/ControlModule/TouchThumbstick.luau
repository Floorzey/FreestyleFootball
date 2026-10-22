local _ = game:GetService("Players")
local gui_service = game:GetService("GuiService")
local user_input_service = game:GetService("UserInputService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClampClassicThumbstick")
end)
local value_2 = success and value
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

function touch_thumbstick.Enable(argument, enabled, target)
    if enabled == nil then
        return false
    elseif argument.enabled ~= enabled then
        argument.moveVector = Vector3.new(0, 0, 0)
        argument.isJumping = false

        if enabled then
            if not argument.thumbstickFrame then
                argument:Create(target)
            end

            argument.thumbstickFrame.Visible = true
        else
            argument.thumbstickFrame.Visible = false
            argument:OnInputEnded()
        end

        argument.enabled = enabled
    else
        return true
    end
end

function touch_thumbstick.OnInputEnded(argument)
    argument.thumbstickFrame.Position = argument.screenPos
    argument.stickImage.Position = UDim2.new(
        0,
        (argument.thumbstickFrame.Size.X.Offset / 2) - (argument.thumbstickSize / 4),
        0,
        (argument.thumbstickFrame.Size.Y.Offset / 2) - (argument.thumbstickSize / 4)
    )
    argument.moveVector = Vector3.new(0, 0, 0)
    argument.isJumping = false
    argument.thumbstickFrame.Position = argument.screenPos
    argument.moveTouchObject = nil
end

function touch_thumbstick.Create(argument, parent)
    if argument.thumbstickFrame then
        argument.thumbstickFrame:Destroy()
        argument.thumbstickFrame = nil

        if argument.onTouchMovedConn then
            argument.onTouchMovedConn:Disconnect()
            argument.onTouchMovedConn = nil
        end

        if argument.onTouchEndedConn then
            argument.onTouchEndedConn:Disconnect()
            argument.onTouchEndedConn = nil
        end

        if argument.absoluteSizeChangedConn then
            argument.absoluteSizeChangedConn:Disconnect()
            argument.absoluteSizeChangedConn = nil
        end
    end

    argument.thumbstickFrame = Instance.new("Frame")
    argument.thumbstickFrame.Name = "ThumbstickFrame"
    argument.thumbstickFrame.Active = true
    argument.thumbstickFrame.Visible = false
    argument.thumbstickFrame.BackgroundTransparency = 1
    local outer_image = Instance.new("ImageLabel")
    outer_image.Name = "OuterImage"
    outer_image.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    outer_image.ImageRectOffset = Vector2.new()
    outer_image.ImageRectSize = Vector2.new(220, 220)
    outer_image.BackgroundTransparency = 1
    outer_image.Position = UDim2.new(0, 0, 0, 0)
    argument.stickImage = Instance.new("ImageLabel")
    argument.stickImage.Name = "StickImage"
    argument.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    argument.stickImage.ImageRectOffset = Vector2.new(220, 0)
    argument.stickImage.ImageRectSize = Vector2.new(111, 111)
    argument.stickImage.BackgroundTransparency = 1
    argument.stickImage.ZIndex = 2

    local function resize_thumbstick()
        local condition = math.min(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) <= 500
        local thumbstick_size

        if condition then
            thumbstick_size = 70
        else
            thumbstick_size = 120
        end

        argument.thumbstickSize = thumbstick_size
        thumbstick_size = (
            condition and UDim2.new(0, (argument.thumbstickSize / 2) - 10, 1, -argument.thumbstickSize - 20)
        ) or UDim2.new(0, argument.thumbstickSize / 2, 1, -argument.thumbstickSize * 1.75)
        argument.screenPos = thumbstick_size
        argument.thumbstickFrame.Size = UDim2.new(0, argument.thumbstickSize, 0, argument.thumbstickSize)
        argument.thumbstickFrame.Position = argument.screenPos
        outer_image.Size = UDim2.new(0, argument.thumbstickSize, 0, argument.thumbstickSize)
        argument.stickImage.Size = UDim2.new(0, argument.thumbstickSize / 2, 0, argument.thumbstickSize / 2)
        argument.stickImage.Position = UDim2.new(
            0,
            (argument.thumbstickSize / 2) - (argument.thumbstickSize / 4),
            0,
            (argument.thumbstickSize / 2) - (argument.thumbstickSize / 4)
        )
    end

    resize_thumbstick()
    argument.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_thumbstick)
    outer_image.Parent = argument.thumbstickFrame
    argument.stickImage.Parent = argument.thumbstickFrame
    local value_3 = nil

    local function do_move(argument_2)
        local move_vector = argument_2 / (argument.thumbstickSize / 2)
        local magnitude = move_vector.magnitude

        if magnitude < 0.05 then
            move_vector = Vector3.new()
        else
            move_vector = value_2 and move_vector.unit * math.min(1, (magnitude - 0.05) / 0.95)
                or move_vector.unit * ((magnitude - 0.05) / 0.95)
            move_vector = Vector3.new(move_vector.X, 0, move_vector.Y)
        end

        argument.moveVector = move_vector
    end

    local function move_stick(argument_2)
        local vector = Vector2.new(argument_2.X - value_3.X, argument_2.Y - value_3.Y)
        local magnitude = vector.magnitude
        local quotient = argument.thumbstickFrame.AbsoluteSize.X / 2

        if argument.isFollowStick and (quotient < magnitude) then
            local product = vector.unit * quotient
            argument.thumbstickFrame.Position = UDim2.new(
                0,
                (argument_2.X - (argument.thumbstickFrame.AbsoluteSize.X / 2)) - product.X,
                0,
                (argument_2.Y - (argument.thumbstickFrame.AbsoluteSize.Y / 2)) - product.Y
            )
        else
            vector = vector.unit * math.min(magnitude, quotient)
        end

        argument.stickImage.Position = UDim2.new(
            0,
            vector.X + (argument.stickImage.AbsoluteSize.X / 2),
            0,
            vector.Y + (argument.stickImage.AbsoluteSize.Y / 2)
        )
    end

    argument.thumbstickFrame.InputBegan:Connect(function(input)
        if argument.moveTouchObject or input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if input.UserInputState ~= Enum.UserInputState.Begin then
            return
        end

        argument.moveTouchObject = input
        argument.thumbstickFrame.Position = UDim2.new(
            0,
            input.Position.X - (argument.thumbstickFrame.Size.X.Offset / 2),
            0,
            input.Position.Y - (argument.thumbstickFrame.Size.Y.Offset / 2)
        )
        value_3 = Vector2.new(
            argument.thumbstickFrame.AbsolutePosition.X + (argument.thumbstickFrame.AbsoluteSize.X / 2),
            argument.thumbstickFrame.AbsolutePosition.Y + (argument.thumbstickFrame.AbsoluteSize.Y / 2)
        )
        local _ = Vector2.new(input.Position.X - value_3.X, input.Position.Y - value_3.Y)
    end)

    argument.onTouchMovedConn = user_input_service.TouchMoved:Connect(function(argument_2, argument_3)
        if argument_2 ~= argument.moveTouchObject then
            return
        end

        value_3 = Vector2.new(
            argument.thumbstickFrame.AbsolutePosition.X + (argument.thumbstickFrame.AbsoluteSize.X / 2),
            argument.thumbstickFrame.AbsolutePosition.Y + (argument.thumbstickFrame.AbsoluteSize.Y / 2)
        )
        local move_vector = Vector2.new(argument_2.Position.X - value_3.X, argument_2.Position.Y - value_3.Y)
            / (argument.thumbstickSize / 2)
        local magnitude = move_vector.magnitude

        if magnitude < 0.05 then
            move_vector = Vector3.new()
        else
            move_vector = value_2 and move_vector.unit * math.min(1, (magnitude - 0.05) / 0.95)
                or move_vector.unit * ((magnitude - 0.05) / 0.95)
            move_vector = Vector3.new(move_vector.X, 0, move_vector.Y)
        end

        argument.moveVector = move_vector
        move_stick(argument_2.Position)
    end)
    argument.onTouchEndedConn = user_input_service.TouchEnded:Connect(function(hit, argument_2)
        if hit ~= argument.moveTouchObject then
            return
        end

        argument:OnInputEnded()
    end)

    gui_service.MenuOpened:Connect(function()
        if not argument.moveTouchObject then
            return
        end

        argument:OnInputEnded()
    end)

    argument.thumbstickFrame.Parent = parent
end

return touch_thumbstick
