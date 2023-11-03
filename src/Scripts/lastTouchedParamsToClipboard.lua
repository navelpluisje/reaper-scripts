-- v0.0.2
local function speak(str, showAlert)
  showAlert = showAlert or false;
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(str);
  elseif (showAlert) then
    reaper.MB(str, 'Script message', 0);
  end
end

--- Copy the given text to the clipboard
---@param text string The text to copy to the clipboard
---@return boolean
local function copyToClipboard(text)
  -- Check if the operating system supports the 'pbcopy' command (MacOS)
  if os.execute("type pbcopy >/dev/null 2>&1") then
    os.execute("echo '" .. text .. "' | pbcopy")
    return true
  end

  -- Check if the operating system supports the 'xclip' command (Linux)
  if os.execute("type xclip >/dev/null 2>&1") then
    os.execute("echo -n '" .. text .. "' | xclip -selection clipboard")
    return true
  end

  -- Check if the operating system supports the 'clip' command (Windows)
  if os.execute("type clip >/dev/null 2>&1") then
    os.execute("echo | set /p='" .. text .. "' | clip")
    return true
  end

  -- If none of the clipboard commands are available, return false
  return false
end

local zoneStart = 'Zone "%s"\n'
local zoneParam = '    FXParam %d "%s"\n'
local zoneEnd = 'ZoneEnd'

local function getFxParams(trackId, fxId)
  trackId = trackId or 0;
  fxId = fxId or 0;

  local track = reaper.GetTrack(0, trackId);
  local _, fxName = reaper.TrackFX_GetFXName(track, fxId);
  local nbParams = reaper.TrackFX_GetNumParams(track, fxId);

  local result = string.format(zoneStart, fxName);

  for paramId = 1, nbParams, 1 do
    local hasName, paramName = reaper.TrackFX_GetParamName(track, fxId, paramId);
    if (hasName) then
      result = result .. string.format(zoneParam, paramId, paramName);
    end
  end

  result = result .. zoneEnd;

  if (copyToClipboard(result)) then
    speak('The params are copied to the clipboard');
  else
    speak('Params are not copied');
  end;
end

local function main()
  local retval, tracknumber, _, fxnumber = reaper.GetFocusedFX2();
  if (retval) then
    getFxParams(tracknumber - 1, fxnumber);
  else
    speak('No parameter selected', true);
  end
end

main()
