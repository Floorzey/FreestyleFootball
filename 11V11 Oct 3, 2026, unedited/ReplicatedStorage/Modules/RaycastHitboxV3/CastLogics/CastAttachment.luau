--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/CastLogics/CastAttachment
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
    if not (a2.LastPosition) then
        a2.LastPosition = a2.Attachment.WorldPosition
    end
    if a3 then
        Debugger_upv_1(a2.Attachment.WorldPosition - a2.LastPosition, CFrame.new(a2.Attachment.WorldPosition, a2.LastPosition))
    end
    return a2.LastPosition, a2.Attachment.WorldPosition - a2.LastPosition
end
function tbl_1.lastPosition(a1, a2)
    --[[
      name: lastPosition
      line: 15
    ]]
    a2.LastPosition = a2.Attachment.WorldPosition
end
return tbl_1