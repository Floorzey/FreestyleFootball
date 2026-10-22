local path_display = {
    spacing = 8,
    image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
    imageSize = Vector2.new(2, 2),
}
local model = Instance.new("Model")
model.Name = "PathDisplayPoints"
local path_display_adornee = Instance.new("Part")
path_display_adornee.Anchored = true
path_display_adornee.CanCollide = false
path_display_adornee.Transparency = 1
path_display_adornee.Name = "PathDisplayAdornee"
path_display_adornee.CFrame = CFrame.new(0, 0, 0)
path_display_adornee.Parent = model
local number = 30
local values = {}
local values_2 = {}
local values_3 = {}

for index = 1, number do
    local image_handle_adornment = Instance.new("ImageHandleAdornment")
    image_handle_adornment.Archivable = false
    image_handle_adornment.Adornee = path_display_adornee
    image_handle_adornment.Image = path_display.image
    image_handle_adornment.Size = path_display.imageSize
    values[index] = image_handle_adornment
    local _ = index
end

local function retrieve_from_pool()
    local value_entry = values[1]

    if not value_entry then
        return nil
    end

    values[1] = values[number]
    values[number] = nil
    number = number - 1

    return value_entry
end

local function return_to_pool(argument: userdata)
    number = number + 1
    values[number] = argument
end

local function render_point(argument: vector, argument_2: any)
    if number == 0 then
        return nil
    end

    local ray = Ray.new(argument + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0))
    local hit_part, value, value_2 =
        workspace:FindPartOnRayWithIgnoreList(ray, { game.Players.LocalPlayer.Character, workspace.CurrentCamera })

    if not hit_part then
        return nil
    end

    local cframe = CFrame.new(value, value + value_2)
    local value_entry = values[1]

    if value_entry then
        values[1] = values[number]
        values[number] = nil
        number = number - 1
    else
        value_entry = nil
    end

    value_entry.CFrame = cframe
    value_entry.Parent = model

    return value_entry
end

function path_display.setCurrentPoints(argument)
    if typeof(argument) == "table" then
        values_2 = argument

        return
    end

    values_2 = {}
end

function path_display.clearRenderedPath()
    for _, item in ipairs(values_3) do
        item.Parent = nil
        number = number + 1
        values[number] = item
    end

    values_3 = {}
    model.Parent = nil
end

function path_display.renderPath()
    path_display.clearRenderedPath()

    if not values_2 or #values_2 == 0 then
        return
    end

    local values_count = #values_2
    values_3[1] = render_point(values_2[values_count], true)

    if not values_3[1] then
        return
    end

    local number_2 = 0

    while true do
        local value_entry = values_2[values_count]

        if values_count < 2 then
            break
        end

        local difference = values_2[values_count - 1] - value_entry
        local magnitude = difference.magnitude

        if magnitude < number_2 then
            number_2 = number_2 - magnitude
            values_count = values_count - 1
        else
            local result = render_point(value_entry + difference.unit * number_2, false)

            if result then
                values_3[#values_3 + 1] = result
            end

            number_2 = number_2 + path_display.spacing
        end
    end

    model.Parent = workspace.CurrentCamera
end

return path_display
