local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local level = creature:getLevel()
	local magicLevel = creature:getMagicLevel()

	local min = (level * 0.2 + magicLevel * 1.4) + 8
	local max = (level * 0.2 + magicLevel * 1.795) + 11
	local reducedMin = math.floor(min * 0.5)
	local reducedMax = math.floor(max * 0.5)
	local healthGain = math.random(reducedMin, reducedMax)

	local condition = Condition(CONDITION_REGENERATION)
	condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000)
	condition:setParameter(CONDITION_PARAM_HEALTHGAIN, healthGain)
	condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 3 * 1000)
	condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	creature:addCondition(condition)

	return combat:execute(creature, variant)
end

spell:name("Recovery")
spell:words("utura")
spell:group("healing")
spell:vocation("knight;true", "elite knight;true", "paladin;true", "royal paladin;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_RECOVERY)
spell:id(159)
spell:cooldown(1 * 60 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(20)
spell:mana(75)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
