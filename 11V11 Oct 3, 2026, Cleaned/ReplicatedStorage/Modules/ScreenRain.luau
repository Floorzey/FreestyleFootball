local properties = { UpdateFreq = 0.022222222222222223, Fade = 1.5, Rate = 8, Size = 0.09 }
properties.Tint = Color3.fromRGB(226, 244, 255)
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local object_pool = require(script.ObjectPool)
local current_camera = workspace.CurrentCamera
local local_player = players.LocalPlayer
local game_settings = UserSettings().GameSettings
local is_saved_quality_level_value = game_settings.SavedQualityLevel.Value >= 8
game_settings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()
    local enabled = true
    if not (game_settings.SavedQualityLevel.Value >= 8) then
        enabled = game_settings.SavedQualityLevel.Value == 0
    end
    is_saved_quality_level_value = enabled
end)
properties.Rate = properties.Rate or 5
properties.Size = properties.Size or 1.5
properties.Tint = properties.Tint or Color3.fromRGB(226, 244, 255)
properties.Fade = properties.Fade or 1.5
properties.UpdateFreq = properties.UpdateFreq or 0.022222222222222223
local values = {}
local number = 0

local function add_to_ignore(argument)
    if argument then
        local number_offset_3 = number + 1
        number = number + 1
        values[number_offset_3] = argument
        local _ = nil
        local connection_4 = argument.AncestryChanged:Connect(function() end)
        _ = connection_4
    end
end

local character = local_player.Character
if character then
    local number_offset = number + 1
    number = number + 1
    values[number_offset] = character
    local _ = nil
    local connection = character.AncestryChanged:Connect(function() end)
    _ = connection
end
local_player.CharacterAdded:Connect(add_to_ignore)
local folder = Instance.new("Folder")
folder.Name = "ScreenDroplets"
folder.Parent = current_camera
if folder then
    local number_offset_2 = number + 1
    number = number + 1
    values[number_offset_2] = folder
    local connection_3 = nil
    local connection_2 = folder.AncestryChanged:Connect(function()
        if folder:IsDescendantOf(game) then
            return
        end
        connection_3:Disconnect()
        values[number_offset_2] = values[number]
        values[number] = nil
        number = number - 1
    end)
    connection_3 = connection_2
end
local values_2 = {}
local values_3 = {}
local cframe = current_camera.CFrame
local rate_offset_offset = properties.Rate * properties.Fade * 3
run_service:BindToRenderStep("ScreenRainUpdate", Enum.RenderPriority.Camera.Value + 2, function()
    cframe = current_camera.CFrame
    local create_result = table.create(rate_offset_offset)
    local create_result_2 = table.create(rate_offset_offset)
    local number_2 = 0
    local tan_result_offset = math.tan(math.rad(current_camera.FieldOfView * 0.5)) / 0.7002075382097097
    for key, item in pairs(values_3) do
        local number_offset_3 = number_2 + 1
        local position = item.Position
        local cframe_2 =
            CFrame.new(Vector3.new(position.X * tan_result_offset, position.Y * tan_result_offset, position.Z))
        create_result_2[number_offset_3] = cframe * (cframe_2 * (item - item.Position))
        create_result[number_offset_3] = key
        number_2 = number_offset_3
    end
    rate_offset_offset = number_2
    workspace:BulkMoveTo(create_result, create_result_2, Enum.BulkMoveMode.FireCFrameChanged)
end)
local part = Instance.new("Part")
part.Name = "Droplet"
part.Material = Enum.Material.Glass
part.CastShadow = false
part.CanCollide = false
part.CanQuery = false
part.CanTouch = false
part.Anchored = true
part.Transparency = 0.5
part.Color = properties.Tint
part.Size = Vector3.new(1, 1, 1)
local new = Instance.new
local result = new("SpecialMesh")
result.Name = "Mesh"
result.MeshType = Enum.MeshType.Sphere
result.Parent = part
local object_pool_2 = object_pool.new(part, (properties.Rate * properties.Fade) * 3)

local function cleanup(argument)
    values_2[argument] = nil
    values_3[argument] = nil
    object_pool_2:Return(argument)
end

local function under_object(argument, number_2)
    number_2 = number_2 or 120
    local hit_part, value =
        workspace:FindPartOnRayWithIgnoreList(Ray.new(argument, Vector3.new(0, 1, 0) * number_2), values)
    if hit_part then
        if hit_part.Transparency == 1 then
            return (under_object(value + Vector3.new(0, 1, 0), number_2 - (argument - value).Magnitude))
        end
        return true
    end
    return false
end

local function create_droplet()
    local scale = properties.Size + math.random((properties.Size / 3) * -10, (properties.Size / 3) * 10) / 10
    local value = object_pool_2:Get()
    value.Mesh.Scale = Vector3.new(scale, scale, scale)
    value.Mesh.Offset = Vector3.new(0, 0, 0)
    value.Color = properties.Tint
    value.Transparency = 0.7
    local cframe_2 = CFrame.new(math.random(-120, 120) / 100, math.random(-100, 100) / 100, -1)
    values_3[value] = cframe_2
    values_2[value] =
        { startClock = os.clock(), scale = scale, stretch = (math.random(5, 10) / 10) * scale, mesh = value.Mesh }
    value.Parent = folder
    for _ = 1, math.random(4) do
        local scale_2 = scale / 1.5 + math.random((scale / 3) * -100, (scale / 3) * 100) / 100
        local value_2 = object_pool_2:Get()
        value_2.Mesh.Scale = Vector3.new(scale_2, scale_2, scale_2)
        value_2.Mesh.Offset = Vector3.new(0, 0, 0)
        value_2.Color = properties.Tint
        value_2.Transparency = 0.7
        local scale_offset = scale_2 * 60
        values_3[value_2] = cframe_2
            * CFrame.new(
                math.random(-scale_offset, scale_offset) / 100,
                math.random(-scale_offset, scale_offset) / 100,
                0
            )
        values_2[value_2] = {
            startClock = os.clock(),
            scale = scale_2,
            stretch = (math.random(5, 10) / 10) * scale_2,
            mesh = value_2.Mesh,
        }
        value_2.Parent = folder
    end
end

local screen_rain = { Enabled = false, _activeUpdater = false }

function screen_rain.Enable(self, argument)
    self.Enabled = true
    self:Configure(argument)
    if self._activeUpdater then
        return
    end
    self._activeUpdater = true
    local number_2 = 0
    task.defer(function()
        print("spawned updater")
        local timestamp = os.clock()
        local value = nil
        while task.wait(properties.UpdateFreq) do
            if self.Enabled or next(values_2) then
                debug.profilebegin("ScreenRainUpdate")
                local timestamp_2 = os.clock()
                debug.profilebegin("Animations")
                for key, item in pairs(values_2) do
                    local timestamp_offset = timestamp_2 - item.startClock
                    if properties.Fade <= timestamp_offset then
                        values_2[key] = nil
                        values_3[key] = nil
                        object_pool_2:Return(key)
                    else
                        local mesh = item.mesh
                        local scale = item.scale
                        local timestamp_offset_offset = timestamp_offset / properties.Fade
                        local scale_offset = scale
                            + item.stretch
                                * (((timestamp_offset_offset * timestamp_offset_offset) * timestamp_offset_offset) * timestamp_offset_offset)
                        key.Transparency = 0.7 + (0.3 * (timestamp_offset_offset * timestamp_offset_offset))
                        mesh.Scale = Vector3.new(scale, scale_offset, scale)
                        mesh.Offset = Vector3.new(0, scale_offset / -2, 0)
                    end
                end
                debug.profileend()
                debug.profilebegin("Droplet Creation")
                if not self.Enabled or not is_saved_quality_level_value or not (cframe.LookVector.Y > -0.4) then
                    number_2 = number_2 % 1
                    debug.profileend()
                    debug.profileend()
                    timestamp = timestamp_2
                    continue
                end
                local position = cframe.Position
                local number_3 = nil or 120
                local hit_part, value_2 =
                    workspace:FindPartOnRayWithIgnoreList(Ray.new(position, Vector3.new(0, 1, 0) * number_3), values)
                if hit_part then
                    value = ((hit_part.Transparency ~= 1) and true)
                        or (under_object(value_2 + Vector3.new(0, 1, 0), number_3 - (position - value_2).Magnitude))
                else
                    value = false
                end
                if value then
                    number_2 = number_2 % 1
                    debug.profileend()
                    debug.profileend()
                    timestamp = timestamp_2
                    continue
                end
                number_2 = number_2 + ((timestamp_2 - timestamp) * properties.Rate)
                for _ = 1, math.floor(number_2) do
                    create_droplet()
                end
                number_2 = number_2 % 1
                debug.profileend()
                debug.profileend()
                timestamp = timestamp_2
                continue
            else
                self._activeUpdater = false
                print("closed updater")
                return
            end
        end
    end)
end

function screen_rain.Disable(self)
    self.Enabled = false
end

function screen_rain.Configure(self, argument)
    if type(argument) ~= "table" then
        return
    end
    for key, item in pairs(argument) do
        print(key, item)
        properties[key] = item
    end
end

return screen_rain
