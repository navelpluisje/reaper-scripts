--[[
  Add ReaComp to given track and add sidechain routing to selected tracks
  @author: Erwin Goossen
--]]
local speak = require('speak');

local function showError(message)
  speak(message, true);
end

local function getTrackByName(value)
  local nbTracks = reaper.GetNumTracks();

  for i = 0, nbTracks - 1, 1 do
    local t = reaper.GetTrack(0, i);
    if (not t) then goto loopEnd end

    local _, name = reaper.GetTrackName(t)

    if (name == value) then
      return t
    end
    ::loopEnd::
  end

  return nil;
end

local function addSend(srcTrack, dstTrack)
  local sendIndex = reaper.CreateTrackSend(srcTrack, dstTrack)
  reaper.SetTrackSendInfo_Value(srcTrack, 0, sendIndex, 'D_VOL', 1)
  reaper.SetTrackSendInfo_Value(srcTrack, 0, sendIndex, 'I_DSTCHAN', 2)
end

local function main()
  local retVal, value = reaper.GetUserInputs('Titel', 1, 'Track id or name', '0');
  local track;

  if (not retVal) then
    return showError('Cancelled');
  end

  if (tonumber(value) ~= nil) then
    track = reaper.GetTrack(0, tonumber(value));
  else
    track = getTrackByName(value);
  end

  if (not track) then
    return showError('Track does not exist');
  end
  if (reaper.IsTrackSelected(track)) then
    return showError('Track is also selected, select an unselected track for the effect');
  end
  -- We have the track to add the plugin to
  local fxIndex = reaper.TrackFX_AddByName(track, 'ReaComp (Cockos)', false, 1);
  if (fxIndex < 0) then
    return showError('Not able to add effect');
  end
  reaper.SetMediaTrackInfo_Value(track, 'I_NCHAN', 4);
  reaper.TrackFX_SetParam(track, fxIndex, 8, 2 / 1084) -- set in detector to auxilary

  for i = 0, reaper.CountSelectedTracks(0) - 1, 1 do
    local srcTrack = reaper.GetSelectedTrack(0, i);
    addSend(srcTrack, track);
  end
end

if (reaper.CountSelectedTracks(0) == 0) then
  return showError('No track selected');
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Create ReaGate sidechain routing', -1)
