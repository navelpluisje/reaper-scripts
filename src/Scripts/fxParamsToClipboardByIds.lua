local speak = require('speak');
local splitString = require('splitString');

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

  if (reaper.CF_SetClipboard(result)) then
    speak('The params are copied to the clipboard', false);
  else
    speak('Params are not copied', false);
  end;
end

local function main()
  local retval, values = reaper.GetUserInputs('Enter a trackId and pluginId', 2, 'Track id,Plugin id', '');
  if (retval) then
    local x = splitString(values, ',');
    getFxParams(tonumber(x[1]) - 1, tonumber(x[2]));
  else
    speak('No plugin selected', true);
  end
end

main()
