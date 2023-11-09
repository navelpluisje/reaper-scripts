--- Returns the value of a number rounded to the nearest integer
--- @param number number
--- @return integer
local function round(number)
  local rest = number % 1;
  if (rest < 0.5) then
    return math.floor(number);
  else
    return math.ceil(number);
  end
end

return round;
