-- returns json object with the list of players
local function listConnectedPlayers()
	local obj = http.get("http://api.mineaurion.com/v1/serveurs")
	if obj == nil then
		print("Warning : HTTP request on [http://api.mineaurion.com/v1/serveurs] failed.")
		return nil
	end
	local str = obj.readAll()
	local arrObj = json.decode(str) -- array of json object containing each server
	return arrObj
end
ObjectJSON.listConnectedPlayers = listConnectedPlayers