--- When osara is installed it should speak out the message
--- When showAlert is set, it will also show a dialog
--- @param message string The message to speak out
--- @param showAlert boolean Wether or not to show a dialog
local function speak(message, showAlert)
  showAlert = showAlert or false;

  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(message);
  elseif (showAlert) then
    reaper.MB(message, 'Script message', 0);
  end
end

return speak;
