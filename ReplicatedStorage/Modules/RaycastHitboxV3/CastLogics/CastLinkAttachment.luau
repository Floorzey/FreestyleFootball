--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/CastLogics/CastLinkAttachment
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
    if a3 then
        Debugger_upv_1(a2.Attachment.WorldPosition - a2.Attachment0.WorldPosition, CFrame.new(a2.Attachment.WorldPosition, a2.Attachment0.WorldPosition))
    end
    return a2.Attachment.WorldPosition, a2.Attachment0.WorldPosition - a2.Attachment.WorldPosition
end
function tbl_1.lastPosition(a1, a2)
    --[[
      name: lastPosition
      line: 12
    ]]
    a2.LastPosition = a2.Attachment.WorldPosition
end
return tbl_1