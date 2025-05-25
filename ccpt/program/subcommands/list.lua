-- List
--[[ List all Packages 
]]--
function list(args)
	-- Read data
	print("Reading all packages data...")
	if not fs.exists(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata")) then
		properprint.pprint("No Packages found. Please run 'cctp update' first.'")
		return
	end
	local packagedata = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata"),true)
	print("Reading Installed packages...")
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	-- Print list
	properprint.pprint("List of all known Packages:")
	for k,v in pairs(installedpackages) do
		local updateinfo
		if packagedata[k]["newestversion"] > v then
			updateinfo = "outdated"
		else
			updateinfo = "up to date"
		end
		properprint.pprint(k .. " (installed, " .. updateinfo .. ")",2)
	end
	for k,v in pairs(packagedata) do
		if installedpackages[k] == nil then
			properprint.pprint(k .. " (not installed)",2)
		end
	end
end

_G.ccpt.subcommands.list = {
    func = list,
    comment = "List installed and able to install Packages"
}