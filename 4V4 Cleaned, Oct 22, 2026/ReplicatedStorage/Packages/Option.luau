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

function option.Wrap(argument)
    if argument ~= nil then
        return option.Some(argument)
    end

    return option.None
end

function option.Is(argument)
    return (type(argument) == "table") and (getmetatable(argument) == option)
end

function option.Assert(argument)
    assert(option.Is(argument), "Result was not of type Option")
end

function option.Deserialize(argument)
    local condition = (type(argument) == "table") and (argument.ClassName == "Option")
    assert(condition, "Invalid data for deserializing Option")

    return ((argument.Value == nil) and option.None) or option.Some(argument.Value)
end

function option.Serialize(argument)
    local values = {}
    values.ClassName = argument.ClassName
    values.Value = argument._v

    return values
end

function option.Match(argument, argument_2)
    local some = argument_2.Some
    local none = argument_2.None
    local is_function = type(some) == "function"
    assert(is_function, "Missing 'Some' match")
    local is_function_2 = type(none) == "function"
    assert(is_function_2, "Missing 'None' match")

    if argument:IsSome() then
        return some(argument:Unwrap())
    end

    return none()
end

function option.IsSome(argument)
    return argument._s
end

function option.IsNone(argument)
    return not argument._s
end

function option.Expect(argument, argument_2)
    assert(argument:IsSome(), argument_2)

    return argument._v
end

function option.ExpectNone(argument, argument_2)
    assert(argument:IsNone(), argument_2)
end

function option.Unwrap(argument)
    return argument:Expect("Cannot unwrap option of None type")
end

function option.UnwrapOr(argument, argument_2)
    if argument:IsSome() then
        return argument:Unwrap()
    end

    return argument_2
end

function option.UnwrapOrElse(argument, callback)
    if argument:IsSome() then
        return argument:Unwrap()
    end

    return callback()
end

function option.And(argument, argument_2)
    if argument:IsSome() then
        return argument_2
    end

    return option.None
end

function option.AndThen(argument, callback)
    if not argument:IsSome() then
        return option.None
    end

    local result = callback(argument:Unwrap())
    option.Assert(result)

    return result
end

function option.Or(argument, argument_2)
    if argument:IsSome() then
        return argument
    end

    return argument_2
end

function option.OrElse(argument, callback)
    if argument:IsSome() then
        return argument
    end

    local result = callback()
    option.Assert(result)

    return result
end

function option.XOr(argument, argument_2)
    local is_some_result = argument:IsSome()

    if is_some_result ~= argument_2:IsSome() then
        if is_some_result then
            return argument
        end

        return argument_2
    end

    return option.None
end

function option.Filter(argument, callback)
    if not (argument:IsNone()) and callback(argument._v) then
        return argument
    end

    return option.None
end

function option.Contains(argument, argument_2)
    return argument:IsSome() and (argument._v == argument_2)
end

function option.__tostring(argument)
    if argument:IsSome() then
        return "Option<" .. typeof(argument._v) .. ">"
    end

    return "Option<None>"
end

function option.__eq(argument, argument_2)
    if not (option.Is(argument_2)) then
        return false
    end

    if argument:IsSome() and argument_2:IsSome() then
        return argument:Unwrap() == argument_2:Unwrap()
    end

    return if argument:IsNone() and argument_2:IsNone() then true else false
end

option.None = option._new()

return option
