local function readLinesFromFile(filename)
  local lines = assert(io.lines(filename), 'File does not exist');

  return lines;
end
