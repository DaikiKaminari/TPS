local libPath = "lib/ObjectJSON/"
local ObjectJSON = dofile(libPath .. "ObjectJSON.lua")

print("--- TEST decodeHTTPSave ---")
ObjectJSON.decodeHTTPSave("https://jsonplaceholder.typicode.com/todos/1", libPath .. "jsonTEST.json")

print("--- TEST decodeFromFile ---")
local obj = ObjectJSON.decodeFromFile(libPath .. "jsonTEST.json")

print("--- TEST decode ---")
local obj2 = ObjectJSON.decode("{\"userId\": 1,\"id\": 1,\"title\": \"delectus aut autem\",\"completed\": false}")
for k,v in pairs(obj) do -- obj and obj2 should be identical (content)
    assert(v == obj2[k])
end

print("--- TEST encodeAndSavePretty ---")
obj["userId"] = 2
ObjectJSON.encodeAndSavePretty(obj, libPath .. "jsonTEST.json")
assert(ObjectJSON.decodeFromFile(libPath .. "jsonTEST.json")["userId"] == 2)

print("\nAll tests of ObjectJSON.lua passed without error.")
