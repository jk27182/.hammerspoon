-- Shell ausführungen
-- function shell_cmd(name, bool)
-- 	return function()
-- 		hs.execute(name, bool)
-- 	end
-- end
-- hs.hotkey.bind({"shift", "alt"}, "N", shell_cmd("open -a iTerm ~/scripts/make_note.sh", true))
-- hs.hotkey.bind({"shift", "alt"}, "V", shell_cmd("open -a iTerm ~/scripts/neovim_browser.sh", true))
-- hs.hotkey.bind({"shift", "alt"}, "T", shell_cmd("open -a iTerm ~/scripts/todos_in_notes.sh", true))

-- local window_switcher = require("Window_switcher")
--
-- hs.hotkey.bind({"cmd", "shift", }, "J", function()
--     window_switcher.windowFuzzySearch()
-- end)
-- local tab_switcher = require("safari_tab_switcher")
-- hs.tabs.enableForApp(hs.application.get("Safari"))
-- hs.hotkey.bind({"cmd", "shift", }, "S", function()
--     tab_switcher.tabFuzzySearch()
-- end)
--- start quick open applications
function open_app(name)
	return function()
		local app = hs.application.get(name)
		if app then
			if app:isFrontmost() then
				app:hide()
			else
				app:activate()
			end
		else
			hs.application.launchOrFocus(name)
			if name == "Finder" then
				hs.appfinder.appFromName(name):activate()
			end
		end
	end
end
-- Screenshot to Clipboard
--hs.hotkey.bind({"cmd", "shift"}, "4", {"cmd", "shift", "ctrl", "4"})
hs.hotkey.bind({ "cmd" }, "G", function()
	hs.eventtap.keyStroke({ "cmd", "shift", "ctrl" }, "4")
end)

-- Shortcut für Kurzebefehle
hs.hotkey.bind({ "shift", "alt" }, "E", function()
	hs.shortcuts.run("Add New Reminder")
end)
hs.hotkey.bind({ "shift", "alt" }, "W", function()
	hs.shortcuts.run("Add New Reminder with Screenshot")
end)
--

--- quick open applications
hs.hotkey.bind({ "shift", "alt" }, "S", open_app("Safari"))
hs.hotkey.bind({ "shift", "alt" }, "M", open_app("Mail"))
-- hs.hotkey.bind({"shift", "alt"}, "E", open_app("Reminders"))
-- hs.hotkey.bind({"shift", "alt"}, "N", open_app("Reminders"))
hs.hotkey.bind({ "shift", "alt" }, "R", open_app("Reminders"))
hs.hotkey.bind({ "shift", "alt" }, "F", open_app("Finder"))
-- hs.hotkey.bind({"shift", "alt"}, "G", open_app("Google Chrome"))
hs.hotkey.bind({ "shift", "alt" }, "G", open_app("ChatGPT"))
hs.hotkey.bind({ "shift", "alt" }, "P", open_app("Preview"))
hs.hotkey.bind({ "shift", "alt" }, "space", open_app("Terminal"))
hs.hotkey.bind({ "shift", "alt" }, "N", open_app("Obsidian"))
-- hs.hotkey.bind({"shift", "alt"}, "M", open_app("Notion"))
hs.hotkey.bind({ "shift", "alt" }, "K", open_app("Calendar"))
hs.hotkey.bind({ "shift", "alt" }, "D", open_app("Firefox"))
hs.hotkey.bind({ "shift", "alt" }, "V", open_app("Neovide"))
hs.hotkey.bind({ "shift", "alt" }, "O", open_app("Orbstack"))
hs.hotkey.bind({ "shift", "alt" }, "Z", open_app("Zotero"))
hs.hotkey.bind({ "shift", "alt" }, "C", open_app("Code"))
-- hs.hotkey.bind({"shift", "alt"}, "P", open_app("superproductivity"))

--- end quick open applications

-- Jump to a Safari tab
function jump_to_safari_tab()
	local prompt = hs.dialog.textPromp("tab zum suchen")
	hs.osascript.javascript([[
	(function() {
	var safari = Application('Safari');
	safari.activate();

	for (win of safari.windows()) {
	  var tabIndex =
	    win.tabs().findIndex(tab => tab.url().match(/meet.google.com/));

	  if (tabIndex != -1) {
	    win.activeTabIndex = (tabIndex + 1);
	    win.index = 1;
	  }
	}
	})();
	]])
end
-- Function to search Safari tabs from within Safari and switch to the matching tab
-- Function to search Safari tabs from within Safari
-- Load the telescope package
-- local telescope = require('telescope')
--
-- Function to search Safari tabs from within Safari
-- Function to search Safari tabs from within Safari
-- Function to search Safari tabs from within Safari
-- function searchSafariTabs()
--     local safari = hs.appfinder.appFromName("Safari")
--     if safari then
--         local safariWindow = safari:mainWindow()
--         local allTabs = safariWindow:tabCount()
--
--         if allTabs then
--             local choices = {}
--             local query = ""
--
--             -- Iterate through each tab and add it to the choices
--             for i = 1, allTabs do
--                 local tab = safariWindow:tabAtIndex(i)
--                 if tab then
--                     local tabTitle = tab:title()
--                     local tabURL = tab:URL()
--
--                     local label = i .. ". " .. tabTitle
--                     local subText = tabURL
--
--                     if query == "" or string.find(label:lower(), query:lower()) then
--                         table.insert(choices, {text = label, subText = subText, index = i})
--                     end
--                 end
--             end
--
--             -- Show the choices in the search box
--             local chooser = hs.chooser.new(function(choice)
--                 local index = choice.index
--                 if index then
--                     local tab = safariWindow:tabAtIndex(index)
--                     if tab then
--                         safariWindow:selectTab(tab)
--                         tab:focus()
--                     end
--                 end
--             end)
--
--             chooser:choices(choices)
--             chooser:placeholderText("Search Safari Tabs")
--             chooser:searchSubText(true)
--             chooser:show()
--         else
--             print("No tabs found in Safari.")
--         end
--     else
--         print("Safari is not running.")
--     end
-- end
--
-- -- Bind the function to the "cmd + shift + F" keybinding
-- hs.hotkey.bind({"cmd", "shift"}, "F", searchSafariTabs)

-- Window management

-- Wenn kein Window da ist, funktioniert es nicht
-- hs.hotkey.bind({"shift", "alt"}, "space", function()
--   local app = hs.application.get("kitty")
--   if app then
--       if not app:mainWindow() then
--           app:selectMenuItem({"kitty", "New OS window"})
--       elseif app:isFrontmost() then
--           app:hide()
--       else
--           app:activate()
--       end
--   else
--       hs.application.launchOrFocus("kitty")
--       -- app = hs.application.get("kitty")
--   end
--
--   -- app:mainWindow():moveToUnit'[100,50,0,0]'
--   -- app:mainWindow().setShadows(false)
-- end)
-- paired with 'hide_window_decorations yes' in kitty.conf it makes for a very viable alternative to iTerm
-- hs.hotkey.bind({"alt", "shift"}, "H", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--
--   f.x = f.x - 10
--   win:setFrame(f)
-- end)

-- Fenster "magnetisieren"
-- function magnetizeWindowLeft()
-- 	local app = hs.application.frontmostApplication()
-- 	print(app)
-- 	local t = app:findMenuItem({"Window", "Move Window to Left Side of Screen"})
-- 	print(t)
-- 	local t = app:findMenuItem({"Fenster"})
-- 	print(t)
-- 	print(app:getMenuItems())
-- 	app:selectMenuItem({"Window", "Move Window to Left Side of Screen"})
-- end
-- hs.hotkey.bind({"shift", "alt"}, 'P', magnetizeWindowLeft)

-- multiscreen setup

function moveWindowToNextScreenAndMaximize()
	-- Get the focused window
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	-- Get the current and next screen
	local screen = win:screen()
	local nextScreen = screen:next()

	-- Move the window to the next screen and maximize it
	win:moveToScreen(nextScreen)
	win:maximize()
end
function moveToNextScreen()
	local app = hs.window.focusedWindow()
	app:moveToScreen(app:screen():next())
	app:maximize()
end
hs.application.enableSpotlightForNameSearches(true)
hs.hotkey.bind({ "shift", "alt" }, "right", moveWindowToNextScreenAndMaximize)
hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "M", moveWindowToNextScreenAndMaximize)

--
local animation_duration = 0.07
hs.hotkey.bind({ "shift", "alt" }, "H", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	win:setFrame(f, animation_duration)
end)

hs.hotkey.bind({ "shift", "alt" }, "L", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.y = max.y
	f.w = max.w / 2
	f.x = max.x + (max.w / 2)
	f.h = max.h
	win:setFrame(f, animation_duration)
end)

hs.hotkey.bind({ "shift", "alt" }, "return", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h
	-- 0 ist fuer das Abschalten der Animation, damit es smoother ist
	win:setFrame(f, animation_duration)
end)

function runScriptInTerminal(script_path)
	-- Use absolute path to lazygit
	-- AppleScript to open Terminal and run the command
	local script = string.format(
		[[
        tell application "Terminal"
            activate
            -- Create a new window and execute the command
            do script "%s"
        end tell
    ]],
		script_path
	)
	-- Execute the AppleScript
	hs.osascript.applescript(script)
	-- Force the application to the front and make it the active application
	hs.application.launchOrFocus("Terminal")
	-- Optional: Bring current window to front (sometimes needed for multi-monitor setups)
	local terminalApp = hs.appfinder.appForName("Terminal")
	if terminalApp then
		terminalApp:bringToFront(true)
	end
end
wakeWatcher = hs.caffeinate.watcher.new(function(eventType)
	if eventType == hs.caffeinate.watcher.systemDidWake then
		local clockerPath = "clocker"
		hs.timer.doAfter(1.5, function()
			runScriptInTerminal(clockerPath)
		end)
	end
end)
wakeWatcher:start()
