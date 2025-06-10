--[[ 
	Module to handle installing and upgrading of packages

	Authors: PentagonLP 2021, 2025
	@module upgradeinstall
]]

-- Load module dependencies
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local installtypes = _G.ccpt.loadmodule("installtypes")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local statcounters = _G.ccpt.loadmodule("statcounters")

-- Module interface table
local upgradeinstall = {}

-- ## START OF MODULE ##

--[[ Recursive function to install packages and dependencies
	@tparam string packageid ID of the package to be installed
	@tparam[opt] packagedata packageinfo Information of the package to be installed
	@treturn bool Whether the install was successful
]]
function upgradeinstall.installpackage(packageid, packageinfo)
	properprint.pprint("Installing '" .. packageid .. "'...")

	-- Get Packageinfo
	if (packageinfo == nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo == false then
			return false
		end
	end

	-- Install dependencies
	properprint.pprint("Installing dependencies of '" .. packageid .. "', if there are any...")
	for k, v in pairs(packageinfo["dependencies"]) do
		local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
		if installedpackages[k] == nil then
			if upgradeinstall.installpackage(k, nil) == false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradeinstall.upgradepackage(k, nil) == false then
				return false
			end
		end
	end

	-- Install package
	print("Installing '" .. packageid .. "'...")
	local installdata = packageinfo["install"]
	local result = installtypes[installdata["type"]]["install"](installdata)
	if result == false then
		return false
	end
	local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(_G.ccpt.progdir, "installedpackages"), installedpackages)
	print("'" .. packageid .. "' successfully installed!")
	statcounters.increasecounter("installed", 1)
	return true
end

--[[ Recursive function to upgrade Packages and dependencies
	@tparam string packageid ID of the package to be upgraded
	@tparam[opt] packagedata packageinfo Information of the package to be upgraded
	@treturn bool Whether the upgrade was successful
]]
function upgradeinstall.upgradepackage(packageid, packageinfo)
	-- Get Packageinfo
	if (packageinfo == nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo == false then
			return false
		end
	end

	local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	if installedpackages[packageid] == packageinfo["newestversion"] then
		properprint.pprint("'" .. packageid .. "' already updated! Skipping... (This is NOT an error)")
		return true
	else
		properprint.pprint("Updating '" .. packageid .. "' (" .. installedpackages[packageid] .. "->" .. packageinfo["newestversion"] .. ")...")
	end

	-- Install/Update dependencies
	properprint.pprint("Updating or installing new dependencies of '" .. packageid .. "', if there are any...")
	for k, v in pairs(packageinfo["dependencies"]) do
		installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
		if installedpackages[k] == nil then
			if upgradeinstall.installpackage(k, nil) == false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradeinstall.upgradepackage(k, nil) == false then
				return false
			end
		end
	end

	-- Install package
	print("Updating '" .. packageid .. "'...")
	local installdata = packageinfo["install"]
	local result = installtypes[installdata["type"]]["update"](installdata)
	if result == false then
		return false
	end
	installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(_G.ccpt.progdir, "installedpackages"), installedpackages)
	print("'" .. packageid .. "' successfully updated!")
	statcounters.increasecounter("upgraded", 1)
	return true
end

-- ## END OF MODULE ##

return upgradeinstall
