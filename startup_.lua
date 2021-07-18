--- LIBS LOADING ---
local tps = require("tps_monitor")

--- GLOBAL VARIABLES
local monitor -- peripheral : monitor

--- FUNCTIONS ---
local function init()
    monitor = peripheral.find("monitor")
    assert(monitor, "No monitor found.")
end

--- MAIN ---
local function main()
    print(tps.measureTPS(30))
end

main()