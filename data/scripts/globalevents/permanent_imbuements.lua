local permanentImbuements = GlobalEvent("PermanentImbuements")

local MAX_IMBUEMENT_DURATION = 20 * 60 * 60 -- 20 hours in seconds
local IMBUEMENT_SLOT_BASE_ATTRIBUTE = 500
local IMBUABLE_EQUIPMENT_SLOTS = {
	CONST_SLOT_HEAD,
	CONST_SLOT_NECKLACE,
	CONST_SLOT_BACKPACK,
	CONST_SLOT_ARMOR,
	CONST_SLOT_RIGHT,
	CONST_SLOT_LEFT,
	CONST_SLOT_LEGS,
	CONST_SLOT_FEET,
	CONST_SLOT_RING,
	CONST_SLOT_AMMO,
}

local function refreshImbuementDuration(item)

	if not item then
		return
	end

	local imbuementSlots = item:getImbuementSlot()
	if imbuementSlots <= 0 then
		return
	end

	for slotId = 0, imbuementSlots - 1 do
		local attributeKey = tostring(IMBUEMENT_SLOT_BASE_ATTRIBUTE + slotId)
		local packedValue = item:getCustomAttribute(attributeKey)

		if type(packedValue) == "number" then
			local imbuementData = math.floor(packedValue)
			if imbuementData > 0 then
				local imbuementId = imbuementData % 256
				local duration = math.floor(imbuementData / 256)

				if imbuementId > 0 and duration > 0 and duration < MAX_IMBUEMENT_DURATION then
					local permanentPackedValue = (MAX_IMBUEMENT_DURATION * 256) + imbuementId
					item:setCustomAttribute(attributeKey, permanentPackedValue)
				end
			end
		end
	end
end

function permanentImbuements.onThink(interval)
	for _, player in ipairs(Game.getPlayers()) do
		for _, slot in ipairs(IMBUABLE_EQUIPMENT_SLOTS) do
			refreshImbuementDuration(player:getSlotItem(slot))
		end
	end

	return true
end

permanentImbuements:interval(60 * 1000)
permanentImbuements:register()
