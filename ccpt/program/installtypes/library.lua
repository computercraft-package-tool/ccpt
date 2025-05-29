local library = {}

--[[ Different install methodes
]]--
function library.install(installdata)
	local result = httputils.downloadfile("/lib/" .. installdata["filename"],installdata["url"])
	if result==false then
		return false
	end
end

library.update = library.install

--[[ Different install methodes require different uninstall methodes
]]--
function library.remove(installdata)
	fs.delete("/lib/" .. installdata["filename"])
end

library.desc = "Single file library"

return library