local attributes = require("../mod/attributes")
local lerp = require("../mod/lerp")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local bezier = require("../obj/Bezier")
local random = Random.new()
local randomizer = {}

local function get_bezier(argument: string)
    local bezier_cache_entry = tween.bezier_cache[argument]

    if not bezier_cache_entry then
        local success, result = pcall(function()
            return utility.deserializePath(argument)
        end)

        if not success then
            return nil
        end

        bezier_cache_entry = bezier.new(result, 0)
        tween.bezier_cache[argument] = bezier_cache_entry
    end

    return bezier_cache_entry
end

local function sample_weighted(argument)
    return 1 - argument:getEase((random:NextNumber())).y
end

function randomizer.emit(argument: userdata, argument_2: any, argument_3: boolean)
    local target = utility.getTarget(argument)

    if not target then
        return
    end

    local name = argument.Name
    local get_result = attributes.get(argument, "_START_VALUE", nil)
    local get_result_2 = attributes.get(argument, "_END_VALUE", nil)

    if get_result == nil or get_result_2 == nil then
        return
    end

    local value_type = typeof(get_result)

    if value_type ~= typeof(get_result_2) then
        return
    end

    local result = get_bezier((attributes.get(argument, "Weight_Curve", utility.linear_bezier)))

    if not result then
        return
    end

    local get_result_3

    if argument_3 then
        get_result_3 = attributes.get(target, name, nil)
    else
        local pcall_result
        pcall_result, get_result_3 = pcall(function()
            return target[name]
        end)

        if not pcall_result then
            return
        end
    end

    local result_2 = (lerp[value_type] or lerp.Other)(
        get_result,
        get_result_2,
        1 - result:getEase((random:NextNumber())).y
    )
    local get_result_4 = attributes.get(argument, "ResetOnFinish", true)

    if argument_3 then
        attributes.set(target, name, result_2)
    else
        target[name] = result_2
    end

    if not get_result_4 then
        return
    end

    task.defer(function()
        if argument_3 then
            attributes.set(target, name, get_result_3)

            return
        end

        target[name] = get_result_3
    end)
end

return randomizer
