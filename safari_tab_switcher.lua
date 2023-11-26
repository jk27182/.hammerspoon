-- Fuzzy Tab Switcher

local _fuzzyChoices = nil
local _fuzzyChooser = nil
local _fuzzyLastTab = nil

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

function _fuzzyPickTab(item)
	if item == nil then
		if _fuzzyLastTab then
			-- Workaround so last focused tab stays focused after dismissing
			_fuzzyLastTab:focus()
			_fuzzyLastTab = nil
		end
		return
	end
	id = item["tabID"]
	tab = hs.tabs.get(id)
	tab:focus()
end

function tabFuzzySearch()
	tabs = hs.tabs.filter.default:getTabs(hs.tabs.filter.sortByFocusedLast)
	_fuzzyChoices = {}
	for i,t in pairs(tabs) do
		title = t:title()
		app = t:application():name()
		item = {
			["text"] = app,
			["subText"] = title,
			["tabID"] = t:id()
		}
		table.insert(_fuzzyChoices, item)
	end
	_fuzzyLastTab = hs.tabs.focusedTab()
	_fuzzyChooser = hs.chooser.new(_fuzzyPickTab):choices(_fuzzyChoices):searchSubText(true)
	_fuzzyChooser:queryChangedCallback(_fuzzyFilterChoices) -- Enable true fuzzy find
	_fuzzyChooser:show()
end

return {
    tabFuzzySearch = tabFuzzySearch
}

