--[[
    Script Path: Game/ReplicatedStorage/Packages/Option
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1._new(a1)
    --[[
      name: _new
      line: 90
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local tbl_2 = {_s = 0, ClassName = "Option"}
    tbl_2._v = a1
    tbl_2._s = a1 ~= nil
    return (setmetatable(tbl_2, tbl_upv_1))
end
function tbl_upv_1.Some(a1)
    --[[
      name: Some
      line: 100
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    assert(a1 ~= nil, "Option.Some() value cannot be nil")
    return tbl_upv_1._new(a1)
end
function tbl_upv_1.Wrap(a1)
    --[[
      name: Wrap
      line: 106
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if a1 ~= nil then
        return tbl_upv_1.Some(a1)
    end
    return tbl_upv_1.None
end
function tbl_upv_1.Is(a1)
    --[[
      name: Is
      line: 115
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = (type(a1) == "table") and (getmetatable(a1) == tbl_upv_1)
    return v1
end
function tbl_upv_1.Assert(a1)
    --[[
      name: Assert
      line: 120
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    assert(tbl_upv_1.Is(a1), "Result was not of type Option")
end
function tbl_upv_1.Deserialize(a1)
    --[[
      name: Deserialize
      line: 125
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v2 = (type(a1) == "table") and (a1.ClassName == "Option")
    assert(v2, "Invalid data for deserializing Option")
    local v3 = ((a1.Value == nil) and (tbl_upv_1.None)) or (tbl_upv_1.Some(a1.Value))
    return v3
end
function tbl_upv_1.Serialize(a1)
    --[[
      name: Serialize
      line: 131
    ]]
    local tbl_3 = {}
    tbl_3.ClassName = a1.ClassName
    tbl_3.Value = a1._v
    return tbl_3
end
function tbl_upv_1.Match(a1, a2)
    --[[
      name: Match
      line: 139
    ]]
    local Some_1 = a2.Some
    local None_1 = a2.None
    local v4 = type(Some_1) == "function"
    assert(v4, "Missing 'Some' match")
    local v5 = type(None_1) == "function"
    assert(v5, "Missing 'None' match")
    if a1:IsSome() then
        return Some_1(a1:Unwrap())
    end
    return None_1()
end
function tbl_upv_1.IsSome(a1)
    --[[
      name: IsSome
      line: 152
    ]]
    return a1._s
end
function tbl_upv_1.IsNone(a1)
    --[[
      name: IsNone
      line: 157
    ]]
    return not a1._s
end
function tbl_upv_1.Expect(a1, a2)
    --[[
      name: Expect
      line: 162
    ]]
    assert(a1:IsSome(), a2)
    return a1._v
end
function tbl_upv_1.ExpectNone(a1, a2)
    --[[
      name: ExpectNone
      line: 168
    ]]
    assert(a1:IsNone(), a2)
end
function tbl_upv_1.Unwrap(a1)
    --[[
      name: Unwrap
      line: 173
    ]]
    return a1:Expect("Cannot unwrap option of None type")
end
function tbl_upv_1.UnwrapOr(a1, a2)
    --[[
      name: UnwrapOr
      line: 178
    ]]
    if a1:IsSome() then
        return a1:Unwrap()
    end
    return a2
end
function tbl_upv_1.UnwrapOrElse(a1, a2)
    --[[
      name: UnwrapOrElse
      line: 187
    ]]
    if a1:IsSome() then
        return a1:Unwrap()
    end
    return a2()
end
function tbl_upv_1.And(a1, a2)
    --[[
      name: And
      line: 196
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if a1:IsSome() then
        return a2
    end
    return tbl_upv_1.None
end
function tbl_upv_1.AndThen(a1, a2)
    --[[
      name: AndThen
      line: 205
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if not a1:IsSome() then
        return tbl_upv_1.None
    end
    local v6 = a2(a1:Unwrap())
    tbl_upv_1.Assert(v6)
    return v6
end
function tbl_upv_1.Or(a1, a2)
    --[[
      name: Or
      line: 216
    ]]
    if a1:IsSome() then
        return a1
    end
    return a2
end
function tbl_upv_1.OrElse(a1, a2)
    --[[
      name: OrElse
      line: 225
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if a1:IsSome() then
        return a1
    end
    local v7 = a2()
    tbl_upv_1.Assert(v7)
    return v7
end
function tbl_upv_1.XOr(a1, a2)
    --[[
      name: XOr
      line: 236
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v8 = a1:IsSome()
    if v8 ~= a2:IsSome() then
        if v8 then
            return a1
        end
        return a2
    end
    return tbl_upv_1.None
end
function tbl_upv_1.Filter(a1, a2)
    --[[
      name: Filter
      line: 249
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if not (a1:IsNone()) and a2(a1._v) then
        return a1
    end
    return tbl_upv_1.None
end
function tbl_upv_1.Contains(a1, a2)
    --[[
      name: Contains
      line: 258
    ]]
    local v9 = a1:IsSome() and (a1._v == a2)
    return v9
end
function tbl_upv_1.__tostring(a1)
    --[[
      name: __tostring
      line: 263
    ]]
    if a1:IsSome() then
        return "Option<" .. typeof(a1._v) .. ">"
    end
    return "Option<None>"
end
function tbl_upv_1.__eq(a1, a2)
    --[[
      name: __eq
      line: 272
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if tbl_upv_1.Is(a2) then
        if a1:IsSome() and a2:IsSome() then
            local v10 = a1:Unwrap() == a2:Unwrap()
            return v10
        end
        if a1:IsNone() and a2:IsNone() then
            return true
        end
    end
    return false
end
tbl_upv_1.None = tbl_upv_1._new()
return tbl_upv_1