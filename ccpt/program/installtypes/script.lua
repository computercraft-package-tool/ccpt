--[[ 
	Module to implement the install script install type

	Authors: PentagonLP 2021, 2025
	@module script
]]

-- Load module dependencies
local httputils = _G.ccpt.loadmodule("/lib/httputils")

-- Module interface table
local script = {}

-- ## START OF MODULE ##

--[[ Download, run and delete the installscript for a package defined by installdata again
	@tparam {type="script",scripturl=string} installdata The installdata specified in the packageinfo file of the package, used to specify the download url of the script
]]
local function runtempinstaller(installdata, args)
	local tempinstallerpath = fs.combine(_G.ccpt.progdir, "tempinstaller")

	-- Download script
	local result = httputils.downloadfile(tempinstallerpath, installdata["scripturl"])
	if result == false then
		return false
	end
	-- Run script
	_G.ccpt.shell.run(tempinstallerpath, unpack(args))
	-- Delete script
	fs.delete(tempinstallerpath)
end

--[[ Install a package with the 'script' install type. Passes on 'install' as the first argument of the script.
	@tparam {type="script",scripturl=string} installdata The installdata specified in the packageinfo file of the package, used to specify the download url of the script
]]
function script.install(installdata)
	runtempinstaller(installdata, { "install" })
end

--[[ Upgrade a package with the 'script' install type. Passes on 'update' as the first argument of the script.
	@tparam {type="script",scripturl=string} installdata The installdata specified in the packageinfo file of the package, used to specify the download url of the script
]]
function script.update(installdata)
	runtempinstaller(installdata, { "update" })
end

--[[ Uninstall a package with the 'script' install type. Passes on 'remove' as the first argument of the script.
	@tparam {type="script",scripturl=string} installdata The installdata specified in the packageinfo file of the package, used to specify the download url of the script
]]
function script.remove(installdata)
	runtempinstaller(installdata, { "remove" })
end

--[[ Description to be printed when the package info of a package using this installtype is requested with 'ccpt info'
]]
script.desc = "Programm installed via Installer"

-- ## END OF MODULE ##

return script
