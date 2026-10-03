--[[
    Script Path: Game/ReplicatedStorage/Modules/ScreenRain/ObjectPool
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local u1 = CFrame.new(0, 0, 1e+06)
local tbl_1 = {}
function tbl_1.new(a1, a2)
    --[[
      name: new
      line: 9
      upvalues:
        u1 (copy, index: 1)
    ]]
    local tbl_upv_2 = {}
    tbl_upv_2.Object = a1:Clone()
    tbl_upv_2.Available = {}
    for n_1 = 1, a2 or 1 do
        tbl_upv_2.Available[n_1] = tbl_upv_2.Object:Clone()
    end
    function tbl_upv_2.Get(a3)
        --[[
          name: Get
          line: 19
          upvalues:
            tbl_upv_2 (copy, index: 1)
        ]]
        local v1 = #tbl_upv_2.Available
        local v2 = tbl_upv_2.Available[v1]
        if v2 then
            table.remove(tbl_upv_2.Available, v1)
            return v2
        end
        return tbl_upv_2.Object:Clone()
    end
    function tbl_upv_2.Return(a4, a5)
        --[[
          name: Return
          line: 30
          upvalues:
            u1 (copy, index: 1)
            tbl_upv_2 (copy, index: 2)
        ]]
        a5.CFrame = u1
        table.insert(tbl_upv_2.Available, a5)
    end
    return tbl_upv_2
end
return tbl_1