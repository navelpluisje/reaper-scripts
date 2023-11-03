--- Create path with correct separator for the different
--- operating system
--- @param path string The full path to store the file to
--- @return string
local function createPath(path)
  return '' .. path:gsub('/', package.config:sub(1, 1));
end

--- Write the content to a file with the given filename
--- @param fileName string  Full filename with path to store the content into
--- @param content string The content to store
local function writeToFile(fileName, content)
  local zoneFile = io.open(createPath(fileName), 'w+');
  ---@diagnostic disable-next-line: need-check-nil
  zoneFile:write(content);
  ---@diagnostic disable-next-line: need-check-nil
  zoneFile:close();
end
