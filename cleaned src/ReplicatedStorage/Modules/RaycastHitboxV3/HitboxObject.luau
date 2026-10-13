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

function instance.__tostring(self)
    return string.format("Hitbox for instance %s [%s]", self.object.Name, self.object.ClassName)
end

function hitbox_object.new(argument)
    return (setmetatable({}, instance))
end

function instance.config(self, object, filter_descendants_instances)
    self.active = false
    self.deleted = false
    self.partMode = false
    self.debugMode = false
    self.points = {}
    self.targetsHit = {}
    self.OnHit = signal:Create()
    self.OnUpdate = signal:Create()
    self.raycastParams = RaycastParams.new()
    self.raycastParams.FilterType = Enum.RaycastFilterType.Include
    self.raycastParams.FilterDescendantsInstances = filter_descendants_instances or {}
    self.object = object
    collection_service:AddTag(self.object, "RaycastModuleManaged")
end

function instance.SetPoints(self, relative_part, argument, group)
    if not relative_part then
        return
    end
    if relative_part:IsA("BasePart") or relative_part:IsA("MeshPart") then
        for _, attachment in ipairs(argument) do
            if typeof(attachment) == "Vector3" then
                table.insert(
                    self.points,
                    { RelativePart = relative_part, Attachment = attachment, group = group, solver = cast_vector_point }
                )
            end
        end
    end
end

function instance.RemovePoints(self, argument, argument_2)
    if not argument then
        return
    end
    if argument:IsA("BasePart") or argument:IsA("MeshPart") then
        for n = 1, #self.points do
            local point_entry = self.points[n]
            for _, item in ipairs(argument_2) do
                if typeof(point_entry.Attachment) ~= "Vector3" or point_entry.Attachment ~= item then
                    continue
                end
                if point_entry.RelativePart == argument then
                    self.points[n] = nil
                end
            end
        end
    end
end

function instance.LinkAttachments(self, attachment, attachment0)
    if not attachment:IsA("Attachment") then
        return
    end
    if attachment0:IsA("Attachment") then
        local group = attachment:FindFirstChild("Group")
        local values = { group = 0, solver = 0 }
        values.Attachment = attachment
        values.Attachment0 = attachment0
        values.group = group and group.Value
        values.solver = cast_link_attachment
        table.insert(self.points, values)
    end
end

function instance.UnlinkAttachments(self, argument)
    for index, item in ipairs(self.points) do
        if not item.Attachment or item.Attachment ~= argument then
            continue
        end
        table.remove(self.points, index)
        return
    end
end

function instance.seekAttachments(self, argument, argument_2)
    if #self.points <= 0 then
        table.insert(self.raycastParams.FilterDescendantsInstances, workspace.Terrain)
    end
    for _, attachment in ipairs(self.object:GetDescendants()) do
        if not (attachment:IsA("Attachment")) then
            continue
        end
        if attachment.Name == argument then
            local group = attachment:FindFirstChild("Group")
            local values = { group = 0, solver = 0 }
            values.Attachment = attachment
            values.group = group and group.Value
            values.solver = cast_attachment
            table.insert(self.points, values)
        end
    end
    if not argument_2 then
        return
    end
    if #self.points <= 0 then
        warn(
            string.format(
                "\n[[RAYCAST WARNING]]\nNo attachments with the name '%s' were found in %s. No raycasts will be drawn. Can be ignored if you are using SetPoints.",
                argument,
                self.object.Name
            )
        )
    else
        print(
            string.format(
                "\n[[RAYCAST MESSAGE]]\n\nCreated Hitbox for %s - Attachments found: %s",
                self.object.Name,
                #self.points
            )
        )
    end
end

function instance.Destroy(self)
    if self.deleted then
        return
    end
    if self.OnHit then
        self.OnHit:Delete()
    end
    if self.OnUpdate then
        self.OnUpdate:Delete()
    end
    self.points = nil
    self.active = false
    self.deleted = true
end

function instance.HitStart(self)
    self.active = true
end

function instance.HitStop(self)
    if self.deleted then
        return
    end
    self.active = false
    table.clear(self.targetsHit)
end

function instance.PartMode(self, part_mode)
    self.partMode = part_mode
end

function instance.DebugMode(self, debug_mode)
    self.debugMode = debug_mode
end

return hitbox_object
