local function readFromFile(filename)
  local file = assert(io.open(filename, "r+"), 'File does not exist')
  local content = file:read("*all")
  file:close();

  return content;
end
