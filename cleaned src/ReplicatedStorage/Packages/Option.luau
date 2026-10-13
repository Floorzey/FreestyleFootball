local option = {}
option.__index = option

function option._new(v)
    local values = { _s = 0, ClassName = "Option" }
    values._v = v
    values._s = v ~= nil
    return (setmetatable(values, option))
end

function option.Some(v)
    assert(v ~= nil, "Option.Some() value cannot be nil")
    return option._new(v)
end

function option.Wrap(self)
    if self ~= nil then
        return option.Some(self)
    end
    return option.None
end

function option.Is(self)
    local is_table = (type(self) == "table") and (getmetatable(self) == option)
    return is_table
end

function option.Assert(self)
    assert(option.Is(self), "Result was not of type Option")
end

function option.Deserialize(self)
    local is_table = (type(self) == "table") and (self.ClassName == "Option")
    assert(is_table, "Invalid data for deserializing Option")
    local none = ((self.Value == nil) and option.None) or (option.Some(self.Value))
    return none
end

function option.Serialize(self)
    local values = {}
    values.ClassName = self.ClassName
    values.Value = self._v
    return values
end

function option.Match(self, argument)
    local some = argument.Some
    local none = argument.None
    local is_function = type(some) == "function"
    assert(is_function, "Missing 'Some' match")
    local is_function_2 = type(none) == "function"
    assert(is_function_2, "Missing 'None' match")
    if self:IsSome() then
        return some(self:Unwrap())
    end
    return none()
end

function option.IsSome(self)
    return self._s
end

function option.IsNone(self)
    return not self._s
end

function option.Expect(self, argument)
    assert(self:IsSome(), argument)
    return self._v
end

function option.ExpectNone(self, argument)
    assert(self:IsNone(), argument)
end

function option.Unwrap(self)
    return self:Expect("Cannot unwrap option of None type")
end

function option.UnwrapOr(self, argument)
    if self:IsSome() then
        return self:Unwrap()
    end
    return argument
end

function option.UnwrapOrElse(self, callback)
    if self:IsSome() then
        return self:Unwrap()
    end
    return callback()
end

function option.And(self, argument)
    if self:IsSome() then
        return argument
    end
    return option.None
end

function option.AndThen(self, callback)
    if not self:IsSome() then
        return option.None
    end
    local result = callback(self:Unwrap())
    option.Assert(result)
    return result
end

function option.Or(self, argument)
    if self:IsSome() then
        return self
    end
    return argument
end

function option.OrElse(self, callback)
    if self:IsSome() then
        return self
    end
    local result = callback()
    option.Assert(result)
    return result
end

function option.XOr(self, argument)
    local is_some_result = self:IsSome()
    if is_some_result ~= argument:IsSome() then
        if is_some_result then
            return self
        end
        return argument
    end
    return option.None
end

function option.Filter(self, callback)
    if not (self:IsNone()) and callback(self._v) then
        return self
    end
    return option.None
end

function option.Contains(self, argument)
    local is_v = self:IsSome() and (self._v == argument)
    return is_v
end

function option.__tostring(self)
    if self:IsSome() then
        return "Option<" .. typeof(self._v) .. ">"
    end
    return "Option<None>"
end

function option.__eq(self, argument)
    if option.Is(argument) then
        if self:IsSome() and argument:IsSome() then
            local is_unwrap_result = self:Unwrap() == argument:Unwrap()
            return is_unwrap_result
        end
        if self:IsNone() and argument:IsNone() then
            return true
        end
    end
    return false
end

option.None = option._new()

return option
