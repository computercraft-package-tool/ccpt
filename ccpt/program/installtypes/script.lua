function installscript(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"install")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

--[[ Different install methodes require different update methodes
]]--
function updatescript(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"update")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

function removescript(installdata)
	local result = httputils.downloadfile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),installdata["scripturl"])
	if result==false then
		return false
	end
	_G.ccpt.shell.run(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"),"remove")
	fs.delete(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../tempinstaller"))
end

_G.ccpt.installtypes.script = {
    install = installscript,
    update = updatescript,
    remove = removescript,
    desc = "Programm installed via Installer"
}