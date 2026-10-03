local targetfolder = game
local hideidentity = true
local anonymousname = "Player"
local anonymoususerid = "0"
local printprogress = true
local maxpathlength = 240

local rootfolder = "Dumps/" .. tostring(game.PlaceId or 0) .. (hideidentity and "_Anonymous" or "")
local players = game:GetService("Players")
local localplayer = players.LocalPlayer

if hideidentity and not localplayer then
	error("Players.LocalPlayer is unavailable while identity masking is enabled.")
end

local identity = {
	username = localplayer and tostring(localplayer.Name or "") or "",
	displayname = localplayer and tostring(localplayer.DisplayName or "") or "",
	userid = localplayer and tostring(localplayer.UserId or "") or ""
}

local function replaceplain(value, oldvalue, newvalue)
	value = tostring(value or "")
	oldvalue = tostring(oldvalue or "")
	newvalue = tostring(newvalue or "")

	if oldvalue == "" or oldvalue == newvalue then
		return value
	end

	local output = {}
	local cursor = 1

	while true do
		local first, last = string.find(value, oldvalue, cursor, true)

		if not first then
			table.insert(output, value:sub(cursor))
			break
		end

		table.insert(output, value:sub(cursor, first - 1))
		table.insert(output, newvalue)
		cursor = last + 1
	end

	return table.concat(output)
end

local function isdigit(value)
	return value ~= "" and value:match("%d") ~= nil
end

local function replacenumerictoken(value, oldvalue, newvalue)
	value = tostring(value or "")
	oldvalue = tostring(oldvalue or "")
	newvalue = tostring(newvalue or "")

	if oldvalue == "" or oldvalue == newvalue then
		return value
	end

	local output = {}
	local cursor = 1

	while true do
		local first, last = string.find(value, oldvalue, cursor, true)

		if not first then
			table.insert(output, value:sub(cursor))
			break
		end

		local before = first > 1 and value:sub(first - 1, first - 1) or ""
		local after = last < #value and value:sub(last + 1, last + 1) or ""

		table.insert(output, value:sub(cursor, first - 1))

		if not isdigit(before) and not isdigit(after) then
			table.insert(output, newvalue)
		else
			table.insert(output, value:sub(first, last))
		end

		cursor = last + 1
	end

	return table.concat(output)
end

local function sanitizeidentity(value)
	value = tostring(value or "")

	if not hideidentity then
		return value
	end

	local first = identity.username
	local second = identity.displayname

	if #second > #first then
		first, second = second, first
	end

	if first ~= "" then
		value = replaceplain(value, first, anonymousname)
	end

	if second ~= "" and second ~= first then
		value = replaceplain(value, second, anonymousname)
	end

	if identity.userid ~= "" then
		value = replacenumerictoken(value, identity.userid, anonymoususerid)
	end

	return value
end

if hideidentity then
	if identity.username ~= "" and sanitizeidentity(identity.username) ~= anonymousname then
		error("Username masking self-test failed.")
	end

	if identity.displayname ~= "" and sanitizeidentity(identity.displayname) ~= anonymousname then
		error("Display name masking self-test failed.")
	end

	if identity.userid ~= "" and sanitizeidentity(identity.userid) ~= anonymoususerid then
		error("UserId masking self-test failed.")
	end
end

local required = {
	decompile = decompile,
	isfolder = isfolder,
	makefolder = makefolder,
	isfile = isfile,
	readfile = readfile,
	writefile = writefile
}

for name, fn in pairs(required) do
	if type(fn) ~= "function" then
		error(string.format("Required executor function is unavailable: %s", name))
	end
end

if typeof(targetfolder) ~= "Instance" then
	error("targetfolder is not a valid Roblox Instance.")
end

local reservednames = {
	CON = true,
	PRN = true,
	AUX = true,
	NUL = true,
	COM1 = true,
	COM2 = true,
	COM3 = true,
	COM4 = true,
	COM5 = true,
	COM6 = true,
	COM7 = true,
	COM8 = true,
	COM9 = true,
	LPT1 = true,
	LPT2 = true,
	LPT3 = true,
	LPT4 = true,
	LPT5 = true,
	LPT6 = true,
	LPT7 = true,
	LPT8 = true,
	LPT9 = true
}

local function sanitizefilename(name)
	local value = sanitizeidentity(name)
	value = value:gsub("[%z\1-\31]", "_")
	value = value:gsub('[<>:"/\\|%?%*]', "_")
	value = value:gsub("[%.%s]+$", "")

	if value == "" then
		value = "_unnamed"
	end

	local basename = value:match("^([^%.]+)") or value

	if reservednames[basename:upper()] then
		value = "_" .. value
	end

	if #value > 80 then
		value = value:sub(1, 80)
	end

	return value
end

local function safeisfolder(path)
	local ok, result = pcall(isfolder, path)
	return ok and result == true
end

local function safeisfile(path)
	local ok, result = pcall(isfile, path)
	return ok and result == true
end

local function ensuredirectory(path)
	path = tostring(path):gsub("\\", "/")
	local current = ""

	for part in path:gmatch("[^/]+") do
		current = current == "" and part or (current .. "/" .. part)

		if not safeisfolder(current) then
			local ok, err = pcall(makefolder, current)

			if not ok and not safeisfolder(current) then
				warn(string.format(
					"Failed to create directory '%s': %s",
					current,
					sanitizeidentity(err)
				))
				return false
			end
		end
	end

	return true
end

local siblingcache = setmetatable({}, {__mode = "k"})
local scriptcache = setmetatable({}, {__mode = "k"})

local function getsiblingsegments(parent)
	if not parent then
		return {}
	end

	local cached = siblingcache[parent]

	if cached then
		return cached
	end

	local result = {}
	local seen = {}
	local ok, children = pcall(function()
		return parent:GetChildren()
	end)

	if ok and type(children) == "table" then
		for _, child in ipairs(children) do
			local base = sanitizefilename(child.Name)
			local key = base:lower()
			local count = (seen[key] or 0) + 1
			seen[key] = count
			result[child] = count == 1 and base or (base .. "__" .. tostring(count))
		end
	end

	siblingcache[parent] = result
	return result
end

local function getsegment(instance)
	if not instance then
		return "_unnamed"
	end

	local parent = instance.Parent

	if not parent then
		return sanitizefilename(instance.Name)
	end

	return getsiblingsegments(parent)[instance] or sanitizefilename(instance.Name)
end

local function isdumpscript(instance)
	local ok, result = pcall(function()
		return instance:IsA("LocalScript") or instance:IsA("ModuleScript")
	end)

	return ok and result == true
end

local function getscriptfilename(scriptobject)
	local cached = scriptcache[scriptobject]

	if cached then
		return cached
	end

	local base = sanitizefilename(scriptobject.Name)
	local key = base:lower()
	local count = 0
	local parent = scriptobject.Parent

	if parent then
		local ok, children = pcall(function()
			return parent:GetChildren()
		end)

		if ok and type(children) == "table" then
			for _, child in ipairs(children) do
				if isdumpscript(child) and sanitizefilename(child.Name):lower() == key then
					count += 1
				end

				if child == scriptobject then
					break
				end
			end
		end
	end

	if count > 1 then
		base = base .. "__" .. tostring(count)
	end

	local filename = base .. ".luau"
	scriptcache[scriptobject] = filename
	return filename
end

local function getparentpath(instance, basepath)
	if not instance or instance == game then
		return basepath
	end

	local parts = {}
	local current = instance

	while current and current ~= game do
		table.insert(parts, 1, getsegment(current))
		current = current.Parent
	end

	local path = basepath

	for _, part in ipairs(parts) do
		path = path .. "/" .. part
	end

	return path
end

local function simplehash(value)
	local hash = 7

	for index = 1, #value do
		hash = ((hash * 131) + value:byte(index)) % 2147483647
	end

	return string.format("%08x", hash)
end

local function shortenpath(parentpath, filename)
	local filepath = parentpath .. "/" .. filename

	if #filepath <= maxpathlength then
		return filepath
	end

	local overflow = rootfolder .. "/_LongPaths"

	if not ensuredirectory(overflow) then
		return filepath
	end

	local extension = filename:match("(%.[^%.]+)$") or ".luau"
	local basename = filename:sub(1, #filename - #extension)

	if basename == "" then
		basename = "Script"
	end

	return overflow .. "/" .. basename:sub(1, 50) .. "_" .. simplehash(filepath) .. extension
end

local function stripheader(content)
	if type(content) ~= "string" then
		return ""
	end

	local headerend = content:find("\n\n", 1, true)
	return headerend and content:sub(headerend + 2) or content
end

local function gettimestamp()
	local ok, result = pcall(os.date, "%Y-%m-%d %H:%M:%S")
	return ok and type(result) == "string" and result or "Unknown"
end

local function createtraceback(message)
	message = sanitizeidentity(message)

	if debug and type(debug.traceback) == "function" then
		local ok, traceback = pcall(debug.traceback, message, 2)

		if ok and type(traceback) == "string" then
			return sanitizeidentity(traceback)
		end
	end

	return message
end

local function decompilewithdiagnostics(scriptobject, index)
	local fullname = sanitizeidentity(scriptobject:GetFullName())
	local started = os.clock()

	if printprogress then
		print(string.format("[%d] Decompile started: %s", index, fullname))
	end

	local ok, result = xpcall(function()
		return decompile(scriptobject)
	end, createtraceback)

	local elapsed = os.clock() - started

	if printprogress then
		print(string.format("[%d] Decompile finished in %.3f seconds: %s", index, elapsed, fullname))
	end

	if not ok then
		return nil, result
	end

	if type(result) ~= "string" then
		return nil, string.format("Decompiler returned %s instead of a string.", typeof(result))
	end

	return result, nil
end

local function savescript(scriptobject, basepath, index)
	local fullgamepath = sanitizeidentity(getparentpath(scriptobject, "Game"))
	local parentpath = getparentpath(scriptobject.Parent, basepath)

	if not ensuredirectory(parentpath) then
		warn(string.format("[%d] Could not create directory: %s", index, parentpath))
		return false
	end

	local filename = getscriptfilename(scriptobject)
	local filepath = shortenpath(parentpath, filename)
	local existed = safeisfile(filepath)
	local source, decompileerror = decompilewithdiagnostics(scriptobject, index)

	if source then
		source = sanitizeidentity(source)
	else
		decompileerror = sanitizeidentity(decompileerror)
		source = string.format(
			"-- Failed to decompile %s.\n-- Instance: %s\n-- Reason:\n%s",
			scriptobject.ClassName,
			fullgamepath,
			tostring(decompileerror)
		)
		warn(string.format(
			"[%d] Decompile failed: %s\n%s",
			index,
			fullgamepath,
			tostring(decompileerror)
		))
	end

	local header = string.format(
		"--[[\n    Script Path: %s\n    Class: %s\n    Time: %s\n--]]\n\n",
		fullgamepath,
		scriptobject.ClassName,
		gettimestamp()
	)

	local content = header .. source

	if existed then
		local ok, oldcontent = pcall(readfile, filepath)

		if ok and type(oldcontent) == "string" and stripheader(oldcontent) == stripheader(content) then
			print(string.format("[%d] Skipped (unchanged): %s", index, filepath))
			return false
		end
	end

	local ok, err = pcall(writefile, filepath, content)

	if not ok then
		warn(string.format(
			"[%d] Failed to write file:\nScript: %s\nPath: %s\nPath length: %d\nError: %s",
			index,
			fullgamepath,
			filepath,
			#filepath,
			sanitizeidentity(err)
		))
		return false
	end

	print(string.format("[%d] %s: %s", index, existed and "Saved/updated" or "Saved", filepath))
	return true
end

local skipnames = {
	CorePackages = true,
	CoreGui = true
}

local function shouldskip(instance)
	return not instance or skipnames[instance.Name] == true
end

local function getchildren(instance)
	local ok, children = pcall(function()
		return instance:GetChildren()
	end)

	if not ok or type(children) ~= "table" then
		return nil, children
	end

	return children, nil
end

local function scanandsave(root, basepath)
	local processed = 0
	local saved = 0
	local failedscans = 0
	local stack = {root}

	while #stack > 0 do
		local parent = table.remove(stack)

		if not shouldskip(parent) then
			local children, scanerror = getchildren(parent)

			if not children then
				failedscans += 1
				local parentname = "<unknown>"

				pcall(function()
					parentname = sanitizeidentity(parent:GetFullName())
				end)

				warn(string.format(
					"Could not scan %s: %s",
					parentname,
					sanitizeidentity(scanerror)
				))
			else
				for index = #children, 1, -1 do
					table.insert(stack, children[index])
				end

				for _, child in ipairs(children) do
					local ok, isscript = pcall(function()
						return child:IsA("LocalScript") or child:IsA("ModuleScript")
					end)

					if ok and isscript then
						processed += 1
						local saveok, result = pcall(savescript, child, basepath, processed)

						if saveok and result then
							saved += 1
						elseif not saveok then
							warn(string.format(
								"[%d] Unexpected save error for %s: %s",
								processed,
								sanitizeidentity(child:GetFullName()),
								sanitizeidentity(result)
							))
						end
					end
				end
			end
		end
	end

	return processed, saved, failedscans
end

if not ensuredirectory(rootfolder) then
	error("Could not create root dump folder: " .. rootfolder)
end

local targetname = "<unknown>"

pcall(function()
	targetname = sanitizeidentity(targetfolder:GetFullName())
end)

print(string.format(
	"Starting dump from %s... Identity anonymization: %s",
	targetname,
	hideidentity and "ON" or "OFF"
))

local started = os.clock()
local processed, saved, failedscans = scanandsave(targetfolder, rootfolder)
local elapsed = os.clock() - started

print(string.format(
	"Dump complete.\nProcessed: %d script(s)\nSaved or updated: %d\nUnchanged: %d\nFailed folder scans: %d\nElapsed time: %.2f seconds",
	processed,
	saved,
	processed - saved,
	failedscans,
	elapsed
))
