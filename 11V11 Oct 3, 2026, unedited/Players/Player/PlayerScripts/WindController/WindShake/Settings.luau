--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController/WindShake/Settings
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_1 = {}
function tbl_1.new(a1, a2)
    --[[
      name: new
      line: 9
    ]]
    local u1 = table.create(3)
    local u2 = a1:GetAttribute("WindPower")
    local u3 = a1:GetAttribute("WindSpeed")
    local u4 = a1:GetAttribute("WindDirection")
    u1.WindPower = typeof(u2) == "number" and u2 or a2.WindPower
    u1.WindSpeed = typeof(u3) == "number" and u3 or a2.WindSpeed
    u1.WindDirection = typeof(u4) == "Vector3" and u4 or a2.WindDirection
    local u5 = a1:GetAttributeChangedSignal("WindPower"):Connect(
        function()
            --[[
              line: 24
              upvalues:
                u2 (ref,  index: 1)
                a1 (copy, index: 2)
                u1 (copy, index: 3)
                a2 (copy, index: 4)
            ]]
            u2 = a1:GetAttribute("WindPower")
            u1.WindPower = typeof(u2) == "number" and u2 or a2.WindPower
        end
    )
    local u6 = a1:GetAttributeChangedSignal("WindSpeed"):Connect(
        function()
            --[[
              line: 29
              upvalues:
                u3 (ref,  index: 1)
                a1 (copy, index: 2)
                u1 (copy, index: 3)
                a2 (copy, index: 4)
            ]]
            u3 = a1:GetAttribute("WindSpeed")
            u1.WindSpeed = typeof(u3) == "number" and u3 or a2.WindSpeed
        end
    )
    local u7 = a1:GetAttributeChangedSignal("WindDirection"):Connect(
        function()
            --[[
              line: 34
              upvalues:
                u4 (ref,  index: 1)
                a1 (copy, index: 2)
                u1 (copy, index: 3)
                a2 (copy, index: 4)
            ]]
            u4 = a1:GetAttribute("WindDirection")
            u1.WindDirection = typeof(u4) == "Vector3" and u4 or a2.WindDirection
        end
    )
    function u1.Destroy(a3)
        --[[
          name: Destroy
          line: 41
          upvalues:
            u5 (copy, index: 1)
            u6 (copy, index: 2)
            u7 (copy, index: 3)
            u1 (copy, index: 4)
        ]]
        u5:Disconnect()
        u6:Disconnect()
        u7:Disconnect()
        table.clear(u1)
    end
    return u1
end
return tbl_1