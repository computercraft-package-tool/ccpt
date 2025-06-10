--[[ 
	Module to implement the single file library install type

	Authors: PentagonLP 2021, 2025
	@module library
]]

-- Load module dependencies
local httputils = _G.ccpt.loadmodule("/lib/httputils")

-- Module interface table
local library = {}

-- ## START OF MODULE ##

--[[ Install a library as specified by the given installdata table
	@tparam {type="library",url=string,filename=string} installdata Information for the installer to download the the single library file from 'url' and put in it a file in '/lib' with its name specified by 'filename'
]]
function library.install(installdata)
	local result = httputils.downloadfile("/lib/" .. installdata["filename"], installdata["url"])
	if result == false then
		return false
	end
end

--[[ Update a library as specified by the given installdata table. Same function as @{library.install}.
	@tparam {type="library",url=string,filename=string} installdata Information for the installer to download the the single library file from 'url' and put in it a file in '/lib' with its name specified by 'filename'
]]
library.update = library.install

--[[ Uninstall a library as specified by the given installdata table
	@tparam {type="library",url=string,filename=string} installdata Information for the installer to remove the single library file from the '/lib' folder, with the filename specified by 'filename'
]]
function library.remove(installdata)
	fs.delete("/lib/" .. installdata["filename"])
end

--[[ Description to be printed when the package info of a package using this installtype is requested with 'ccpt info'
]]
library.desc = "Single file library"

-- ## END OF MODULE ##

return library
