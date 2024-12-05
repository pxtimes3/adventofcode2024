local fu = require 'lib.fileutils'

local matrix_test = {
	{'M','M','M','S','X','X','M','A','S','M'},
	{'M','S','A','M','X','M','S','M','S','A'},
	{'A','M','X','S','X','M','A','A','M','M'},
	{'M','S','A','M','A','S','M','S','M','X'},
	{'X','M','A','S','A','M','X','A','M','M'},
	{'X','X','A','M','M','X','X','A','M','A'},
	{'S','M','S','M','S','A','S','X','S','S'},
	{'S','A','X','A','M','A','S','A','A','A'},
	{'M','A','M','M','M','X','M','M','M','M'},
	{'M','X','M','X','A','X','M','A','S','X'}
}

local matrix = {}

local function is_valid(x, y)
	return x >= 1 and x <= #matrix[1] and y >= 1 and y <= #matrix
end

local function check_direction(x, y, dx, dy)
    if not is_valid(x+dx, y+dy) then return false end
    if matrix[y+dy][x+dx] ~= 'M' then return false end

    if not is_valid(x+2*dx, y+2*dy) then return false end
    if matrix[y+2*dy][x+2*dx] ~= 'A' then return false end

    if not is_valid(x+3*dx, y+3*dy) then return false end
    if matrix[y+3*dy][x+3*dx] ~= 'S' then return false end

    return true
end

local function find_sequences()
    local count = 0
    local directions = {
        {1,0}, {-1,0}, {0,1}, {0,-1},
        {1,1}, {-1,1}, {1,-1}, {-1,-1}
    }

    for y = 1, #matrix do
        for x = 1, #matrix[1] do
            if matrix[y][x] == 'X' then
                for _, dir in ipairs(directions) do
                    if check_direction(x, y, dir[1], dir[2]) then
                        count = count + 1
                        print(string.format("Found XMAS at x:%d,y:%d dir:%d,%d", 
                            x, y, dir[1], dir[2]))
                    end
                end
            end
        end
    end
    return count
end


local function main()
	local wp = fu.cwd()
	local lines = fu.open_file(wp .. './input.txt')

	for x in pairs(lines) do
		local row = {}
		for i = 1, #lines[x] do
			local char = string.sub(lines[x], i, i)
			table.insert(row, i, char)
		end
		table.insert(matrix, x, row)
	end

	-- print_matrix()
	-- print(string.format("Matrix rows: %d", #matrix))
	
	print(find_sequences())
end

main()