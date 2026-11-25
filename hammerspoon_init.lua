-- Toggle Ghostty with Ctrl + the top-left key below Esc
local function toggleGhostty()
  local id = "com.mitchellh.ghostty"
  local app = hs.application.get(id)
  if not app then
    hs.application.launchOrFocusByBundleID(id)
    return
  end
  if app:isFrontmost() then
    app:hide()
  elseif #app:allWindows() == 0 then
    app:activate()
    app:selectMenuItem({"File", "New Window"})
  else
    app:unhide()
    app:activate()
  end
end
hs.hotkey.bind({"ctrl"}, "`", toggleGhostty)

-- DEBUG_TAP = false
tap = hs.eventtap.new({hs.eventtap.event.types.systemDefined}, function(event)
  -- if DEBUG_TAP then
  --   print("event tap debug got event:")
  --   print(hs.inspect.inspect(event:getRawEventData()))
  --   print(hs.inspect.inspect(event:getFlags()))
  --   print(hs.inspect.inspect(event:systemKey()))
  -- end
  local sys_key_event = event:systemKey()
  if not sys_key_event or not sys_key_event.down or sys_key_event['repeat'] then
    return false -- do not delete event
  end
  if sys_key_event.key == "PLAY" then
    hs.spotify.playpause()
    return true
  end
  return false
end)
tap:start()
