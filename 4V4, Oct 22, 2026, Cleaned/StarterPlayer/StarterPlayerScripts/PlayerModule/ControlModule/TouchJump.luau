local players = game:GetService("Players")
local gui_service = game:GetService("GuiService")
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local touch_jump = setmetatable({}, base_character_controller)
touch_jump.__index = touch_jump
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
end)
local value_2 = success and value

function touch_jump.new()
    local instance = setmetatable(base_character_controller.new(), touch_jump)
    instance.parentUIFrame = nil
    instance.jumpButton = nil
    instance.characterAddedConn = nil
    instance.humanoidStateEnabledChangedConn = nil
    instance.humanoidJumpPowerConn = nil
    instance.humanoidParentConn = nil
    instance.externallyEnabled = false
    instance.jumpPower = 0
    instance.jumpStateEnabled = true
    instance.isJumping = false
    instance.humanoid = nil

    return instance
end

function touch_jump.EnableButton(argument, argument_2)
    if argument_2 then
        if not argument.jumpButton then
            argument:Create()
        end

        local humanoid = players.LocalPlayer.Character
            and players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if
            not humanoid
            or not argument.externallyEnabled
            or not argument.externallyEnabled
            or not (humanoid.JumpPower > 0)
        then
            return
        end

        argument.jumpButton.Visible = true
    else
        argument.jumpButton.Visible = false

        if value_2 then
            argument.touchObject = nil
        end

        argument.isJumping = false
        argument.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

function touch_jump.UpdateEnabled(argument)
    if argument.jumpPower > 0 and argument.jumpStateEnabled then
        argument:EnableButton(true)
    else
        argument:EnableButton(false)
    end
end

function touch_jump.HumanoidChanged(argument, argument_2)
    local humanoid = players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if argument_2 == "JumpPower" then
        argument.jumpPower = humanoid.JumpPower
        argument:UpdateEnabled()
    elseif argument_2 == "Parent" and not humanoid.Parent then
        argument.humanoidChangeConn:Disconnect()
    end
end

function touch_jump.HumanoidStateEnabledChanged(argument, argument_2, jump_state_enabled)
    if argument_2 ~= Enum.HumanoidStateType.Jumping then
        return
    end

    argument.jumpStateEnabled = jump_state_enabled
    argument:UpdateEnabled()
end

function touch_jump.CharacterAdded(argument, argument_2)
    if argument.humanoidChangeConn then
        argument.humanoidChangeConn:Disconnect()
        argument.humanoidChangeConn = nil
    end

    argument.humanoid = argument_2:FindFirstChildOfClass("Humanoid")

    while not argument.humanoid do
        argument_2.ChildAdded:wait()
        argument.humanoid = argument_2:FindFirstChildOfClass("Humanoid")
    end

    argument.humanoidJumpPowerConn = argument.humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        argument.jumpPower = argument.humanoid.JumpPower
        argument:UpdateEnabled()
    end)
    argument.humanoidParentConn = argument.humanoid:GetPropertyChangedSignal("Parent"):Connect(function()
        if argument.humanoid.Parent then
            return
        end

        argument.humanoidJumpPowerConn:Disconnect()
        argument.humanoidJumpPowerConn = nil
        argument.humanoidParentConn:Disconnect()
        argument.humanoidParentConn = nil
    end)
    argument.humanoidStateEnabledChangedConn = argument.humanoid.StateEnabledChanged:Connect(
        function(argument_3, argument_4)
            argument:HumanoidStateEnabledChanged(argument_3, argument_4)
        end
    )
    argument.jumpPower = argument.humanoid.JumpPower
    argument.jumpStateEnabled = argument.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
    argument:UpdateEnabled()
end

function touch_jump.SetupCharacterAddedFunction(argument)
    argument.characterAddedConn = players.LocalPlayer.CharacterAdded:Connect(function(character)
        argument:CharacterAdded(character)
    end)

    if not players.LocalPlayer.Character then
        return
    end

    argument:CharacterAdded(players.LocalPlayer.Character)
end

function touch_jump.Enable(argument, externally_enabled, parent_ui_frame)
    if parent_ui_frame then
        argument.parentUIFrame = parent_ui_frame
    end

    argument.externallyEnabled = externally_enabled
    argument:EnableButton(externally_enabled)
end

function touch_jump.Create(argument)
    if not argument.parentUIFrame then
        return
    end

    if argument.jumpButton then
        argument.jumpButton:Destroy()
        argument.jumpButton = nil
    end

    if argument.absoluteSizeChangedConn then
        argument.absoluteSizeChangedConn:Disconnect()
        argument.absoluteSizeChangedConn = nil
    end

    argument.jumpButton = Instance.new("ImageButton")
    argument.jumpButton.Name = "JumpButton"
    argument.jumpButton.Visible = false
    argument.jumpButton.BackgroundTransparency = 1
    argument.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    argument.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    argument.jumpButton.ImageRectSize = Vector2.new(144, 144)

    local function resize_jump_button()
        local condition = math.min(argument.parentUIFrame.AbsoluteSize.x, argument.parentUIFrame.AbsoluteSize.y) <= 500
        local control_size

        if condition then
            control_size = 70
        else
            control_size = 120
        end

        argument.jumpButton.Size = UDim2.new(0, control_size, 0, control_size)
        local jump_button = argument.jumpButton
        jump_button.Position = condition and UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size - 20)
            or UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size * 1.75)
    end

    resize_jump_button()
    argument.absoluteSizeChangedConn =
        argument.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_jump_button)
    argument.touchObject = nil

    argument.jumpButton.InputBegan:connect(function(touch_object)
        if
            argument.touchObject
            or touch_object.UserInputType ~= Enum.UserInputType.Touch
            or touch_object.UserInputState ~= Enum.UserInputState.Begin
        then
            return
        end

        argument.touchObject = touch_object
        argument.jumpButton.ImageRectOffset = Vector2.new(146, 146)
        argument.isJumping = true
    end)

    argument.jumpButton.InputEnded:connect(function(argument_2)
        if argument_2 ~= argument.touchObject then
            return
        end

        argument.touchObject = nil
        argument.isJumping = false
        argument.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end)

    gui_service.MenuOpened:connect(function()
        if not argument.touchObject then
            return
        end

        argument.touchObject = nil
        argument.isJumping = false
        argument.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end)

    if not argument.characterAddedConn then
        argument:SetupCharacterAddedFunction()
    end

    argument.jumpButton.Parent = argument.parentUIFrame
end

return touch_jump
