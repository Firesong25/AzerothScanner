local Grid, gTable = ...

local function BuffStackCount(buffName)
    for i=1,40 do
        local name, icon, count, _, _, etime = UnitBuff("player",i)
        if name == buffName and count ~= nil then
            --print(buffName .. " stacks " .. count)
            return count
        end
    end
    return 0
end


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

function PressKey(squareColor, intModifierColor)
    intModifierColor = intModifierColor or 0
    modifierColor = colorBackground

    if intModifierColor == 1 then
        modifierColor = colorOne
    elseif intModifierColor == 2 then
        modifierColor = colorTwo
    end

    CommandKeyToPress1.texture:SetColorTexture(modifierColor[1], modifierColor[2], modifierColor[3]) 
    CommandKeyToPress0.texture:SetColorTexture(squareColor[1], squareColor[2], squareColor[3])  
end

local function delay(tick)
    local th = coroutine.running()
    C_Timer.After(tick, function() coroutine.resume(th) end)
    coroutine.yield()
end

function PulseCrusaderAura()
    delay(500)
end

function PaladinRest()


    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local healthPercentage = math.floor(health / maxHealth * 100)

    local mana = UnitPower("player", Enum.PowerType.Mana)
    local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
    local manaPercentage = math.floor(mana / maxMana * 100)

    local myHolyPower = UnitPower("player", 9)
    local incombat = UnitAffectingCombat("player")    
    local phialsInBags = GetItemCount("Phial of Serenity")

    if incombat then
        return
    end
    --[[
    if IsMounted() and 
    IsUsableSpell("Crusader Aura") and 
    AuraUtil.FindAuraByName("Crusader Aura", "player") == nil then
        print("No Crusader Aura")
end
]]
    if IsMounted() then
        message = "Mounted."
    elseif UnitIsDeadOrGhost("player") then
        message = string.format("I, %s, am dead.", UnitName("player")) 
    elseif IsUsableSpell("Word of Glory") and healthPercentage < 90 then
        CommandKeyToPress1.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3]) 
        CommandKeyToPress0.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])  
        message = "Recovering - Word of Glory"
    elseif IsUsableSpell("Flash of Light") and 
            healthPercentage < 80 and 
            manaPercentage > 35 then
        message = string.format("Recovering - Flash of Light at health percentage: %s ", healthPercentage)
        CommandKeyToPress0.texture:SetColorTexture(colorFour[1], colorFour[2], colorFour[3])     
        CommandKeyToPress1.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])              
    elseif IsUsableSpell("Summon Steward") and phialsInBags < 1 then
        message = "I need to summon a steward."
        PressKey(colorOne, 2) --F12
    else
        message = string.format("I, %s, am ready for combat", UnitName("player"))
        PressKey(colorBackground)
    end
end



function RetributionCombat()    
    if not incombat then
        return
    end
    local aoeNeeded = false
    local inRange, nameplates = 0, C_NamePlate.GetNamePlates()
    for index = 1, #nameplates do
       local unit = nameplates[index].namePlateUnitToken
       if UnitCanAttack("player", unit) and IsItemInRange(63427, unit) then
          if inRange > 1 then aoeNeeded = true end
          inRange = inRange + 1
       end
    end

    if IsMounted() then
        return
    end

    if not UnitAffectingCombat("player") then
        return
    end

    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local healthPercentage = math.floor(health / maxHealth * 100)

    local spell, _, _, _, endTime = UnitCastingInfo("target")
    if CanCastSpell("Rebuke") and spell then 
        for i,v in ipairs(spellsToInterrupt) do
        if v == spell then
            PressKey(colorSeven, 1)  
            message = "Rebuke"
        end    
      end  
    elseif CanCastSpell("Avenging Wrath") then
        PressKey(colorNine)
        message = "Avenging Wrath"
    elseif IsUsableSpell("Devotion Aura") and AuraUtil.FindAuraByName("Devotion Aura", "player") == nil then
        PressKey(colorTwo, 2) 
        message = "Devotion Aura"
    elseif CanCastSpell("Lay on Hands") and healthPercentage < 35  then
        PressKey(colorFive, 1)  
        message = "Lay on Hands"
    elseif CanCastSpell("Divine Shield") and healthPercentage < 55 then
        PressKey(colorEight) 
        message = "Divine Shield"
    elseif IsUsableSpell("Word of Glory") and healthPercentage < 75 then
        PressKey(colorZero, 1) 
        message = "Word of Glory"
    elseif CanCastSpell("Flash of Light") and 
            healthPercentage < 85 and
            BuffStackCount("Selfless Healer") > 3 then
        message = string.format("Flash of Light: instant cast.", healthPercentage)
        PressKey(colorFour, 1)     
    elseif CanCastSpell("Flash of Light") and 
            AuraUtil.FindAuraByName("Divine Shield", "player") ~= nil and 
            healthPercentage < 75 then
        message = string.format("Flash of Light: Health percentage is %s.", healthPercentage)
        PressKey(colorFour, 1)          
    elseif CanCastSpell("Shield of Vengeance")  then
        PressKey(colorThree, 1) 
        message = "Shield of Vengeance"
    elseif CanCastSpell("Blinding Light") and aoeNeeded  then
        PressKey(colorEight, 1) 
        message = "Blinding Light"   
    elseif CanCastSpell("Fleshcraft") and healthPercentage < 90  then
        PressKey(colorZero, 1) 
        message = "Fleshcraft"   
    elseif CanCastSpell("Ashen Hallow") and healthPercentage < 95  then
        PressKey(colorZero, 1)   
        message = "Ashen Hallow"   
    elseif aoeNeeded == true and 
            CanCastSpell("Divine Storm") and
            IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorSix, 1)   
        message = "Divine Storm"     
    elseif CanCastSpell("Templar's Verdict") and 
            IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorSix)   
        message = "Templar's Verdict"
    elseif CanCastSpell("Vanquisher's Hammer") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorTwo, 1)   
        message = "Vanquisher's Hammer"
    elseif CanCastSpell("Divine Toll") and IsSpellInRange("Judgment", "target")==1 then
        PressKey(colorZero)  
        message = "Divine Toll"
    --[[
    elseif CanCastSpell("Blessing of Spring") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorZero, 1)   
        message = "Blessing of Bloody Fae"
    elseif CanCastSpell("Blessing of Summer") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorZero, 1)   
        message = "Blessing of Bloody Fae"
    elseif CanCastSpell("Blessing of Autumn") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorZero, 1)  
        message = "Blessing of Bloody Fae"
    elseif CanCastSpell("Blessing of Winter") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorZero, 1)  
        message = "Blessing of Bloody Fae"
    ]]
    elseif CanCastSpell("Hammer of Wrath") then
        PressKey(colorFour)   
        message = "Hammer of Wrath"
    elseif CanCastSpell("Consecration") and 
            IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorFive)  
        message = "Consecration"
    elseif CanCastSpell("Hammer of Justice") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorSeven)  
        message = "Hammer of Justice"
    elseif CanCastSpell("Blade of Justice") and IsSpellInRange("Crusader Strike", "target") == 1 then
        PressKey(colorOne)  
        message = "Blade of Justice"
    elseif CanCastSpell("Judgment") then
        PressKey(colorThree)  
        message = "Judgement"
    elseif CanCastSpell("Crusader Strike") then
        PressKey(colorTwo)   
        message = "Crusader Strike"
    else
        PressKey(colorBackground, 1)   
        message = ""
    end
end

local function ProtectionCombat()
    if IsMounted() then
        return
    end

    if not UnitAffectingCombat("player") then
        return
    end

    local aoeNeeded = false
    local inRange, nameplates = 0, C_NamePlate.GetNamePlates()
    for index = 1, #nameplates do
       local unit = nameplates[index].namePlateUnitToken
       if UnitCanAttack("player", unit) and IsItemInRange(63427, unit) then
          if inRange > 1 then aoeNeeded = true end
          inRange = inRange + 1
       end
    end

    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local healthPercentage = math.floor(health / maxHealth * 100)

    local mana = UnitPower("player", Enum.PowerType.Mana)
    local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
    local manaPercentage = math.floor(mana / maxMana * 100)

    local myHolyPower = UnitPower("player", 9)
    local incombat = UnitAffectingCombat("player")     

    if IsUsableSpell("Devotion Aura") and AuraUtil.FindAuraByName("Devotion Aura", "player") == nil then
        PressKey(colorTwo, 2)   
        message = "Devotion Aura"
    elseif CanCastSpell("Lay on Hands") and healthPercentage < 35  then
        PressKey(colorFive, 1)   
        message = "Lay on Hands"
    elseif CanCastSpell("Ardent Defender") and healthPercentage < 40 then
        PressKey(colorThree, 1)   
        message = "Ardent Defender"
    elseif CanCastSpell("Guardian of Ancient Kings") and aoeNeeded == true then
        PressKey(colorSix, 1)   
        message = "Guardian of Ancient Kings"
    elseif CanCastSpell("Guardian of Ancient Kings") and healthPercentage < 50 then
        PressKey(colorSix, 1)    
        message = "Guardian of Ancient Kings"
    elseif CanCastSpell("Word of Glory") and healthPercentage < 40 then
        PressKey(colorZero, 1)   
        message = "Word of Glory"
    elseif IsUsableSpell("Shield of the Righteous") and 
            IsSpellInRange("Crusader Strike", "target")==1 and 
            healthPercentage < 50
            then
                PressKey(colorTwo)   
        message = "Shield of the Righteous"
    elseif CanCastSpell("Divine Shield") and healthPercentage < 75 then
        PressKey(colorEight)  
        message = "Divine Shield"
    elseif CanCastSpell("Avenging Wrath") then
        PressKey(colorNine)  
        message = "Avenging Wrath"
    elseif CanCastSpell("Avenger's Shield") then
        PressKey(colorSix)    
        message = "Avenger's Shield"
    elseif CanCastSpell("Divine Toll") and IsSpellInRange("Judgment", "target")==1 then
        PressKey(colorZero)  
        message = "Divine Toll"
    elseif CanCastSpell("Hammer of Wrath") then
        PressKey(colorFour)  
        message = "Hammer of Wrath"
    elseif CanCastSpell("Judgment") then
        PressKey(colorThree)  
        message = "Judgement"
    elseif CanCastSpell("Consecration") and IsSpellInRange("Crusader Strike", "target") == 1 then
        PressKey(colorFive)   
        message = "Consecration"
    elseif CanCastSpell("Hammer of the Righteous") and IsSpellInRange("Crusader Strike", "target") == 1 then
        PressKey(colorOne)  
        message = "Hammer of the Righteous"
    elseif CanCastSpell("Hammer of Justice") and IsSpellInRange("Crusader Strike", "target")==1 then
        PressKey(colorSeven)   
        message = "Hammer of Justice"
    elseif CanCastSpell("Crusader Strike") then
        PressKey(colorOne)  
        message = "Crusader Strike"
    else
        PressKey(colorBackground)     
        message = ""
    end
end

local function HolyCombat()
    LowbieCombat()
end

function LowbieCombat()

    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    local healthPercentage = math.floor(health / maxHealth * 100)

    local mana = UnitPower("player", Enum.PowerType.Mana)
    local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
    local manaPercentage = math.floor(mana / maxMana * 100)

    local myHolyPower = UnitPower("player", 9)
    local incombat = UnitAffectingCombat("player")     

    if CanCastSpell("Judgment") then
        PressKey(colorThree)
        message = "Lowbie Combat: Judgement"
    elseif CanCastSpell("Consecration") and IsSpellInRange("Crusader Strike", "target") == 1 then
        CommandKeyToPress0.texture:SetColorTexture(colorFive[1], colorFive[2], colorFive[3])  
        message = "Lowbie Combat: Consecration"
    elseif CanCastSpell("Holy Shock") and IsSpellInRange("Crusader Strike", "target") == 1 then
        PressKey(colorSix) 
        message = "Holy Combat: Holy Shock"
    elseif CanCastSpell("Hammer of Justice") and IsSpellInRange("Crusader Strike", "target")==1 then
        CommandKeyToPress0.texture:SetColorTexture(colorSeven[1], colorSeven[2], colorSeven[3])  
        message = "Lowbie Combat: Hammer of Justice"
    elseif CanCastSpell("Divine Shield") and healthPercentage < 50 then
        CommandKeyToPress0.texture:SetColorTexture(colorEight[1], colorEight[2], colorEight[3])  
        message = "Lowbie Combat: Divine Shield"
    elseif CanCastSpell("Word of Glory") and healthPercentage < 40 then
        CommandKeyToPress0.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])  
        message = "Lowbie Combat: Word of Glory"
    elseif CanCastSpell("Flash of Light") and healthPercentage < 50 then
        CommandKeyToPress0.texture:SetColorTexture(colorFour[1], colorFour[2], colorFour[3])  
        message = string.format("Lowbie Combat: Flash of Light - HP percentage is %s", healthPercentage)
    elseif IsUsableSpell("Shield of the Righteous") then
        -- no idea why this is needed
        if IsSpellInRange("Crusader Strike", "target")==1 then 
            CommandKeyToPress0.texture:SetColorTexture(colorTwo[1], colorTwo[2], colorTwo[3])  
            message = "Lowbie Combat: Shield of the Righteous"
        end
    elseif CanCastSpell("Crusader Strike") then
        CommandKeyToPress0.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
        message = "Lowbie Combat: Crusader Strike"
    else
        CommandKeyToPress0.texture:SetColorTexture(colorBackground[1], colorBackground[2], colorBackground[3])  
        message = ""
    end
end

function Paladin()
    if not incombat or IsMounted() then
        PaladinRest()
    end

    if not incombat then
        return
    end
 
    local target = GetUnitName("target")
    if target then
        local targetId = select(6, strsplit("-", UnitGUID("target")))
        if targetId ~= targetIdSpam then
            targetIdSpam = targetId
            message = string.format("My target is %s.", target)
        end
    end

    isDead = UnitIsDead("target")
    if isDead then
        message = "Target is dead."
        UnitCanAttackFrame.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])
        return  
    end

    if UnitCanAttack("player", "target") == true then
        UnitCanAttackFrame.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
    end

    spellName, spellSubName, spellID = GetSpellBookItemName("Templar's Verdict")
    if spellID ~= nil then
        RetributionCombat()
        return
    end

    spellName, spellSubName, spellID = GetSpellBookItemName("Avenger's Shield")
    if spellID ~= nil then
        ProtectionCombat()
        return
    end

    spellName, spellSubName, spellID = GetSpellBookItemName("Holy Shock")
    if spellID ~= nil then
        HolyCombat()
        return
    end
    
    LowbieCombat()
end

