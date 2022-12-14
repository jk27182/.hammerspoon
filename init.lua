--- start quick open applications 
function open_app(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end
--- quick open applications
hs.hotkey.bind({"shift", "alt"}, "S", open_app("Safari"))
hs.hotkey.bind({"shift", "alt"}, "M", open_app("Mail"))
hs.hotkey.bind({"shift", "alt"}, "E", open_app("Emacs"))
hs.hotkey.bind({"shift", "alt"}, "N", open_app("Reminders"))
hs.hotkey.bind({"shift", "alt"}, "R", open_app("RStudio"))
hs.hotkey.bind({"shift", "alt"}, "C", open_app("Visual Studio Code"))
hs.hotkey.bind({"shift", "alt"}, "F", open_app("Finder"))
hs.hotkey.bind({"shift", "alt"}, "G", open_app("Google Chrome"))
hs.hotkey.bind({"shift", "alt"}, "V", open_app("Preview"))
--- end quick open applications

-- hs.hotkey.bind({"alt", "shift"}, "H", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
-- 
--   f.x = f.x - 10
--   win:setFrame(f)
-- end)

-- Fenster "magnetisieren"
function magnetizeWindowLeft() 
	local app = hs.application.frontmostApplication()
	print(app)
	local t = app:findMenuItem({"Window", "Move Window to Left Side of Screen"})
	print(t)
	local t = app:findMenuItem({"Fenster"})
	print(t)
	print(app:getMenuItems())
	app:selectMenuItem({"Window", "Move Window to Left Side of Screen"})
end
hs.hotkey.bind({"shift", "alt"}, 'P', magnetizeWindowLeft)
--
hs.hotkey.bind({"shift", "alt"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"shift", "alt"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)


hs.hotkey.bind({"shift", "alt"}, "return", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x 
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)
