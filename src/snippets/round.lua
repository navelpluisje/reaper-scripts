local function round(number)
  local rest = number % 1;
  if (rest < 0.5) then
    return math.floor(number);
  else
    return math.ceil(number);
  end
end
