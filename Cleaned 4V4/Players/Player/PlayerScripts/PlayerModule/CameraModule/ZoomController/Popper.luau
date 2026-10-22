local players = game:GetService("Players")
local current_camera = game.Workspace.CurrentCamera
local min = math.min
local tan = math.tan
local to_radians = math.rad
local new = Ray.new

local function get_total_transparency(argument)
    return 1 - ((1 - argument.Transparency) * (1 - argument.LocalTransparencyModifier))
end

local function erase_from_end(argument, argument_2)
    for n = #argument, argument_2 + 1, -1 do
        argument[n] = nil
    end
end

local value = nil
local value_2 = nil

local function update_projection()
    local result_3 = to_radians(current_camera.FieldOfView)
    local viewport_size_2 = current_camera.ViewportSize
    value_2 = tan(result_3 / 2) * 2
    value = (viewport_size_2.X / viewport_size_2.Y) * value_2
end

current_camera:GetPropertyChangedSignal("FieldOfView"):Connect(update_projection)
current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(update_projection)
local result = to_radians(current_camera.FieldOfView)
local viewport_size = current_camera.ViewportSize
local result_2 = tan(result / 2)
value_2 = result_2 * 2
value = viewport_size.X / viewport_size.Y * value_2
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
    local function character_added(argument)
        values_2[player_2] = argument
        local number_4 = 1
        values = {}

        for _, item_3 in pairs(values_2) do
            values[number_4] = item_3
            number_4 += 1
        end
    end

    local function character_removing()
        values_2[player_2] = nil
        local number_4 = 1
        values = {}

        for _, item_3 in pairs(values_2) do
            values[number_4] = item_3
            number_4 += 1
        end
    end

    player_2.CharacterAdded:Connect(character_added)
    player_2.CharacterRemoving:Connect(character_removing)

    if not player_2.Character then
        return
    end

    values_2[player_2] = player_2.Character
    local number_2 = 1
    values = {}
    local number_3 = number_2

    for _, item_2 in pairs(values_2) do
        values[number_3] = item_2
        number_3 += 1
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
result_2 = number

for _, item in pairs(values_2) do
    values[result_2] = item
    result_2 += 1
end

result = nil
local value_3 = nil

current_camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
    local camera_subject = current_camera.CameraSubject

    if camera_subject:IsA("Humanoid") then
        value_3 = camera_subject.RootPart
    elseif camera_subject:IsA("BasePart") then
        value_3 = camera_subject
    else
        value_3 = nil
    end
end)

local function can_occlude(argument)
    return (1 - ((1 - argument.Transparency) * (1 - argument.LocalTransparencyModifier)) < 0.25)
        and (
            argument.CanCollide
            and ((result ~= (argument:GetRootPart() or argument)) and (not argument:IsA("TrussPart")))
        )
end

local values_3 =
    { Vector2.new(0.4, 0), Vector2.new(-0.4, 0), Vector2.new(0, -0.4), Vector2.new(0, 0.4), Vector2.new(0, 0.2) }

local function get_collision_point(argument, argument_2)
    local values_count = #values
    local value_4 = nil

    while true do
        local hit_part, value_5 = workspace:FindPartOnRayWithIgnoreList(new(argument, argument_2), values, false, true)

        if hit_part then
            if hit_part.CanCollide then
                for n = #values, values_count + 1, -1 do
                    values[n] = nil
                end

                return value_5, true
            end

            values[#values + 1] = hit_part
        end

        if hit_part then
            continue
        end

        for n_2 = #values, values_count + 1, -1 do
            values[n_2] = nil
        end

        return argument + argument_2, false
    end
end

local function query_point(argument, argument_2, sum, argument_3)
    debug.profilebegin("queryPoint")
    local values_count = #values
    sum += near_plane_z
    local sum_2 = argument + argument_2 * sum
    local huge = math.huge
    local huge_2 = math.huge
    local number_2 = 0
    local argument_4 = argument
    local value_4 = nil
    local hit_part

    repeat
        local value_5
        hit_part, value_5 =
            workspace:FindPartOnRayWithIgnoreList(new(argument_4, sum_2 - argument_4), values, false, true)
        number_2 += 1

        if hit_part then
            local condition = number_2 >= 64
            local condition_2 = 1 - (1 - hit_part.Transparency) * (1 - hit_part.LocalTransparencyModifier) < 0.25
                and hit_part.CanCollide
                and result ~= (hit_part:GetRootPart() or hit_part)
                and not hit_part:IsA("TrussPart")

            if condition_2 or condition then
                local values_4 = { hit_part }
                local part_on_ray_with_whitelist =
                    workspace:FindPartOnRayWithWhitelist(new(sum_2, value_5 - sum_2), values_4, true)
                local magnitude = (value_5 - argument).Magnitude

                if not part_on_ray_with_whitelist or condition then
                    huge_2 = magnitude
                    values[#values + 1] = hit_part
                    argument_4 = value_5 - argument_2 * 0.001

                    if huge_2 < math.huge or not hit_part then
                        break
                    end
                end

                value_4 = false

                if argument_3 then
                    value_4 = workspace:FindPartOnRayWithWhitelist(new(argument_3, sum_2 - argument_3), values_4, true)
                        or workspace:FindPartOnRayWithWhitelist(new(sum_2, argument_3 - sum_2), values_4, true)
                end

                if value_4 then
                    huge_2 = magnitude
                elseif sum < huge then
                    huge = magnitude
                end

                values[#values + 1] = hit_part
                argument_4 = value_5 - argument_2 * 0.001

                if huge_2 < math.huge or not hit_part then
                    break
                end
            end

            values[#values + 1] = hit_part
            argument_4 = value_5 - argument_2 * 0.001
        end

        if huge_2 < math.huge then
            break
        end
    until not hit_part

    for n = #values, values_count + 1, -1 do
        values[n] = nil
    end

    debug.profileend()

    return huge - near_plane_z, huge_2 - near_plane_z
end

local function query_viewport(argument, sum)
    debug.profilebegin("queryViewport")
    local p = argument.p
    local right_vector = argument.rightVector
    local up_vector = argument.upVector
    local viewport_size_2 = current_camera.ViewportSize
    local huge = math.huge
    local huge_2 = math.huge

    for n = 0, 1 do
        local product = right_vector * ((n - 0.5) * value)

        for n_2 = 0, 1 do
            local result_3, value_4 = query_point(
                p + (near_plane_z * (product + (up_vector * ((n_2 - 0.5) * value_2)))),
                -argument.lookVector,
                sum,
                current_camera:ViewportPointToRay(viewport_size_2.x * n, viewport_size_2.y * n_2).Origin
            )

            if value_4 < huge then
                huge = value_4
            end

            if result_3 < huge_2 then
                huge_2 = result_3
            end
        end
    end

    debug.profileend()

    return huge_2, huge
end

local function test_promotion(argument, sum, argument_2)
    debug.profilebegin("testPromotion")
    local p = argument.p
    local right_vector = argument.rightVector
    local up_vector = argument.upVector
    debug.profilebegin("extrapolate")

    for n = 0, min(
        1.25,
        argument_2.rotVelocity.magnitude
            + ((get_collision_point(p, argument_2.posVelocity * 1.25) - p).Magnitude / argument_2.posVelocity.magnitude)
    ), 0.0625 do
        local extrapolate_result = argument_2.extrapolate(n)

        if not (sum <= query_point(extrapolate_result.p, -extrapolate_result.lookVector, sum)) then
            continue
        end

        return false
    end

    debug.profileend()
    debug.profilebegin("testOffsets")

    for _, item_2 in ipairs(values_3) do
        local result_3 = get_collision_point(p, (right_vector * item_2.x) + (up_vector * item_2.y))

        if query_point(result_3, ((p + (-argument.lookVector * sum)) - result_3).Unit, sum) ~= math.huge then
            continue
        end

        return false
    end

    debug.profileend()
    debug.profileend()

    return true
end

local function popper(argument, argument_2, argument_3)
    debug.profilebegin("popper")
    local root_part = (value_3 and value_3:GetRootPart()) or value_3
    result = root_part
    local result_3, value_4 = query_viewport(argument, argument_2)

    if value_4 < argument_2 then
    end

    if (result_3 < argument_2) and test_promotion(argument, argument_2, argument_3) then
    end

    result = nil
    debug.profileend()

    return argument_2
end

return popper
