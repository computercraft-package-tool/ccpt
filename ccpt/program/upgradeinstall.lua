local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local installtypes = _G.ccpt.loadmodule("installtypes")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local statcounters = _G.ccpt.loadmodule("statcounters")

local upgradeinstall = {}

--[[ Recursive function to install Packages and dependencies
]]--
function upgradeinstall.installpackage(packageid,packageinfo)
	properprint.pprint("Installing '" .. packageid .. "'...")
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo==false then
			return false
		end
	end
	
	-- Install dependencies
	properprint.pprint("Installing dependencies of '" .. packageid .. "', if there are any...")
	for k,v in pairs(packageinfo["dependencies"]) do
		local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
		if installedpackages[k] == nil then
			if upgradeinstall.installpackage(k,nil)==false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradeinstall.upgradepackage(k,nil)==false then
				return false
			end
		end
	end
	
	-- Install package
	print("Installing '" .. packageid .. "'...")
	local installdata = packageinfo["install"]
	local result = installtypes[installdata["type"]]["install"](installdata)
	if result==false then
		return false
	end
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
	print("'" .. packageid .. "' successfully installed!")
	statcounters.increasecounter("installed", 1)
end

--[[ Recursive function to update Packages and dependencies
]]--
function upgradeinstall.upgradepackage(packageid,packageinfo)
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
			if upgradeinstall.installpackage(k,nil)==false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradeinstall.upgradepackage(k,nil)==false then
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

return upgradeinstall