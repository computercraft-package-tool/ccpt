local httputils = _G.ccpt.loadmodule("/lib/httputils")

local script = {}

function script.install(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"install")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

--[[ Different install methodes require different update methodes
]]--
function script.update(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"update")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

function script.remove(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"remove")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

script.desc = "Programm installed via Installer"

return script