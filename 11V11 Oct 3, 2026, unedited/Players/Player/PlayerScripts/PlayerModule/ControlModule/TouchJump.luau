--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/TouchJump
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local Players_upv_1 = game:GetService("Players")
local GuiService_upv_1 = game:GetService("GuiService")
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u1 = setmetatable({}, BaseCharacterController_upv_1)
u1.__index = u1
local success_1, v1 = pcall(
    function()
        --[[
          line: 21
        ]]
        return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
    end
)
local u2 = success_1 and v1
function u1.new()
    --[[
      name: new
      line: 27
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
    ]]
    local v2 = setmetatable(BaseCharacterController_upv_1.new(), u1)
    v2.parentUIFrame = nil
    v2.jumpButton = nil
    v2.characterAddedConn = nil
    v2.humanoidStateEnabledChangedConn = nil
    v2.humanoidJumpPowerConn = nil
    v2.humanoidParentConn = nil
    v2.externallyEnabled = false
    v2.jumpPower = 0
    v2.jumpStateEnabled = true
    v2.isJumping = false
    v2.humanoid = nil
    return v2
end
function u1.EnableButton(a1, a2)
    --[[
      name: EnableButton
      line: 45
      upvalues:
        Players_upv_1 (copy, index: 1)
        u2 (ref,  index: 2)
    ]]
    if a2 then
        if not (a1.jumpButton) then
            a1:Create()
        end
        local v3 = Players_upv_1.LocalPlayer.Character and (Players_upv_1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
        if not v3 or not a1.externallyEnabled or not a1.externallyEnabled or not (v3.JumpPower > 0) then
            return
        end
        a1.jumpButton.Visible = true
    else
        a1.jumpButton.Visible = false
        if u2 then
            a1.touchObject = nil
        end
        a1.isJumping = false
        a1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end
function u1.UpdateEnabled(a1)
    --[[
      name: UpdateEnabled
      line: 68
    ]]
    if a1.jumpPower > 0 and a1.jumpStateEnabled then
        a1:EnableButton(true)
    else
        a1:EnableButton(false)
    end
end
function u1.HumanoidChanged(a1, a2)
    --[[
      name: HumanoidChanged
      line: 76
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    local v4 = Players_upv_1.LocalPlayer.Character and (Players_upv_1.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    if not v4 then
        return
    end
    if a2 == "JumpPower" then
        a1.jumpPower = v4.JumpPower
        a1:UpdateEnabled()
    elseif a2 == "Parent" and not v4.Parent then
        a1.humanoidChangeConn:Disconnect()
    end
end
function u1.HumanoidStateEnabledChanged(a1, a2, a3)
    --[[
      name: HumanoidStateEnabledChanged
      line: 90
    ]]
    if a2 ~= Enum.HumanoidStateType.Jumping then
        return
    end
    a1.jumpStateEnabled = a3
    a1:UpdateEnabled()
end
function u1.CharacterAdded(a1, a2)
    --[[
      name: CharacterAdded
      line: 97
    ]]
    if a1.humanoidChangeConn then
        a1.humanoidChangeConn:Disconnect()
        a1.humanoidChangeConn = nil
    end
    a1.humanoid = a2:FindFirstChildOfClass("Humanoid")
    while not (a1.humanoid) do
        a2.ChildAdded:wait()
        a1.humanoid = a2:FindFirstChildOfClass("Humanoid")
    end
    a1.humanoidJumpPowerConn = a1.humanoid:GetPropertyChangedSignal("JumpPower"):Connect(
        function()
            --[[
              line: 109
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.jumpPower = a1.humanoid.JumpPower
            a1:UpdateEnabled()
        end
    )
    a1.humanoidParentConn = a1.humanoid:GetPropertyChangedSignal("Parent"):Connect(
        function()
            --[[
              line: 114
              upvalues:
                a1 (copy, index: 1)
            ]]
            if (a1.humanoid.Parent) then
                return
            end
            a1.humanoidJumpPowerConn:Disconnect()
            a1.humanoidJumpPowerConn = nil
            a1.humanoidParentConn:Disconnect()
            a1.humanoidParentConn = nil
        end
    )
    a1.humanoidStateEnabledChangedConn = a1.humanoid.StateEnabledChanged:Connect(
        function(a3, a4)
            --[[
              line: 123
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:HumanoidStateEnabledChanged(a3, a4)
        end
    )
    a1.jumpPower = a1.humanoid.JumpPower
    a1.jumpStateEnabled = a1.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
    a1:UpdateEnabled()
end
function u1.SetupCharacterAddedFunction(a1)
    --[[
      name: SetupCharacterAddedFunction
      line: 132
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    a1.characterAddedConn = Players_upv_1.LocalPlayer.CharacterAdded:Connect(
        function(a2)
            --[[
              line: 133
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:CharacterAdded(a2)
        end
    )
    if not Players_upv_1.LocalPlayer.Character then
        return
    end
    a1:CharacterAdded(Players_upv_1.LocalPlayer.Character)
end
function u1.Enable(a1, a2, a3)
    --[[
      name: Enable
      line: 141
    ]]
    if a3 then
        a1.parentUIFrame = a3
    end
    a1.externallyEnabled = a2
    a1:EnableButton(a2)
end
function u1.Create(a1)
    --[[
      name: Create
      line: 149
      upvalues:
        GuiService_upv_1 (copy, index: 1)
    ]]
    if not a1.parentUIFrame then
        return
    end
    if a1.jumpButton then
        a1.jumpButton:Destroy()
        a1.jumpButton = nil
    end
    if a1.absoluteSizeChangedConn then
        a1.absoluteSizeChangedConn:Disconnect()
        a1.absoluteSizeChangedConn = nil
    end
    a1.jumpButton = Instance.new("ImageButton")
    a1.jumpButton.Name = "JumpButton"
    a1.jumpButton.Visible = false
    a1.jumpButton.BackgroundTransparency = 1
    a1.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    a1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    a1.jumpButton.ImageRectSize = Vector2.new(144, 144)
    local function ResizeJumpButton()
        --[[
          name: ResizeJumpButton
          line: 171
          upvalues:
            a1 (copy, index: 1)
        ]]
        local v5 = math.min(a1.parentUIFrame.AbsoluteSize.x, a1.parentUIFrame.AbsoluteSize.y) <= 500
        local v6
        if v5 then
            v6 = 70
        else
            v6 = 120
        end
        a1.jumpButton.Size = UDim2.new(0, v6, 0, v6)
        local jumpButton_1 = a1.jumpButton
        jumpButton_1.Position = v5 and UDim2.new(1, -((v6 * 1.5) - 10), 1, -v6 - 20) or UDim2.new(1, -((v6 * 1.5) - 10), 1, -v6 * 1.75)
    end
    ResizeJumpButton()
    a1.absoluteSizeChangedConn = a1.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)
    a1.touchObject = nil
    a1.jumpButton.InputBegan:connect(
        function(a2)
            --[[
              line: 186
              upvalues:
                a1 (copy, index: 1)
            ]]
            if (a1.touchObject) or a2.UserInputType ~= Enum.UserInputType.Touch or a2.UserInputState ~= Enum.UserInputState.Begin then
                return
            end
            a1.touchObject = a2
            a1.jumpButton.ImageRectOffset = Vector2.new(146, 146)
            a1.isJumping = true
        end
    )
    a1.jumpButton.InputEnded:connect(
        function(a3)
            --[[
              line: 205
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a3 ~= a1.touchObject then
                return
            end
            a1.touchObject = nil
            a1.isJumping = false
            a1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    )
    GuiService_upv_1.MenuOpened:connect(
        function()
            --[[
              line: 211
              upvalues:
                a1 (copy, index: 1)
            ]]
            if not a1.touchObject then
                return
            end
            a1.touchObject = nil
            a1.isJumping = false
            a1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    )
    if not (a1.characterAddedConn) then
        a1:SetupCharacterAddedFunction()
    end
    a1.jumpButton.Parent = a1.parentUIFrame
end
return u1