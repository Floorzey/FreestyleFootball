local properties = {
    Rate = 8,
    Size = 0.09,
    Fade = 1.5,
    UpdateFreq = 0.022222222222222223,
    Tint = Color3.fromRGB(226, 244, 255),
}
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local script_object_pool = require(script.ObjectPool)
local workspace_current_camera = workspace.CurrentCamera
local local_player = players.LocalPlayer
local game_settings = UserSettings().GameSettings
local condition = game_settings.SavedQualityLevel.Value >= 8

game_settings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()
    condition = game_settings.SavedQualityLevel.Value >= 8 and true or game_settings.SavedQualityLevel.Value == 0
end)

properties.Rate = properties.Rate or 5
properties.Size = properties.Size or 1.5
properties.Tint = properties.Tint or Color3.fromRGB(226, 244, 255)
properties.Fade = properties.Fade or 1.5
properties.UpdateFreq = properties.UpdateFreq or 0.022222222222222223
local values = {}
local number = 0

local function add_to_ignore(instance: userdata?)
    if not instance then
        return
    end

    local sum_3 = number + 1
    number = number + 1
    values[sum_3] = instance
    local connection_3 = nil
    connection_3 = instance.AncestryChanged:Connect(function()
        if instance:IsDescendantOf(game) then
            return
        end

        connection_3:Disconnect()
        values[sum_3] = values[number]
        values[number] = nil
        number = number - 1
    end)
end

local character = local_player.Character

if character then
    local sum = number + 1
    number = number + 1
    values[sum] = character
    local connection = nil
    connection = character.AncestryChanged:Connect(function()
        if character:IsDescendantOf(game) then
            return
        end

        connection:Disconnect()
        values[sum] = values[number]
        values[number] = nil
        number = number - 1
    end)
end

local_player.CharacterAdded:Connect(add_to_ignore)
local screen_droplets = Instance.new("Folder")
screen_droplets.Name = "ScreenDroplets"
screen_droplets.Parent = workspace_current_camera

if screen_droplets then
    local sum_2 = number + 1
    number = number + 1
    values[sum_2] = screen_droplets
    local connection_2 = nil
    connection_2 = screen_droplets.AncestryChanged:Connect(function()
        if screen_droplets:IsDescendantOf(game) then
            return
        end

        connection_2:Disconnect()
        values[sum_2] = values[number]
        values[number] = nil
        number = number - 1
    end)
end

local values_2 = {}
local values_3 = {}
local c_frame2 = workspace_current_camera.CFrame
local product = properties.Rate * properties.Fade * 3

run_service:BindToRenderStep("ScreenRainUpdate", Enum.RenderPriority.Camera.Value + 2, function()
    c_frame2 = workspace_current_camera.CFrame
    local create_result = table.create(product)
    local create_result_2 = table.create(product)
    local radians = math.rad(workspace_current_camera.FieldOfView * 0.5)
    local quotient = math.tan(radians) / 0.7002075382097097
    local number_2 = 0

    for key, item in pairs(values_3) do
        number_2 = number_2 + 1
        local position = item.Position
        create_result_2[number_2] = c_frame2
            * (
                CFrame.new((Vector3.new(position.X * quotient, position.Y * quotient, position.Z)))
                * (item - item.Position)
            )
        create_result[number_2] = key
    end

    product = number_2
    workspace:BulkMoveTo(create_result, create_result_2, Enum.BulkMoveMode.FireCFrameChanged)
end)

local droplet = Instance.new("Part")
droplet.Name = "Droplet"
droplet.Material = Enum.Material.Glass
droplet.CastShadow = false
droplet.CanCollide = false
droplet.CanQuery = false
droplet.CanTouch = false
droplet.Anchored = true
droplet.Transparency = 0.5
droplet.Color = properties.Tint
droplet.Size = Vector3.new(1, 1, 1)
local special_mesh = Instance.new("SpecialMesh")
special_mesh.Name = "Mesh"
special_mesh.MeshType = Enum.MeshType.Sphere
special_mesh.Parent = droplet
local script_object_pool_2 = script_object_pool.new(droplet, properties.Rate * properties.Fade * 3)

local function cleanup(argument: userdata)
    values_2[argument] = nil
    values_3[argument] = nil
    script_object_pool_2:Return(argument)
end

local function under_object(argument, argument_2)
    local number_2 = argument_2 or 120
    local hit_part, value =
        workspace:FindPartOnRayWithIgnoreList(Ray.new(argument, Vector3.new(0, 1, 0) * number_2), values)

    if hit_part then
        return hit_part.Transparency ~= 1 and true
            or under_object(value + Vector3.new(0, 1, 0), number_2 - (argument - value).Magnitude)
    end

    return false
end

local function create_droplet()
    local scale = properties.Size + math.random(properties.Size / 3 * -10, properties.Size / 3 * 10) / 10
    local value = script_object_pool_2:Get()
    value.Mesh.Scale = Vector3.new(scale, scale, scale)
    value.Mesh.Offset = Vector3.new(0, 0, 0)
    value.Color = properties.Tint
    value.Transparency = 0.7
    local cframe = CFrame.new(math.random(-120, 120) / 100, math.random(-100, 100) / 100, -1)
    values_3[value] = cframe
    values_2[value] = {
        startClock = os.clock(),
        scale = scale,
        stretch = math.random(5, 10) / 10 * scale,
        mesh = value.Mesh,
    }
    value.Parent = screen_droplets

    for index = 1, math.random(4) do
        local scale_2 = scale / 1.5 + math.random(scale / 3 * -100, scale / 3 * 100) / 100
        local value_2 = script_object_pool_2:Get()
        value_2.Mesh.Scale = Vector3.new(scale_2, scale_2, scale_2)
        value_2.Mesh.Offset = Vector3.new(0, 0, 0)
        value_2.Color = properties.Tint
        value_2.Transparency = 0.7
        local product_2 = scale_2 * 60
        values_3[value_2] = cframe
            * CFrame.new(math.random(-product_2, product_2) / 100, math.random(-product_2, product_2) / 100, 0)
        values_2[value_2] = {
            startClock = os.clock(),
            scale = scale_2,
            stretch = math.random(5, 10) / 10 * scale_2,
            mesh = value_2.Mesh,
        }
        value_2.Parent = screen_droplets
        local _ = index
    end
end

return {
    Enabled = false,
    _activeUpdater = false,

    Enable = function(argument, argument_2)
        argument.Enabled = true
        argument:Configure(argument_2)

        if argument._activeUpdater then
            return
        end

        argument._activeUpdater = true
        local number_2 = 0

        task.defer(function()
            print("spawned updater")
            local timestamp = os.clock()

            while true do
                if not task.wait(properties.UpdateFreq) then
                    return
                end

                if not (argument.Enabled or next(values_2)) then
                    argument._activeUpdater = false
                    print("closed updater")

                    return
                end

                debug.profilebegin("ScreenRainUpdate")
                local timestamp_2 = os.clock()
                debug.profilebegin("Animations")

                for key, item in pairs(values_2) do
                    local difference = timestamp_2 - item.startClock

                    if properties.Fade <= difference then
                        values_2[key] = nil
                        values_3[key] = nil
                        script_object_pool_2:Return(key)
                    else
                        local mesh = item.mesh
                        local scale = item.scale
                        local quotient = difference / properties.Fade
                        local sum_3 = scale + item.stretch * (quotient * quotient * quotient * quotient)
                        key.Transparency = 0.7 + 0.3 * (quotient * quotient)
                        mesh.Scale = Vector3.new(scale, sum_3, scale)
                        mesh.Offset = Vector3.new(0, sum_3 / -2, 0)
                    end
                end

                debug.profileend()
                debug.profilebegin("Droplet Creation")

                if argument.Enabled and (condition and c_frame2.LookVector.Y > -0.4) then
                    local position = c_frame2.Position
                    local number_3 = nil or 120
                    local hit_part, value = workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(position, Vector3.new(0, 1, 0) * number_3),
                        values
                    )
                    local enabled

                    if hit_part then
                        enabled = hit_part.Transparency ~= 1 and true
                            or under_object(value + Vector3.new(0, 1, 0), number_3 - (position - value).Magnitude)
                    else
                        enabled = false
                    end

                    if enabled then
                        number_2 = number_2 % 1
                    else
                        number_2 = number_2 + (timestamp_2 - timestamp) * properties.Rate

                        for index = 1, math.floor(number_2) do
                            create_droplet()
                            local _ = index
                        end

                        number_2 = number_2 % 1
                    end
                else
                    number_2 = number_2 % 1
                end

                debug.profileend()
                debug.profileend()
                timestamp = timestamp_2
            end
        end)
    end,

    Disable = function(argument)
        argument.Enabled = false
    end,

    Configure = function(argument, argument_2)
        if type(argument_2) == "table" then
            for key, item in pairs(argument_2) do
                print(key, item)
                properties[key] = item
            end
        end
    end,
}
