--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/History
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 4
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1._currentIndex = 0
    v1.Records = {}
    return v1
end
function tbl_upv_1.WriteHistory(a1, a2)
    --[[
      name: WriteHistory
      line: 12
    ]]
    a1._currentIndex = a1._currentIndex + 1
    if a1._currentIndex < #a1.Records then
        for n_1 = a1._currentIndex + 1, #a1.Records do
            a1.Records[n_1] = nil
        end
    end
    a1.Records[a1._currentIndex] = a2
end
function tbl_upv_1.GetRecord(a1, a2)
    --[[
      name: GetRecord
      line: 23
    ]]
    return a1.Records[a2 or (a1._currentIndex)]
end
function tbl_upv_1.IncrementHistory(a1, a2)
    --[[
      name: IncrementHistory
      line: 27
    ]]
    if not (a1._currentIndex <= 1) or not (a2 < 0) then
        a1._currentIndex = math.clamp(a1._currentIndex + a2, 1, #a1.Records)
        return a1.Records[a1._currentIndex]
    end
end
function tbl_upv_1.ClearHistory(a1)
    --[[
      name: ClearHistory
      line: 34
    ]]
    a1.Records = {}
    a1._currentIndex = 0
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 39
    ]]
    a1:ClearHistory()
end
return tbl_upv_1