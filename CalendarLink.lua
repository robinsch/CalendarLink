-- local constants
local CALENDAR_MAX_DAYS_PER_MONTH				= 42;		-- 6 weeksOnModifiedClic
local CALENDAR_DAYBUTTON_MAX_VISIBLE_EVENTS		= 4;

-- taken from HolidayNames.dbc
local CALENDAR_EVENT_NAMES =
{
    ["1"] = "Darkmoon Faire",
    ["5"] = "Fireworks Celebration",
    ["6"] = "Stranglethorn Fishing Extravaganza",
    ["7"] = "Brewfest",
    ["9"] = "Love is in the Air",
    ["11"] = "Midsummer Fire Festival",
    ["12"] = "Fireworks Spectacular",
    ["13"] = "Children's Week",
    ["14"] = "Feast of Winter Veil",
    ["15"] = "Noblegarden",
    ["16"] = "Hallow's End",
    ["17"] = "Harvest Festival",
    ["18"] = "Lunar Festival",
    ["19"] = "Brewfest",
    ["21"] = "Pirates' Day",
    ["22"] = "Call to Arms: Alterac Valley",
    ["23"] = "Call to Arms: Arathi Basin",
    ["24"] = "Call to Arms: Eye of the Storm",
    ["25"] = "Call to Arms: Warsong Gulch",
    ["41"] = "Call to Arms: Stand of the Ancients",
    ["61"] = "Wrath of the Lich King Launch",
    ["81"] = "Day of the Dead",
    ["101"] = "Pilgrim's Bounty",
    ["121"] = "Call to Arms: Isle of Conquest",
    ["141"] = "Mohawk Promotion",
    ["161"] = "Kalu'ak Fishing Derby",
}

local CALENDAR_EVENT_IDS =
{
    ["Darkmoon Faire"] = 1,
    ["Fireworks Celebration"] = 5,
    ["Stranglethorn Fishing Extravaganza"] = 6,
    ["Brewfest"] = 7,
    ["Love is in the Air"] = 9,
    ["Midsummer Fire Festival"] = 11,
    ["Fireworks Spectacular"] = 12,
    ["Children's Week"] = 13,
    ["Feast of Winter Veil"] = 14,
    ["Noblegarden"] = 15,
    ["Hallow's End"] = 16,
    ["Harvest Festival"] = 17,
    ["Lunar Festival"] = 18,
    ["Brewfest"] = 19,
    ["Pirates' Day"] = 21,
    ["Call to Arms: Alterac Valley"] = 22,
    ["Call to Arms: Arathi Basin"] = 23,
    ["Call to Arms: Eye of the Storm"] = 24,
    ["Call to Arms: Warsong Gulch"] = 25,
    ["Call to Arms: Stand of the Ancients"] = 41,
    ["Wrath of the Lich King Launch"] = 61,
    ["Day of the Dead"] = 81,
    ["Pilgrim's Bounty"] = 101,
    ["Call to Arms: Isle of Conquest"] = 121,
    ["Mohawk Promotion"] = 141,
    ["Kalu'ak Fishing Derby"] = 161,
}

-- we need to force load the addon in order to override button events
if ( not IsAddOnLoaded("Blizzard_Calendar") ) then
    UIParentLoadAddOn("Blizzard_Calendar")
end

-- allow to click hyperlinks in chat
local ChatFrame_OnHyperlinkShow_O = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(frame, link, text, button)
    local type, value = link:match("(%a+):(.+)")
    if ( type == "gameevent" ) then
        ShowCalendarEvent(value)
    else
        ChatFrame_OnHyperlinkShow_O(self, link, text, button)
    end
end

-- allow to shift-click events to post to chat
local CalendarDayEventButton_OnClick_O = CalendarDayEventButton_OnClick
function CalendarDayEventButton_OnClick(self, button)
    if ( IsModifiedClick("CHATLINK") ) then
        local eventName = _G[self:GetName().."Text1"]:GetText()
        if ( eventName == nil ) then
            return
        end
        eventName = eventName:gsub("% Begins", "")
        eventName = eventName:gsub("% Ends", "")
        local eventId = CALENDAR_EVENT_IDS[eventName]
        if ( eventName ~= nil and eventId ~= nil ) then
            ChatEdit_InsertLink("|cffc6a04d|Hgameevent:"..eventId.."|h[Calendar: "..eventName.."]|h|r")
        end
    else
        CalendarDayEventButton_OnClick_O(self, button)
    end
end

-- open up the calendar and finds the next occurrence of given event id
function ShowCalendarEvent(eventId)
    if ( CalendarFrame:IsShown() ) then
        Calendar_Hide();
        return
    else
        Calendar_Show();
    end

    for i = CalendarTodayFrame:GetParent():GetID(), CALENDAR_MAX_DAYS_PER_MONTH do
        for j = 1, CALENDAR_DAYBUTTON_MAX_VISIBLE_EVENTS do
            local eventName = _G["CalendarDayButton"..i.."EventButton"..j.."Text1"]:GetText()
            if ( eventName ~= nil ) then
                eventName = eventName:gsub("% Begins", "")
                eventName = eventName:gsub("% Ends", "")
                if ( eventName == CALENDAR_EVENT_NAMES[eventId] ) then
                    CalendarDayEventButton_Click(_G["CalendarDayButton"..i.."EventButton"..j], true)
                    return
                end
            end
        end
    end
end
