--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/MouseLockController
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local FlagUtil_1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local Value_upv_1 = Enum.ContextActionPriority.Medium.Value
local Players_upv_1 = game:GetService("Players")
local ContextActionService_upv_1 = game:GetService("ContextActionService")
local GameSettings_upv_1 = UserSettings().GameSettings
local CameraUtils_upv_1 = require(script.Parent:WaitForChild("CameraUtils"))
local u1 = FlagUtil_1.getUserFlag("UserFixCameraOffsetJitter2")
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 32
      upvalues:
        tbl_upv_1 (copy, index: 1)
        GameSettings_upv_1 (copy, index: 2)
        Players_upv_1 (copy, index: 3)
    ]]
    local u2 = setmetatable({}, tbl_upv_1)
    u2.isMouseLocked = false
    u2.savedMouseCursor = nil
    u2.boundKeys = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift}
    u2.mouseLockToggledEvent = Instance.new("BindableEvent")
    local v1 = script:FindFirstChild("BoundKeys")
    if not (v1) or not (v1:IsA("StringValue")) then
        if v1 then
            v1:Destroy()
        end
        v1 = Instance.new("StringValue")
        assert(v1, "")
        v1.Name = "BoundKeys"
        v1.Value = "LeftShift,RightShift"
        v1.Parent = script
    end
    if v1 then
        v1.Changed:Connect(
            function(a1)
                --[[
                  line: 57
                  upvalues:
                    u2 (copy, index: 1)
                ]]
                u2:OnBoundKeysObjectChanged(a1)
            end
        )
        u2:OnBoundKeysObjectChanged(v1.Value)
    end
    GameSettings_upv_1.Changed:Connect(
        function(a2)
            --[[
              line: 64
              upvalues:
                u2 (copy, index: 1)
            ]]
            if a2 ~= "ControlMode" and a2 ~= "ComputerMovementMode" then
                return
            end
            u2:UpdateMouseLockAvailability()
        end
    )
    Players_upv_1.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(
        function()
            --[[
              line: 71
              upvalues:
                u2 (copy, index: 1)
            ]]
            u2:UpdateMouseLockAvailability()
        end
    )
    Players_upv_1.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(
        function()
            --[[
              line: 76
              upvalues:
                u2 (copy, index: 1)
            ]]
            u2:UpdateMouseLockAvailability()
        end
    )
    u2:UpdateMouseLockAvailability()
    return u2
end
function tbl_upv_1.GetIsMouseLocked(a1)
    --[[
      name: GetIsMouseLocked
      line: 85
    ]]
    return a1.isMouseLocked
end
function tbl_upv_1.GetBindableToggleEvent(a1)
    --[[
      name: GetBindableToggleEvent
      line: 89
    ]]
    return a1.mouseLockToggledEvent.Event
end
function tbl_upv_1.GetMouseLockOffset(a1)
    --[[
      name: GetMouseLockOffset
      line: 93
      upvalues:
        u1 (copy, index: 1)
    ]]
    if u1 then
        return Vector3.new(1.75, 0, 0)
    end
    local CameraOffset_1 = script:FindFirstChild("CameraOffset")
    if CameraOffset_1 and CameraOffset_1:IsA("Vector3Value") then
        return CameraOffset_1.Value
    end
    if CameraOffset_1 then
        CameraOffset_1:Destroy()
    end
    local v2 = Instance.new("Vector3Value")
    assert(v2, "")
    v2.Name = "CameraOffset"
    v2.Value = Vector3.new(1.75, 0, 0)
    v2.Parent = script
    if v2 and v2.Value then
        return v2.Value
    end
    return Vector3.new(1.75, 0, 0)
end
function tbl_upv_1.UpdateMouseLockAvailability(a1)
    --[[
      name: UpdateMouseLockAvailability
      line: 120
      upvalues:
        Players_upv_1 (copy, index: 1)
        GameSettings_upv_1 (copy, index: 2)
    ]]
    local DevEnableMouseLock_1 = Players_upv_1.LocalPlayer.DevEnableMouseLock
    local v3 = Players_upv_1.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v4 = GameSettings_upv_1.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v5 = DevEnableMouseLock_1 and (v4 and (GameSettings_upv_1.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and (not v3)))
    if v5 == a1.enabled then
        return
    end
    a1:EnableMouseLock(v5)
end
function tbl_upv_1.OnBoundKeysObjectChanged(a1, a2)
    --[[
      name: OnBoundKeysObjectChanged
      line: 132
    ]]
    a1.boundKeys = {}
    for key_1 in string.gmatch(a2, "[^%s,]+") do
        for _, value_1 in pairs(Enum.KeyCode:GetEnumItems()) do
            if key_1 == value_1.Name then
                a1.boundKeys[#a1.boundKeys + 1] = value_1
                break
            end
        end
    end
    a1:UnbindContextActions()
    a1:BindContextActions()
end
function tbl_upv_1.OnMouseLockToggled(a1)
    --[[
      name: OnMouseLockToggled
      line: 147
      upvalues:
        CameraUtils_upv_1 (copy, index: 1)
    ]]
    a1.isMouseLocked = not a1.isMouseLocked
    local v6 = nil
    if a1.isMouseLocked then
        v6 = script:FindFirstChild("CursorImage")
        if v6 and v6:IsA("StringValue") and v6.Value then
            CameraUtils_upv_1.setMouseIconOverride(v6.Value)
        else
            if v6 then
                v6:Destroy()
            end
            local v7 = Instance.new("StringValue")
            assert(v7, "")
            v7.Name = "CursorImage"
            v7.Value = "rbxasset://textures/MouseLockedCursor.png"
            v7.Parent = script
            CameraUtils_upv_1.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        end
    else
        CameraUtils_upv_1.restoreMouseIcon()
    end
    a1.mouseLockToggledEvent:Fire()
end
function tbl_upv_1.DoMouseLockSwitch(a1, a2, a3, a4)
    --[[
      name: DoMouseLockSwitch
      line: 172
    ]]
    if a3 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end
    a1:OnMouseLockToggled()
    return Enum.ContextActionResult.Sink
end
function tbl_upv_1.BindContextActions(a1)
    --[[
      name: BindContextActions
      line: 180
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
        Value_upv_1 (copy, index: 2)
    ]]
    ContextActionService_upv_1:BindActionAtPriority(
        "MouseLockSwitchAction",
        function(a2, a3, a4)
            --[[
              line: 181
              upvalues:
                a1 (copy, index: 1)
            ]]
            return a1:DoMouseLockSwitch(a2, a3, a4)
        end,
        false,
        Value_upv_1,
        unpack(a1.boundKeys)
    )
end
function tbl_upv_1.UnbindContextActions(a1)
    --[[
      name: UnbindContextActions
      line: 186
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    ContextActionService_upv_1:UnbindAction("MouseLockSwitchAction")
end
function tbl_upv_1.IsMouseLocked(a1)
    --[[
      name: IsMouseLocked
      line: 190
    ]]
    return a1.enabled and (a1.isMouseLocked)
end
function tbl_upv_1.EnableMouseLock(a1, a2)
    --[[
      name: EnableMouseLock
      line: 194
      upvalues:
        CameraUtils_upv_1 (copy, index: 1)
    ]]
    if a2 == a1.enabled then
        return
    end
    a1.enabled = a2
    if a1.enabled then
        a1:BindContextActions()
    else
        CameraUtils_upv_1.restoreMouseIcon()
        a1:UnbindContextActions()
        if a1.isMouseLocked then
            a1.mouseLockToggledEvent:Fire()
        end
        a1.isMouseLocked = false
    end
end
return tbl_upv_1