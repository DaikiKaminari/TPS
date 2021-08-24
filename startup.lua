--- LIBS LOADING ---
local tps

--- GLOBAL VARIABLES
local monitor -- peripheral : monitor

--- FUNCTIONS ---
local function init()
    tps = require("tps_monitor")
    tps.init()
    shell.run("label set tps")
    monitor = peripheral.find("monitor")
    assert(monitor, "No monitor found.")
    term.redirect(monitor)
    term.clear()
end

--- MAIN ---
local function main()
    init()
    while true do
        print(tps.measureTPS(60))
        sleep(0)
    end
end

main()