local combat = Combat()
local cooldown = 60000 -- milis

combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local level = creature:getLevel()
	local magicLevel = creature:getMagicLevel()

	local min = (level * 0.2 + magicLevel * 1.4) + 8
	local max = (level * 0.2 + magicLevel * 1.795) + 11
	local healthGain = math.random(math.floor(min), math.floor(max))

	local condition = Condition(CONDITION_REGENERATION)
	condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000)
	condition:setParameter(CONDITION_PARAM_HEALTHGAIN, healthGain)
	condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 3 * 1000)
	condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	creature:addCondition(condition)

	return combat:execute(creature, variant)
end

spell:name("Intense Recovery")
spell:words("utura gran")
spell:group("healing")
spell:vocation("knight;true", "elite knight;true", "paladin;true", "royal paladin;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_INTENSE_RECOVERY)
spell:id(160)
spell:cooldown(cooldown)
spell:groupCooldown(1000)
spell:level(100)
spell:mana(165)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)

spell:register()
