local fileutils = require("lib.fileutils")
local mathutils = require("lib.mathutils")

local function analyze_line(line)
    local previous = nil
    local increasing = nil
    local safe = true
    local numbers = {}

    -- print(string.format("Got line %s", line))

    for n in line:gmatch("%d+") do
        table.insert( numbers, tonumber(n) )
    end

    for i = 1, #numbers do
        n = numbers[i]
        if previous == nil then
            previous = n
            goto continue
        end

        local valid = mathutils.check_distance(previous, n, {1, 3})

        if not valid then
            safe = false
            break
        else
            if increasing == nil then
                increasing = n > previous
            elseif (increasing and n < previous) or (not increasing and n > previous) then
                safe = false
                break
            end
        end

        previous = n
        ::continue::
    end

    -- print(string.format("Line: %s\t\t\tSafe: %s", line, safe)) -- funkar för part 1
    return safe
end

local function analyze_with_removal(line)
    local numbers = {}
    for n in line:gmatch("%d+") do
        table.insert(numbers, tonumber(n))
    end

    for i = 1, #numbers do
        local test_numbers = ""
        for j = 1, #numbers do
            if i ~= j then
                test_numbers = test_numbers .. " " .. numbers[j]
            end
        end

        if analyze_line(test_numbers) then
            return true
        end
    end
    return false
end

local function main()
    local path = fileutils.cwd() or ""
    local file = path .. 'input.txt'
    if not fileutils.file_exists(file) then
        print("file not found!")
        return
    end
    local lines = fileutils.lines_from(file)
    local safe = 0

    local part1safe = 0
    local part2safe = 0

    -- control
    local control_lines = {
        "7 6 4 2 1", -- p1 safe,   p2 safe
        "1 2 7 8 9", -- p1 unsafe, p2 unsafe
        "9 7 6 2 1", -- p1 unsafe, p2 unsafe
        "1 3 2 4 5", -- p1 unsafe, p2 safe (removes 3)
        "8 6 4 4 1", -- p1 unsafe, p2 safe (removes 4)
        "1 3 6 7 9"  -- p1 safe,   p2 safe
    }

    -- print("Part 1")
    for _,l in pairs(lines) do
        if analyze_line(l, 0) then
            part1safe = part1safe + 1
        end
    end

    -- print(string.format("\nPart 2"))
    for _,l in pairs(lines) do
        if analyze_with_removal(l) then
            part2safe = part2safe + 1
        end
    end

    print(string.format("\nPart 1: Safe lines: %d", part1safe))
    print(string.format("Part 2: Safe lines: %d", part2safe))
end

main()
