-- v0.0.2
local function round(number)
  local rest = number % 1;
  if (rest < 0.5) then
    return math.floor(number);
  else
    return math.ceil(number);
  end
end

local function speak(str, showAlert)
  showAlert = showAlert or false;
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(str);
  elseif (showAlert) then
    reaper.MB(str, 'Script message', 0);
  end
end

local function getFxData(trackId, fxId, paramId)
  trackId = trackId or 0;
  fxId = fxId or 0;
  paramId = paramId or 9;

  local track = reaper.GetTrack(0, trackId);
  local _, fxName = reaper.TrackFX_GetFXName(track, fxId);
  local _, paramName = reaper.TrackFX_GetParamName(track, fxId, paramId);
  local _, step, smallstep, largestep, istoggle = reaper.TrackFX_GetParameterStepSizes(
    track,
    fxId,
    paramId
  );
  local nbSteps = round(1 / step);
  local stepslist = '';
  local result = string.format('Fx-Name: %s\nParam: %s\nParamId: %s\n', fxName, paramName, paramId);

  if (istoggle) then
    result = result .. 'Param is a toggle';
    stepslist = stepslist .. '[ 0.0 1.0 ]';

    local action = reaper.MB(result, 'Steps for' .. fxName, 1);
    if (action == 1) then
      reaper.CF_SetClipboard(stepslist);
    end
  elseif (nbSteps > 1 and nbSteps .. '' ~= 'inf' and nbSteps .. '' ~= '1.#INF') then
    result = result .. string.format('Number of Steps: %s', nbSteps);
    stepslist = stepslist .. '[ 0.0'
    for i = 1, nbSteps - 1 do
      stepslist = stepslist .. ' ' .. string.sub((i * step) .. '', 1, 6)
    end
    stepslist = stepslist .. ' 1.0 ]';

    local action = reaper.MB(result, 'Steps for' .. fxName, 1);
    if (action == 1) then
      reaper.CF_SetClipboard(stepslist);
    end
  else
    speak('Param has no steps', true);
  end
end

local function main()
  local retval, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX();
  if (retval) then
    getFxData(tracknumber - 1, fxnumber, paramnumber);
  else
    speak('No parameter selected', true);
  end
end

main()
