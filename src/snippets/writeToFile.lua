local createPath = require('createPath')

--- Write the content to a file with the given filename
--- @param fileName string  Full filename with path to store the content into
--- @param content string The content to store
--- @return boolean
local function writeToFile(fileName, content)
  local file = io.open(createPath(fileName), 'w+');
  if (file == nil) then
    return false;
  end
  ---@diagnostic disable-next-line: need-check-nil
  file:write(content);
  ---@diagnostic disable-next-line: need-check-nil
  file:close();
  return true;
end

return writeToFile;
