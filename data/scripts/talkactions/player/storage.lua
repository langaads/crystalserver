local storage = TalkAction("!storage")

function storage.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: !storage <key> or !storage <key>, <value>")
		return true
	end

	local keyParam, valueParam = string.splitFirst(param, ",")
	if not keyParam then
		player:sendCancelMessage("Usage: !storage <key> or !storage <key>, <value>")
		return true
	end

	local storageKey = tonumber(keyParam) or keyParam:trim()
	if not storageKey then
		player:sendCancelMessage("Invalid storage key.")
		return true
	end

	if not valueParam then
		local storageValue = player:getStorageValue(storageKey)
		if storageValue == nil then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Storage [" .. keyParam:trim() .. "] is not set.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Storage [" .. keyParam:trim() .. "] = " .. storageValue .. ".")
		end
		return true
	end

	local storageValue = tonumber(valueParam:trim())
	if storageValue == nil then
		player:sendCancelMessage("Storage value must be a number.")
		return true
	end

	if type(storageKey) == "number" then
		player:setStorageValue(storageKey, storageValue)
	else
		player:setStorageValueByName(storageKey, storageValue)
	end

	player:save()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Storage [" .. keyParam:trim() .. "] updated to " .. storageValue .. ".")
	return true
end

storage:separator(" ")
storage:groupType("normal")
storage:register()
