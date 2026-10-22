local players = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_utils = {}

local function round(argument: number)
    return math.floor(argument + 0.5)
end

local spring = {}
spring.__index = spring

function spring.new(freq, goal)
    return setmetatable({
        vel = 0,
        freq = freq,
        goal = goal,
        pos = goal,
    }, spring)
end

function spring.step(argument: table, argument_2: number)
    local product = argument.freq * 2 * 3.141592653589793
    local goal = argument.goal
    local vel = argument.vel
    local difference = argument.pos - goal
    local exp_result = math.exp(-product * argument_2)
    local pos = (difference * (product * argument_2 + 1) + vel * argument_2) * exp_result + goal
    argument.pos = pos
    argument.vel = (vel * (1 - product * argument_2) - difference * (product * product * argument_2)) * exp_result

    return pos
end

camera_utils.Spring = spring

function camera_utils.map(
    argument: number,
    argument_2: number,
    argument_3: number,
    argument_4: number,
    argument_5: number
)
    return (argument - argument_2) * (argument_5 - argument_4) / (argument_3 - argument_2) + argument_4
end

function camera_utils.mapClamp(
    argument: number,
    argument_2: number,
    argument_3: number,
    argument_4: number,
    argument_5: number
)
    local minimum = math.min(argument_4, argument_5)
    local maximum = math.max(argument_4, argument_5)

    return math.clamp(
        (argument - argument_2) * (argument_5 - argument_4) / (argument_3 - argument_2) + argument_4,
        minimum,
        maximum
    )
end

function camera_utils.getLooseBoundingSphere(argument: table)
    local create_result = table.create(#argument)

    for key, item in pairs(argument) do
        create_result[key] = item.Position
    end

    local create_result_entry = create_result[1]
    local create_result_entry_2 = create_result_entry
    local number = 0

    for _, item_2 in ipairs(create_result) do
        local magnitude = (item_2 - create_result_entry).Magnitude

        if number < magnitude then
            create_result_entry_2 = item_2
            number = magnitude
        end
    end

    local create_result_entry_3 = create_result_entry_2
    local number_2 = 0

    for _, item_3 in ipairs(create_result) do
        local magnitude_2 = (item_3 - create_result_entry_2).Magnitude

        if number_2 < magnitude_2 then
            create_result_entry_3 = item_3
            number_2 = magnitude_2
        end
    end

    local product = (create_result_entry_2 + create_result_entry_3) * 0.5
    local product_2 = (create_result_entry_2 - create_result_entry_3).Magnitude * 0.5

    for _, item_4 in ipairs(create_result) do
        local magnitude_3 = (item_4 - product).Magnitude

        if product_2 < magnitude_3 then
            product += (magnitude_3 - product_2) * 0.5 * (item_4 - product).Unit
            product_2 = (magnitude_3 + product_2) * 0.5
        end
    end

    return product, product_2
end

function camera_utils.sanitizeAngle(argument: number)
    return (argument + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function camera_utils.Round(argument: number, argument_2: number)
    local power = 10 ^ argument_2

    return math.floor(argument * power + 0.5) / power
end

function camera_utils.IsFinite(argument: number)
    local condition

    if argument == argument and argument ~= (1 / 0) then
        condition = argument ~= (-1 / 0)
    else
        condition = false
    end

    return condition
end

function camera_utils.IsFiniteVector3(argument: vector)
    return camera_utils.IsFinite(argument.X) and camera_utils.IsFinite(argument.Y) and camera_utils.IsFinite(argument.Z)
end

function camera_utils.GetAngleBetweenXZVectors(argument: vector, argument_2: vector)
    return math.atan2(
        argument_2.X * argument.Z - argument_2.Z * argument.X,
        argument_2.X * argument.X + argument_2.Z * argument.Z
    )
end

function camera_utils.RotateVectorByAngleAndRound(vector: vector, argument: number, argument_2: number)
    if vector.Magnitude <= 0 then
        return 0
    end

    local unit = vector.Unit
    local angle = math.atan2(unit.Z, unit.X)
    local sum = (math.atan2(unit.Z, unit.X) + argument) / argument_2 + 0.5

    return math.floor(sum) * argument_2 - angle
end

local function s_curve_tranform(argument: number)
    local clamped_value = math.clamp(argument, -1, 1)

    if clamped_value >= 0 then
        return clamped_value * 0.35 / (0.35 - clamped_value + 1)
    end

    return -(-clamped_value * 0.8 / (clamped_value + 0.8 + 1))
end

local function to_s_curve_space(argument: number)
    return (math.abs(argument) * 2 - 1) * 1.1 - 0.1
end

local function from_s_curve_space(argument: number)
    return argument / 2 + 0.5
end

function camera_utils.GamepadLinearToCurve(argument)
    local function on_axis(argument_2)
        local absolute_value_3 = math.abs(argument_2)
        local difference_3 = (math.abs(absolute_value_3) * 2 - 1) * 1.1 - 0.1
        local clamped_value_4 = math.clamp(difference_3, -1, 1)
        local quotient_3

        if clamped_value_4 >= 0 then
            quotient_3 = clamped_value_4 * 0.35 / (0.35 - clamped_value_4 + 1)
        else
            quotient_3 = -(-clamped_value_4 * 0.8 / (clamped_value_4 + 0.8 + 1))
        end

        return math.clamp((quotient_3 / 2 + 0.5) * (argument_2 < 0 and -1 or 1), -1, 1)
    end

    local vector2_new = Vector2.new
    local x = argument.X
    local absolute_value = math.abs(x)
    local difference = (math.abs(absolute_value) * 2 - 1) * 1.1 - 0.1
    local clamped_value = math.clamp(difference, -1, 1)
    local quotient

    if clamped_value >= 0 then
        quotient = clamped_value * 0.35 / (0.35 - clamped_value + 1)
    else
        quotient = -(-clamped_value * 0.8 / (clamped_value + 0.8 + 1))
    end

    local clamped_value_2 = math.clamp((quotient / 2 + 0.5) * (x < 0 and -1 or 1), -1, 1)
    local y = argument.Y
    local absolute_value_2 = math.abs(y)
    local difference_2 = (math.abs(absolute_value_2) * 2 - 1) * 1.1 - 0.1
    local clamped_value_3 = math.clamp(difference_2, -1, 1)
    local quotient_2

    if clamped_value_3 >= 0 then
        quotient_2 = clamped_value_3 * 0.35 / (0.35 - clamped_value_3 + 1)
    else
        quotient_2 = -(-clamped_value_3 * 0.8 / (clamped_value_3 + 0.8 + 1))
    end

    return vector2_new(clamped_value_2, (math.clamp((quotient_2 / 2 + 0.5) * (y < 0 and -1 or 1), -1, 1)))
end

function camera_utils.ConvertCameraModeEnumToStandard(argument)
    if argument == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if argument == Enum.ComputerCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Classic
    end

    if
        argument == Enum.TouchCameraMovementMode.Classic
        or (
            argument == Enum.DevTouchCameraMovementMode.Classic
            or (
                argument == Enum.DevComputerCameraMovementMode.Classic
                or argument == Enum.ComputerCameraMovementMode.Classic
            )
        )
    then
        return Enum.ComputerCameraMovementMode.Classic
    end

    if
        argument == Enum.TouchCameraMovementMode.Follow
        or (
            argument == Enum.DevTouchCameraMovementMode.Follow
            or (
                argument == Enum.DevComputerCameraMovementMode.Follow
                or argument == Enum.ComputerCameraMovementMode.Follow
            )
        )
    then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if
        argument == Enum.TouchCameraMovementMode.Orbital
        or (
            argument == Enum.DevTouchCameraMovementMode.Orbital
            or (
                argument == Enum.DevComputerCameraMovementMode.Orbital
                or argument == Enum.ComputerCameraMovementMode.Orbital
            )
        )
    then
        return Enum.ComputerCameraMovementMode.Orbital
    end

    if
        argument == Enum.ComputerCameraMovementMode.CameraToggle
        or argument == Enum.DevComputerCameraMovementMode.CameraToggle
    then
        return Enum.ComputerCameraMovementMode.CameraToggle
    end

    if
        argument == Enum.DevTouchCameraMovementMode.UserChoice
        or argument == Enum.DevComputerCameraMovementMode.UserChoice
    then
        return Enum.DevComputerCameraMovementMode.UserChoice
    end

    return Enum.ComputerCameraMovementMode.Classic
end

local function get_mouse()
    local local_player = players.LocalPlayer

    if not local_player then
        players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        local_player = players.LocalPlayer
    end

    assert(local_player)

    return local_player:GetMouse()
end

local icon = ""
local value = nil

function camera_utils.setMouseIconOverride(icon_2: string)
    local local_player = players.LocalPlayer

    if not local_player then
        players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        local_player = players.LocalPlayer
    end

    assert(local_player)
    local mouse = local_player:GetMouse()

    if mouse.Icon ~= value then
        icon = mouse.Icon
    end

    mouse.Icon = icon_2
    value = icon_2
end

function camera_utils.restoreMouseIcon()
    local local_player = players.LocalPlayer

    if not local_player then
        players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        local_player = players.LocalPlayer
    end

    assert(local_player)
    local mouse = local_player:GetMouse()

    if mouse.Icon == value then
        mouse.Icon = icon
    end

    value = nil
end

local default = Enum.MouseBehavior.Default
local value_2 = nil

function camera_utils.setMouseBehaviorOverride(mouse_behavior)
    if user_input_service.MouseBehavior ~= value_2 then
        default = user_input_service.MouseBehavior
    end

    user_input_service.MouseBehavior = mouse_behavior
    value_2 = mouse_behavior
end

function camera_utils.restoreMouseBehavior()
    if user_input_service.MouseBehavior == value_2 then
        user_input_service.MouseBehavior = default
    end

    value_2 = nil
end

local movement_relative = Enum.RotationType.MovementRelative
local value_3 = nil

function camera_utils.setRotationTypeOverride(rotation_type)
    if user_game_settings.RotationType ~= value_3 then
        movement_relative = user_game_settings.RotationType
    end

    user_game_settings.RotationType = rotation_type
    value_3 = rotation_type
end

function camera_utils.restoreRotationType()
    if user_game_settings.RotationType == value_3 then
        user_game_settings.RotationType = movement_relative
    end

    value_3 = nil
end

return camera_utils
