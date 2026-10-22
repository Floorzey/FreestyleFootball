local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local connection_util = require(common_utils:WaitForChild("ConnectionUtil"))
local get_user_flag_result = flag_util.getUserFlag("UserUpdateInputConnections")
local vector = Vector3.new()
local base_character_controller = {}
base_character_controller.__index = base_character_controller

function base_character_controller.new()
    local instance = setmetatable({}, base_character_controller)
    instance.enabled = false
    instance.moveVector = vector
    instance.moveVectorIsCameraRelative = true
    instance.isJumping = false

    if get_user_flag_result then
        instance._connections = connection_util.new()
    end

    return instance
end

function base_character_controller.OnRenderStepped(argument, argument_2)
    assert(not get_user_flag_result)
end

function base_character_controller.GetMoveVector(argument)
    return argument.moveVector
end

function base_character_controller.IsMoveVectorCameraRelative(argument)
    return argument.moveVectorIsCameraRelative
end

function base_character_controller.GetIsJumping(argument)
    return argument.isJumping
end

function base_character_controller.Enable(argument, argument_2)
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")

    return false
end

return base_character_controller
