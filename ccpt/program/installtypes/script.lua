local httputils = _G.ccpt.loadmodule("/lib/httputils")

local script = {}

local function runtempinstaller(installdata, args)
	local tempinstallerpath = fs.combine(_G.ccpt.progdir, "tempinstaller")

	-- Download script
	local result = httputils.downloadfile(tempinstallerpath, installdata["scripturl"])
	if result==false then
		return false
	end
	-- Run script
	_G.ccpt.shell.run(tempinstallerpath, unpack(args))
	-- Delete script
	fs.delete(tempinstallerpath)
end

function script.install(installdata)
	runtempinstaller(installdata, {"install"})
end

function script.update(installdata)
	runtempinstaller(installdata, {"update"})
end

function script.remove(installdata)
	runtempinstaller(installdata, {"remove"})
end

script.desc = "Programm installed via Installer"

return script