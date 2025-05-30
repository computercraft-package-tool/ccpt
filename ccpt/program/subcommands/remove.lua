-- Remove
local autocomplete_helpers_subcommands = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete_helpers_subcommands.lua"))
local fileutils = dofile("lib/fileutils.lua")
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local properprint = dofile("lib/properprint.lua")
local update = dofile(fs.combine(_G.ccpt.progdir, "program/subcommands/update.lua"))

local remove = {}

--[[  Remove Package URL from local list
]]--
function remove.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt remove <PackageID>'")
		return
	end
	local custompackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),true)
	if custompackages[args[2]]==nil then
		properprint.pprint("A custom package with the id '" .. args[2] .. "' does not exist!")
		return
	end

	-- Really wanna do that?
	properprint.pprint("Do you want to remove the custom package '" .. args[2] .. "'? There is no undo. [y/n]:")
	if not misc.ynchoice() then
		properprint.pprint("Canceled. No action was taken.")
		return
	end

	-- Remove entry from custompackages file
	custompackages[args[2]] = nil
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),custompackages)
	properprint.pprint("Custom package successfully removed!")

	-- Update packagedata?
	properprint.pprint("Do you want to update the package data ('cctp update')? Your custom package will still be able to be installed/updated/uninstalled until updating. [y/n]:")
	if misc.ynchoice() then
		update.func()
	end
end


remove.comment = "Remove Package URL from local list"

remove.autocomplete = {
    func = autocomplete_helpers_subcommands.completecustompackageid,
    funcargs = {}
}

return remove