--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/ControlModule/BaseCharacterController
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local CommonUtils_1 = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil_1 = require(CommonUtils_1:WaitForChild("FlagUtil"))
local ConnectionUtil_upv_1 = require(CommonUtils_1:WaitForChild("ConnectionUtil"))
local u1 = FlagUtil_1.getUserFlag("UserUpdateInputConnections")
local u2 = Vector3.new()
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 38
      upvalues:
        tbl_upv_1 (copy, index: 1)
        u2 (copy, index: 2)
        u1 (copy, index: 3)
        ConnectionUtil_upv_1 (copy, index: 4)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.enabled = false
    v1.moveVector = u2
    v1.moveVectorIsCameraRelative = true
    v1.isJumping = false
    if u1 then
        v1._connections = ConnectionUtil_upv_1.new()
    end
    return v1
end
function tbl_upv_1.OnRenderStepped(a1, a2)
    --[[
      name: OnRenderStepped
      line: 52
      upvalues:
        u1 (copy, index: 1)
    ]]
    assert(not u1)
end
function tbl_upv_1.GetMoveVector(a1)
    --[[
      name: GetMoveVector
      line: 57
    ]]
    return a1.moveVector
end
function tbl_upv_1.IsMoveVectorCameraRelative(a1)
    --[[
      name: IsMoveVectorCameraRelative
      line: 61
    ]]
    return a1.moveVectorIsCameraRelative
end
function tbl_upv_1.GetIsJumping(a1)
    --[[
      name: GetIsJumping
      line: 65
    ]]
    return a1.isJumping
end
function tbl_upv_1.Enable(a1, a2)
    --[[
      name: Enable
      line: 71
    ]]
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
    return false
end
return tbl_upv_1