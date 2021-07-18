-- [V1.0]
--- LIBS LOADING ---
datetime = require("lib/Datetime/datetime")
local tps = {}

local function diffSeconds(datetime1, datetime2)
    local tot_secs_1 = datetime1["hour"] * 3600 + datetime1["min"] * 60 + datetime1["sec"]
    local tot_secs_2 = datetime2["hour"] * 3600 + datetime2["min"] * 60 + datetime2["sec"]
    return tot_secs_2 - tot_secs_1
end
tps.diffSeconds = diffSeconds

local function measureTPS(seconds)
    irl_start = assert(datetime.getDatetime(), "Cannot reach datetime json API.")
    ig_start = os.clock()
    sleep(seconds)
    irl_end = assert(datetime.getDatetime(), "Cannot reach datetime json API.")
    ig_end = os.clock()
    local irl_timespan = diffSeconds(irl_start, irl_end)
    return ((ig_end - ig_start) / irl_timespan) * 20
end
tps.measureTPS = measureTPS

return tps