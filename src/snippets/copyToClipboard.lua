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
