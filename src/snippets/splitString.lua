---Split a string by the given seperator
---@param input string The string to split
---@param sep string The separartor. Defaults to a space
---@return table
local function splitString(input, sep)
  sep = sep or '%s';
  local result = {};
  for str in string.gmatch(input, "([^" .. sep .. "]+)") do
    if (str ~= nil) then
      table.insert(result, str);
    end
  end
  return result;
end

return splitString;
