--[[ 
	Subcommand to uninstall a package

	Authors: PentagonLP 2021, 2025
	@module uninstall
]]

-- Load module dependencies
local autocomplete_helpers_subcommands = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_subcommands")
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local installtypes = _G.ccpt.loadmodule("installtypes")
local misc = _G.ccpt.loadmodule("misc")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local statcounters = _G.ccpt.loadmodule("statcounters")

-- Module interface table
local uninstall = {}

-- ## START OF MODULE ##

--[[ Recursive function to find all Packages that are dependend on the one we want to remove to also remove them
	@tparam string packageid The ID of the package to uninstall
	@tparam packagedata packageinfo Infotable of the package to uninstall
	@tparam installedpackages installedpackages Information about all installed packages on the system
	@tparam {[string]=bool} packagestoremove Table of '<packageid> => true' into which to insert the found packages to remove
	@treturn {[string]=bool} packagestoremove with the newly found packages inserted into it
]] --
local function getpackagestoremove(packageid, packageinfo, installedpackages, packagestoremove)
	packagestoremove[packageid] = true
	-- Get Packageinfo
	if (packageinfo == nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo == false then
			return false
		end
	end

	-- Check packages that are dependend on that said package
	for k, _ in pairs(installedpackages) do
		if not (package.getpackagedata(k)["dependencies"][packageid] == nil) then
			local packagestoremovenew = getpackagestoremove(k, nil, installedpackages, packagestoremove)
			if not (type(packagestoremovenew) == "table") then
				return packagestoremovenew
			end
			for l, w in pairs(packagestoremovenew) do
				packagestoremove[l] = true
			end
		end
	end

	return packagestoremove
end

--[[ Remove installed Packages
	@tparam {string,...} args Array of all arguments of the 'ccpt'-command
]]
function uninstall.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt uninstall <PackageID>'")
		return
	end
	local packageinfo = package.getpackagedata(args[2])
	if packageinfo == false then
		return
	end
	if packageinfo["status"] == "not installed" then
		properprint.pprint("Package '" .. args[2] .. "' is not installed.")
		return
	end

	-- Check witch package(s) to remove (A package dependend on a package that's about to get removed is also removed)
	local packagestoremove = getpackagestoremove(args[2], packageinfo,
		fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true), {})
	if not (type(packagestoremove) == "table") then
		return packagestoremove
	end
	local packagestoremovestring = ""
	for k, _ in pairs(packagestoremove) do
		if not (k == args[2]) then
			packagestoremovestring = packagestoremovestring .. k .. " "
		end
	end

	-- Are you really really REALLY sure to remove these packages?
	if not (#packagestoremovestring == 0) then
		properprint.pprint("There are installed packages that depend on the package you want to uninstall: " .. packagestoremovestring)
		properprint.pprint("These packages will be removed if you proceed. Are you sure you want to continue? [y/n]:")
		if misc.ynchoice() == false then
			return
		end
	else
		properprint.pprint("There are no installed packages that depend on the package you want to uninstall.")
		properprint.pprint("'" .. args[2] .. "' will be removed if you proceed. Are you sure you want to continue? [y/n]:")
		if misc.ynchoice() == false then
			return
		end
	end

	-- If cctp would be removed in the process, tell the user that that's a dump idea. But I mean, who am I to stop him, I guess...
	for k, _ in pairs(packagestoremove) do
		if k == "ccpt" then
			if args[2] == "ccpt" then
				properprint.pprint("You are about to uninstall the package tool itself. You won't be able to install or uninstall stuff using the tool afterwords (obviously). Are you sure you want to continue? [y/n]:")
			else
				properprint.pprint("You are about to uninstall the package tool itself, because it depends one or more package that is removed. You won't be able to install or uninstall stuff using the tool afterwords (obviously). Are you sure you want to continue? [y/n]:")
			end

			if misc.ynchoice() == false then
				return
			end
			break
		end
	end

	-- Uninstall package(s)
	for k, _ in pairs(packagestoremove) do
		print("Uninstalling '" .. k .. "'...")
		local installdata = package.getpackagedata(k)["install"]
		local result = installtypes[installdata["type"]]["remove"](installdata)
		if result == false then
			return false
		end
		local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
		installedpackages[k] = nil
		fileutils.storeData(fs.combine(_G.ccpt.progdir, "installedpackages"), installedpackages)
		print("'" .. k .. "' successfully uninstalled!")
		statcounters.increasecounter("removed", 1)
	end
end

-- Register entry in the help page upon first module load
help.registerinfo("uninstall", {
	comment = "Remove installed Packages"
})

--[[ Allow autocompletion of the subcommand, specify first argument to be the ID of any known and installed package
]]
uninstall.autocomplete = {
	func = autocomplete_helpers_subcommands.completepackageid,
	funcargs = { "installed" }
}

-- ## END OF MODULE ##

return uninstall
