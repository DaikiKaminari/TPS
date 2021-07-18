-- [V1.2-BETA]
--- LIBS LOADING ---
local Datetime = {}
local objectJSON

-- table : days of march and october when we add/remove an hour for daylight saving
local daylightHours = {
    [2020] = {["summerBegin"] = 28, ["summerEnd"] = 24},
    [2021] = {["summerBegin"] = 27, ["summerEnd"] = 30},
    [2022] = {["summerBegin"] = 26, ["summerEnd"] = 29},
    [2023] = {["summerBegin"] = 25, ["summerEnd"] = 28},
    [2024] = {["summerBegin"] = 30, ["summerEnd"] = 26},
    [2025] = {["summerBegin"] = 29, ["summerEnd"] = 25}
}

--- INIT ---
local function init()
    if not fs.exists("lib/ObjectJSON/json.lua") then
        error("[lib/ObjectJSON/json.lua] file not found.")
    end
    if not fs.exists("lib/ObjectJSON/ObjectJSON.lua") then
        error("[lib/ObjectJSON/ObjectJSON.lua] file not found.")
    end
    objectJSON = require("lib/ObjectJSON/ObjectJSON")
    print("API [datetime] loaded.")
end
Datetime.init = init


--- UTILS ----
local function split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function getDaylightHours(day, month, year)
    if month == 3 and day >= daylightHours[year]["summerBegin"] or
    month == 10 and day <= daylightHours[year]["summerEnd"] or
    (month > 3 and month < 10) then
        return 1 -- summer
    else
        return 0 -- winter
    end
end

--- FUNCTIONS ---
local function getDatetime()
    local jsonDatetime = objectJSON.decodeHTTP("http://worldtimeapi.org/api/timezone/Europe/Paris.json")
    if jsonDatetime == nil then
        return nil
    end
    local datetime = jsonDatetime.utc_datetime
    local offset = jsonDatetime.utc_offset

    local dayOfWeek = jsonDatetime.day_of_week
    local days = {
        [0] = "Dimanche",
        [1] = "Lundi",
        [2] = "Mardi",
        [3] = "Mercredi",
        [4] = "Jeudi",
        [5] = "Vendredi",
        [6] = "Samedi"
    }

    local infos = {}
    local date = split(split(datetime, "T")[1], "-")
    local year = date[1]
    local month = date[2]
    local day = date[3]
    local time = split(split(datetime, "T")[2], ":")
    local offset = split(split(offset, ":")[1], "+")[1]

    infos["dayOfWeek"] = days[dayOfWeek]
    infos["year"] = year
    infos["month"] = month
    infos["day"] = day
    infos["hour"] = (tonumber(time[1]) + tonumber(offset) + 1) % 24
    infos["min"] = time[2]
    infos["sec"] = split(time[3], ".")[1]

    return infos -- table with keys : dayOfWeek, year, month, day, hour, min, sec
end
Datetime.getDatetime = getDatetime

local function getDatetime2()
    local jsonDatetime = objectJSON.decodeHTTP("http://worldclockapi.com/api/json/utc/now")
    if jsonDatetime == nil then
        return nil
    end
    local datetime = jsonDatetime.currentDateTime       -- 2020-08-09T16:14Z

    local infos = {}             
    local date = split(split(datetime, "T")[1], "-")    -- 2020-08-09
    local year = date[1]
    local month = date[2]
    local day = date[3]

    local dayOfWeek = jsonDatetime.dayOfTheWeek
    local days = {
        ["Sunday"] = "Dimanche",
        ["Monday"] = "Lundi",
        ["Tuesday"] = "Mardi",
        ["Wednesday"] = "Mercredi",
        ["Thursday"] = "Jeudi",
        ["Friday"] = "Vendredi",
        ["Saturday"] = "Samedi"
    }
    
    local daylight = getDaylightHours(tonumber(day), tonumber(month), tonumber(year))
    local time = split(split(datetime, "T")[2], ":")    -- 16:14Z
    local hour = tostring((tonumber(time[1]) + daylight + 1) % 24)
    local min = split(time[2], "Z")[1]
    
    infos["dayOfWeek"] = days[dayOfWeek]
    infos["year"] = year
    infos["month"] = month
    infos["day"] = day
    infos["hour"] = hour
    infos["min"] = min
    return infos -- table with keys : dayOfWeek, year, month, day, hour, min
end
Datetime.getDatetime2 = getDatetime2

init()
return Datetime