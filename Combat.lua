local Grid, gTable = ...

keyToPress = '-'
myClass, classTable, classId = UnitClass("player")

local function CanCastSpell(spellName)
    if not UnitExists("target") or not UnitIsVisible("target") then
        --print("No target.")
        return false
    end

    local cast = UnitCastingInfo('player')
    local chan = UnitChannelInfo('player')
    if cast or chan then
        --print("Casting.")
		return false
	end

    local start, duration, enabled, modRate = GetSpellCooldown(spellName)    

    if ( start ~= nil and duration ~= nil and start > 0 and duration > 0) then
        return false
    end

    local inRange, unit = 0, "target"
    usable, nomana = IsUsableSpell(spellName)

    if not usable then
        --print("Not usable.")
        return false
    end
    
   -- If we got this far we are good...
    return true
end

targetIdSpam = ""
gTable.CastSpells = function()
    local target = GetUnitName("target")
    if target then
        local targetId = select(6, strsplit("-", UnitGUID("target")))
        if targetId ~= targetIdSpam then
            targetIdSpam = targetId
            --message = string.format("My target is %s", target)
        end
    else
        UnitCanAttackFrame.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3]) 
    end

    if not (UnitCanAttack("player", "target") == true ) then
        UnitCanAttackFrame.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])  
    end

    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local healthPercentage = health / maxHealth * 100

    local mana = UnitPower("player", Enum.PowerType.Mana)
    local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
    local manaPercentage = mana / maxMana * 100
    local incombat = UnitAffectingCombat("player")

    -- warrior
    if classId == 1 and UnitCanAttack("player", "target") == true then
        WarriorCombat()
    -- paladin
    elseif classId == 2 then 
        Paladin()
    -- rogue 
    elseif classId == 4 then
        local target = GetUnitName("target")
        local myComboPoints = 0;
        if target then
            myComboPoints = UnitPower("player", 4) --GetComboPoints('player', 'target') 
        end

        if myComboPoints > 0 and CanCastSpell("Eviscerate") then
            message = string.format("Eviscerate with %s combo points", myComboPoints)
            CommandKeyToPress.texture:SetColorTexture(colorTwo[1], colorTwo[2], colorTwo[3])              
        elseif CanCastSpell("Sinister Strike") then
            CommandKeyToPress.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
            message = "Sinister Strike"
        end    
    -- priest
    elseif classId == 5 and UnitCanAttack("player", "target") == true then
        PriestCombat()
    -- shaman
    elseif classId == 7 then
        if CanCastSpell("Lightning Bolt") then
            CommandKeyToPress.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
            message = "Lightning Bolt"
        end        
        
    end
end