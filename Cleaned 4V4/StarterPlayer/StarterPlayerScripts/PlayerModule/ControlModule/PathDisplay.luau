local path_display = {}
path_display.spacing = 8
path_display.image = "rbxasset://textures/Cursors/Gamepad/Pointer.png"
path_display.imageSize = Vector2.new(2, 2)
local values = {}
local values_2 = {}
local path_display_points = Instance.new("Model")
path_display_points.Name = "PathDisplayPoints"
local path_display_adornee = Instance.new("Part")
path_display_adornee.Anchored = true
path_display_adornee.CanCollide = false
path_display_adornee.Transparency = 1
path_display_adornee.Name = "PathDisplayAdornee"
path_display_adornee.CFrame = CFrame.new(0, 0, 0)
path_display_adornee.Parent = path_display_points
local values_3 = {}
local number = 30

for n = 1, number do
    local image_handle_adornment = Instance.new("ImageHandleAdornment")
    image_handle_adornment.Archivable = false
    image_handle_adornment.Adornee = path_display_adornee
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

    local hit_part, value, value_entry = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(argument + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0)),
        { game.Players.LocalPlayer.Character, workspace.CurrentCamera }
    )

    if not hit_part then
        return nil
    end

    local cframe = CFrame.new(value, value + value_entry)
    local value_entry_2 = values_3[1]

    if value_entry_2 then
        local number_2 = number
        values_3[1] = values_3[number]
        values_3[number_2] = nil
        number = number - 1
        value_entry = value_entry_2
    else
        value_entry = nil
    end

    value_entry.CFrame = cframe
    value_entry.Parent = path_display_points

    return value_entry
end

function path_display.setCurrentPoints(argument)
    if typeof(argument) ~= "table" then
        values = {}
    else
        values = argument
    end
end

function path_display.clearRenderedPath()
    for _, item in ipairs(values_2) do
        item.Parent = nil
        number = number + 1
        values_3[number] = item
    end

    values_2 = {}
    path_display_points.Parent = nil
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

        local difference = value_entry_2 - value_entry
        local magnitude = difference.magnitude

        if magnitude < number_2 then
            local difference_2 = number_2 - magnitude
            values_count = values_count - 1
            number_2 = difference_2
            continue
        end

        local result = render_point(value_entry + (difference.unit * number_2), false)

        if result then
            values_2[#values_2 + 1] = result
        end

        number_2 = number_2 + path_display.spacing
    end

    path_display_points.Parent = workspace.CurrentCamera
end

return path_display
