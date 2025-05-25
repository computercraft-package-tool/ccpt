--[[ Different install methodes
]]--
function installlibrary(installdata)
	local result = httputils.downloadfile("/lib/" .. installdata["filename"],installdata["url"])
	if result==false then
		return false
	end
end

--[[ Different install methodes require different uninstall methodes
]]--
function removelibrary(installdata)
	fs.delete("/lib/" .. installdata["filename"])
end

_G.ccpt.installtypes.library = {
    install = installlibrary,
    update = installlibrary,
    remove = removelibrary,
    desc = "Single file library"
}