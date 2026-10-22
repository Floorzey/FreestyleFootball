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

function spring.step(self, argument)
    local freq_offset_offset = self.freq * 2 * math.pi
    local goal = self.goal
    local vel = self.vel
    local pos_offset = self.pos - goal
    local exp_result = math.exp(-freq_offset_offset * argument)
    local pos = ((pos_offset * ((freq_offset_offset * argument) + 1)) + (vel * argument)) * exp_result + goal
    self.pos = pos
    self.vel = (
        (vel * (1 - (freq_offset_offset * argument)))
        - (pos_offset * ((freq_offset_offset * freq_offset_offset) * argument))
    ) * exp_result
    return pos
end

camera_utils.Spring = spring

function camera_utils.map(self, argument, argument_2, argument_3, argument_4)
    return (((self - argument) * (argument_4 - argument_3)) / (argument_2 - argument)) + argument_3
end

function camera_utils.mapClamp(self, argument, argument_2, argument_3, argument_4)
    return (
        math.clamp(
            (((self - argument) * (argument_4 - argument_3)) / (argument_2 - argument)) + argument_3,
            math.min(argument_3, argument_4),
            math.max(argument_3, argument_4)
        )
    )
end

function camera_utils.getLooseBoundingSphere(self)
    local create_result = table.create(#self)
    for key, item in pairs(self) do
        create_result[key] = item.Position
    end
    local create_result_entry = create_result[1]
    local number = 0
    local create_result_entry_2 = create_result_entry
    for _, item_2 in ipairs(create_result) do
        local magnitude = (item_2 - create_result_entry).Magnitude
        if number < magnitude then
            number, create_result_entry_2 = magnitude, item_2
        end
    end
    local number_2 = 0
    local number_3, create_result_entry_3 = number_2, create_result_entry_2
    for _, item_3 in ipairs(create_result) do
        local magnitude_2 = (item_3 - create_result_entry_2).Magnitude
        if number_3 < magnitude_2 then
            number_3, create_result_entry_3 = magnitude_2, item_3
        end
    end
    local create_result_entry_offset_offset = (create_result_entry_2 + create_result_entry_3) * 0.5
    local magnitude_offset = (create_result_entry_2 - create_result_entry_3).Magnitude * 0.5
    local create_result_entry_offset_offset_2, magnitude_offset_2 = create_result_entry_offset_offset, magnitude_offset
    for _, item_4 in ipairs(create_result) do
        local magnitude_3 = (item_4 - create_result_entry_offset_offset_2).Magnitude
        if magnitude_offset_2 < magnitude_3 then
            create_result_entry_offset_offset_2, magnitude_offset_2 =
                create_result_entry_offset_offset_2 + ((magnitude_3 - magnitude_offset_2) * 0.5) * (
                    item_4 - create_result_entry_offset_offset_2
                ).Unit,
                (magnitude_3 + magnitude_offset_2) * 0.5
        end
    end
    return create_result_entry_offset_offset_2, magnitude_offset_2
end

function camera_utils.sanitizeAngle(self)
    return ((self + math.pi) % math.tau) - math.pi
end

function camera_utils.Round(self, argument)
    local number_offset = 10 ^ argument
    return math.floor((self * number_offset) + 0.5) / number_offset
end

function camera_utils.IsFinite(self)
    return (self == self) and ((self ~= math.huge) and (self ~= -math.huge))
end

function camera_utils.IsFiniteVector3(self)
    local is_finite_result = camera_utils.IsFinite(self.X)
        and (camera_utils.IsFinite(self.Y) and (camera_utils.IsFinite(self.Z)))
    return is_finite_result
end

function camera_utils.GetAngleBetweenXZVectors(self, argument)
    return (math.atan2((argument.X * self.Z) - (argument.Z * self.X), (argument.X * self.X) + (argument.Z * self.Z)))
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

function camera_utils.GamepadLinearToCurve(self)
    local function on_axis(argument)
        local is_argument = ((argument < 0) and -1) or 1
        local clamped_value_4 = math.clamp((((math.abs(math.abs(argument)) * 2) - 1) * 1.1) - 0.1, -1, 1)
        return (
            math.clamp(
                (
                    (
                        (
                            ((clamped_value_4 >= 0) and (clamped_value_4 * 0.35 / ((0.35 - clamped_value_4) + 1)))
                            or -((-clamped_value_4 * 0.8) / ((clamped_value_4 + 0.8) + 1))
                        ) / 2
                    ) + 0.5
                ) * is_argument,
                -1,
                1
            )
        )
    end
    local x = self.X
    local is_x = ((x < 0) and -1) or 1
    local clamped_value = math.clamp((((math.abs(math.abs(x)) * 2) - 1) * 1.1) - 0.1, -1, 1)
    local clamped_value_2 = math.clamp(
        (
            (
                (
                    ((clamped_value >= 0) and (clamped_value * 0.35 / ((0.35 - clamped_value) + 1)))
                    or -((-clamped_value * 0.8) / ((clamped_value + 0.8) + 1))
                ) / 2
            ) + 0.5
        ) * is_x,
        -1,
        1
    )
    local y = self.Y
    local is_y = ((y < 0) and -1) or 1
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
            ) * is_y,
            -1,
            1
        )
    )
end

function camera_utils.ConvertCameraModeEnumToStandard(self)
    if self ~= Enum.TouchCameraMovementMode.Default then
        if
            self ~= Enum.ComputerCameraMovementMode.Default
            and self ~= Enum.TouchCameraMovementMode.Classic
            and self ~= Enum.DevTouchCameraMovementMode.Classic
            and self ~= Enum.DevComputerCameraMovementMode.Classic
            and self ~= Enum.ComputerCameraMovementMode.Classic
        then
            if
                self ~= Enum.TouchCameraMovementMode.Follow
                and self ~= Enum.DevTouchCameraMovementMode.Follow
                and self ~= Enum.DevComputerCameraMovementMode.Follow
                and self ~= Enum.ComputerCameraMovementMode.Follow
            then
                if
                    self ~= Enum.TouchCameraMovementMode.Orbital
                    and self ~= Enum.DevTouchCameraMovementMode.Orbital
                    and self ~= Enum.DevComputerCameraMovementMode.Orbital
                    and self ~= Enum.ComputerCameraMovementMode.Orbital
                then
                    if
                        self ~= Enum.ComputerCameraMovementMode.CameraToggle
                        and self ~= Enum.DevComputerCameraMovementMode.CameraToggle
                    then
                        if
                            self ~= Enum.DevTouchCameraMovementMode.UserChoice
                            and self ~= Enum.DevComputerCameraMovementMode.UserChoice
                        then
                            return Enum.ComputerCameraMovementMode.Classic
                        end
                        return Enum.DevComputerCameraMovementMode.UserChoice
                    end
                    return Enum.ComputerCameraMovementMode.CameraToggle
                end
                return Enum.ComputerCameraMovementMode.Orbital
            end
            return Enum.ComputerCameraMovementMode.Follow
        end
        return Enum.ComputerCameraMovementMode.Classic
    end
    return Enum.ComputerCameraMovementMode.Follow
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
