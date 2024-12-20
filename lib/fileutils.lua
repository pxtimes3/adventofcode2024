local fileutils = {}

--[[
Returns the current working directory path from the source file location.
Uses debug information to extract the directory path from the source file.
@return string Directory path ending with a forward slash
]]--
function fileutils.cwd()
    local str = debug.getinfo(2, "S").source:sub(2)

    return str:match("(.*/)")
end

--[[
Checks if a file exists in the filesystem.

@param file string: Path to the file to check
@return boolean: true if file exists, false otherwise
]]
function fileutils.file_exists(file)
    local f = io.open(file, "rb")

    if f then f:close() end
    return f ~= nil
end

--[[
Reads all lines from a specified file and returns them as a table.

@param file: The path to the file to read.
@return: A table containing each line of the file as a separate element.
         Returns an empty table if the file does not exist.
]]
function fileutils.lines_from(file)
    if not fileutils.file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end


--[[
Opens a file from the specified path relative to the current working directory.

@param path string: Relative path to the file to open.

@return table: A table containing each line of the file as a separate element.
               Exits the program with status 127 if the file does not exist.
]]
function fileutils.open_file(path)
    if not fileutils.file_exists(path) then
        print(string.format("File %s does not exist!?", path))
        os.exit(127)
    else
        return fileutils.lines_from(path)
    end
end

return fileutils
