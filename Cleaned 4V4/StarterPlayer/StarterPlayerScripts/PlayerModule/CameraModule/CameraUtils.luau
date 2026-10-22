local players = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_utils = {}

local function round(argument)
    return (math.floor(argument + 0.5))
end

local spring = {}
spring.__index = spring

function spring.new(freq, goal)
    return (setmetatable({ vel = 0, freq = freq, goal = goal, pos = goal }, spring))
end

function spring.step(argument, argument_2)
    local product = argument.freq * 2 * math.pi
    local goal = argument.goal
    local vel = argument.vel
    local difference = argument.pos - goal
    local exp_result = math.exp(-product * argument_2)
    local pos = ((difference * ((product * argument_2) + 1)) + (vel * argument_2)) * exp_result + goal
    argument.pos = pos
    argument.vel = ((vel * (1 - (product * argument_2))) - (difference * ((product * product) * argument_2)))
        * exp_result

    return pos
end

camera_utils.Spring = spring

function camera_utils.map(argument, argument_2, argument_3, argument_4, argument_5)
    return (((argument - argument_2) * (argument_5 - argument_4)) / (argument_3 - argument_2)) + argument_4
end

function camera_utils.mapClamp(argument, argument_2, argument_3, argument_4, argument_5)
    return (
        math.clamp(
            (((argument - argument_2) * (argument_5 - argument_4)) / (argument_3 - argument_2)) + argument_4,
            math.min(argument_4, argument_5),
            math.max(argument_4, argument_5)
        )
    )
end

function camera_utils.getLooseBoundingSphere(argument)
    local create_result = table.create(#argument)

    for key, item in pairs(argument) do
        create_result[key] = item.Position
    end

    local create_result_entry = create_result[1]
    local magnitude = 0
    local create_result_entry_2 = create_result_entry

    for _, item_2 in ipairs(create_result) do
        local magnitude_2 = (item_2 - create_result_entry).Magnitude

        if magnitude < magnitude_2 then
            magnitude, create_result_entry_2 = magnitude_2, item_2
        end
    end

    local number = 0
    local number_2
    number_2, magnitude = number, create_result_entry_2

    for _, item_3 in ipairs(create_result) do
        local magnitude_3 = (item_3 - create_result_entry_2).Magnitude

        if number_2 < magnitude_3 then
            number_2, magnitude = magnitude_3, item_3
        end
    end

    local product = (create_result_entry_2 + magnitude) * 0.5
    local product_2 = (create_result_entry_2 - magnitude).Magnitude * 0.5
    local product_3
    number_2, product_3 = product, product_2

    for _, item_4 in ipairs(create_result) do
        magnitude = (item_4 - number_2).Magnitude

        if product_3 < magnitude then
            number_2, product_3 =
                number_2 + ((magnitude - product_3) * 0.5) * (item_4 - number_2).Unit, (magnitude + product_3) * 0.5
        end
    end

    return number_2, product_3
end

function camera_utils.sanitizeAngle(argument)
    return ((argument + math.pi) % math.tau) - math.pi
end

function camera_utils.Round(argument, argument_2)
    local power = 10 ^ argument_2

    return math.floor((argument * power) + 0.5) / power
end

function camera_utils.IsFinite(argument)
    return (argument == argument) and ((argument ~= math.huge) and (argument ~= -math.huge))
end

function camera_utils.IsFiniteVector3(argument)
    return camera_utils.IsFinite(argument.X)
        and (camera_utils.IsFinite(argument.Y) and camera_utils.IsFinite(argument.Z))
end

function camera_utils.GetAngleBetweenXZVectors(argument, argument_2)
    return (
        math.atan2(
            (argument_2.X * argument.Z) - (argument_2.Z * argument.X),
            (argument_2.X * argument.X) + (argument_2.Z * argument.Z)
        )
    )
end

function camera_utils.RotateVectorByAngleAndRound(vector, argument, argument_2)
    if not (vector.Magnitude > 0) then
        return 0
    end

    local unit = vector.Unit
    local angle = math.atan2(unit.Z, unit.X)

    return (math.floor(((math.atan2(unit.Z, unit.X) + argument) / argument_2) + 0.5) * argument_2) - angle
end

local function s_curve_tranform(argument)
    local clamped_value = math.clamp(argument, -1, 1)

    if clamped_value >= 0 then
        return (clamped_value * 0.35) / ((0.35 - clamped_value) + 1)
    end

    return -((-clamped_value * 0.8) / ((clamped_value + 0.8) + 1))
end

local function to_s_curve_space(argument)
    return (((math.abs(argument) * 2) - 1) * 1.1) - 0.1
end

local function from_s_curve_space(argument)
    return (argument / 2) + 0.5
end

function camera_utils.GamepadLinearToCurve(argument)
    local function on_axis(argument_2)
        local negated_value_3 = ((argument_2 < 0) and -1) or 1
        local clamped_value_4 = math.clamp((((math.abs(math.abs(argument_2)) * 2) - 1) * 1.1) - 0.1, -1, 1)

        return (
            math.clamp(
                (
                    (
                        (
                            ((clamped_value_4 >= 0) and (clamped_value_4 * 0.35 / ((0.35 - clamped_value_4) + 1)))
                            or -((-clamped_value_4 * 0.8) / ((clamped_value_4 + 0.8) + 1))
                        ) / 2
                    ) + 0.5
                ) * negated_value_3,
                -1,
                1
            )
        )
    end

    local x = argument.X
    local negated_value = ((x < 0) and -1) or 1
    local clamped_value = math.clamp((((math.abs(math.abs(x)) * 2) - 1) * 1.1) - 0.1, -1, 1)
    local clamped_value_2 = math.clamp(
        (
            (
                (
                    ((clamped_value >= 0) and (clamped_value * 0.35 / ((0.35 - clamped_value) + 1)))
                    or -((-clamped_value * 0.8) / ((clamped_value + 0.8) + 1))
                ) / 2
            ) + 0.5
        ) * negated_value,
        -1,
        1
    )
    local y = argument.Y
    local negated_value_2 = ((y < 0) and -1) or 1
    local clamped_value_3 = math.clamp((((math.abs(math.abs(y)) * 2) - 1) * 1.1) - 0.1, -1, 1)

    return Vector2.new(
        clamped_value_2,
        math.clamp(
            (
                (
                    (
                        ((clamped_value_3 >= 0) and (clamped_value_3 * 0.35 / ((0.35 - clamped_value_3) + 1)))
                        or -((-clamped_value_3 * 0.8) / ((clamped_value_3 + 0.8) + 1))
                    ) / 2
                ) + 0.5
            ) * negated_value_2,
            -1,
            1
        )
    )
end

function camera_utils.ConvertCameraModeEnumToStandard(argument)
    if argument == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if
        not (
            argument ~= Enum.ComputerCameraMovementMode.Default
            and argument ~= Enum.TouchCameraMovementMode.Classic
            and argument ~= Enum.DevTouchCameraMovementMode.Classic
            and argument ~= Enum.DevComputerCameraMovementMode.Classic
            and argument ~= Enum.ComputerCameraMovementMode.Classic
        )
    then
        return Enum.ComputerCameraMovementMode.Classic
    end

    if
        not (
            argument ~= Enum.TouchCameraMovementMode.Follow
            and argument ~= Enum.DevTouchCameraMovementMode.Follow
            and argument ~= Enum.DevComputerCameraMovementMode.Follow
            and argument ~= Enum.ComputerCameraMovementMode.Follow
        )
    then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if
        not (
            argument ~= Enum.TouchCameraMovementMode.Orbital
            and argument ~= Enum.DevTouchCameraMovementMode.Orbital
            and argument ~= Enum.DevComputerCameraMovementMode.Orbital
            and argument ~= Enum.ComputerCameraMovementMode.Orbital
        )
    then
        return Enum.ComputerCameraMovementMode.Orbital
    end

    if
        not (
            argument ~= Enum.ComputerCameraMovementMode.CameraToggle
            and argument ~= Enum.DevComputerCameraMovementMode.CameraToggle
        )
    then
        return Enum.ComputerCameraMovementMode.CameraToggle
    end

    if
        argument ~= Enum.DevTouchCameraMovementMode.UserChoice
        and argument ~= Enum.DevComputerCameraMovementMode.UserChoice
    then
        return Enum.ComputerCameraMovementMode.Classic
    end

    return Enum.DevComputerCameraMovementMode.UserChoice
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

function camera_utils.setMouseIconOverride(icon_2)
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
