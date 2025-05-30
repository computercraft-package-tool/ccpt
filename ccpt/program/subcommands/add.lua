-- Add
local fileutils = dofile("lib/fileutils.lua")
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local properprint = dofile("lib/properprint.lua")
local update = dofile(fs.combine(_G.ccpt.progdir, "program/subcommands/update.lua"))

local add = {}

--[[ Add custom package URL to local list
]]--
function add.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt add <PackageID> <PackageinfoURL>'")
		return
	end
	if args[3] == nil then
		properprint.pprint("Incomplete command, missing: 'Packageinfo URL'; Syntax: 'ccpt add <PackageID> <PackageinfoURL>'")
		return
	end

	-- Check preconditions
	local custompackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),true)
	if not (custompackages[args[2]]==nil) then
		properprint.pprint("A custom package with the id '" .. args[2] .. "' already exists! Please choose a different one.")
		return
	end
	if not fs.exists(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata")) then
		properprint.pprint("Package Date is not yet built. Please execute 'ccpt update' first. If this message still apears, thats a bug, please report.")
	end

	-- Overwrite default packages?
	if not (fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata"),true)[args[2]]==nil) then
		properprint.pprint("A package with the id '" .. args[2] .. "' already exists! This package will be overwritten if you proceed. Do you want to proceed? [y/n]:")
		if not misc.ynchoice() then
			return
		end
	end

	-- Add entry in custompackages file
	custompackages[args[2]] = args[3]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),custompackages)
	properprint.pprint("Custom package successfully added!")

	-- Update packagedata?
	properprint.pprint("Do you want to update the package data ('cctp update')? Your custom package won't be able to be installed until updating. [y/n]:")
	if misc.ynchoice() then
		update.func()
	end
end

add.comment = "Add Package URL to local list"

return add