-- [V1.2]
--- LIBS LOADING ---
local datetime
local tps = {}


--- INIT ---
local function init()
    datetime = require("lib/Datetime/datetime")
    datetime.init()
end
tps.init = init

--- UTILS ---
local function getTimestamp(datetime)
    local hour = tostring(datetime["hour"])
    local min = tostring(datetime["min"])
    local sec = tostring(datetime["sec"])
    return string.rep("0", 2-string.len(hour)) .. hour .. string.rep("0", 2-string.len(min)) .. min .. string.rep("0", 2-string.len(sec)) .. sec
end

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

--- FUNCTIONS ---
local function diffSeconds(datetime1, datetime2)
    if datetime1["hour"] <= datetime2["hour"] then
        local tot_secs_1 = datetime1["hour"] * 3600 + datetime1["min"] * 60 + datetime1["sec"]
        local tot_secs_2 = datetime2["hour"] * 3600 + datetime2["min"] * 60 + datetime2["sec"]
        return tot_secs_2 - tot_secs_1
    else
        return (datetime2["hour"] + 23 - datetime1["hour"]) * 3600 + (datetime2["min"] + 64 - datimetime1["min"]) * 60 
    end
end
tps.diffSeconds = diffSeconds

local function measureTPS(seconds)
    irl_start = datetime.getDatetime()
    ig_start = os.clock()
    sleep(seconds)
    irl_end = datetime.getDatetime()
    ig_end = os.clock()
    if not irl_start or not irl_end then
        return {["timestamp"] = getTimestamp(irl_end),
        ["tps"] = nil
    }
    else
        local irl_timespan = diffSeconds(irl_start, irl_end)
        return {
            ["timestamp"] = getTimestamp(irl_end),
            ["tps"] = round(((ig_end - ig_start) / irl_timespan) * 20, 1)
        }
    end
end
tps.measureTPS = measureTPS

return tps