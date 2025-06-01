local loadmodule = {}

local loadedmodules = {}

local function loadmodule_abspath(abspath)
    loadedmodules[abspath] = loadedmodules[abspath] or dofile(abspath)
    return loadedmodules[abspath]
end

function loadmodule.loadmodule(path)
    local abspath
    if string.sub(path,1,1) == "/" then
        abspath = path
    else
        abspath = fs.combine(_G.ccpt.progdir, fs.combine("program", path))
    end

    if fs.isDir(abspath) then
        local modules = {}
        for _, v in ipairs(fs.list(abspath)) do
            local modulename = string.gsub(v, "%.lua$", "")
            modules[modulename] = loadmodule_abspath(fs.combine(abspath, v))
        end
        return modules
    else
        return loadmodule_abspath(abspath  .. ".lua")
    end
end

return loadmodule