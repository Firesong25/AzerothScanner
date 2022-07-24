local Grid, gTable = ...

local questChoicePending, questChoiceFinished

function GetActiveQuestIds()
    activeQuestIds = {}
    local numEntries, numQuests = C_QuestLog.GetNumQuestLogEntries()
    local allmax=C_QuestLog.GetMaxNumQuests()

    for i = 1, allmax do 
        if C_QuestLog.GetInfo(i) ~= nil then
            local info = C_QuestLog.GetInfo(i)
            
            local title = info["title"]		
            local header = info["isHeader"]		
            local id = info["questID"]

            if title and not header then
                table.insert(activeQuestIds, id)
            end
        end
    end
    return activeQuestIds    
end

function StripText(text)
	if not text then return "" end
	text = gsub(text, "%[.*%]%s*","")
	text = gsub(text, "|c%x%x%x%x%x%x%x%x(.+)|r","%1")
	text = gsub(text, "(.+) %(.+%)", "%1")
	return strtrim(text)
end

function UpdateQuestGrid()
    local ids = GetActiveQuestIds()
    count = table.getn(ids)

	if count > 0 then
        sixNumbersTable = NumberToSixTable(ids[1])
        digit = sixNumbersTable[2]
        colourTable = NumberToColour(digit)
        QuestGrid11.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[3]
        colourTable = NumberToColour(digit)
        QuestGrid12.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[4]
        colourTable = NumberToColour(digit)
        QuestGrid13.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[5]
        colourTable = NumberToColour(digit)
        QuestGrid14.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[6]
        colourTable = NumberToColour(digit)
        QuestGrid15.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
    end
  
    if count > 1 then
        sixNumbersTable = NumberToSixTable(ids[2])
        digit = sixNumbersTable[2]
        colourTable = NumberToColour(digit)
        QuestGrid21.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[3]
        colourTable = NumberToColour(digit)
        QuestGrid22.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[4]
        colourTable = NumberToColour(digit)
        QuestGrid23.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[5]
        colourTable = NumberToColour(digit)
        QuestGrid24.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[6]
        colourTable = NumberToColour(digit)
        QuestGrid25.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
    end

    if count > 2 then
        sixNumbersTable = NumberToSixTable(ids[3])
		digit = sixNumbersTable[2]
		colourTable = NumberToColour(digit)
		QuestGrid31.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
		digit = sixNumbersTable[3]
		colourTable = NumberToColour(digit)
		QuestGrid32.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
		digit = sixNumbersTable[4]
		colourTable = NumberToColour(digit)
		QuestGrid33.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
		digit = sixNumbersTable[5]
		colourTable = NumberToColour(digit)
		QuestGrid34.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
		digit = sixNumbersTable[6]
		colourTable = NumberToColour(digit)
		QuestGrid35.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
    end

    if count > 3 then
        sixNumbersTable = NumberToSixTable(ids[4])		
        digit = sixNumbersTable[2]
        colourTable = NumberToColour(digit)
        QuestGrid41.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[3]
        colourTable = NumberToColour(digit)
        QuestGrid42.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[4]
        colourTable = NumberToColour(digit)
        QuestGrid43.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[5]
        colourTable = NumberToColour(digit)
        QuestGrid44.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
        digit = sixNumbersTable[6]
        colourTable = NumberToColour(digit)
        QuestGrid45.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
    end
end

function FlagCompletedQuests()
	isQuestOneCompleted = C_QuestLog.IsQuestFlaggedCompleted(questDoneId1)
	isQuestTwoCompleted = C_QuestLog.IsQuestFlaggedCompleted(questDoneId2)
	isQuestThreeCompleted = C_QuestLog.IsQuestFlaggedCompleted(questDoneId3)
	
	if isQuestOneCompleted then
		Quest1Completed.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])
	end

	if isQuestTwoCompleted then
		Quest2Completed.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])
	end

	if isQuestThreeCompleted then
		Quest3Completed.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])
	end
end

function ListActiveQuestIds()
    activeQuestIds = {}
    local numEntries, numQuests = C_QuestLog.GetNumQuestLogEntries()
    local allmax=C_QuestLog.GetMaxNumQuests()

    for i = 1, allmax do 
        if C_QuestLog.GetInfo(i) ~= nil then
            local info = C_QuestLog.GetInfo(i)
            
            local title = info["title"]		
            local header = info["isHeader"]		
            local id = info["questID"]

            if title and not header then
                log(string.format("%s has questID %d", title, id))
            end
        end
    end
end