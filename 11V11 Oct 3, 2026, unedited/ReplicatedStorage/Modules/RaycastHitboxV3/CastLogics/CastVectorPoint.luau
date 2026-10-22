--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/CastLogics/CastVectorPoint
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
local Debugger_upv_1 = require(script.Parent.Debug.Debugger)
function tbl_1.solve(a1, a2, a3)
    --[[
      name: solve
      line: 4
      upvalues:
        Debugger_upv_1 (copy, index: 1)
    ]]
    local v1 = a2.RelativePart.Position + a2.RelativePart.CFrame:VectorToWorldSpace(a2.Attachment)
    if not (a2.LastPosition) then
        a2.LastPosition = v1
    end
    if a3 then
        Debugger_upv_1(v1 - a2.LastPosition, CFrame.new(v1, a2.LastPosition))
    end
    local LastPosition_1 = a2.LastPosition
    local v2 = ((a2.LastPosition) and (a2.LastPosition)) or (Vector3.new())
    return LastPosition_1, v1 - v2, v1
end
function tbl_1.lastPosition(a1, a2, a3)
    --[[
      name: lastPosition
      line: 17
    ]]
    a2.LastPosition = a3
end
return tbl_1