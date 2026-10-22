local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local connection_util = require(common_utils:WaitForChild("ConnectionUtil"))
local user_flag = flag_util.getUserFlag("UserUpdateInputConnections")
local vector = Vector3.new()
local base_character_controller = {}
base_character_controller.__index = base_character_controller

function base_character_controller.new()
    local instance = setmetatable({}, base_character_controller)
    instance.enabled = false
    instance.moveVector = vector
    instance.moveVectorIsCameraRelative = true
    instance.isJumping = false

    if user_flag then
        instance._connections = connection_util.new()
    end

    return instance
end

function base_character_controller.OnRenderStepped(argument: table, argument_2: number)
    assert(not user_flag)
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

function base_character_controller.Enable(argument: table, argument_2: boolean)
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")

    return false
end

return base_character_controller
