local popper = require(script:WaitForChild("Popper"))
local math_clamp = math.clamp
local math_exp = math.exp
local math_min = math.min
local math_max = math.max
local value = nil
local value_2 = nil
local local_player = game:GetService("Players").LocalPlayer
assert(local_player)

local function update_bounds()
    value = local_player.CameraMinZoomDistance
    value_2 = local_player.CameraMaxZoomDistance
end

value = local_player.CameraMinZoomDistance
value_2 = local_player.CameraMaxZoomDistance
local_player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(update_bounds)
local_player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(update_bounds)
local values_2 = {}
values_2.__index = values_2

function values_2.new(freq: number, argument: number, min_value: number, max_value: number)
    local x = math_clamp(argument, min_value, max_value)

    return setmetatable({
        v = 0,
        freq = freq,
        x = x,
        minValue = min_value,
        maxValue = max_value,
        goal = x,
    }, values_2)
end

function values_2.Step(argument: table, argument_2: number)
    local product = argument.freq * 2 * 3.141592653589793
    local v = argument.v
    local min_value = argument.minValue
    local max_value = argument.maxValue
    local goal = argument.goal
    local difference = goal - argument.x
    local product_2 = product * argument_2
    local result = math_exp(-product_2)
    local sum = goal + (v * argument_2 - difference * (product_2 + 1)) * result
    local v_2 = ((difference * product - v) * product_2 + v) * result

    if sum < min_value then
        max_value = min_value
        v_2 = 0
    elseif max_value < sum then
        v_2 = 0
    else
        max_value = sum
    end

    argument.x = max_value
    argument.v = v_2

    return max_value
end

local values = values_2.new(4.5, 12.5, 0.5, value_2)

local function step_target_zoom(argument: number, argument_2: number, argument_3: number, argument_4: number)
    local result = math_clamp(argument + argument_2 * (argument * 0.0375 + 1), argument_3, argument_4)

    return result < 1 and (argument_2 <= 0 and argument_3 and argument_3 or 1) or result
end

local number = 0

return {
    Update = function(argument: number, argument_2, argument_3: any)
        local sum

        if values.goal > 1 then
            local x = values.x
            local goal = values.goal
            local number_2 = number
            local value_3 = value
            local result = math_clamp(goal + number_2 * (goal * 0.0375 + 1), value_3, value_2)
            local result_2 = math_max(x, result < 1 and (number_2 <= 0 and value_3 and value_3 or 1) or result)
            sum = popper(argument_2 * CFrame.new(0, 0, 0.5), result_2 - 0.5, argument_3) + 0.5
        else
            sum = (1 / 0)
        end

        values.minValue = 0.5
        values.maxValue = math_min(value_2, sum)

        return values:Step(argument)
    end,

    GetZoomRadius = function()
        return values.x
    end,

    SetZoomParameters = function(goal, argument)
        values.goal = goal
        number = argument
    end,

    ReleaseSpring = function()
        values.x = values.goal
        values.v = 0
    end,
}
