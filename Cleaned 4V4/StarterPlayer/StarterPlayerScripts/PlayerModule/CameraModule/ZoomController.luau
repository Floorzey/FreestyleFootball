local popper = require(script:WaitForChild("Popper"))
local clamp = math.clamp
local exp = math.exp
local min = math.min
local max = math.max
local camera_min_zoom_distance = nil
local camera_max_zoom_distance = nil
local local_player = game:GetService("Players").LocalPlayer
assert(local_player)

local function update_bounds()
    camera_min_zoom_distance = local_player.CameraMinZoomDistance
    camera_max_zoom_distance = local_player.CameraMaxZoomDistance
end

camera_min_zoom_distance = local_player.CameraMinZoomDistance
camera_max_zoom_distance = local_player.CameraMaxZoomDistance
local_player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(update_bounds)
local_player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(update_bounds)
local values_2 = {}
values_2.__index = values_2

function values_2.new(freq, x, min_value, max_value)
    x = clamp(x, min_value, max_value)

    return (setmetatable({ v = 0, freq = freq, x = x, minValue = min_value, maxValue = max_value, goal = x }, values_2))
end

function values_2.Step(argument, argument_2)
    local product = argument.freq * 2 * math.pi
    local v = argument.v
    local min_value = argument.minValue
    local max_value = argument.maxValue
    local goal = argument.goal
    local difference = goal - argument.x
    local product_2 = product * argument_2
    local result = exp(-product_2)
    local x = goal + ((v * argument_2) - (difference * (product_2 + 1))) * result
    local v_2 = ((((difference * product) - v) * product_2) + v) * result

    if x < min_value then
        x, v_2 = min_value, 0
    elseif max_value < x then
        x, v_2 = max_value, 0
    end

    argument.x = x
    argument.v = v_2

    return x
end

local values = values_2.new(4.5, 12.5, 0.5, camera_max_zoom_distance)

local function step_target_zoom(number_2, argument, argument_2, argument_3)
    local result = clamp(number_2 + (argument * ((number_2 * 0.0375) + 1)), argument_2, argument_3)

    if result < 1 then
        local number_3 = argument <= 0 and argument_2 or 1
        number_2 = number_3
    else
        number_2 = result
    end

    return number_2
end

local number = 0
local zoom_controller = {}

function zoom_controller.Update(argument, argument_2, argument_3)
    local huge = math.huge
    local value = nil

    if values.goal > 1 then
        local x = values.x
        local goal = values.goal
        local number_2 = number
        local camera_min_zoom_distance_2 = camera_min_zoom_distance
        value =
            clamp(values.goal + number * (values.goal * 0.0375 + 1), camera_min_zoom_distance, camera_max_zoom_distance)

        if value < 1 then
            goal = number_2 <= 0 and camera_min_zoom_distance_2 or 1
        else
            goal = value
        end

        local result = max(x, goal)
        huge = popper(argument_2 * CFrame.new(0, 0, 0.5), result - 0.5, argument_3) + 0.5
    end

    values.minValue = 0.5
    values.maxValue = min(camera_max_zoom_distance, huge)

    return values:Step(argument)
end

function zoom_controller.GetZoomRadius()
    return values.x
end

function zoom_controller.SetZoomParameters(goal, argument)
    values.goal = goal
    number = argument
end

function zoom_controller.ReleaseSpring()
    values.x = values.goal
    values.v = 0
end

return zoom_controller
