-- Info
local autocomplete_helpers_subcommands = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete_helpers_subcommands.lua"))
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local package = dofile(fs.combine(_G.ccpt.progdir, "program/package.lua"))

local installtypes = misc.loadfolder("program/installtypes")

local info = {}

--[[ Info about a package
]]--
function info.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt info <PackageID>'")
		return
	end

	-- Get packagedata
	local packageinfo = package.getpackagedata(args[2])
	if packageinfo == false then
		return
	end

	-- Print packagedata
	properprint.pprint(packageinfo["name"] .. " by " .. packageinfo["author"])
	properprint.pprint(packageinfo["comment"])
	if not (packageinfo["website"]==nil) then
		properprint.pprint("Website: " .. packageinfo["website"])
	end
	properprint.pprint("Installation Type: " .. installtypes[packageinfo["install"]["type"]]["desc"])
	if packageinfo["status"]=="installed" then
		properprint.pprint("Installed, Version: " .. packageinfo["installedversion"] .. "; Newest Version is " .. packageinfo["newestversion"])
	else
		properprint.pprint("Not installed; Newest Version is " .. packageinfo["newestversion"])
	end
end

info.comment = "Information about a package"

info.autocomplete = {
    func = autocomplete_helpers_subcommands.completepackageid,
    funcargs = {}
}

return info