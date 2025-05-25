-- Remove
--[[  Remove Package URL from local list
]]--
function remove(args)
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
	if not ynchoice() then
		properprint.pprint("Canceled. No action was taken.")
		return
	end
	-- Remove entry from custompackages file
	custompackages[args[2]] = nil
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),custompackages)
	properprint.pprint("Custom package successfully removed!")
	-- Update packagedata?
	properprint.pprint("Do you want to update the package data ('cctp update')? Your custom package will still be able to be installed/updated/uninstalled until updating. [y/n]:")
	if ynchoice() then
		update()
	end
end

_G.ccpt.subcommands.remove = {
    func = remove,
    comment = "Remove Package URL from local list"
}

_G.ccpt.autocomplete.next.remove = {
    func = completecustompackageid,
    funcargs = {}
}