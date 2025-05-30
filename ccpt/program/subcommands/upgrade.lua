-- Upgrade
local fileutils = dofile("lib/fileutils.lua")
local install = dofile(fs.combine(_G.ccpt.progdir, "program/subcommands/install.lua"))
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local package = dofile(fs.combine(_G.ccpt.progdir, "program/package.lua"))
local properprint = dofile("lib/properprint.lua")
local statcounters = dofile(fs.combine(_G.ccpt.progdir, "program/statcounters.lua"))

local installtypes = misc.loadfolder("program/installtypes")

local upgrade = {}

--[[ Recursive function to update Packages and dependencies
]]--
local function upgradepackage(packageid,packageinfo)
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo==false then
			return false
		end
	end
	
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	if installedpackages[packageid]==packageinfo["newestversion"] then
		properprint.pprint("'" .. packageid .. "' already updated! Skipping... (This is NOT an error)")
		return true
	else
		properprint.pprint("Updating '" .. packageid .. "' (" .. installedpackages[packageid] .. "->" .. packageinfo["newestversion"] .. ")...")
	end
	
	-- Install/Update dependencies
	properprint.pprint("Updating or installing new dependencies of '" .. packageid .. "', if there are any...")
	for k,v in pairs(packageinfo["dependencies"]) do
		installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
		if installedpackages[k] == nil then
			if install.installpackage(k,nil)==false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradepackage(k,nil)==false then
				return false
			end
		end
	end
	
	-- Install package
	print("Updating '" .. packageid .. "'...")
	local installdata = packageinfo["install"]
	local result =  installtypes[installdata["type"]]["update"](installdata)
	if result==false then
		return false
	end
	installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
	print("'" .. packageid .. "' successfully updated!")
	statcounters.increasecounter("upgraded", 1)
end

-- Upgrade installed Packages
-- TODO: Single package updates
function upgrade.func(args)
	local packageswithupdates = package.checkforupdates(fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true),false)
	if packageswithupdates==false then
		return
	end
	if #packageswithupdates==0 then
		return
	end
	properprint.pprint("Do you want to update these packages? [y/n]:")
	if not misc.ynchoice() then
		return
	end
	for k,v in pairs(packageswithupdates) do
		upgradepackage(v,nil)
	end
end

upgrade.comment = "Upgrade installed Packages"

return upgrade