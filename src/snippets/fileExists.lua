---Check if a file exists
---@param name string Path to check
---@return boolean
local function fileExists(name)
  local file = io.open(name, "r")
  if (file ~= nil) then
    io.close(file);
    return true;
  else
    return false;
  end
end

return fileExists
;
