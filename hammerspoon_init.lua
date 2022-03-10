hs.hotkey.bind({"option"}, "space", function()
  local app = hs.application.get("kitty")
  if app then
    if not app:mainWindow() then
      app:selectMenuItem({"Shell", "New OS Window"})
    elseif app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  else
    hs.application.launchOrFocus("kitty")
  end
end)

DEBUG_TAP = false
tap = hs.eventtap.new({hs.eventtap.event.types.systemDefined}, function(event)
	if DEBUG_TAP then
		print("event tap debug got event:")
		print(hs.inspect.inspect(event:getRawEventData()))
		print(hs.inspect.inspect(event:getFlags()))
		print(hs.inspect.inspect(event:systemKey()))
	end
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
