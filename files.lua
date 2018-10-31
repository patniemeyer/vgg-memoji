
-- Get a list of the files in a directory
function scandir(directory, pattern)
    local i, t, popen = 0, {}, io.popen
    local cmd='ls -a '..directory..'/'..pattern
    local pfile = popen(cmd)
    for filename in pfile:lines() do
        i = i + 1
        if filename ~= '.' and filename ~= '..' then  -- Lua is weird
            t[i] = filename
        end
    end
    pfile:close()
    return t
end

