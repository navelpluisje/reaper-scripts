---Read the lines of a file with the given name
---@param filename string The filename of teh file to read the content from
---@return table
local function readLinesFromFile(filename)
  local lines = {}
  for line in assert(io.lines(filename), 'File does not exist') do
    table.insert(lines, line);
  end

  return lines;
end
