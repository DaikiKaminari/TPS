-- [V2.21]
--- LIBS LOADING ---
local ObjectJSON = {}
local json -- required lib

--- INIT ---
local function init()
	-- load json API
	json = require("json")
end
ObjectJSON.init = init

--- BASIC FUNCTIONS ---

-- convert text (in json format) into a JSON object (table) and returns it
local function decode(text)
	assert(text, "text cannot be nil.")
	return json.decode(text)
end
ObjectJSON.decode = decode

-- convert JSON object (table) into a string
local function encode(obj)
	assert(obj, "obj cannot be nil.")
	return json.encore(obj)
end
ObjectJSON.encode = encode

-- convert JSON object (table) into a string (pretty json)
local function encodePretty(obj)
	assert(obj, "obj cannot be nil.")
	return json.encodePretty(obj)
end
ObjectJSON.encodePretty = encodePretty


--- ADVANCED FUNCTIONS ---
-- get the content of a file and returns a JSON object (table)
local function decodeFromFile(filename)
	assert(filename, "filename cannot be nil.")
	assert(fs.exists(filename), "[" .. filename .. "] not found.")
	local f = assert(fs.open(filename, "r"))
	local decoded = ObjectJSON.decode(f.readAll())
	f.close()
	return decoded
end
ObjectJSON.decodeFromFile = decodeFromFile

-- get the content of a HTTP link and returns a JSON object (table)
local function decodeHTTP(link)
	assert(link, "link cannot be nil.")
	local request = http.get(link)
	if request == nil then
		print("Warning : HTTP request on [" .. link .. "] failed.")
		return nil
	end
	local content = request.readAll()
	local r = ObjectJSON.decode(content)
	return r
end
ObjectJSON.decodeHTTP = decodeHTTP

-- get the content of a HTTP link and save it to a file
local function decodeHTTPSave(link, filename)
	assert(link, "link cannot be nil.")
	assert(filename, "filename cannot be nil.")
	local request = http.get(link)
	assert(request, "Warning : HTTP request on [" .. link .. "] failed.")
	local str = request.readAll()
	assert(str and str ~= "", "Warning : HTTP request on [" .. link .. "] failed.")
	local h = fs.open(filename, "w")
	h.write(ObjectJSON.encodePretty(ObjectJSON.decode(str)))
	h.close()
end
ObjectJSON.decodeHTTPSave = decodeHTTPSave

-- save a table to a JSON file
local function encodeAndSavePretty(obj, filename)
	assert(filename, "filename cannot be nil.")
	assert(obj, "obj cannot be nil.")
	if not fs.exists(filename) then
		print("Creating file [" .. filename .. "]")
	end
	local h = fs.open(filename, "w")
	h.write(json.encodePretty(obj))
	h.close()
end
ObjectJSON.encodeAndSavePretty = encodeAndSavePretty

return ObjectJSON
