--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/ControlModule/VehicleController
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local ContextActionService_upv_1 = game:GetService("ContextActionService")
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 27
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.CONTROL_ACTION_PRIORITY = a1
    v1.enabled = false
    v1.vehicleSeat = nil
    v1.throttle = 0
    v1.steer = 0
    v1.acceleration = 0
    v1.decceleration = 0
    v1.turningRight = 0
    v1.turningLeft = 0
    v1.vehicleMoveVector = Vector3.new(0, 0, 0)
    v1.autoPilot = {}
    v1.autoPilot.MaxSpeed = 0
    v1.autoPilot.MaxSteeringAngle = 0
    return v1
end
function tbl_upv_1.BindContextActions(a1)
    --[[
      name: BindContextActions
      line: 51
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    ContextActionService_upv_1:BindActionAtPriority(
        "throttleAccel",
        function(a2, a3, a4)
            --[[
              line: 53
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnThrottleAccel(a2, a3, a4)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.KeyCode.ButtonR2
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "throttleDeccel",
        function(a5, a6, a7)
            --[[
              line: 57
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnThrottleDeccel(a5, a6, a7)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.KeyCode.ButtonL2
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "arrowSteerRight",
        function(a8, a9, a10)
            --[[
              line: 62
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnSteerRight(a8, a9, a10)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.KeyCode.Right
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "arrowSteerLeft",
        function(a11, a12, a13)
            --[[
              line: 66
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnSteerLeft(a11, a12, a13)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.KeyCode.Left
    )
end
function tbl_upv_1.Enable(a1, a2, a3)
    --[[
      name: Enable
      line: 72
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    if a2 ~= a1.enabled or a3 ~= a1.vehicleSeat then
        a1.enabled = a2
        a1.vehicleMoveVector = Vector3.new(0, 0, 0)
        if a2 then
            if not a3 then
                return
            end
            a1.vehicleSeat = a3
            a1:SetupAutoPilot()
            a1:BindContextActions()
        else
            ContextActionService_upv_1:UnbindAction("throttleAccel")
            ContextActionService_upv_1:UnbindAction("throttleDeccel")
            ContextActionService_upv_1:UnbindAction("arrowSteerRight")
            ContextActionService_upv_1:UnbindAction("arrowSteerLeft")
            a1.vehicleSeat = nil
        end
    end
end
function tbl_upv_1.OnThrottleAccel(a1, a2, a3, a4)
    --[[
      name: OnThrottleAccel
      line: 98
    ]]
    if a3 == Enum.UserInputState.End or a3 == Enum.UserInputState.Cancel then
        a1.acceleration = 0
    else
        a1.acceleration = -1
    end
    a1.throttle = a1.acceleration + a1.decceleration
end
function tbl_upv_1.OnThrottleDeccel(a1, a2, a3, a4)
    --[[
      name: OnThrottleDeccel
      line: 107
    ]]
    if a3 == Enum.UserInputState.End or a3 == Enum.UserInputState.Cancel then
        a1.decceleration = 0
    else
        a1.decceleration = 1
    end
    a1.throttle = a1.acceleration + a1.decceleration
end
function tbl_upv_1.OnSteerRight(a1, a2, a3, a4)
    --[[
      name: OnSteerRight
      line: 116
    ]]
    if a3 == Enum.UserInputState.End or a3 == Enum.UserInputState.Cancel then
        a1.turningRight = 0
    else
        a1.turningRight = 1
    end
    a1.steer = a1.turningRight + a1.turningLeft
end
function tbl_upv_1.OnSteerLeft(a1, a2, a3, a4)
    --[[
      name: OnSteerLeft
      line: 125
    ]]
    if a3 == Enum.UserInputState.End or a3 == Enum.UserInputState.Cancel then
        a1.turningLeft = 0
    else
        a1.turningLeft = -1
    end
    a1.steer = a1.turningRight + a1.turningLeft
end
function tbl_upv_1.Update(a1, a2, a3, a4)
    --[[
      name: Update
      line: 135
    ]]
    if a1.vehicleSeat then
        if a3 then
            a2 = a2 + Vector3.new(a1.steer, 0, a1.throttle)
            a1.vehicleSeat.ThrottleFloat = -a2.Z
            a1.vehicleSeat.SteerFloat = a2.X
            return a2, true
        else
            local v2 = a1.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(a2)
            a1.vehicleSeat.ThrottleFloat = a1:ComputeThrottle(v2)
            a1.vehicleSeat.SteerFloat = a1:ComputeSteer(v2)
            return Vector3.new(0, 0, 0), true
        end
    else
        return a2, false
    end
end
function tbl_upv_1.ComputeThrottle(a1, a2)
    --[[
      name: ComputeThrottle
      line: 161
    ]]
    if a2 == Vector3.new(0, 0, 0) then
        return 0
    end
    return -a2.Z
end
function tbl_upv_1.ComputeSteer(a1, a2)
    --[[
      name: ComputeSteer
      line: 170
    ]]
    if a2 == Vector3.new(0, 0, 0) then
        return 0
    end
    return -math.atan2(-a2.x, -a2.z) * 57.29577951308232 / a1.autoPilot.MaxSteeringAngle
end
function tbl_upv_1.SetupAutoPilot(a1)
    --[[
      name: SetupAutoPilot
      line: 179
    ]]
    a1.autoPilot.MaxSpeed = a1.vehicleSeat.MaxSpeed
    a1.autoPilot.MaxSteeringAngle = 35
end
return tbl_upv_1