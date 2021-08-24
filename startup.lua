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
        local measured_tps = tps.measureTPS(60)
        if not measured_tps["tps"] then
            print(measured_tps["timestamp"] .. " -> " .. "Error.")
        else
            print(measured_tps["timestamp"] .. " -> " .. tostring(measured_tps["tps"]))
        end
        sleep(0)
    end
end

main()