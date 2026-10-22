local players = game:GetService("Players")
local current_camera = game.Workspace.CurrentCamera
local math_min = math.min
local math_tan = math.tan
local to_radians = math.rad
local ray_new = Ray.new

local function get_total_transparency(argument)
    return 1 - (1 - argument.Transparency) * (1 - argument.LocalTransparencyModifier)
end

local function erase_from_end(argument, argument_2)
    for index = #argument, argument_2 + 1, -1 do
        argument[index] = nil
        local _ = index
    end
end

local value = nil
local value_2 = nil

local function update_projection()
    local result_2 = to_radians(current_camera.FieldOfView)
    local viewport_size_2 = current_camera.ViewportSize
    local quotient_2 = viewport_size_2.X / viewport_size_2.Y
    value_2 = math_tan(result_2 / 2) * 2
    value = quotient_2 * value_2
end

current_camera:GetPropertyChangedSignal("FieldOfView"):Connect(update_projection)
current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(update_projection)
local result = to_radians(current_camera.FieldOfView)
local viewport_size = current_camera.ViewportSize
local quotient = viewport_size.X / viewport_size.Y
value_2 = math_tan(result / 2) * 2
value = quotient * value_2
local near_plane_z = current_camera.NearPlaneZ

current_camera:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
    near_plane_z = current_camera.NearPlaneZ
end)

local values = {}
local values_2 = {}

local function refresh_ignore_list()
    local number_2 = 1
    values = {}

    for _, item_2 in pairs(values_2) do
        values[number_2] = item_2
        number_2 += 1
    end
end

local function player_added(player_2)
    local function character_removing()
        values_2[player_2] = nil
        local number_3 = 1
        values = {}

        for _, item_3 in pairs(values_2) do
            values[number_3] = item_3
            number_3 += 1
        end
    end

    player_2.CharacterAdded:Connect(function(character)
        values_2[player_2] = character
        local number_3 = 1
        values = {}

        for _, item_3 in pairs(values_2) do
            values[number_3] = item_3
            number_3 += 1
        end
    end)

    player_2.CharacterRemoving:Connect(character_removing)

    if not player_2.Character then
        return
    end

    values_2[player_2] = player_2.Character
    local number_2 = 1
    values = {}

    for _, item_2 in pairs(values_2) do
        values[number_2] = item_2
        number_2 += 1
    end
end

local function player_removing(argument)
    values_2[argument] = nil
    local number_2 = 1
    values = {}

    for _, item_2 in pairs(values_2) do
        values[number_2] = item_2
        number_2 += 1
    end
end

players.PlayerAdded:Connect(player_added)
players.PlayerRemoving:Connect(player_removing)

for _, player in ipairs(players:GetPlayers()) do
    player_added(player)
end

local number = 1
values = {}

for _, item in pairs(values_2) do
    values[number] = item
    number += 1
end

local value_3 = nil
local value_4 = nil

current_camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
    local camera_subject = current_camera.CameraSubject

    if camera_subject:IsA("Humanoid") then
        value_4 = camera_subject.RootPart

        return
    end

    if camera_subject:IsA("BasePart") then
        value_4 = camera_subject

        return
    end

    value_4 = nil
end)

local function can_occlude(argument)
    local can_collide

    if 1 - (1 - argument.Transparency) * (1 - argument.LocalTransparencyModifier) < 0.25 then
        can_collide = argument.CanCollide

        if can_collide then
            if value_3 == (argument:GetRootPart() or argument) then
                can_collide = false
            else
                can_collide = not argument:IsA("TrussPart")
            end
        end
    else
        can_collide = false
    end

    return can_collide
end

local values_3 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2),
}

local function get_collision_point(argument, argument_2)
    local values_count = #values

    while true do
        local hit_part, value_5 =
            workspace:FindPartOnRayWithIgnoreList(ray_new(argument, argument_2), values, false, true)

        if hit_part then
            if hit_part.CanCollide then
                local values_4 = values

                for index = #values_4, values_count + 1, -1 do
                    values_4[index] = nil
                    local _ = index
                end

                return value_5, true
            end

            values[#values + 1] = hit_part
        end

        if not hit_part then
            local values_5 = values

            for index_2 = #values_5, values_count + 1, -1 do
                values_5[index_2] = nil
                local _ = index_2
            end

            return argument + argument_2, false
        end
    end
end

local function query_point(difference, argument, argument_2, argument_3)
    debug.profilebegin("queryPoint")
    local values_count = #values
    local sum = argument_2 + near_plane_z
    local sum_2 = difference + argument * sum
    local difference_2 = difference
    local number_2 = 0
    local quotient_2 = (1 / 0)
    local quotient_3 = (1 / 0)

    while true do
        local hit_part, value_5 =
            workspace:FindPartOnRayWithIgnoreList(ray_new(difference, sum_2 - difference), values, false, true)
        number_2 += 1
        local magnitude

        if hit_part then
            local condition = number_2 >= 64
            local can_collide

            if 1 - (1 - hit_part.Transparency) * (1 - hit_part.LocalTransparencyModifier) < 0.25 then
                can_collide = hit_part.CanCollide

                if can_collide then
                    if value_3 == (hit_part:GetRootPart() or hit_part) then
                        can_collide = false
                    else
                        can_collide = not hit_part:IsA("TrussPart")
                    end
                end
            else
                can_collide = false
            end

            if can_collide or condition then
                local values_4 = { hit_part }
                local part_on_ray_with_whitelist =
                    workspace:FindPartOnRayWithWhitelist(ray_new(sum_2, value_5 - sum_2), values_4, true)
                magnitude = (value_5 - difference_2).Magnitude

                if part_on_ray_with_whitelist and not condition then
                    local part_on_ray_with_whitelist_2

                    if argument_3 then
                        part_on_ray_with_whitelist_2 = workspace:FindPartOnRayWithWhitelist(
                            ray_new(argument_3, sum_2 - argument_3),
                            values_4,
                            true
                        ) or workspace:FindPartOnRayWithWhitelist(
                            ray_new(sum_2, argument_3 - sum_2),
                            values_4,
                            true
                        )
                    else
                        part_on_ray_with_whitelist_2 = false
                    end

                    if part_on_ray_with_whitelist_2 then
                        quotient_2 = magnitude
                        magnitude = quotient_3
                    elseif sum >= quotient_3 then
                        magnitude = quotient_3
                    end
                else
                    quotient_2 = magnitude
                    magnitude = quotient_3
                end
            else
                magnitude = quotient_3
            end

            values[#values + 1] = hit_part
            difference = value_5 - argument * 0.001
        else
            magnitude = quotient_3
        end

        if quotient_2 < (1 / 0) or not hit_part then
            local values_5 = values

            for index = #values_5, values_count + 1, -1 do
                values_5[index] = nil
                local _ = index
            end

            debug.profileend()

            return magnitude - near_plane_z, quotient_2 - near_plane_z
        end

        quotient_3 = magnitude
    end
end

local function query_viewport(argument, argument_2)
    debug.profilebegin("queryViewport")
    local p = argument.p
    local right_vector = argument.rightVector
    local up_vector = argument.upVector
    local negated_value = -argument.lookVector
    local viewport_size2 = current_camera.ViewportSize
    local quotient_2 = (1 / 0)
    local quotient_3 = (1 / 0)

    for index = 0, 1 do
        local product = right_vector * ((index - 0.5) * value)
        local index_3 = index

        for index_2 = 0, 1 do
            local result_2, quotient_4 = query_point(
                p + near_plane_z * (product + up_vector * ((index_2 - 0.5) * value_2)),
                negated_value,
                argument_2,
                current_camera:ViewportPointToRay(viewport_size2.x * index_3, viewport_size2.y * index_2).Origin
            )

            if quotient_4 >= quotient_3 then
                quotient_4 = quotient_3
            end

            local index_4

            if result_2 < quotient_2 then
                index_4 = index_2
                quotient_3 = quotient_4
                quotient_2 = result_2
            else
                index_4 = index_2
                quotient_3 = quotient_4
            end
        end
    end

    debug.profileend()

    return quotient_2, quotient_3
end

local function test_promotion(argument, argument_2, argument_3)
    debug.profilebegin("testPromotion")
    local p = argument.p
    local right_vector = argument.rightVector
    local up_vector = argument.upVector
    local negated_value = -argument.lookVector
    debug.profilebegin("extrapolate")
    local magnitude = (get_collision_point(p, argument_3.posVelocity * 1.25) - p).Magnitude

    for index = 0, math_min(1.25, argument_3.rotVelocity.magnitude + magnitude / argument_3.posVelocity.magnitude), 0.0625 do
        local extrapolate_result = argument_3.extrapolate(index)

        if argument_2 <= query_point(extrapolate_result.p, -extrapolate_result.lookVector, argument_2) then
            return false
        end

        local _ = index
    end

    debug.profileend()
    debug.profilebegin("testOffsets")

    for _, item_2 in ipairs(values_3) do
        local difference = get_collision_point(p, right_vector * item_2.x + up_vector * item_2.y)

        if query_point(difference, (p + negated_value * argument_2 - difference).Unit, argument_2) == (1 / 0) then
            return false
        end
    end

    debug.profileend()
    debug.profileend()

    return true
end

return function(argument, argument_2, argument_3)
    debug.profilebegin("popper")
    value_3 = value_4 and value_4:GetRootPart() or value_4
    local result_2, argument_4 = query_viewport(argument, argument_2)

    if argument_4 >= argument_2 then
        argument_4 = argument_2
    end

    if result_2 < argument_4 then
        if not test_promotion(argument, argument_2, argument_3) then
            result_2 = argument_4
        end
    else
        result_2 = argument_4
    end

    value_3 = nil
    debug.profileend()

    return result_2
end
