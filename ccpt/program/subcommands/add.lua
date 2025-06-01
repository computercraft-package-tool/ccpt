-- Add
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local misc = _G.ccpt.loadmodule("misc")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local update = _G.ccpt.loadmodule("subcommands/update")

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
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir,"custompackages"),true)
	if not (custompackages[args[2]]==nil) then
		properprint.pprint("A custom package with the id '" .. args[2] .. "' already exists! Please choose a different one.")
		return
	end
	if not fs.exists(fs.combine(_G.ccpt.progdir,"packagedata")) then
		properprint.pprint("Package Date is not yet built. Please execute 'ccpt update' first. If this message still apears, thats a bug, please report.")
	end

	-- Overwrite default packages?
	if not (fileutils.readData(fs.combine(_G.ccpt.progdir,"packagedata"),true)[args[2]]==nil) then
		properprint.pprint("A package with the id '" .. args[2] .. "' already exists! This package will be overwritten if you proceed. Do you want to proceed? [y/n]:")
		if not misc.ynchoice() then
			return
		end
	end

	-- Add entry in custompackages file
	custompackages[args[2]] = args[3]
	fileutils.storeData(fs.combine(_G.ccpt.progdir,"custompackages"),custompackages)
	properprint.pprint("Custom package successfully added!")

	-- Update packagedata?
	properprint.pprint("Do you want to update the package data ('cctp update')? Your custom package won't be able to be installed until updating. [y/n]:")
	if misc.ynchoice() then
		update.func()
	end
end

help.registerinfo("add", {
	comment = "Add Package URL to local list"
})

add.autocomplete = {}

return add