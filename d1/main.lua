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
        -- print(string.format("%d\t%d\tdistance = %d\tsum = %d", v, arr2[k], distance, sum))
    end
    return sum
end

local function separate_columns(input, arr1, arr2)
    for _,v in pairs(input) do
        local num1, num2 = v:match("(%d+)%s+(%d+)")
        if num1 and num2 then
            -- print(num1, num2)
            table.insert(arr1, tonumber(num1))
            table.insert(arr2, tonumber(num2))
        end
    end

    table.sort(arr1)
    table.sort(arr2)

    return arr1, arr2
end

local function table_find(find, list)
    local occurences = 0
    for i = 1, #list do
        if list[i] == find then
            occurences = occurences + 1
        else
            occurences = occurences
        end
    end

    -- if occurences > 1 then
    --    print(string.format("Found %d %d times.", find, occurences))
    -- end

    return find * occurences
end

local function calculate_similarity(arr1, arr2)
    local sim = 0
    for _,v in pairs(arr1) do
        local found = table_find(v, arr2)
        if found then
            sim = sim + found
        end
    end

    return sim
end

local function main()
    local path = cwd() or ""
    local file = path .. 'input.txt'
    if not file_exists(file) then
        print("file not found!")
        return
    end
    local lines = lines_from(file)
    local first_list = {}
    local second_list = {}
    local total = 0
    local similarity = 0

    first_list, second_list = separate_columns(lines, first_list, second_list)

    if compare_sizes(first_list, second_list) then
        total = getDistance(first_list, second_list)
        similarity = calculate_similarity(first_list, second_list)

        print(string.format("Total distance is:\t%d", total))
        print(string.format("Similarity score is:\t%d", similarity))
    end


end

main()
