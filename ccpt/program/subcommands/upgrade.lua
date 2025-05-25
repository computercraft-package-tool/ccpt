-- Upgrade
-- Upgrade installed Packages
-- TODO: Single package updates
function upgrade(args)
	local packageswithupdates = checkforupdates(fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true),false)
	if packageswithupdates==false then
		return
	end
	if #packageswithupdates==0 then
		return
	end
	properprint.pprint("Do you want to update these packages? [y/n]:")
	if not ynchoice() then
		return
	end
	for k,v in pairs(packageswithupdates) do
		upgradepackage(v,nil)
	end
end

--[[ Recursive function to update Packages and dependencies
]]--
function upgradepackage(packageid,packageinfo)
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = getpackagedata(packageid)
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
			if installpackage(k,nil)==false then
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
	local result =  _G.ccpt.installtypes[installdata["type"]]["update"](installdata)
	if result==false then
		return false
	end
	installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
	print("'" .. packageid .. "' successfully updated!")
	increasecounter("upgraded", 1)
end

_G.ccpt.subcommands.upgrade = {
    func = upgrade,
    comment = "Upgrade installed Packages"
}