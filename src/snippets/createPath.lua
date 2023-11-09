--- Create path with correct separator for the different
--- operating system
--- @param path string The full path to store the file to
--- @return string
local function createPath(path)
  return '' .. path:gsub('/', package.config:sub(1, 1));
end

return createPath;
