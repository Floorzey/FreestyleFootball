local run_service = game:GetService("RunService")
local logger = require("./logger")
local is_server_result = run_service:IsServer()
local values = {}
local values_2 = {}
local values_3 = {}
local number = 0
local attributes = {
    cache = function(argument: userdata)
        local attribute = argument:GetAttribute("U")

        if attribute then
            logger.warn(`{argument} is already cached (id={attribute})`)

            return
        end

        local attributes_2 = argument:GetAttributes()

        if next(attributes_2) == nil then
            return
        end

        number = number + 1
        local attribute_value = number
        local values_4 = {}

        for attribute_name, item in attributes_2 do
            if attribute_name ~= "U" then
                values_4[attribute_name] = item
                argument:SetAttribute(attribute_name, nil)
            end
        end

        values[attribute_value] = values_4
        argument:SetAttribute("U", attribute_value)
    end,

    restore = function(argument: userdata)
        local attribute = argument:GetAttribute("U")
        local value_entry = values[attribute]

        if not value_entry then
            logger.warn(`{argument} with cache id '{attribute}' doesn't have any cached attributes`)

            return
        end

        for attribute_name, attribute_value in value_entry do
            argument:SetAttribute(attribute_name, attribute_value)
        end

        argument:SetAttribute("U", nil)
    end,

    get = function(
        argument: userdata,
        attribute_name: string,
        attribute_value: any,
        argument_2: boolean?,
        callback: ((...any) -> ...any)?
    )
        local value_entry = values[argument:GetAttribute("U")]

        if value_entry then
            value_entry = value_entry[attribute_name]
        end

        if value_entry ~= nil then
            if callback then
                return callback(value_entry)
            end

            if value_entry == nil then
                return attribute_value
            end

            return value_entry
        end

        local attribute = argument:GetAttribute(attribute_name)

        if callback then
            attribute_value = callback(attribute)
        elseif attribute ~= nil then
            attribute_value = attribute
        end

        if not argument_2 and is_server_result then
            argument:SetAttribute(attribute_name, attribute_value)
        end

        return attribute_value
    end,
}

function attributes.getRange(argument: userdata, argument_2: string, argument_3, argument_4, argument_5: boolean?)
    return attributes.get(argument, argument_2, argument_3, argument_5, function(argument_6)
        if typeof(argument_6) ~= "NumberRange" then
            return argument_3
        end

        if argument_4 then
            return NumberRange.new(
                math.clamp(argument_6.Min, argument_4.Min, argument_4.Max),
                (math.clamp(argument_6.Max, argument_4.Min, argument_4.Max))
            )
        end

        return argument_6
    end)
end

function attributes.getEnum(
    argument: userdata,
    argument_2: string,
    argument_3: any,
    argument_4: table,
    argument_5: boolean?
)
    return attributes.get(argument, argument_2, argument_3, argument_5, function(argument_6)
        if argument_6 == nil or not table.find(argument_4, argument_6) then
            return argument_3
        end

        return argument_6
    end)
end

function attributes.set(argument: userdata, attribute_name: string, attribute_value: any)
    local value_entry = values[argument:GetAttribute("U")]

    if value_entry then
        value_entry[attribute_name] = attribute_value

        return
    end

    argument:SetAttribute(attribute_name, attribute_value)
end

function attributes.isCached(argument: userdata)
    return argument:GetAttribute("U") ~= nil
end

function attributes.getState(argument: userdata, argument_2: string, argument_3: any)
    local value_entry = values_3[argument]

    if value_entry then
        value_entry = value_entry[argument_2]
    end

    if value_entry == nil then
        return argument_3
    end

    return value_entry
end

function attributes.setState(argument: userdata, argument_2: string, argument_3: any)
    local value_entry = values_3[argument]

    if not value_entry then
        value_entry = {}
        values_3[argument] = value_entry
    end

    value_entry[argument_2] = argument_3
end

function attributes.clearState(argument: userdata)
    values_3[argument] = nil
end

function attributes.trigger(argument: userdata, argument_2: string, argument_3: any)
    local value_entry = values_2[argument]

    if value_entry then
        value_entry = value_entry[argument_2]
    end

    if not value_entry then
        return
    end

    for _, callback in value_entry do
        callback(argument_3)
    end
end

function attributes.hook(argument: userdata, attribute_name: string, callback: (...any) -> ...any)
    local value_entry = values_2[argument]

    if not value_entry then
        value_entry = {}
        values_2[argument] = value_entry
    end

    local value_entry_entry = value_entry[attribute_name]

    if not value_entry_entry then
        value_entry_entry = {}
        value_entry[attribute_name] = value_entry_entry
    end

    table.insert(value_entry_entry, callback)
    local connection

    if attributes.isCached(argument) then
        connection = nil
    else
        connection = argument:GetAttributeChangedSignal(attribute_name):Connect(function()
            callback((argument:GetAttribute(attribute_name)))
        end)
    end

    return function()
        if connection then
            connection:Disconnect()
        end

        local match_index = table.find(value_entry_entry, callback)

        if match_index then
            table.remove(value_entry_entry, match_index)
        end

        if #value_entry_entry == 0 then
            value_entry[attribute_name] = nil
        end

        if next(value_entry) == nil then
            values_2[argument] = nil
        end
    end
end

return attributes
