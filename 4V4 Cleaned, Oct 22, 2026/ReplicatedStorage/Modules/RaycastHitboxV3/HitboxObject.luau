local _ = game:GetService("Players")
local collection_service = game:GetService("CollectionService")
local parent = script.Parent
local cast_attachment = require(parent.CastLogics.CastAttachment)
local cast_vector_point = require(parent.CastLogics.CastVectorPoint)
local cast_link_attachment = require(parent.CastLogics.CastLinkAttachment)
local signal = require(parent.Tools.Signal)
local hitbox_object = {}
local instance = {}
instance.__index = instance

function instance.__tostring(argument)
    return string.format("Hitbox for instance %s [%s]", argument.object.Name, argument.object.ClassName)
end

function hitbox_object.new(argument)
    return (setmetatable({}, instance))
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
    if not relative_part then
        return
    end

    if not (relative_part:IsA("BasePart") or relative_part:IsA("MeshPart")) then
        return
    end

    for _, attachment in ipairs(argument_2) do
        if typeof(attachment) == "Vector3" then
            table.insert(
                argument.points,
                { RelativePart = relative_part, Attachment = attachment, group = group, solver = cast_vector_point }
            )
        end
    end
end

function instance.RemovePoints(argument, argument_2, argument_3)
    if not argument_2 then
        return
    end

    if not (argument_2:IsA("BasePart") or argument_2:IsA("MeshPart")) then
        return
    end

    for n = 1, #argument.points do
        local point_entry = argument.points[n]

        for _, item in ipairs(argument_3) do
            if typeof(point_entry.Attachment) ~= "Vector3" or point_entry.Attachment ~= item then
                continue
            end

            if point_entry.RelativePart == argument_2 then
                argument.points[n] = nil
            end
        end
    end
end

function instance.LinkAttachments(argument, attachment, attachment0)
    if not attachment:IsA("Attachment") then
        return
    end

    if not (attachment0:IsA("Attachment")) then
        return
    end

    local group = attachment:FindFirstChild("Group")
    local values = { group = 0, solver = 0 }
    values.Attachment = attachment
    values.Attachment0 = attachment0
    values.group = group and group.Value
    values.solver = cast_link_attachment
    table.insert(argument.points, values)
end

function instance.UnlinkAttachments(argument, argument_2)
    for index, item in ipairs(argument.points) do
        if not item.Attachment or item.Attachment ~= argument_2 then
            continue
        end

        table.remove(argument.points, index)

        return
    end
end

function instance.seekAttachments(argument, argument_2, argument_3)
    if #argument.points <= 0 then
        table.insert(argument.raycastParams.FilterDescendantsInstances, workspace.Terrain)
    end

    for _, attachment in ipairs(argument.object:GetDescendants()) do
        if not (attachment:IsA("Attachment")) then
            continue
        end

        if attachment.Name == argument_2 then
            local group = attachment:FindFirstChild("Group")
            local values = { group = 0, solver = 0 }
            values.Attachment = attachment
            values.group = group and group.Value
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
    else
        print(
            string.format(
                "\n[[RAYCAST MESSAGE]]\n\nCreated Hitbox for %s - Attachments found: %s",
                argument.object.Name,
                #argument.points
            )
        )
    end
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
