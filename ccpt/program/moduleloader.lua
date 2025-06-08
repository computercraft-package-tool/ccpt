--[[ 
	Module loader to load and cache the various dependencies of a given module

	Authors: PentagonLP 2025
	@module loadmodule
]]

-- Module interface table
local loadmodule = {}

-- ## START OF MODULE ##

--[[ Loaded interface tables, indexed by filepath
]]
local loadedmodules = {}

--[[ Load a module file by its absolute path
    @tparam string abspath The path of the module file
    @treturn interfacetable The interface table of the module
]]
local function loadmodule_abspath(abspath)
    loadedmodules[abspath] = loadedmodules[abspath] or dofile(abspath)
    return loadedmodules[abspath]
end

--[[ Load a module file, given a path. Folder paths and paths relative to the CCPT program directory are allowed.
    @tparam string path Path to the module file or folder; Paths beginning with '/' are absolute, otherwise relative to the CCPT program directory
    @treturn interfacetable|{[string]=interfacetable} The interface table of the module, or a list of interfacetables when loading a folder, indexed by the module name
]]
function loadmodule.loadmodule(path)
    -- Build absolute path to the file or folder
    local abspath
    if string.sub(path, 1, 1) == "/" then
        abspath = path
    else
        abspath = fs.combine(_G.ccpt.progdir, fs.combine("program", path))
    end

    -- Load directory of modules
    if fs.isDir(abspath) then
        local modules = {}
        for _, v in ipairs(fs.list(abspath)) do
            local modulename = string.gsub(v, "%.lua$", "")
            modules[modulename] = loadmodule_abspath(fs.combine(abspath, v))
        end
        return modules
    -- Load single module file
    else
        return loadmodule_abspath(abspath .. ".lua")
    end
end

-- ## END OF MODULE ##

return loadmodule
