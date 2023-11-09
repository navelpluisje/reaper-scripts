---Read the content of a file with the given name
---@param filename string The filename of teh file to read the content from
---@return string
local function readFromFile(filename)
  local file = assert(io.open(filename, "r+"), 'File does not exist')
  local content = file:read("*aL")
  file:close();

  return content;
end

return readFromFile
