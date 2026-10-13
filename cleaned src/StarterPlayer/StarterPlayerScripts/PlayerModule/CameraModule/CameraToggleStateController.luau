local _ = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_ui = require(script.Parent:WaitForChild("CameraUI"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local enabled = false
local timestamp = tick()
local enabled_2 = false
local enabled_3 = false
local enabled_4 = false
camera_ui.setCameraModeToastEnabled(false)

local camera_toggle_state_controller = function(argument)
    local get_toggle_pan_result = camera_input.getTogglePan()
    if argument and get_toggle_pan_result ~= enabled then
        enabled_2 = true
    end
    if enabled ~= get_toggle_pan_result or tick() - timestamp > 3 then
        local is_timestamp_offset = get_toggle_pan_result and tick() - timestamp < 3
        camera_ui.setCameraModeToastOpen(is_timestamp_offset)
        if get_toggle_pan_result then
            enabled_2 = false
        end
        timestamp = tick()
        enabled = get_toggle_pan_result
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
        else
            camera_utils.restoreMouseIcon()
            camera_utils.restoreMouseBehavior()
        end
        camera_utils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
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

return camera_toggle_state_controller
