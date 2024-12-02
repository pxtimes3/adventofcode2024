local mathutils = {}

--[[
Checks if a value is within a specified range (inclusive).

@param value  The number to check
@param min    The minimum value of the range
@param max    The maximum value of the range
@return       true if value is between min and max (inclusive), false otherwise
]]--
function mathutils.in_range(value, min, max)
    return value >= min and value <= max
end


--[[
    Constrains a value between a minimum and maximum range.

    @param value The number to clamp
    @param min   The minimum allowed value
    @param max   The maximum allowed value
    @return      The clamped value between min and max
]]
function mathutils.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end


--[[
Checks if the distance between two numbers falls within a specified range.
Returns the difference between the numbers if the distance is within range,
or nil otherwise. Default range is [1, 3].

@param n1 First number
@param n2 Second number
@param range Optional table with min and max range values {min, max}
@return Difference between n1 and n2 if distance is in range, nil otherwise
]]
function mathutils.check_distance(n1, n2, range)
    range = range or {min = 1, max = 3}
    local d = math.abs(n1 - n2)

    if range then
        if mathutils.in_range(d, range[1], range[2]) then
            return n1 - n2
        end
    else
        return n1 - n2
    end
end

return mathutils
