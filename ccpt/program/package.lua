--[[ 
	Module to read various information about packages

	Authors: PentagonLP 2021, 2025
	@module package
]]

-- Load module dependencies
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local misc = _G.ccpt.loadmodule("misc")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local package = {}

-- ## START OF MODULE ##

--[[ Checks wether a package is installed
	@tparam string packageid: The ID of the package
	@treturn bool Is the package installed?
]]
function package.isinstalled(packageid)
	return not (fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)[packageid] == nil)
end

--[[ Checks wether a package is installed
	@table packagedata
	@field status string Either 'installed' or 'not installed'
	@field[opt] installedversion string If package is installed: The locally installed version of the package
	@tparam string packageid The ID of the package
	@treturn packagedata|boolean packagedata|error: Read the data of the package from '/.ccpt/packagedata'; If package is not found return false
]]
function package.getpackagedata(packageid)
	-- Read package data
	local allpackagedata = fileutils.readData(fs.combine(_G.ccpt.progdir, "packagedata"), false)

	-- Is the package data built yet?
	if allpackagedata == false then
		properprint.pprint("Package Date is not yet built. Please execute 'ccpt update' first. If this message still apears, thats a bug, please report.")
		return false
	end

	local packagedata = allpackagedata[packageid]
	-- Does the package exist?
	if packagedata == nil then
		properprint.pprint("No data about package '" .. packageid .. "' availible. If you've spelled everything correctly, try executing 'ccpt update'")
		return false
	end

	-- Is the package installed?
	local installedversion = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)[packageid]
	if not (installedversion == nil) then
		packagedata["status"] = "installed"
		packagedata["installedversion"] = installedversion
	else
		packagedata["status"] = "not installed"
	end

	return packagedata
end

--[[ Searches all packages for updates
	@table installedpackages
	@field <packageid> string The installed version of the package
	@tparam[opt] installedpackages installedpackages: installedpackages to prevent fetching them again; If nil they are fetched again
	@tparam[opt] bool reducedprint If reducedprint is true, only if updates are availible only the result is printed in console, but nothing else. If nil, false is taken as default.
	@treturn {string,...} packageswithupdates: List of packages with updates
]]
function package.checkforupdates(installedpackages, reducedprint)
	-- If parameters are nil, load defaults
	reducedprint = reducedprint or false
	installedpackages = installedpackages or fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)

	misc.bprint("Checking for updates...", reducedprint)

	-- Check for updates
	local packageswithupdates = {}
	for k, v in pairs(installedpackages) do
		if package.getpackagedata(k)["newestversion"] > v then
			packageswithupdates[#packageswithupdates + 1] = k
		end
	end

	-- Print result
	if #packageswithupdates == 0 then
		misc.bprint("All installed packages are up to date!", reducedprint)
	elseif #packageswithupdates == 1 then
		print("There is 1 package with a newer version availible: " .. misc.arraytostring(packageswithupdates))
	else
		print("There are " .. #packageswithupdates .. " packages with a newer version availible: " .. misc.arraytostring(packageswithupdates))
	end

	return packageswithupdates
end

-- ## END OF MODULE ##

return package
