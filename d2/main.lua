local function cwd()
    local str = debug.getinfo(2, "S").source:sub(2)

    return str:match("(.*/)")
end

local function file_exists(file)
    local f = io.open(file, "rb")

    if f then f:close() end
    return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}

    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

local function distance(n1, n2)
    local threshold = 3
    local distance = math.abs(n1 - n2)

    if distance > 0 and distance <= threshold then
        return n1 - n2
    end
end

local function analyze_line(line)
    local t = {} -- store för nummer i raden
    local str = ""

    local previous = nil
    local increasing = nil
    local safe = nil

    for n in line:gmatch("%d+") do
        n = tonumber(n)
        if previous == nil then
            previous = n
            goto continue
        end

        local distance = distance(previous, n)

        if distance then
            if increasing == nil and n > previous then
                -- print(string.format("Increasing"))
                increasing = true
            elseif increasing == nil and n < previous then
                -- print("Decreasing")
                increasing = false
            end

            if increasing == true and n < previous then
                -- print(string.format("Error. Is increasing and %d < %d", n, previous))
                safe = false
                break
            elseif increasing == false and n > previous then
                -- print(string.format("Error. Is decreasing and %d > %d", n, previous))
                safe = false
                break
            elseif n == previous then
                safe = false
                break
            else
                safe = true
            end
        else
            -- print(string.format("Error! Distance is %d", math.abs(n - previous)))
            safe = false
            break
        end

        previous = n

        ::continue::
    end

    -- print(string.format("Line: %s, Safe: %s", line, safe))

    return safe
end

local function main()
    local path = cwd() or ""
    local file = path .. 'input.txt'
    if not file_exists(file) then
        print("file not found!")
        return
    end
    local lines = lines_from(file)
    local safe = 0

    local i = 0

    -- lines = {
    --     "7 6 4 2 1",
    --     "1 2 7 8 9",
    --     "9 7 6 2 1",
    --     "1 3 2 4 5",
    --     "8 6 4 4 1",
    --     "1 3 6 7 9"
    -- }

    for _,l in pairs(lines) do
        if analyze_line(l) then
            i = i + 1
        end
    end

    print(string.format("Safe lines: %d", i))
end

main()
