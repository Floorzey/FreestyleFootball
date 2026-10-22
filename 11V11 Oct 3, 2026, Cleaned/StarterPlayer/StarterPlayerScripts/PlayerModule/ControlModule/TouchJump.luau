local players = game:GetService("Players")
local gui_service = game:GetService("GuiService")
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local touch_jump = setmetatable({}, base_character_controller)
touch_jump.__index = touch_jump
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
end)
local success_2 = success and value

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

function touch_jump.EnableButton(self, argument)
    if argument then
        if not self.jumpButton then
            self:Create()
        end
        local humanoid = players.LocalPlayer.Character
            and (players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
        if not humanoid or not self.externallyEnabled or not self.externallyEnabled or not (humanoid.JumpPower > 0) then
            return
        end
        self.jumpButton.Visible = true
    else
        self.jumpButton.Visible = false
        if success_2 then
            self.touchObject = nil
        end
        self.isJumping = false
        self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

function touch_jump.UpdateEnabled(self)
    if self.jumpPower > 0 and self.jumpStateEnabled then
        self:EnableButton(true)
    else
        self:EnableButton(false)
    end
end

function touch_jump.HumanoidChanged(self, argument)
    local humanoid = players.LocalPlayer.Character and (players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    if not humanoid then
        return
    end
    if argument == "JumpPower" then
        self.jumpPower = humanoid.JumpPower
        self:UpdateEnabled()
    elseif argument == "Parent" and not humanoid.Parent then
        self.humanoidChangeConn:Disconnect()
    end
end

function touch_jump.HumanoidStateEnabledChanged(self, argument, jump_state_enabled)
    if argument ~= Enum.HumanoidStateType.Jumping then
        return
    end
    self.jumpStateEnabled = jump_state_enabled
    self:UpdateEnabled()
end

function touch_jump.CharacterAdded(self, argument)
    if self.humanoidChangeConn then
        self.humanoidChangeConn:Disconnect()
        self.humanoidChangeConn = nil
    end
    self.humanoid = argument:FindFirstChildOfClass("Humanoid")
    while not self.humanoid do
        argument.ChildAdded:wait()
        self.humanoid = argument:FindFirstChildOfClass("Humanoid")
    end
    self.humanoidJumpPowerConn = self.humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        self.jumpPower = self.humanoid.JumpPower
        self:UpdateEnabled()
    end)
    self.humanoidParentConn = self.humanoid:GetPropertyChangedSignal("Parent"):Connect(function()
        if self.humanoid.Parent then
            return
        end
        self.humanoidJumpPowerConn:Disconnect()
        self.humanoidJumpPowerConn = nil
        self.humanoidParentConn:Disconnect()
        self.humanoidParentConn = nil
    end)
    self.humanoidStateEnabledChangedConn = self.humanoid.StateEnabledChanged:Connect(function(argument_2, argument_3)
        self:HumanoidStateEnabledChanged(argument_2, argument_3)
    end)
    self.jumpPower = self.humanoid.JumpPower
    self.jumpStateEnabled = self.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
    self:UpdateEnabled()
end

function touch_jump.SetupCharacterAddedFunction(self)
    self.characterAddedConn = players.LocalPlayer.CharacterAdded:Connect(function(character)
        self:CharacterAdded(character)
    end)
    if not players.LocalPlayer.Character then
        return
    end
    self:CharacterAdded(players.LocalPlayer.Character)
end

function touch_jump.Enable(self, externally_enabled, parent_ui_frame)
    if parent_ui_frame then
        self.parentUIFrame = parent_ui_frame
    end
    self.externallyEnabled = externally_enabled
    self:EnableButton(externally_enabled)
end

function touch_jump.Create(self)
    if not self.parentUIFrame then
        return
    end
    if self.jumpButton then
        self.jumpButton:Destroy()
        self.jumpButton = nil
    end
    if self.absoluteSizeChangedConn then
        self.absoluteSizeChangedConn:Disconnect()
        self.absoluteSizeChangedConn = nil
    end
    self.jumpButton = Instance.new("ImageButton")
    self.jumpButton.Name = "JumpButton"
    self.jumpButton.Visible = false
    self.jumpButton.BackgroundTransparency = 1
    self.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    self.jumpButton.ImageRectSize = Vector2.new(144, 144)
    local function resize_jump_button()
        local is_minimum = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y) <= 500
        local control_size
        if is_minimum then
            control_size = 70
        else
            control_size = 120
        end
        self.jumpButton.Size = UDim2.new(0, control_size, 0, control_size)
        local jump_button = self.jumpButton
        jump_button.Position = is_minimum and UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size - 20)
            or UDim2.new(1, -((control_size * 1.5) - 10), 1, -control_size * 1.75)
    end
    resize_jump_button()
    self.absoluteSizeChangedConn =
        self.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize_jump_button)
    self.touchObject = nil
    self.jumpButton.InputBegan:connect(function(touch_object)
        if
            self.touchObject
            or touch_object.UserInputType ~= Enum.UserInputType.Touch
            or touch_object.UserInputState ~= Enum.UserInputState.Begin
        then
            return
        end
        self.touchObject = touch_object
        self.jumpButton.ImageRectOffset = Vector2.new(146, 146)
        self.isJumping = true
    end)
    self.jumpButton.InputEnded:connect(function(argument)
        if argument ~= self.touchObject then
            return
        end
        self.touchObject = nil
        self.isJumping = false
        self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end)
    gui_service.MenuOpened:connect(function()
        if not self.touchObject then
            return
        end
        self.touchObject = nil
        self.isJumping = false
        self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end)
    if not self.characterAddedConn then
        self:SetupCharacterAddedFunction()
    end
    self.jumpButton.Parent = self.parentUIFrame
end

return touch_jump
