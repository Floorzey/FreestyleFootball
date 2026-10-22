game:GetService("Players")
local collection_service = game:GetService("CollectionService")
local script_parent = script.Parent
local cast_attachment = require(script_parent.CastLogics.CastAttachment)
local cast_vector_point = require(script_parent.CastLogics.CastVectorPoint)
local cast_link_attachment = require(script_parent.CastLogics.CastLinkAttachment)
local signal = require(script_parent.Tools.Signal)
local hitbox_object = {}
local instance = {}
instance.__index = instance

function instance.__tostring(argument)
    return string.format("Hitbox for instance %s [%s]", argument.object.Name, argument.object.ClassName)
end

function hitbox_object.new(argument)
    return setmetatable({}, instance)
end

function instance.config(argument, object, filter_descendants_instances)
    argument.active = false
    argument.deleted = false
    argument.partMode = false
    argument.debugMode = false
    argument.points = {}
    argument.targetsHit = {}
    argument.OnHit = signal:Create()
    argument.OnUpdate = signal:Create()
    argument.raycastParams = RaycastParams.new()
    argument.raycastParams.FilterType = Enum.RaycastFilterType.Include
    argument.raycastParams.FilterDescendantsInstances = filter_descendants_instances or {}
    argument.object = object
    collection_service:AddTag(argument.object, "RaycastModuleManaged")
end

function instance.SetPoints(argument, relative_part, argument_2, group)
    if not (relative_part and (relative_part:IsA("BasePart") or relative_part:IsA("MeshPart"))) then
        return
    end

    for _, attachment in ipairs(argument_2) do
        if typeof(attachment) == "Vector3" then
            table.insert(argument.points, {
                LastPosition = nil,
                RelativePart = relative_part,
                Attachment = attachment,
                group = group,
                solver = cast_vector_point,
            })
        end
    end
end

function instance.RemovePoints(argument, argument_2, argument_3)
    if not (argument_2 and (argument_2:IsA("BasePart") or argument_2:IsA("MeshPart"))) then
        return
    end

    for index = 1, #argument.points do
        local point_entry = argument.points[index]
        local index_2 = index

        for _, item in ipairs(argument_3) do
            if
                typeof(point_entry.Attachment) == "Vector3"
                and (point_entry.Attachment == item and point_entry.RelativePart == argument_2)
            then
                argument.points[index_2] = nil
            end
        end
    end
end

function instance.LinkAttachments(argument, attachment, attachment0)
    if not (attachment:IsA("Attachment") and attachment0:IsA("Attachment")) then
        return
    end

    local group = attachment:FindFirstChild("Group")
    local values = {
        RelativePart = nil,
        LastPosition = nil,
        Attachment = attachment,
        Attachment0 = attachment0,
    }

    if group then
        group = group.Value
    end

    values.group = group
    values.solver = cast_link_attachment
    table.insert(argument.points, values)
end

function instance.UnlinkAttachments(argument, argument_2)
    for index, item in ipairs(argument.points) do
        if item.Attachment and item.Attachment == argument_2 then
            table.remove(argument.points, index)

            return
        end
    end
end

function instance.seekAttachments(argument, argument_2, argument_3)
    if #argument.points <= 0 then
        table.insert(argument.raycastParams.FilterDescendantsInstances, workspace.Terrain)
    end

    for _, descendant in ipairs(argument.object:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == argument_2 then
            local group = descendant:FindFirstChild("Group")
            local values = {
                RelativePart = nil,
                LastPosition = nil,
                Attachment = descendant,
            }

            if group then
                group = group.Value
            end

            values.group = group
            values.solver = cast_attachment
            table.insert(argument.points, values)
        end
    end

    if not argument_3 then
        return
    end

    if #argument.points <= 0 then
        warn(
            string.format(
                "\n[[RAYCAST WARNING]]\nNo attachments with the name '%s' were found in %s. No raycasts will be drawn. Can be ignored if you are using SetPoints.",
                argument_2,
                argument.object.Name
            )
        )

        return
    end

    print(
        string.format(
            "\n[[RAYCAST MESSAGE]]\n\nCreated Hitbox for %s - Attachments found: %s",
            argument.object.Name,
            #argument.points
        )
    )
end

function instance.Destroy(argument)
    if argument.deleted then
        return
    end

    if argument.OnHit then
        argument.OnHit:Delete()
    end

    if argument.OnUpdate then
        argument.OnUpdate:Delete()
    end

    argument.points = nil
    argument.active = false
    argument.deleted = true
end

function instance.HitStart(argument)
    argument.active = true
end

function instance.HitStop(argument)
    if argument.deleted then
        return
    end

    argument.active = false
    table.clear(argument.targetsHit)
end

function instance.PartMode(argument, part_mode)
    argument.partMode = part_mode
end

function instance.DebugMode(argument, debug_mode)
    argument.debugMode = debug_mode
end

return hitbox_object
