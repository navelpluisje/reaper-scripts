local function createPath(path)
  return path:gsub('/', package.config:sub(1, 1));
end

local function writeToFile(fileName, content)
  local zoneFile = io.open(createPath(fileName), 'w+');
  ---@diagnostic disable-next-line: need-check-nil
  zoneFile:write(content);
  ---@diagnostic disable-next-line: need-check-nil
  zoneFile:close();
end
