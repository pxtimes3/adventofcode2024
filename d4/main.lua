local fu = require 'lib.fileutils'
local re = require 'rex_pcre2'

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

local sequence = "XMAS"

local function is_valid(x, y)
	return x >= 1 and x <= #matrix[1] and y >= 1 and y <= #matrix
end

local function check_neighbors(x, y, currentSeqPos, direction, found)
	if currentSeqPos == 1 and matrix[y][x] ~= 'X' then
		return false
	end

	if currentSeqPos >= #sequence then
		local key = x..","..y..","..direction[1]..","..direction[2]
		if not found[key] then
			found[key] = true
			return true
		end
		return false
	end

	local newX = x + direction[1]
	local newY = y + direction[2]
	
	if is_valid(newX, newY) then
		local nextExpected = string.sub(sequence, currentSeqPos + 1, currentSeqPos + 1)
		if matrix[newY][newX] == nextExpected then
			return check_neighbors(newX, newY, currentSeqPos + 1, direction, found)
		end
	end
	
	return false
end

local function find_sequences()
	local found = {}
	local count = 0
	
	local directions = {
		{1,0},   -- right
		{-1,0},  -- left
		{0,1},   -- down
		{0,-1},  -- up
		{1,1},   -- down-right
		{-1,1},  -- down-left
		{1,-1},  -- up-right
		{-1,-1}  -- up-left
	}

	-- for for for eller for for lamm? >_<
	for y = 1, #matrix do
		for x = 1, #matrix[1] do
			if matrix[y][x] == 'X' then
				for _, dir in ipairs(directions) do
					if check_neighbors(x, y, 1, dir, found) then
						count = count + 1
						print(string.format("Found XMAS starting at x:%d, y:%d going dx:%d dy:%d", x, y, dir[1], dir[2]))
					end
				end
			end
		end
	end
	print("\nTotal sequences found: " .. count)
end


local function print_matrix()
	print("Matrix contents:")
	for y = 1, #matrix do
		local line = ""
		for x = 1, #matrix[y] do
			line = line .. matrix[y][x] .. " "
		end
		print(line)
	end
	print("Matrix dimensions:", #matrix, "rows x", #matrix[1], "columns")
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
	
	find_sequences()
end

main()