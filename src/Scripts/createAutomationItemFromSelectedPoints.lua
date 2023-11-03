--[[
  Create automation item from selected envelope points
  @author: Erwin Goossen
--]]
local function speak(str, showAlert)
  showAlert = showAlert or false;
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(str);
  elseif (showAlert) then
    reaper.MB(str, 'Script message', 0);
  end
end

local function main()
  local TrackEnvelope = reaper.GetSelectedTrackEnvelope(0);
  local nbPoints = reaper.CountEnvelopePoints(TrackEnvelope);
  local startTime = 0;
  local endTime = 0;
  local lastTime = 0;
  local inSelection = false;

  for i = 0, nbPoints - 1, 1 do
    local retval, time, _, _, _, selected = reaper.GetEnvelopePoint(TrackEnvelope, i);
    if (retval and selected and not inSelection) then
      inSelection = true;
      startTime = time;
    end
    if (inSelection and retval and not selected) then
      inSelection = false;
      endTime = lastTime;
    end
    lastTime = time;
  end

  if (inSelection and endTime == 0) then
    endTime = lastTime;
  end

  if (endTime > 0) then
    local st, et = reaper.GetSet_LoopTimeRange2(0, true, false, startTime, endTime, false)
    local result = reaper.InsertAutomationItem(TrackEnvelope, -1, startTime, endTime - startTime);
    speak('Automation item is created');
  else
    speak('There were no selected envelope points');
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Create automationItem', -1)
