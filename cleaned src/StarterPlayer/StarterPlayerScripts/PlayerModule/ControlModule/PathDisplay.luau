local path_display = {}
path_display.spacing = 8
path_display.image = "rbxasset://textures/Cursors/Gamepad/Pointer.png"
path_display.imageSize = Vector2.new(2, 2)
local values = {}
local values_2 = {}
local model = Instance.new("Model")
model.Name = "PathDisplayPoints"
local part = Instance.new("Part")
part.Anchored = true
part.CanCollide = false
part.Transparency = 1
part.Name = "PathDisplayAdornee"
part.CFrame = CFrame.new(0, 0, 0)
part.Parent = model
local values_3 = {}
local number = 30
for n = 1, number do
    local image_handle_adornment = Instance.new("ImageHandleAdornment")
    image_handle_adornment.Archivable = false
    image_handle_adornment.Adornee = part
    image_handle_adornment.Image = path_display.image
    image_handle_adornment.Size = path_display.imageSize
    values_3[n] = image_handle_adornment
end

local function retrieve_from_pool()
    local value_entry = values_3[1]
    if not value_entry then
        return nil
    end
    local number_2 = number
    values_3[1] = values_3[number]
    values_3[number_2] = nil
    number = number - 1
    return value_entry
end

local function return_to_pool(argument)
    number = number + 1
    values_3[number] = argument
end

local function render_point(argument, argument_2)
    if number == 0 then
        return nil
    end
    local hit_part, value, value_2 = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(argument + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0)),
        { game.Players.LocalPlayer.Character, workspace.CurrentCamera }
    )
    if not hit_part then
        return nil
    end
    local cframe = CFrame.new(value, value + value_2)
    local value_entry = values_3[1]
    local value_entry_2
    if value_entry then
        local number_2 = number
        values_3[1] = values_3[number]
        values_3[number_2] = nil
        number = number - 1
        value_entry_2 = value_entry
    else
        value_entry_2 = nil
    end
    value_entry_2.CFrame = cframe
    value_entry_2.Parent = model
    return value_entry_2
end

function path_display.setCurrentPoints(self)
    if typeof(self) ~= "table" then
        values = {}
    else
        values = self
    end
end

function path_display.clearRenderedPath()
    for _, item in ipairs(values_2) do
        item.Parent = nil
        number = number + 1
        values_3[number] = item
    end
    values_2 = {}
    model.Parent = nil
end

function path_display.renderPath()
    path_display.clearRenderedPath()
    if not values or #values == 0 then
        return
    end
    local values_count = #values
    local number_2 = 0
    values_2[1] = render_point(values[values_count], true)
    if not values_2[1] then
        return
    end
    while true do
        local value_entry = values[values_count]
        local value_entry_2 = values[values_count - 1]
        if values_count < 2 then
            break
        end
        local value_entry_offset = value_entry_2 - value_entry
        local magnitude = value_entry_offset.magnitude
        if magnitude < number_2 then
            local number_offset = number_2 - magnitude
            values_count = values_count - 1
            number_2 = number_offset
            continue
        end
        local result = render_point(value_entry + (value_entry_offset.unit * number_2), false)
        if result then
            values_2[#values_2 + 1] = result
        end
        number_2 = number_2 + path_display.spacing
    end
    model.Parent = workspace.CurrentCamera
end

return path_display
