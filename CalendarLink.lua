-- local constants
local CALENDAR_MAX_DAYS_PER_MONTH				= 42		-- 6 weeksOnModifiedClic
local CALENDAR_DAYBUTTON_MAX_VISIBLE_EVENTS		= 4

-- taken from HolidayNames.dbc
local CALENDAR_EVENT_DATA =
{
    ["1"] = {
        name="Darkmoon Faire",
        continentIndex={2, 2},
        areaIndex={10, 10},
        x={0, 0},
        y={0, 0},
    },
    ["5"] = { name="Fireworks Celebration" },
    ["6"] =
    {
        name="Stranglethorn Fishing Extravaganza",
        continentIndex={2, 2},
        areaIndex={22, 22},
        x={0.2732, 0.2732},
        y={0.7690, 0.7690},
    },
    ["7"] =
    {
        name="Brewfest",
        continentIndex={2, 1},
        areaIndex={7, 9},
        x={0.4778, 0.4613},
        y={0.3985, 0.1542},
    },
    ["9"] =
    {
        name="Love is in the Air",
        continentIndex={2, 1},
        areaIndex={21, 14},
        x={0.6247, 0.5381},
        y={0.7533, 0.6634},
    },
    ["11"] =
    {
        name="Midsummer Fire Festival",
        continentIndex={2, 1},
        areaIndex={21, 14},
        x={0.4960, 0.4675},
        y={0.7209, 0.3804},
    },
    ["12"] = { name="Fireworks Spectacular" },
    {
        name="Childen's Week",
        continentIndex={2, 1},
        areaIndex={21, 14},
        x={0.5631, 0.7072},
        y={0.5398, 0.2518},
    },
    ["14"] =
    {
        name="Feast of Winter Veil",
        continentIndex={2, 1},
        areaIndex={14, 9},
        x={0.3242, 0.5208},
        y={0.6715, 0.6840},
    },
    ["15"] =
    {
        name="Noblegarden",
        continentIndex={2, 1},
        areaIndex={10, 8},
        x={0.4293, 0.5195},
        y={0.6524, 0.4200},
    },
    ["16"] = { name="Hallow's End" },
    ["17"] =
    {
        name="Harvest Festival",
        continentIndex={2, 1},
        areaIndex={27, 1},
        x={0.5206, 0.8282},
        y={0.8318, 0.7901},
    },
    ["18"] =
    {
        name="Lunar Festival",
        continentIndex={1, 1},
        areaIndex={12, 12},
        x={0.5366, 0.5366},
        y={0.3534, 0.3534},
    },
    ["19"] =
    {
        name="Brewfest",
        continentIndex={2, 1},
        areaIndex={7, 9},
        x={0.4778, 0.4613},
        y={0.3985, 0.1542},
    },
    ["21"] =
    {
        name="Pirates' Day",
        continentIndex={2, 2},
        areaIndex={22, 22},
        x={0.2656, 0.7643},
        y={0.2656, 0.7643},
    },
    ["22"] = { name="Call to Arms: Alterac Valley" },
    ["23"] = { name="Call to Arms: Arathi Basin" },
    ["24"] = { name="Call to Arms: Eye of the Storm" },
    ["25"] = { name="Call to Arms: Warsong Gulch" },
    ["41"] = { name="Call to Arms: Stand of the Ancients" },
    ["61"] = { name="Wrath of the Lich King Launch" },
    ["81"] =
    {
        name="Day of the Dead",
        continentIndex={2, 1},
        areaIndex={10, 8},
        x={0.3910, 0.5195},
        y={0.6009, 0.4200},
    },
    ["101"] = { name="Pilgrim's Bounty" },
    ["121"] = { name="Call to Arms: Isle of Conquest" },
    ["141"] = { name="Mohawk Promotion" },
    ["161"] =
    {
        name="Kalu'ak Fishing Derby",
        continentIndex={4, 4},
        areaIndex={3, 3},
        x={0.5253, 0.5253},
        y={0.656, 0.656}
    },
    ["163"] = { name="Call to Arms: Twin Peaks" },
    ["724"] = { name="Arena Frenzy", continentIndex=2, areaIndex=22 },
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

local CUSTOM_POI_LIST = {}

local MAP_STATE_OPEN = false;
local frame = CreateFrame("FRAME") -- Need a frame to respond to events
frame:RegisterEvent("WORLD_MAP_UPDATE")
function frame:OnEvent(event, data)
    if ( (event == "WORLD_MAP_UPDATE") and WorldMapFrame:IsVisible() ) then
        MAP_STATE_OPEN = true;
    end
end
function frame:OnUpdate()
    if ( (MAP_STATE_OPEN) and not WorldMapFrame:IsVisible() ) then
        MAP_STATE_OPEN = false;

        for i = 1, #CUSTOM_POI_LIST do
            worldMapPOI = _G[CUSTOM_POI_LIST[i]]
            if ( worldMapPOI ~= nil) then
                worldMapPOI:Hide()
            end
        end

        CUSTOM_POI_LIST = {}
    end
end
frame:SetScript("OnEvent", frame.OnEvent)
frame:SetScript("OnUpdate", frame.OnUpdate)

function CreatePOI(index, name, description, textureIndex, x, y)
    WorldMap_CreatePOI(index);
    x1, x2, y1, y2 = WorldMap_GetPOITextureCoords(textureIndex);
    worldMapPOI = _G["WorldMapFramePOI"..index]
    _G[worldMapPOI:GetName().."Texture"]:SetTexCoord(x1, x2, y1, y2);
    x = x * WorldMapButton:GetWidth();
    y = -y * WorldMapButton:GetHeight();
    worldMapPOI:SetPoint("CENTER", "WorldMapButton", "TOPLEFT", x, y );
    worldMapPOI.name = name;
    worldMapPOI.description = description;
    worldMapPOI:Show();

    CUSTOM_POI_LIST[#CUSTOM_POI_LIST]("WorldMapFramePOI"..index)
end

-- create a button to show POI for event location on map
CalendarViewHolidayFrame.ViewButton = CreateFrame("Button", "CalendarViewHolidayFrameButton", CalendarViewHolidayScrollFrame, "UIPanelButtonTemplate")
CalendarViewHolidayFrame.ViewButton:SetWidth(120)
CalendarViewHolidayFrame.ViewButton:SetHeight(22)
CalendarViewHolidayFrame.ViewButton:SetPoint("BOTTOM", 10, 10)
CalendarViewHolidayFrame.ViewButton:RegisterForClicks("AnyUp")
CalendarViewHolidayFrame.ViewButton:SetText("View Location")
CalendarViewHolidayFrame.ViewButton:EnableMouse(true)
CalendarViewHolidayFrame.ViewButton:SetScript("OnMouseUp", function()
    local eventName = _G["CalendarViewHolidayTitleFrameText"]:GetText()
    local eventIndex = CALENDAR_EVENT_IDS[eventName]
    local eventData = CALENDAR_EVENT_DATA[tostring(eventIndex)]
    Calendar_Hide()
    local playerFaction = UnitFactionGroup("player")
    local posIndex = 1
    if ( playerFaction == "Horde" ) then
        posIndex = 2
    end

    WorldMapFrame:Show()
    SetMapZoom(WORLDMAP_COSMIC_ID)
    SetMapZoom(tonumber(eventData.continentIndex[posIndex]), tonumber(eventData.areaIndex[posIndex]))
    CreatePOI(100, eventName, "", 7, eventData.x[posIndex], eventData.y[posIndex])
end)

-- allow to click hyperlinks in chat
local ChatFrame_OnHyperlinkShow_O = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(frame, link, text, button)
    local type, value = link:match("(%a+):(.+)")
    if ( type == "gameevent" ) then
        if ( value ~= "0" ) then
            ShowCalendarEvent(value)
        else
            ShowCustomCalendarEvent(text)
        end
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
        if ( eventId == nil ) then
            eventId = 0
        end
        if ( eventName ~= nil and eventId ~= nil ) then
            ChatEdit_InsertLink("|cffc6a04d|Hgameevent:"..eventId.."|h[Calendar: "..eventName.."]|h|r")
        end
    else
        local showLocationButton = false
        local eventName = _G[self:GetName().."Text1"]:GetText()
        if ( eventName ~= nil ) then
            eventName = eventName:gsub("% Begins", "")
            eventName = eventName:gsub("% Ends", "")
            local eventId = CALENDAR_EVENT_IDS[eventName]
            if ( eventId ~= nil ) then
                eventData = CALENDAR_EVENT_DATA[tostring(eventId)]
                if ( eventData ~= nil and eventData.continentIndex ~= nil ) then
                    showLocationButton = true
                end
            end
        end

        if ( showLocationButton == true ) then
            CalendarViewHolidayFrame.ViewButton:Enable()
        else
            CalendarViewHolidayFrame.ViewButton:Disable()
        end

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
                if ( eventName == CALENDAR_EVENT_DATA[eventId].name ) then
                    CalendarDayEventButton_Click(_G["CalendarDayButton"..i.."EventButton"..j], true)
                    return
                end
            end
        end
    end
end

-- open up the calendar and finds the next occurrence of given event name
function ShowCustomCalendarEvent(name)
    name = string.match(name, "%[Calendar: (.*)%]")
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
                if ( eventName == name ) then
                    CalendarDayEventButton_Click(_G["CalendarDayButton"..i.."EventButton"..j], true)
                    return
                end
            end
        end
    end
end
