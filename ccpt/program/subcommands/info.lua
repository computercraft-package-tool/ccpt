dofile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../package.lua"))
-- Info
--[[ Info about a package
]]--
function info(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt info <PackageID>'")
		return
	end
	-- Get packagedata
	local packageinfo = getpackagedata(args[2])
	if packageinfo == false then
		return
	end
	-- Print packagedata
	properprint.pprint(packageinfo["name"] .. " by " .. packageinfo["author"])
	properprint.pprint(packageinfo["comment"])
	if not (packageinfo["website"]==nil) then
		properprint.pprint("Website: " .. packageinfo["website"])
	end
	properprint.pprint("Installation Type: " .. _G.ccpt.installtypes[packageinfo["install"]["type"]]["desc"])
	if packageinfo["status"]=="installed" then
		properprint.pprint("Installed, Version: " .. packageinfo["installedversion"] .. "; Newest Version is " .. packageinfo["newestversion"])
	else
		properprint.pprint("Not installed; Newest Version is " .. packageinfo["newestversion"])
	end
end

_G.ccpt.subcommands.info = {
    func = info,
    comment = "Information about a package"
}

_G.ccpt.autocomplete.next.info = {
    func = completepackageid,
    funcargs = {}
}