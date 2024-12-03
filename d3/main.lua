local fileutils = require("lib.fileutils")
local rex = require "rex_pcre2"

local function sanitize(str, p)
    local matches = {}
    local multiply = true
    local sum = 0

    local i = 1
    for m in rex.gmatch(str, [[(mul\(\d+,\d+\)|do\(\)|don't\(\))]]) do
       table.insert(matches, m)
    end
        
    for n = 1, #matches do
        if string.sub(matches[n], 1, 5) == "don't" and p == 2 then
            multiply = false
        elseif string.sub(matches[n], 1, 4) == "do()" and p == 2 then
            multiply = true
        elseif string.sub(matches[n], 1, 3) == "mul" and multiply == true then
            local _, d1, d2 = rex.match(matches[n], [[(mul\()(\d+),(\d+)]])
            sum = sum + d1 * d2
        end
    end

    return sum
end

local function main()
    local path = fileutils.cwd() or ""
    local file = path .. 'input.txt'
    if not fileutils.file_exists(file) then
        print("file not found!")
        return
    end
    local lines = fileutils.lines_from(file)
    local oneliner = ""

    local p1sum = 0
    local p2sum = 0

    -- insert matches from each line in t
    for _, v in ipairs(lines) do
        oneliner = oneliner .. v
    end

    p1sum = sanitize(oneliner, 1)
    p2sum = sanitize(oneliner, 2)
    print(string.format("P1 Sum: %d", p1sum))
    print(string.format("P2 Sum: %d", p2sum))
end

main()
