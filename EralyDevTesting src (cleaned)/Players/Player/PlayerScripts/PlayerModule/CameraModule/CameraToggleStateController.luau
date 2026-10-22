game:GetService("Players")
game:GetService("UserInputService")
UserSettings():GetService("UserGameSettings")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_ui = require(script.Parent:WaitForChild("CameraUI"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local enabled = false
local timestamp = tick()
local enabled_2 = false
local enabled_3 = false
local enabled_4 = false
camera_ui.setCameraModeToastEnabled(false)

return function(argument: boolean)
    local toggle_pan = camera_input.getTogglePan()

    if argument and toggle_pan ~= enabled then
        enabled_2 = true
    end

    if enabled ~= toggle_pan or tick() - timestamp > 3 then
        local condition

        if toggle_pan then
            condition = tick() - timestamp < 3
        else
            condition = toggle_pan
        end

        camera_ui.setCameraModeToastOpen(condition)

        if toggle_pan then
            enabled_2 = false
        end

        timestamp = tick()
        enabled = toggle_pan
    end

    if argument ~= enabled_4 then
        if argument then
            enabled_3 = camera_input.getTogglePan()
            camera_input.setTogglePan(true)
        elseif not enabled_2 then
            camera_input.setTogglePan(enabled_3)
        end
    end

    if argument then
        if camera_input.getTogglePan() then
            camera_utils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
            camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
            camera_utils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        else
            camera_utils.restoreMouseIcon()
            camera_utils.restoreMouseBehavior()
            camera_utils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        end
    elseif camera_input.getTogglePan() then
        camera_utils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
        camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
        camera_utils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
    elseif camera_input.getHoldPan() then
        camera_utils.restoreMouseIcon()
        camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
        camera_utils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
    else
        camera_utils.restoreMouseIcon()
        camera_utils.restoreMouseBehavior()
        camera_utils.restoreRotationType()
    end

    enabled_4 = argument
end
