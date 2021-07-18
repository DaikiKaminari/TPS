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
    while true do
        print(tps.measureTPS(60))
        sleep(0)
    end
end

main()