-- Sistema de Rebirth para Crystal Server 15.11
-- O jogador pode resetar seu level para ganhar skill tries

Rebirth = {
	-- Configurações
	Config = {
		expToSkillPercent = 100, -- 100% da exp total será convertida
		coinsPerLevel = 1, -- 1 tibia coin por level
		pointsPerLevelAboveHistory = 1, -- 1 ponto por level acima do histórico
		pointsPerLevelBelowHistory = 1, -- pontos por level até o histórico (arredondado para baixo)
	},

	-- Skills disponíveis para rebirth
	Skills = {
		["sword"] = SKILL_SWORD,
		["club"] = SKILL_CLUB,
		["axe"] = SKILL_AXE,
		["distance"] = SKILL_DISTANCE,
		["shielding"] = SKILL_SHIELD,
		["fishing"] = SKILL_FISHING,
		["magiclevel"] = SKILL_MAGLEVEL,
	},
}

function Rebirth.getLevelHistory(player)
	local rebirthKV = player:kv():scoped("rebirth")
	return rebirthKV:get("level-history") or 0
end

function Rebirth.calculatePromotionPoints(currentLevel, previousHistory)
	local levelsAboveHistory = math.max(0, currentLevel - previousHistory)
	local levelsBelowOrEqualHistory = math.min(currentLevel, previousHistory)

	local pointsFromAbove = levelsAboveHistory * Rebirth.Config.pointsPerLevelAboveHistory
	local pointsFromBelow = math.floor(levelsBelowOrEqualHistory * Rebirth.Config.pointsPerLevelBelowHistory)

	return pointsFromAbove + pointsFromBelow
end

-- Calcula quantos skill tries o jogador vai receber
function Rebirth.calculateSkillTries(player, skill)
	local currentExp = player:getExperience()
	local expToConvert = math.floor(currentExp * (Rebirth.Config.expToSkillPercent / 100))

	-- Para magic level, usa diferentes cálculos
	if skill == SKILL_MAGLEVEL then
		-- Aproximação: 1 magic level = ~400.000 mana spent em vocações normais
		-- Vamos converter exp em mana spent de forma proporcional
		-- 1 exp = aproximadamente 0.1 mana spent
		return math.floor(expToConvert * 0.1)
	else
		-- Para skills de combate, cada skill try tem um custo que aumenta com o level
		-- Vamos converter a exp diretamente em tries
		-- Fórmula aproximada: tries = exp * multiplicador
		return math.floor(expToConvert * 0.05)
	end
end

-- Verifica se o jogador pode fazer rebirth
function Rebirth.canRebirth(player)
	local level = player:getLevel()
	if level < 2 then
		return false, "Você precisa estar no mínimo level 2 para fazer rebirth."
	end
	return true, ""
end

-- Executa o rebirth do jogador
function Rebirth.execute(player, skillName)
	-- Verifica se pode fazer rebirth
	local canDo, errorMsg = Rebirth.canRebirth(player)
	if not canDo then
		return false, errorMsg
	end

	-- Verifica se a skill é válida
	local skill = Rebirth.Skills[skillName:lower()]
	if not skill then
		return false, "Skill inválida. Escolha: sword, club, axe, distance, shielding, fishing ou magiclevel."
	end

	-- Pega informações atuais do jogador
	local currentLevel = player:getLevel()
	local currentExp = player:getExperience()
	local previousLevelHistory = Rebirth.getLevelHistory(player)

	-- Calcula skill tries
	local skillTries = Rebirth.calculateSkillTries(player, skill)
	local promotionPointsToGive = Rebirth.calculatePromotionPoints(currentLevel, previousLevelHistory)

	-- Calcula tibia coins
	local coinsToGive = (currentLevel - 1) * Rebirth.Config.coinsPerLevel -- Level 1 = 0 coins

	-- Atualiza histórico de level (maior level já alcançado antes do rebirth)
	local newLevelHistory = math.max(previousLevelHistory, currentLevel)
	local rebirthKV = player:kv():scoped("rebirth")
	rebirthKV:set("level-history", newLevelHistory)

	-- Acumula promotion points do rebirth na KV da wheel
	if promotionPointsToGive > 0 then
		player:addPromotionPoints(promotionPointsToGive)
	end

	-- Remove toda experiência (isso mantém o level 1)
	player:removeExperience(currentExp, false)
	player:setLevel(1)
	-- enche stamina e offline training
	player:setStamina(2520)
	player:addOfflineTrainingTime(43200) -- 12 horas de offline training

	-- Adiciona skill tries
	if skill == SKILL_MAGLEVEL then
		player:addManaSpent(skillTries, false)
	else
		player:addSkillTries(skill, skillTries, false)
	end

	-- Adiciona tibia coins
	if coinsToGive > 0 then
		player:addTransferableCoins(coinsToGive)
	end

	-- Efeitos visuais
	player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)

	-- Mensagem de sucesso
	local skillNameDisplay = skillName:gsub("^%l", string.upper)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Rebirth realizado com sucesso! Você recebeu %d skill tries em %s, %d tibia coins e %d promotion points para a Destiny Wheel. Bônus de EXP de 100%% ativo enquanto estiver abaixo do seu level memory (%d).", skillTries, skillNameDisplay, coinsToGive, promotionPointsToGive, newLevelHistory))

	return true, ""
end
