-- [V2.01]
local libpath = "lib/ObjectJSON/"
local ObjectJSON = {}

--- INIT ---
local function init()
	print("\n--- INIT ObjectJSON ---")
	if not fs.exists(libpath .. "json") then
		print("Warning : File [json] not found.")
		print("Trying to download [json] lib.")
		local obj = http.get("https://pastebin.com/raw/4nRg9CHU")
		assert(obj, "Download failed.")
		local str = obj.readAll()
		assert(str and str ~= "", "Download failed.")
		local h = fs.open(libpath .. "json", "w")
		h.write(str)
		h.close()
		print("Download successful.")
	end
	assert(os.loadAPI(libpath .. "json"))
	print("API [json] loaded.")
end

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

-- get the content of a HTTP link and returns a JSON object (table)
local function decodeHTTP(link)
	assert(link, "link cannot be nil.")
	local request = http.get(link)
	if request == nil then
		print("Warning : HTTP request on [" .. link .. "] failed.")
		return nil
	end
	return json.decode(request.readAll())
end
ObjectJSON.decodeHTTP = decodeHTTP

--- ADVANCED FUNCTIONS ---

-- get the content of a file and returns a JSON object (table)
local function decodeFromFile(filename)
	assert(filename, "filename cannot be nil.")
	assert(fs.exists(filename), "[" .. filename .. "] not found.")
	return json.decodeFromFile(filename)
end
ObjectJSON.decodeFromFile = decodeFromFile

-- get the content of a HTTP link and save it to a file
local function decodeHTTPSave(link, filename)
	assert(link, "link cannot be nil.")
	assert(filename, "filename cannot be nil.")
	local request = http.get(link)
	assert(request, "Warning : HTTP request on [" .. link .. "] failed.")
	local str = request.readAll()
	assert(str and str ~= "", "Warning : HTTP request on [" .. link .. "] failed.")
	local h = fs.open(filename, "w")
	h.write(encodePretty(decode(str)))
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

init()
return ObjectJSON
