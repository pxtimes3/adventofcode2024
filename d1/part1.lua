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

local function compare_sizes(arr1, arr2)
    sz1 = #arr1
    sz2 = #arr2

    if sz1 == sz2 then
        return true
    end
    print('Different sizes!', sz1, sz2)
    return false
end

local function getDistance(arr1, arr2)
    local sum = 0
    for k,v in ipairs(arr1) do
        local distance = math.abs(v - arr2[k])
        sum = sum + distance
        print(string.format("%d\t%d\tdistance = %d\tsum = %d", v, arr2[k], distance, sum))
    end
    return sum
end

local function separate_columns(input, arr1, arr2)
    for _,v in pairs(input) do
        local num1, num2 = v:match("(%d+)%s+(%d+)")
        if num1 and num2 then
            table.insert(arr1, tonumber(num1))
            table.insert(arr2, tonumber(num2))
        end
    end

    table.sort(arr1)
    table.sort(arr2)

    return arr1, arr2
end

local function main()
    local file = 'input.txt'
    local lines = lines_from(file)
    local first_list = {}
    local second_list = {}
    local total = 0

    first_list, second_list = separate_columns(lines, first_list, second_list)

    if compare_sizes(first_list, second_list) then
        total = getDistance(first_list, second_list)
        print(string.format("Total distance is: %d", total))
    end
end

main()
