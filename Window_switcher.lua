-- Fuzzy Window Switcher

local _fuzzyChoices = nil
local _fuzzyChooser = nil
local _fuzzyLastWindow = nil

function fuzzyQuery(s, m)
    local s_index, m_index, match_start = 1, 1, nil
    local s_len, m_len = s:len(), m:len()

    while s_index <= s_len and m_index <= m_len do
        if s:sub(s_index, s_index) == m:sub(m_index, m_index) then
            match_start = match_start or s_index
            s_index = s_index + 1
            m_index = m_index + 1

            if m_index > m_len then
                return m_len / (s_index - match_start)
            end
        else
            s_index = s_index + 1
        end
    end

    return -1
end


function _fuzzyFilterChoices(query)
    local query_len = query:len()
    if query_len == 0 then
        _fuzzyChooser:choices(_fuzzyChoices)
        return
    end
    local pickedChoices = {}
    local lower_query = query:lower()
    for i,j in pairs(_fuzzyChoices) do
        local fullText = (j["text"] .. " " .. j["subText"]):lower()
        local score = fuzzyQuery(fullText, lower_query)
        if score > 0 then
            j["fzf_score"] = score
            table.insert(pickedChoices, j)
        end
    end
    local sort_func = function( a,b ) return a["fzf_score"] > b["fzf_score"] end
    table.sort( pickedChoices, sort_func )
    _fuzzyChooser:choices(pickedChoices)
end


function _fuzzyPickWindow(item)
	if item == nil then
		if _fuzzyLastWindow then
			-- Workaround so last focused window stays focused after dismissing
			_fuzzyLastWindow:focus()
			_fuzzyLastWindow = nil
		end
		return
	end
	id = item["windowID"]
	window = hs.window.get(id)
	window:focus()
end

function windowFuzzySearch()
	windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)
	-- windows = hs.window.orderedWindows()
	_fuzzyChoices = {}
	for i,w in pairs(windows) do
		title = w:title()
		app = w:application():name()
		item = {
			["text"] = app,
			["subText"] = title,
			--["image"] = w:snapshot(),
			["windowID"] = w:id()
		}
		-- Handle special cases as necessary
		--if app == "Safari" and title == "" then
			-- skip, it's a weird empty window that shows up sometimes for some reason
		--else
			table.insert(_fuzzyChoices, item)
		--end
	end
	_fuzzyLastWindow = hs.window.focusedWindow()
	_fuzzyChooser = hs.chooser.new(_fuzzyPickWindow):choices(_fuzzyChoices):searchSubText(true)
	_fuzzyChooser:queryChangedCallback(_fuzzyFilterChoices) -- Enable true fuzzy find
	_fuzzyChooser:show()
end

return {
    windowFuzzySearch = windowFuzzySearch
}
