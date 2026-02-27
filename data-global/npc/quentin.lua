local internalNpcName = "Quentin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 57,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

-- Wooden Stake Quest
local stakeKeyword = keywordHandler:addKeyword({ "stake" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"A blessed stake to defeat evil spirits? I do know an old prayer which is said to grant sacred power and to be able to bind this power to someone, or something. ...",
		"However, this prayer needs the combined energy of ten priests. Each of them has to say one line of the prayer. ...",
		"I could start with the prayer, but since the next priest has to be in a different location, you probably will have to travel a lot. ...",
		"Is this stake really important enough to you so that you are willing to take this burden?",
	},
}, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == -1
end)
stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Alright, I guess you need a stake first. Maybe Gamon can help you, the leg of a chair or something could just do. Try asking him for a stake, and if you have one, bring it back to me.", reset = true, ungreet = true }, nil, function(player)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.DefaultStart, 1)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, 1)
end)

-- First prayer
keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "I guess you couldn't convince Gamon to give you a stake, eh?" }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 1 and player:getItemCount(5941) == 0
end)

local stakeKeyword = keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, I see you brought a stake with you. Are you ready to receive my line of the prayer then?" }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 1
end)
stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "So receive my prayer: 'Light shall be near - and darkness afar'. Now, bring your stake to Tibra in the Carlin church for the next line of the prayer. I will inform her what to do.", reset = true }, nil, function(player)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, 2)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
end)
stakeKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "I will wait for you.", reset = true })

keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "You should visit Tibra in the Carlin church now." }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 2
end)
keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "You already received my line of the prayer." })

-- Twist of Fate
local blessKeyword = keywordHandler:addKeyword({ "twist of fate" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"This is a special blessing I can bestow upon you once you have obtained at least one of the other blessings and which functions a bit differently. ...",
		"It only works when you're killed by other adventurers, which means that at least half of the damage leading to your death was caused by others, not by monsters or the environment. ...",
		"The {twist of fate} will not reduce the death penalty like the other blessings, but instead prevent you from losing your other blessings as well as the amulet of loss, should you wear one. It costs the same as the other blessings. ...",
		"Would you like to receive that protection for a sacrifice of |PVPBLESSCOST| gold, child?",
	},
})
blessKeyword:addChildKeyword({ "yes" }, StdModule.bless, { npcHandler = npcHandler, text = "So receive the protection of the twist of fate, pilgrim.", cost = "|PVPBLESSCOST|", bless = 1 })
blessKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "Fine. You are free to decline my offer.", reset = true })

-- Adventurer Stone
keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Keep your adventurer's stone well." }, function(player)
	return player:getItemById(16277, true)
end)

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for free?" }, function(player)
	return player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Quentin) ~= 1
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, nil, function(player)
	player:addItem(16277, 1)
	player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Quentin, 1)
end)
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for 30 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 30
end, function(player)
	if player:removeMoneyBank(30) then
		player:addItem(16277, 1)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = text }, function(player)
		return player:getCondition(condition) ~= nil
	end, function(player)
		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end)
end

addHealKeyword("You are burning. Let me quench those flames.", CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword("You are poisoned. Let me soothe your pain.", CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword("You are electrified, my child. Let me help you to stop trembling.", CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You are hurt, my child. I will heal your wounds." }, function(player)
	return player:getHealth() < 40
end, function(player)
	local health = player:getHealth()
	if health < 40 then
		player:addHealth(40 - health)
	end
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
end)
keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You aren't looking that bad. Sorry, I can't help you. But if you are looking for additional protection you should go on the {pilgrimage} of ashes or get the protection of the {twist of fate} here." })

-- Rebirth System - Skill Selection Keywords (must be created first)
local function createRebirthSkillKeyword(skillName, displayName)
	keywordHandler:addKeyword({ skillName }, StdModule.say, {
		npcHandler = npcHandler,
		text = string.format(
			"You have chosen to master the %s skill. This is irreversible! Are you absolutely certain you want to proceed?",
			displayName or skillName
		),
	}, function(player)
		return npcHandler:getTopic(player:getId()) == 100
	end, function(player)
		npcHandler:setTopic(player:getId(), 101) -- Topic 101 = aguardando confirmação final
		player:setStorageValue(90000, Rebirth.Skills[skillName]) -- Temporariamente guarda a skill escolhida
	end)
end

-- Create keywords for all skills
createRebirthSkillKeyword("sword", "sword")
createRebirthSkillKeyword("club", "club")
createRebirthSkillKeyword("axe", "axe")
createRebirthSkillKeyword("distance", "distance")
createRebirthSkillKeyword("shielding", "shielding") -- Renomeado para evitar conflito com blessing
createRebirthSkillKeyword("fishing", "fishing")
createRebirthSkillKeyword("magiclevel", "magic level") -- Renomeado para evitar conflito

-- Confirmação final do rebirth (topic 101)
keywordHandler:addKeyword({ "yes" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "So be it! May the gods grant you strength in your new journey...",
	reset = true,
	ungreet = true,
}, function(player)
	return npcHandler:getTopic(player:getId()) == 101
end, function(player)
	local skillId = player:getStorageValue(90000)
	local skillName = ""
	
	-- Encontra o nome da skill pelo ID
	for name, id in pairs(Rebirth.Skills) do
		if id == skillId then
			skillName = name
			break
		end
	end
	
	if skillName ~= "" then
		local success, errorMsg = Rebirth.execute(player, skillName)
		if not success then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Rebirth failed: " .. errorMsg)
		end
	end
	
	player:setStorageValue(90000, -1) -- Limpa o storage temporário
	npcHandler:setTopic(player:getId(), 0)
end)

-- Cancelamento da escolha de skill (topic 100 ou 101)
keywordHandler:addKeyword({ "no" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "A wise decision to reconsider. Think carefully before choosing the path of rebirth.",
	reset = true,
}, function(player)
	local topic = npcHandler:getTopic(player:getId())
	return topic == 100 or topic == 101
end, function(player)
	player:setStorageValue(90000, -1)
	npcHandler:setTopic(player:getId(), 0)
end)

-- Rebirth main keyword
local rebirthKeyword = keywordHandler:addKeyword({ "rebirth" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Ah, the path of rebirth! A sacred ritual where you sacrifice your current power to gain mastery in a specific skill. ...",
		"If you choose this path, you will lose all your experience and return to level 1, but in return: ...",
		"1% of your total experience will be converted into skill tries for the skill of your choice. ...",
		"You will also receive 1 tibia coin for each level you sacrifice. ...",
		"Do you wish to proceed with the rebirth ritual?",
	},
})

rebirthKeyword:addChildKeyword({ "yes" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Excellent! Now, which skill would you like to master? Choose wisely: ...",
		"Say {sword}, {club}, {axe}, {distance}, {shielding}, {fishing}, or {magiclevel}.",
	},
	reset = false,
	ungreet = false,
}, nil, function(player)
	npcHandler:setTopic(player:getId(), 100) -- Topic 100 = aguardando escolha de skill
end)

rebirthKeyword:addChildKeyword({ "no" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Perhaps another time, then. The path of rebirth will always be available when you're ready.",
	reset = true,
})

-- Basic
keywordHandler:addKeyword({ "pilgrimage" }, StdModule.say, { npcHandler = npcHandler, text = "Whenever you receive a lethal wound, your vital force is damaged and there is a chance that you lose some of your equipment. With every single of the five {blessings} you have, this damage and chance of loss will be reduced." })
keywordHandler:addKeyword({ "blessings" }, StdModule.say, { npcHandler = npcHandler, text = "There are five blessings available in five sacred places: the {spiritual} shielding, the spark of the {phoenix}, the {embrace} of Tibia, the fire of the {suns} and the wisdom of {solitude}. Additionally, you can receive the {twist of fate} here." })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "I see you received the spiritual shielding in the whiteflower temple south of Thais." }, function(player)
	return player:hasBlessing(1)
end)
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the druids north of Carlin have provided you with the Embrace of Tibia." }, function(player)
	return player:hasBlessing(2)
end)
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "I can see you received the blessing of the two suns in the suntower near Ab'Dendriel." }, function(player)
	return player:hasBlessing(3)
end)
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the spark of the phoenix already was given to you by the dwarven priests of earth and fire in Kazordoon." }, function(player)
	return player:hasBlessing(4)
end)
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense you already talked to the hermit Eremo on the isle of Cormaya and received this blessing." }, function(player)
	return player:hasBlessing(5)
end)
keywordHandler:addAliasKeyword({ "wisdom" })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of spiritual shielding in the whiteflower temple south of Thais." })
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "The druids north of Carlin will provide you with the embrace of Tibia." })
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of the two suns in the suntower near Ab'Dendriel." })
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon." })
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "Talk to the hermit Eremo on the isle of Cormaya about this blessing." })
keywordHandler:addAliasKeyword({ "wisdom" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, young |PLAYERNAME|! If you are heavily wounded or poisoned, I can {heal} you for free. I can also help you with the {adventurer stone} or guide you through the path of {rebirth}.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Remember: If you are heavily wounded or poisoned, I can heal you for free. I can also guide you through the path of rebirth.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May the gods bless you, |PLAYERNAME|! May your journey of rebirth lead you to greatness.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
