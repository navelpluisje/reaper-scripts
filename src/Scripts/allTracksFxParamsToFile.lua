local round = require('round');
local speak = require('speak');
local createPath = require('createPath');
local writeToFile = require('writeToFile');
local fileExists = require('fileExists');

local unWantedParamNames = {
  'midi cc',  -- Decomposer, Arturia
  'reserved', -- Decomposer, Valhalla
  -- Blue Cat
  'midi program change',
  'midi controller',
  -- Arturia
  'unassigned',
  'vst_programchange_',
  'mpe_',
  -- Spitfire
  'general purpose',
  -- global
  'undefined',
  'cc%d%d',
  'macro_',
  '#%d%d',
}

--- Check if the param name is not in the list of unwanted names
--- @param name string The param name
--- @return boolean
local function isWantedParam(name)
  local result = true;

  for i = 1, #unWantedParamNames do
    local startIndex = string.find(string.lower(name), unWantedParamNames[i]);
    if (startIndex ~= nil) then
      result = false;
    end
  end

  return result
end

local zoneStart = 'Zone "%s"\n';
local zoneParam = '    FXParam %d "%s" %s\n';
local zoneEnd = 'ZoneEnd';
local path = reaper.GetResourcePath() .. createPath('/CSI/Zones/ZoneRawFXFiles/');
-- Create the folder. Does not do anything if it already exists
os.execute('mkdir ' .. path);

local function createFileName(fxName, version)
  fxName = string.gsub(fxName:gsub('%s', '-'), '[]:%(%)]', '');
  return path .. fxName .. '-V' .. version .. '.zon';
end

local function getFxParamSteps(track, fxId, paramId)
  local _, step, _, _, istoggle = reaper.TrackFX_GetParameterStepSizes(track, fxId, paramId);
  local nbSteps = round(1 / step);

  if (istoggle) then
    return '[ 0.0 1.0 ]';
  elseif (nbSteps > 1 and nbSteps .. '' ~= 'inf' and nbSteps .. '' ~= '1.#INF') then
    local stepslist = '[ 0.0'
    for i = 1, nbSteps - 1 do
      stepslist = stepslist .. ' ' .. string.sub((i * step) .. '', 1, 6)
    end
    stepslist = stepslist .. ' 1.0 ]';
    return stepslist;
  end

  return '';
end

local function getFileVersionNumber(fxName)
  local version = 1;
  local continue = true

  while (continue) do
    if (fileExists(createFileName(fxName, version))) then
      version = version + 1;
    else
      continue = false
    end
  end

  return version;
end

local function getFxParams(trackId, fxId)
  fxId = fxId or 0;

  local track = reaper.GetTrack(0, trackId);
  local _, fxName = reaper.TrackFX_GetFXName(track, fxId);
  local nbParams = reaper.TrackFX_GetNumParams(track, fxId);
  local version = getFileVersionNumber(fxName);
  local content = string.format(zoneStart, fxName);

  for paramId = 0, nbParams, 1 do
    local hasName, paramName = reaper.TrackFX_GetParamName(track, fxId, paramId);

    if (hasName and isWantedParam(paramName)) then
      local paramSteps = getFxParamSteps(track, fxId, paramId);
      content = content .. string.format(zoneParam, paramId, paramName, paramSteps);
    end
  end

  content = content .. zoneEnd;

  writeToFile(createFileName(fxName, version), content);
end

local function main()
  local trackCount = reaper.GetNumTracks();
  local fxCount = 0;
  local fxList = {};

  for trackId = 0, trackCount - 1 do
    local track = reaper.GetTrack(0, trackId);
    local trackFxCount = reaper.TrackFX_GetCount(track);

    if (trackFxCount > 0) then
      for fxId = 0, trackFxCount - 1 do
        local _, fxName = reaper.TrackFX_GetFXName(track, fxId);
        fxList[fxName] = {
          trackId = trackId,
          fxId = fxId,
        }
      end
    end
  end

  for _, fx in pairs(fxList) do
    fxCount = fxCount + 1;
    getFxParams(fx.trackId, fx.fxId);
  end

  if (string.find(reaper.GetOS(), 'OS')) then
    os.execute('open ' .. path);
  elseif (string.find(reaper.GetOS(), 'Win')) then
    os.execute('start ' .. path);
  end

  speak('Script finished, ' .. fxCount .. ' zone files created for ' .. trackCount .. ' tracks', true);
end

main()
