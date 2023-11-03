--- Opens the action pane and calls the callback with the selected action id as argument
--- @param callback function
local function GetSelectedAction(callback)
  local action = 0;
  local actionPaneOpened = false;

  local function handleActionPane()
    if (not actionPaneOpened) then
      action = reaper.PromptForAction(1, 0, 0)
      actionPaneOpened = true
    else
      action = reaper.PromptForAction(0, 0, 0)
    end

    if action > 0 then
      while action > 0 do
        callback(action)
        action = reaper.PromptForAction(0, 0, 0)
        actionPaneOpened = false
      end

      reaper.PromptForAction(-1, 0, 0)
      actionPaneOpened = false
    elseif action == 0 and actionPaneOpened then
      reaper.defer(handleActionPane)
    else
      actionPaneOpened = false
    end
  end

  handleActionPane()
end
