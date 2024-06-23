-- ===========================================================================
--	Historical Victory Scripts
-- ===========================================================================
include("HistoricalVictory_Data");

print("Loading HistoricalVictory_Scripts.lua")

-- ===========================================================================
-- UI Context from ExposedMembers
-- ===========================================================================

ExposedMembers.GetPlayerCityUIDatas = {}
ExposedMembers.GetCalendarTurnYear = {}
ExposedMembers.GetEraCountdown = {}
ExposedMembers.CheckCityOriginalCapital = {}
ExposedMembers.HSD_GetTerritoryCache = {}
ExposedMembers.HSD_GetTerritoryID = {}
ExposedMembers.HSD_GetTotalIncomingRoutes = {}
ExposedMembers.HSD_GetCitiesWithTradingPosts = {}
ExposedMembers.HSD_TradePostEveryPlayerOnContinent = {}
ExposedMembers.HSD_GetRiverPlots = {}
ExposedMembers.HSD_GetCultureCounts = {}
ExposedMembers.HSD_GetNumTechsResearched = {}
ExposedMembers.HSD_GetHolyCitiesCount = {}
ExposedMembers.HSD_GetCitiesWithGovernors = {}
ExposedMembers.HSD_GetUnitPromotionLevel = {}
ExposedMembers.HSD_GetUnitClassLevel = {}
ExposedMembers.HSD_GetTourismCounts = {}
ExposedMembers.HSD_GetPlotYield = {}
ExposedMembers.HSD_GetGreatWorksCount = {}
ExposedMembers.HSD_GetGreatWorkTypeCount = {}
ExposedMembers.HSD_GetNumBeliefs = {}
ExposedMembers.HSD_GetGoldenAge = {}
ExposedMembers.HSD_GetMomentData = {}

-- ===========================================================================
-- Variables
-- ===========================================================================

local iVictoryScoreToWin = 3
local territoryCache = {} -- Used to track territories detected from UI context
local iFreeCitiesPlayerID = PlayerManager.GetFreeCitiesPlayerID()
local bCivilizationVictory = MapConfiguration.GetValue("CivilizationVictoryOnly")

-- ===========================================================================
-- Cache Functions
-- ===========================================================================
local function GetVictoryPlayerType(playerID)
    local CivilizationTypeName = PlayerConfigurations[playerID]:GetCivilizationTypeName()
    local LeaderTypeName = PlayerConfigurations[playerID]:GetLeaderTypeName()
    local playerTypeName = LeaderTypeName
    if bCivilizationVictory or not HSD_victoryConditionsConfig[playerTypeName] then
        -- Use the civ victory if the leader victory is not defined, or if civilization victory mode is enabled
        playerTypeName = CivilizationTypeName
        print("Leader not detected in historical victory table. Using civilization value.")
    end
    if not HSD_victoryConditionsConfig[playerTypeName] then
        playerTypeName = "GENERIC_CIVILIZATION"
    end
    print("GetVictoryPlayerType returned "..tostring(playerTypeName))
    return playerTypeName
end

local function CacheVictoryConditions()
    local allPlayerIDs = PlayerManager.GetAliveIDs()
    local playerVictoryConditions = {} -- Table to hold each player's victory conditions

    for _, playerID in ipairs(allPlayerIDs) do
        local playerTypeName = GetVictoryPlayerType(playerID)
        local conditionsForPlayer = HSD_victoryConditionsConfig[playerTypeName] or {}

        playerVictoryConditions[playerID] = {}

        for i, condition in ipairs(conditionsForPlayer) do
            -- Copy each condition to the player's specific condition list
            playerVictoryConditions[playerID][i] = {
                playerTypeName = playerTypeName,
                id = condition.id,
                index = condition.index,
                year = condition.year or nil,
                yearLimit = condition.yearLimit or nil,
                era = condition.era or nil,
                eraLimit = condition.eraLimit or nil,
                objectives = condition.objectives,
                score = condition.score
            }
        end
    end

    -- Store the cached conditions for later use
    Game:SetProperty("HSD_PlayerVictoryConditions", playerVictoryConditions)
end

-- local function CacheLuxuryResourcePlots()
--     local luxuryResources = {}
    
--     -- Iterate through all resources to initialize the luxuryResources table
--     for resource in GameInfo.Resources() do
--         if resource.ResourceClassType == "RESOURCECLASS_LUXURY" then
--             luxuryResources[resource.ResourceType] = {}
--         end
--     end

--     -- Iterate through all plots and store the indexes of luxury resource plots
--     for plotIndex = 0, Map.GetPlotCount() - 1 do
--         local plot = Map.GetPlotByIndex(plotIndex)
--         local resourceType = plot:GetResourceType()

--         if resourceType ~= -1 then -- Check if there is a resource on the plot
--             local resourceInfo = GameInfo.Resources[resourceType]
--             if resourceInfo and resourceInfo.ResourceClassType == "RESOURCECLASS_LUXURY" then
--                 table.insert(luxuryResources[resourceInfo.ResourceType], plotIndex)
--             end
--         end
--     end

--     -- Store the table in a game property for later access
--     Game:SetProperty("HSD_LuxuryResourcePlotIndexes", luxuryResources)
-- end

local function CacheAllResourcePlots()
    local allResources = {}
    
    -- Initialize the allResources table for every resource type
    for resource in GameInfo.Resources() do
        allResources[resource.ResourceType] = {}
    end

    -- Iterate through all plots and store the indexes of resource plots
    for plotIndex = 0, Map.GetPlotCount() - 1 do
        local plot = Map.GetPlotByIndex(plotIndex)
        local resourceType = plot:GetResourceType()

        if resourceType ~= -1 then -- Check if there is a resource on the plot
            local resourceInfo = GameInfo.Resources[resourceType]
            if resourceInfo then
                table.insert(allResources[resourceInfo.ResourceType], plotIndex)
            end
        end
    end

    -- Store the table in a game property for later access
    Game:SetProperty("HSD_ResourceData", allResources)
end

-- ===========================================================================
-- Helper functions
-- ===========================================================================

-- Helper function to check if a table contains a certain element
local function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function ConvertYearToAnnoDomini(currentTurnYear)
	local calendarDateBC = false
	local calendarTurnString = "nil"
	if (currentTurnYear < 0) then
		-- print("Converting negative year number to calendar date")
		calendarDateBC = currentTurnYear*(-1)
		if calendarDateBC then
			calendarTurnString = tostring(calendarDateBC).."BC"
			-- print("Current turn year is "..tostring(currentTurnYear)..". Converted to calendar year is "..tostring(calendarDateBC))
		else
			calendarTurnString = tostring(currentTurnYear)
		end
	else
		calendarTurnString = tostring(currentTurnYear).."AD"
	end
	return calendarTurnString
end

local function DoesPlayerHaveVictoryCondition(playerID, conditionID)
    local playerVictoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
    local conditionsForPlayer = playerVictoryConditions[playerID] or {}

    for _, condition in ipairs(conditionsForPlayer) do
        if condition.id == conditionID then
            return true
        end
    end
    return false
end

local function IsFreeCityPlayer(playerID)
    if playerID and (playerID == iFreeCitiesPlayerID) then
        return true
    end
    return false
 end

local function IsHistoricalVictoryPlayer(playerID)
    local player = Players[playerID]
    if player and (player:IsMajor()) and (not player:IsBarbarian()) and not IsFreeCityPlayer(playerID) then
        return true
    end
    return false
end

local function IsCityState(playerID)
    local player = Players[playerID]
    if player and (not player:IsMajor()) and (not player:IsBarbarian()) and not IsFreeCityPlayer(playerID) then
        return true
    end
    return false
end

local function HasPlayerSpawned(playerID)
    local player = Players[playerID]
    if player then
        local numPlayerCities = player:GetCities():GetCount()
        if (numPlayerCities >= 1) then
            return true
        end
    end
    return false
end

local function CountCitiesInRange(centerX, centerY, range, playerID)
    local count = 0

    -- Iterate through each tile in the range
    for dx = -range, range do
        for dy = -range, range do
            local x = centerX + dx
            local y = centerY + dy

            if Map.IsPlot(x, y) then
                local plot = Map.GetPlot(x, y)

                -- Check if the plot has a city and if it belongs to the player
                if plot:IsCity() and plot:GetOwner() == playerID then
                    count = count + 1
                end
            end
        end
    end

    return count
end

-- ===========================================================================
-- Victory Conditions
-- ===========================================================================

local function AreTwoWondersInSameCity(playerID, firstWonderID, secondWonderID)
    local player = Players[playerID]
    local playerCities = player:GetCities()

    if not GameInfo.Buildings[firstWonderID] or not GameInfo.Buildings[secondWonderID] then
        return false
    end

    for _, city in playerCities:Members() do
        local cityBuildings = city:GetBuildings()

        local hasFirstWonder = cityBuildings:HasBuilding(GameInfo.Buildings[firstWonderID].Index)
        local hasSecondWonder = cityBuildings:HasBuilding(GameInfo.Buildings[secondWonderID].Index)

        if hasFirstWonder and hasSecondWonder then
            return true
        end
    end

    return false
end

local function GetWondersCount(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local playerWondersCount = 0
    local totalWondersCount = 0

    -- Function to count wonders in a given city
    local function countCityWonders(city)
        local cityBuildings = city:GetBuildings()
        local cityWondersCount = 0
        for building in GameInfo.Buildings() do
            if building.IsWonder and cityBuildings:HasBuilding(building.Index) then
                cityWondersCount = cityWondersCount + 1
            end
        end
        return cityWondersCount
    end

    -- Count wonders for the specified player
    for _, city in playerCities:Members() do
        playerWondersCount = playerWondersCount + countCityWonders(city)
    end

    -- Count wonders for all players to get the total wonders in the world
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        local otherPlayerCities = otherPlayer:GetCities()
        for _, city in otherPlayerCities:Members() do
            totalWondersCount = totalWondersCount + countCityWonders(city)
        end
    end

    -- The amount of player wonders will be evaluated against the total count
    -- If the both are zero, the victory will be marked as completed
    -- Set play wonder count to -1 in this case to prevent this from happening
    if (playerWondersCount == 0) and (totalWondersCount == 0) then
        playerWondersCount = -1
    end

    return playerWondersCount, totalWondersCount
end

local function GetCitiesCount(playerID)
    local player = Players[playerID]
    local playerCitiesCount = player:GetCities():GetCount()
    return playerCitiesCount
end

local function GetCitiesWithNameCount(playerID, word)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local count = 0
    local lowerCaseWord = string.lower(word)

    -- Iterate through each city
    for _, city in playerCities:Members() do
        local cityName = Locale.Lookup(city:GetName())
        local lowerCaseCityName = string.lower(cityName)
        if string.find(lowerCaseCityName, lowerCaseWord) then
            count = count + 1
        end
    end

    return count
end

local function GetNumCitiesWithPopulation(playerID, requiredCityNum, requiredPopulation)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local citiesMeetingCriteria = 0

    for _, city in playerCities:Members() do
        if city:GetPopulation() >= requiredPopulation then
            citiesMeetingCriteria = citiesMeetingCriteria + 1
        end
    end

    return citiesMeetingCriteria
end

local function GetCitiesWithFeatureCount(playerID, featureType)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local featureCount = 0

    if not GameInfo.Features[featureType] then
        print("Feature type " .. tostring(featureType) .. " not found in GameInfo.")
        return featureCount
    end

    local featureIndex = GameInfo.Features[featureType].Index

    for _, city in playerCities:Members() do
        local hasFeature = false

        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
		for _,kCityUIDatas in pairs(CityUIDataList) do
			for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
				local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot:GetFeatureType() == featureIndex then
                    hasFeature = true
                    break -- Break the inner loop as we found the feature in this city
                end
			end
		end

        if hasFeature then
            featureCount = featureCount + 1
        end
    end

    return featureCount
end

local function GetOccupiedCapitals(playerID)
    -- print("Checking number of occupied capitals for player " .. tostring(playerID))
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local count = 0

    for _, city in playerCities:Members() do
		-- print("city name is "..tostring(city:GetName()))
        if ExposedMembers.CheckCityOriginalCapital(playerID, city:GetID()) then
            count = count + 1
        end
    end

    -- print("Player " .. tostring(playerID) .. " owns " .. tostring(count) .. " occupied capitals.")
    return count
end

local function GetRiverOwnership(playerID)
    local player = Players[playerID]
    local capital = player:GetCities():GetCapitalCity()
    local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
    local capitalPlotIndex = Map.GetPlotIndex(capitalPlot)
    local riverID, riverPlots = ExposedMembers.HSD_GetRiverPlots(capitalPlot, capitalPlotIndex)

    local current = 0 -- Number of river plots owned by the player
    local total = #riverPlots -- Total number of river plots

    -- Iterate through each plot index in the riverPlots array
    for _, plotIndex in ipairs(riverPlots) do
        local plot = Map.GetPlotByIndex(plotIndex)
        if plot and plot:IsOwned() then
            if plot:GetOwner() == playerID then
                current = current + 1
            end
        end
    end

    return current, total
end

local function GetHighestEnvoyCount(playerID)
    local highestEnvoyCount = 0
    local player = Players[playerID]
    if not player then
        return 0
    end
    for _, cityStateID in ipairs(PlayerManager.GetAliveMinorIDs()) do
        local otherPlayer = Players[cityStateID]
        local CivilizationTypeName = PlayerConfigurations[cityStateID]:GetCivilizationTypeName()
        if IsCityState(cityStateID) then
            local otherPlayerInfluence = otherPlayer:GetInfluence()
            local envoyCount = 0
            if otherPlayerInfluence then
                envoyCount = otherPlayerInfluence:GetTokensReceived(playerID) or 0
            end
            if envoyCount then
                print("Envoy count for "..tostring(CivilizationTypeName).." is "..tostring(envoyCount))
                if envoyCount > highestEnvoyCount then
                    highestEnvoyCount = envoyCount
                    print("Highest envoy count is "..tostring(highestEnvoyCount))
                end
            end
        end
    end
    return highestEnvoyCount
end

local function GetSuzeraintyCount(playerID)
    local suzerainCount = 0
    -- local playerDiplomacy = Players[playerID]:GetDiplomacy()
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        local CivilizationTypeName = PlayerConfigurations[otherPlayerID]:GetCivilizationTypeName()
        if IsCityState(otherPlayerID) then
            local suzerainID = otherPlayer:GetInfluence():GetSuzerain()
			if suzerainID then
				-- print("suzerainID for "..tostring(CivilizationTypeName).." is "..tostring(suzerainID))
				if suzerainID == playerID then
					suzerainCount = suzerainCount + 1
					print("Suzerainty detected. suzerainCount is "..tostring(suzerainCount))
				end
			end
        end
    end
    return suzerainCount
end

local function GetUnitCount(playerID, unitType)
    print("Checking number of " .. tostring(unitType) .. " units for player " .. tostring(playerID))
    local player = Players[playerID]
    local playerUnits = player:GetUnits()
    local count = 0

    for _, unit in playerUnits:Members() do
		-- print("unitType is "..tostring(unit:GetType()))
        if unit:GetType() == GameInfo.Units[unitType].Index then
            count = count + 1
        end
    end

    print("Player " .. tostring(playerID) .. " owns " .. tostring(count) .. " " .. tostring(unitType) .. " units.")
    return count
end

local function GetUnitClassCount(playerID, unitClassType)
    print("Checking number of " .. tostring(unitClassType) .. " units for player " .. tostring(playerID))
    local player = Players[playerID]
    local unitClassCount = 0

    if not player then
        print("Player not found for playerID: " .. tostring(playerID))
        return 0
    end

    local units = player:GetUnits()
    for _, unit in units:Members() do
        local unitType = unit:GetType()
        local unitInfo = GameInfo.Units[unitType]
        if unitInfo.PromotionClass == unitClassType then
            unitClassCount = unitClassCount + 1
        end
    end
    print("Player " .. tostring(playerID) .. " owns " .. tostring(unitClassCount) .. " " .. tostring(unitClassType) .. " units.")
    return unitClassCount
end

local function GetUnitDomainCount(playerID, unitDomain) -- TODO: Change to formation class
    local playerUnits = Players[playerID]:GetUnits()
    local playerDomainUnitCount = 0
    local highestDomainUnitCount = 0

    -- Count domain units for the specified player
    for _, unit in playerUnits:Members() do
        if GameInfo.Units[unit:GetType()].Domain == unitDomain then
            playerDomainUnitCount = playerDomainUnitCount + 1
        end
    end

    -- Compare with domain units count of all other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayerDomainUnitCount = 0
            local otherPlayerUnits = Players[otherPlayerID]:GetUnits()
            
            for _, unit in otherPlayerUnits:Members() do
                if GameInfo.Units[unit:GetType()].Domain == unitDomain then
                    otherPlayerDomainUnitCount = otherPlayerDomainUnitCount + 1
                end
            end

            if otherPlayerDomainUnitCount > highestDomainUnitCount then
                highestDomainUnitCount = otherPlayerDomainUnitCount
            end
        end
    end

    return playerDomainUnitCount, highestDomainUnitCount
end

local function GetUnitFormationClassCount(playerID, unitFormationClass)
    local playerUnits = Players[playerID]:GetUnits()
    local playerFormationClassUnitCount = 0
    local highestFormationClassUnitCount = 0

    -- Count FormationClass units for the specified player
    for _, unit in playerUnits:Members() do
        if GameInfo.Units[unit:GetType()].FormationClass == unitFormationClass then
            playerFormationClassUnitCount = playerFormationClassUnitCount + 1
        end
    end

    -- Compare with FormationClass units count of all other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayerFormationClassUnitCount = 0
            local otherPlayerUnits = Players[otherPlayerID]:GetUnits()
            
            for _, unit in otherPlayerUnits:Members() do
                if GameInfo.Units[unit:GetType()].FormationClass == unitFormationClass then
                    otherPlayerFormationClassUnitCount = otherPlayerFormationClassUnitCount + 1
                end
            end

            if otherPlayerFormationClassUnitCount > highestFormationClassUnitCount then
                highestFormationClassUnitCount = otherPlayerFormationClassUnitCount
            end
        end
    end

    return playerFormationClassUnitCount, highestFormationClassUnitCount
end

local function GetNuclearWeaponCount(playerID)
    local player = Players[playerID]
    if not player then
        print("Invalid player ID")
        return 0
    end

    local nuclearCount = 0
    local thermonuclearCount = 0

    -- Get counts for nuclear weapons
    local playerUnits = player:GetUnits()
    for _, unit in playerUnits:Members() do
        local unitType = GameInfo.Units[unit:GetType()].UnitType
        if unitType == "UNIT_NUCLEAR_DEVICE" then
            nuclearCount = nuclearCount + 1
        elseif unitType == "UNIT_THERMONUCLEAR_DEVICE" then
            thermonuclearCount = thermonuclearCount + 1
        end
    end

    local totalNukes = nuclearCount + thermonuclearCount
    print("Player " .. playerID .. " has " .. nuclearCount .. " nuclear bombs and " .. thermonuclearCount .. " thermonuclear bombs. Total: " .. totalNukes)
    return totalNukes
end

local function GetBorderingCitiesCount(iPlayer)
    local player = Players[iPlayer]
    local playerCities = player:GetCities()
    local borderingCityCount = 0

    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(iPlayer, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
				local isBorderCity = false
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot then
                    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
                        local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction)
                        if adjacentPlot and adjacentPlot:IsOwned() and adjacentPlot:GetOwner() ~= iPlayer then
                            borderingCityCount = borderingCityCount + 1
							isBorderCity = true
                            print("City bordering another player's territory detected. Total count is " .. tostring(borderingCityCount))
                            break -- Once a border is found, no need to check other plots for this city
                        end
                    end
                end
				if isBorderCity then
					break -- City already counted, move to next city
				end
            end
        end
    end

    return borderingCityCount
end

local function GetCityAdjacentToRiverCount(playerID)
    local player = Players[playerID]
    local riverAdjacentCityCount = 0

    if not player then
        print("Invalid player ID: " .. tostring(playerID))
        return riverAdjacentCityCount
    end

    local playerCities = player:GetCities()

    for _, city in playerCities:Members() do
        local cityX, cityY = city:GetX(), city:GetY()
        local cityPlot = Map.GetPlot(cityX, cityY)

        if cityPlot:IsRiver() or cityPlot:IsRiverAdjacent() then
            riverAdjacentCityCount = riverAdjacentCityCount + 1
        else
            -- Check adjacent plots if the city center is not directly on a river
            -- for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
            --     local adjacentPlot = Map.GetAdjacentPlot(cityX, cityY, direction)
            --     if adjacentPlot and adjacentPlot:IsRiver() then
            --         riverAdjacentCityCount = riverAdjacentCityCount + 1
            --         break -- Found a river adjacent plot, no need to check further
            --     end
            -- end
        end
    end

    return riverAdjacentCityCount
end

local function GetAdjacentDistrictsCapital(playerID)
    local player = Players[playerID]
    local capital = player:GetCities():GetCapitalCity()
    local adjacentDistrictCount = 0

    if capital then
        local capitalX, capitalY = capital:GetX(), capital:GetY()

        -- Check each of the six adjacent plots for districts
        for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
            local adjacentPlot = Map.GetAdjacentPlot(capitalX, capitalY, direction)
            if adjacentPlot and (adjacentPlot:GetDistrictType() ~= -1) then
                print("District detected adjacent to capital")
                local adjacentDistrict = CityManager.GetDistrictAt(adjacentPlot:GetX(), adjacentPlot:GetY())
                if (adjacentDistrict ~= nil) and (adjacentDistrict:GetOwner() == playerID) and (adjacentDistrict:IsComplete()) then
                    adjacentDistrictCount = adjacentDistrictCount + 1
                    print(tostring(GameInfo.Districts[adjacentPlot:GetDistrictType()].Name).." detected. Total count is "..tostring(adjacentDistrictCount))
                end              
            end
        end
    else
        print("No capital city found for player ID " .. tostring(playerID))
    end

    return adjacentDistrictCount
end

local function GetCitiesWithBuilding(playerID, buildingID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local buildingIndex = GameInfo.Buildings[buildingID].Index
    local cityCountWithBuilding = 0
    local totalCityCount = 0

    for _, city in playerCities:Members() do
        totalCityCount = totalCityCount + 1
        if city:GetBuildings():HasBuilding(buildingIndex) then
            cityCountWithBuilding = cityCountWithBuilding + 1
        end
    end

    return cityCountWithBuilding, totalCityCount
end

local function GetBuildingCount(iPlayer, buildingType)
	print("Checking total number of "..tostring(buildingType).." owned by player "..tostring(iPlayer))
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local buildingCount = 0

	if not GameInfo.Buildings[buildingType] then
		print("WARNING: Building type "..tostring(buildingType).." not detected in game database!")
		return buildingCount
	end

	local buildingIndex = GameInfo.Buildings[buildingType].Index

	for _, city in playerCities:Members() do
		if city:GetBuildings():HasBuilding(buildingIndex) then
			buildingCount = buildingCount + 1
		end
	end

	return buildingCount
end

local function GetImprovementCount(iPlayer, improvementType)
	-- print("Checking for total number of "..tostring(improvementType).." owned by player "..tostring(iPlayer))
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local improvementCount = 0

    if not GameInfo.Improvements[improvementType] then
        print("Improvement type " .. tostring(improvementType) .. " not found in GameInfo.")
        return improvementCount
    end

    local improvementIndex = GameInfo.Improvements[improvementType].Index

	for _, city in playerCities:Members() do
		local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(iPlayer, city:GetID())
		for _,kCityUIDatas in pairs(CityUIDataList) do
			for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
				local plot = Map.GetPlotByIndex(kCoordinates.plotID)
				if plot and plot:GetImprovementType() == improvementIndex then
					improvementCount = improvementCount + 1
					-- print("Improvement detected. Total count is "..tostring(improvementCount))
				end
			end
		end
	end

	return improvementCount
end

local function GetHighestImprovementYield(playerID, improvementType, yieldType)
    local player = Players[playerID]
    if not player then
        print("Invalid player ID")
        return 0
    end

    local highestYield = 0
    local improvementIndex = GameInfo.Improvements[improvementType] and GameInfo.Improvements[improvementType].Index
    local yieldIndex = GameInfo.Yields[yieldType] and GameInfo.Yields[yieldType].Index

    if not improvementIndex then
        print("Improvement type " .. tostring(improvementType) .. " not found.")
        return 0
    end

    if not yieldIndex then
        print("Yield type " .. tostring(yieldType) .. " not found.")
        return 0
    end

    -- Iterate through all plots owned by the player
    local playerCities = player:GetCities()
    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and (plot:GetImprovementType() == improvementIndex) then
                    -- print("Plot:GetX() = ".. tostring(plot:GetX()) .. ", GetY() = ".. tostring(plot:GetY()))
                    ---------------------------------------------------------------------------------------
                    -- totalslacker: Do not use the plot yield value from the game, use the one from the UI
                    ---------------------------------------------------------------------------------------
                    -- local plotYield = plot:GetYield(yieldIndex)
                    -- for row in GameInfo.Yields() do
                    --     plotYield = plot:GetYield(row.Index)
                    --     print("Yield: ".. tostring(row.YieldType).. " = ".. tostring(plotYield))
                    -- end
					-- print("plotYield is "..tostring(plotYield))
                    -----------------------------------------------
                    -- totalslacker: Get the plot yield from the UI
                    -----------------------------------------------
                    local plotYield = ExposedMembers.HSD_GetPlotYield(plot:GetIndex(), yieldIndex)
                    if plotYield > highestYield then
                        highestYield = plotYield
                    end
                end
            end
        end
    end

    print("Highest yield from " .. improvementType .. " for " .. yieldType .. " is: " .. highestYield)
    return highestYield
end

local function GetTotalRoutePlots(iPlayer)
	-- print("Checking for total number of route plots owned by player "..tostring(iPlayer))
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local routeCount = 0

	for _, city in playerCities:Members() do
		local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(iPlayer, city:GetID())
		for _,kCityUIDatas in pairs(CityUIDataList) do
			for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
				local plot = Map.GetPlotByIndex(kCoordinates.plotID)
				if plot:IsRoute() then
					routeCount = routeCount + 1
					-- print("plot isRoute detected. Total count is "..tostring(routeCount))
				end
			end
		end
	end

	return routeCount
end

local function GetRouteTypeCount(iPlayer, routeType)
	print("Checking for number of "..tostring(routeType).." plots owned by player "..tostring(iPlayer))
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local routeCount = 0

	for _, city in playerCities:Members() do
		local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(iPlayer, city:GetID())
		for _,kCityUIDatas in pairs(CityUIDataList) do
			for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
				local plot = Map.GetPlotByIndex(kCoordinates.plotID)
				if plot:IsRoute() and plot:GetRouteType() then
					routeCount = routeCount + 1
					-- print(tostring(plot:GetRouteType()).." detected. Total count is "..tostring(routeCount))
				end
			end
		end
	end

	return routeCount
end

local function GetImprovementAdjacentPlot(improvementType, plot)
    local improvementIndex = GameInfo.Improvements[improvementType].Index
    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction)
        if adjacentPlot and adjacentPlot:GetImprovementType() == improvementIndex then
            print("Found " .. improvementType .. " in adjacent plot")
            return true
        end
    end
end

local function GetCitiesWithImprovementCount(playerID, improvementType)
    print("Checking for cities with improvement: " .. tostring(improvementType) .. " for player " .. tostring(playerID))
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local citiesWithImprovementCount = 0

    if not GameInfo.Improvements[improvementType] then
        print("Improvement type " .. tostring(improvementType) .. " not found in GameInfo.")
        return 0 -- Return 0 if the improvement doesn't exist in the database
    end

    local improvementIndex = GameInfo.Improvements[improvementType].Index

    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and plot:GetImprovementType() == improvementIndex then
                    citiesWithImprovementCount = citiesWithImprovementCount + 1
                    break -- Found the improvement in this city, no need to check more plots for this city
                end
            end
        end
    end

    return citiesWithImprovementCount
end

local function GetWonderAdjacentImprovement(playerID, wonderType, improvementType) -- UNUSED
    print("Checking for " .. tostring(wonderType) .. " adjacent to " .. tostring(improvementType) .. " for player #" .. tostring(playerID))
    local player = Players[playerID]
    local playerCities = player:GetCities()

    if not GameInfo.Buildings[wonderType] then
        print("Wonder type " .. tostring(wonderType) .. " not found in GameInfo.")
        return false
    end

    if not GameInfo.Improvements[improvementType] then
        print("Improvement type " .. tostring(improvementType) .. " not found in GameInfo.")
        return false
    end

    local wonderIndex = GameInfo.Buildings[wonderType].Index
    local improvementIndex = GameInfo.Improvements[improvementType].Index

    for _, city in playerCities:Members() do
        if city:GetBuildings():HasBuilding(wonderIndex) then
			local wonderX, wonderY = city:GetBuildings():GetBuildingLocation(wonderIndex)
			if not wonderX or not wonderY then
				local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
				for _,kCityUIDatas in pairs(CityUIDataList) do
					for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
						local plot = Map.GetPlotByIndex(kCoordinates.plotID)
						print("Plot wonder type is "..tostring(plot:GetWonderType()))
						if (plot:GetWonderType() == wonderIndex) and plot:IsWonderComplete() then
							wonderX, wonderY = plot:GetX(), plot:GetY()
						end
					end
				end
			end
            for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
                local adjacentPlot = Map.GetAdjacentPlot(wonderX, wonderY, direction)
                if adjacentPlot and adjacentPlot:GetImprovementType() == improvementIndex then
                    print("Found " .. improvementType .. " adjacent to " .. wonderType)
                    return true
                end
            end
        end
    end

    print("No " .. improvementType .. " found adjacent to " .. wonderType)
    return false
end

local function GetDistrictLocations(iPlayer, districtType) -- UNUSED
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local districtLocations = {}
	local districtInfo = GameInfo.Districts[districtType]

	if not districtInfo then
		print("WARNING: District type " .. tostring(districtType) .. " not detected in game database!")
		return districtLocations
	end

	local districtIndex = districtInfo.Index

	for _, city in playerCities:Members() do
		local cityID = city:GetID()
		local districts = city:GetDistricts()
		if districts ~= nil then
			local districtX, districtY = districts:GetDistrictLocation(districtIndex)
			if districtX ~= nil and districtY ~= nil then
				if not districtLocations[cityID] then
					districtLocations[cityID] = {}
				end
				table.insert(districtLocations[cityID], {districtX, districtY})
			end
		end
	end

	return districtLocations
end

local function GetDistrictTypeCount(iPlayer, districtType)
	print("Checking for total number of "..tostring(districtType).." districts.")
	local player = Players[iPlayer]
	local playerCities = player:GetCities()
	local districtCount = 0

	if not GameInfo.Districts[districtType] then
		print("WARNING: District type "..tostring(districtType).." not detected in game database!")
		return districtCount
	end

	for _, city in playerCities:Members() do
		local districts = city:GetDistricts()
		if (districts ~= nil) then
			local hasDistrict = districts:HasDistrict(GameInfo.Districts[districtType].Index)
			if hasDistrict then
				districtCount = districtCount + 1
				print(tostring(districtType).." detected. Total count is "..tostring(districtCount))
			end
		else
			print("No districts detected in city!")
		end
	end

	return districtCount
end

local function GetNumCitiesWithinCapitalRange(playerID, range)
    local player = Players[playerID]
    local capitalCity = player:GetCities():GetCapitalCity()
    if not capitalCity then
        print("No capital city found for playerID:", playerID)
        return 0
    end

    local capitalX, capitalY = capitalCity:GetX(), capitalCity:GetY()
    local citiesInRangeCount = 0

    -- Iterate through all cities owned by the player
    for _, city in player:GetCities():Members() do
        -- Exclude the capital city from the count
        if city:GetID() ~= capitalCity:GetID() then
            local cityX, cityY = city:GetX(), city:GetY()
            local distance = Map.GetPlotDistance(capitalX, capitalY, cityX, cityY)
            
            -- Increment count if the city is within the specified range
            if distance <= range then
                citiesInRangeCount = citiesInRangeCount + 1
            end
        end
    end

    -- Return the count of cities within range, excluding the capital itself
    return citiesInRangeCount
end

local function GetPercentLandArea(playerID)
    local totalLandTiles = 0
    local playerLandTiles = 0

    -- Iterate through all the tiles on the map
    for iPlot = 0, Map.GetPlotCount() - 1 do
        local plot = Map.GetPlotByIndex(iPlot)
        if plot and not plot:IsWater() then -- Check if the tile is land
            totalLandTiles = totalLandTiles + 1
            if plot:IsOwned() and plot:GetOwner() == playerID then
                playerLandTiles = playerLandTiles + 1
            end
        end
    end

    if totalLandTiles == 0 then
        print("Error: No land tiles found on the map.")
        return 0
    else
        local ownershipPercentage = (playerLandTiles / totalLandTiles) * 100
        return ownershipPercentage
    end
end

local function GetPercentLandArea_ContinentType(playerID, continentName, percent) -- UNUSED
    print("Checking land area control for player " .. tostring(playerID) .. " on continent " .. continentName)
    local totalContinentPlots = 0
    local controlledPlots = 0
	local tContinents = Map.GetContinentsInUse()

	for i,iContinent in ipairs(tContinents) do
		if (GameInfo.Continents[iContinent].ContinentType == continentName) then
			print("Continent type is "..tostring(GameInfo.Continents[iContinent].ContinentType))
			local continentPlotIndexes = Map.GetContinentPlots(iContinent)
			for _, plotID in ipairs(continentPlotIndexes) do
				local continentPlot = Map.GetPlotByIndex(plotID)
				if continentPlot:IsOwned() and continentPlot:GetOwner() == playerID then
					controlledPlots = controlledPlots + 1
				end
				totalContinentPlots = totalContinentPlots + 1
			end
		end
	end

    if totalContinentPlots == 0 then
        print("No plots found for the specified continent.")
        return false
    end

    local controlledPercent = (controlledPlots / totalContinentPlots) * 100
    controlledPercent = math.floor(controlledPercent * 10 + 0.5) / 10 -- Round to one decimal place
    print("Player "..tostring(playerID).." controls " .. tostring(controlledPercent) .. " percent of the continent.")

    -- return controlledPercent >= percent
	return controlledPercent
end

local function GetPercentLandArea_HomeContinent(playerID, percent)
    local player = Players[playerID]
    local capital = player:GetCities():GetCapitalCity()

    if capital == nil then
        print("Player " .. tostring(playerID) .. " does not have a capital city.")
        return false
    end

    local capitalContinentID = capital:GetPlot():GetContinentType()
    local totalContinentPlots = 0
    local controlledPlots = 0

    local continentPlotIndexes = Map.GetContinentPlots(capitalContinentID)
    for _, plotID in ipairs(continentPlotIndexes) do
        local continentPlot = Map.GetPlotByIndex(plotID)
        if continentPlot:IsOwned() and continentPlot:GetOwner() == playerID then
            controlledPlots = controlledPlots + 1
        end
        totalContinentPlots = totalContinentPlots + 1
    end

    if totalContinentPlots == 0 then
        print("No plots found on the home continent for player " .. tostring(playerID))
        return false
    end

    local controlledPercent = (controlledPlots / totalContinentPlots) * 100
    controlledPercent = math.floor(controlledPercent * 10 + 0.5) / 10 -- Round to one decimal place
    print("Player " .. tostring(playerID) .. " controls " .. tostring(controlledPercent) .. "% of their home continent.")

    -- return controlledPercent >= percent
	return controlledPercent
end

local function GetCityCountPerContinent(playerID, requiredCityCount)
    local player = Players[playerID]
    local continentsWithCities = {} -- Track continents with enough cities for this player
    local continentCityCounts = {} -- Count cities per continent for this player
    local allContinents = Map.GetContinentsInUse() -- Get all continents in use
    local totalContinentCount = 0

    -- Initialize continent counts
    for _, continentID in ipairs(allContinents) do
        continentCityCounts[continentID] = 0
        totalContinentCount = totalContinentCount + 1
        print("Total Continents: ".. tostring(totalContinentCount))
    end

    -- Count cities per continent for the specified player
    local playerCities = player:GetCities()
    for _, city in playerCities:Members() do
        local plot = city:GetPlot()
        local continentID = plot:GetContinentType()
        if continentCityCounts[continentID] ~= nil then
            continentCityCounts[continentID] = continentCityCounts[continentID] + 1
            print("Total Cities on continent: ".. tostring(continentCityCounts[continentID]))
        end
    end

    -- Check continents meeting the required city count
    for continentID, count in pairs(continentCityCounts) do
        if count >= requiredCityCount then
            table.insert(continentsWithCities, continentID)
        end
    end

    -- Return the count of continents with the required number of cities and the total number of continents
    return #continentsWithCities, totalContinentCount
end

local function GetCitiesOnForeignContinents(playerID)
    local player = Players[playerID]
    local capital = player:GetCities():GetCapitalCity()
    local iX, iY = capital:GetX(), capital:GetY()
    local capitalContinentID = Map.GetPlot(iX, iY):GetContinentType()
    local foreignCityCount = 0

    for _, city in player:GetCities():Members() do
        if city:GetPlot():GetContinentType() ~= capitalContinentID then
            foreignCityCount = foreignCityCount + 1
        end
    end

    print("Player " .. tostring(playerID) .. " owns " .. tostring(foreignCityCount) .. " cities on foreign continents.")
    return foreignCityCount
end

-- Helper function to check if the civilization controls all plots of a named territory
local function ControlsTerritory(iPlayer, territoryType, minimumSize)
    print("Checking for " .. territoryType .. " territory...")
    local player = Players[iPlayer]
    local playerCities = player:GetCities()
    local territoryOwnership = false
    local territoryIDs = {}

    local function isTargetTerritoryType(plot)
        if territoryType == "SEA" then
            return plot:IsWater()
        elseif territoryType == "DESERT" then
            return ((plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_DESERT"].Index) or (plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_DESERT_HILLS"].Index))
        elseif territoryType == "MOUNTAIN" then
            return plot:IsMountain()
        end
        -- Add more conditions for other territory types
        return false
    end

    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(iPlayer, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                local iTerritory = false
                local territoryInstance = false

                if isTargetTerritoryType(plot) then
                    iTerritory = ExposedMembers.HSD_GetTerritoryID(kCoordinates.plotID)
                    if iTerritory then
                        territoryInstance = territoryCache[iTerritory]
                        if territoryInstance and (#territoryInstance.pPlots > minimumSize) and (not territoryIDs[iTerritory]) then
                            territoryIDs[iTerritory] = true
                            print("Adding territory #"..tostring(iTerritory).." to table.")
                        end
                    end
                end
            end
        end
    end

    for territoryID, _ in pairs(territoryIDs) do
        print("Territory ID is "..tostring(territoryID))
        local territoryPlots = territoryCache[territoryID].pPlots
        local ownershipCount = 0

        for _, iPlot in ipairs(territoryPlots) do
			local plot = Map.GetPlotByIndex(iPlot)
			local plotOwnerID = plot:GetOwner()
			-- print("iPlot is "..tostring(iPlot))
			-- print("plotOwnerID is "..tostring(plotOwnerID))
            if plotOwnerID == iPlayer then
                ownershipCount = ownershipCount + 1
            end
        end

        if ownershipCount == #territoryPlots then
            print(territoryType .. " territory controlled!")
            territoryOwnership = true
        end
    end

    return territoryOwnership
end

local function GetTerrainCounts(playerID, terrainType)
    local playerTerrainCount = 0
    local highestTerrainCount = 0

    local terrainIndex = GameInfo.Terrains[terrainType] and GameInfo.Terrains[terrainType].Index
    if not terrainIndex then
        print("Invalid terrain type: " .. tostring(terrainType))
        return 0, 0
    end

    -- Function to check if a plot has the specified terrain
    local function hasSpecifiedTerrain(plot)
        return plot:GetTerrainType() == terrainIndex
    end

    -- Check player's cities
    local playerCities = Players[playerID]:GetCities()
    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and hasSpecifiedTerrain(plot) then
                    playerTerrainCount = playerTerrainCount + 1
                end
            end
        end
    end

    -- Check other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayerCities = Players[otherPlayerID]:GetCities()
            local otherPlayerTerrainCount = 0
            for _, city in otherPlayerCities:Members() do
                local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(otherPlayerID, city:GetID())
                for _, kCityUIDatas in pairs(CityUIDataList) do
                    for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                        local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                        if plot and hasSpecifiedTerrain(plot) then
                            otherPlayerTerrainCount = otherPlayerTerrainCount + 1
                        end
                    end
                end
            end
            highestTerrainCount = math.max(highestTerrainCount, otherPlayerTerrainCount)
        end
    end

    return playerTerrainCount, highestTerrainCount
end

local function GetTerrainClassCounts(playerID, terrainClassType)
    local playerTerrainCount = 0
    local highestOtherPlayerTerrainCount = 0

    -- Retrieve all terrain types that belong to the specified terrain class
    local terrainTypes = {}
    for row in GameInfo.TerrainClass_Terrains() do
        if row.TerrainClassType == terrainClassType then
            local terrainIndex = GameInfo.Terrains[row.TerrainType].Index
            print("Terrain type: ".. tostring(row.TerrainType)..", index = "..tostring(terrainIndex))
            terrainTypes[terrainIndex] = true -- Store in a table as keys for quick lookup
        end
    end

    -- Check if any terrain type was found
    if next(terrainTypes) == nil then
        print("No terrains found for terrain class type: " .. tostring(terrainClassType))
        return 0, 0
    end

    local function countPlayerTerrains(player)
        local count = 0
        local playerCities = player:GetCities()
        for _, city in playerCities:Members() do
            local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(player:GetID(), city:GetID())
            for _, kCityUIDatas in pairs(CityUIDataList) do
                for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                    local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                    if plot and terrainTypes[plot:GetTerrainType()] then
                        count = count + 1
                    end
                end
            end
        end
        return count
    end

    -- Count terrains for the specified player
    local localPlayer = Players[playerID]
    playerTerrainCount = countPlayerTerrains(localPlayer)

    -- Count and find the maximum for other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayer = Players[otherPlayerID]
            local otherPlayerTerrainCount = countPlayerTerrains(otherPlayer)
            if otherPlayerTerrainCount > highestOtherPlayerTerrainCount then
                highestOtherPlayerTerrainCount = otherPlayerTerrainCount
            end
        end
    end

    return playerTerrainCount, highestOtherPlayerTerrainCount
end

local function GetArcticTerrainCounts(playerID)
    local playerTundraSnowCount = 0
    local highestOtherPlayerTundraSnowCount = 0
    local otherPlayersTundraSnowCounts = {}

    local function checkIfTundraOrSnow(plot)
        return plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_TUNDRA"].Index or 
               plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_TUNDRA_HILLS"].Index or 
               plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_TUNDRA_MOUNTAIN"].Index or
               plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_SNOW"].Index or 
               plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_SNOW_HILLS"].Index or 
               plot:GetTerrainType() == GameInfo.Terrains["TERRAIN_SNOW_MOUNTAIN"].Index
    end

    local playerCities = Players[playerID]:GetCities()
    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and checkIfTundraOrSnow(plot) then
                    playerTundraSnowCount = playerTundraSnowCount + 1
                end
            end
        end
    end

    -- Checking for other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayerCities = Players[otherPlayerID]:GetCities()
            local otherPlayerTundraSnowCount = 0
            for _, city in otherPlayerCities:Members() do
                local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(otherPlayerID, city:GetID())
                for _, kCityUIDatas in pairs(CityUIDataList) do
                    for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                        local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                        if plot and checkIfTundraOrSnow(plot) then
                            otherPlayerTundraSnowCount = otherPlayerTundraSnowCount + 1
                        end
                    end
                end
            end
            otherPlayersTundraSnowCounts[otherPlayerID] = otherPlayerTundraSnowCount
            highestOtherPlayerTundraSnowCount = math.max(highestOtherPlayerTundraSnowCount, otherPlayerTundraSnowCount)
        end
    end

    return playerTundraSnowCount, highestOtherPlayerTundraSnowCount
end

local function GetHillsCount(playerID)
    local playerHillsCount = 0
    local highestOtherPlayerHillsCount = 0

    local function checkIfHills(plot)
        return plot:IsHills()
    end

    local playerCities = Players[playerID]:GetCities()
    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and checkIfHills(plot) then
                    playerHillsCount = playerHillsCount + 1
                end
            end
        end
    end

    -- Checking for other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayerCities = Players[otherPlayerID]:GetCities()
            local otherPlayerHillsCount = 0
            for _, city in otherPlayerCities:Members() do
                local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(otherPlayerID, city:GetID())
                for _, kCityUIDatas in pairs(CityUIDataList) do
                    for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                        local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                        if plot and checkIfHills(plot) then
                            otherPlayerHillsCount = otherPlayerHillsCount + 1
                        end
                    end
                end
            end
            highestOtherPlayerHillsCount = math.max(highestOtherPlayerHillsCount, otherPlayerHillsCount)
        end
    end

    return playerHillsCount, highestOtherPlayerHillsCount
end

local function HasMoreTechsThanContinentMinimum(playerID, continentName)
    local player = Players[playerID]
    local playerTechs = player:GetTechs()
    local playerTechCount = playerTechs:GetNumTechsResearched()
	local continentTechMinimum = 0

    -- Find players on the specified continent
    local playersOnContinent = {}
    for _, otherPlayer in ipairs(PlayerManager.GetAlive()) do
		if otherPlayer:GetCities():GetCount() > 0 then
			for _, city in otherPlayer:GetCities():Members() do
				if city:GetPlot():GetContinentType() == GameInfo.Continents[continentName].Index then
					table.insert(playersOnContinent, otherPlayer)
					break -- Found a city on the continent, no need to check other cities of this player
				end
			end
		end
    end

    -- Compare tech counts
    for _, otherPlayer in ipairs(playersOnContinent) do
        if otherPlayer:GetID() ~= playerID then
            local otherPlayerTechs = otherPlayer:GetTechs()
            local otherPlayerTechCount = otherPlayerTechs:GetNumTechsResearched()
			if continentTechMinimum == 0 then
				-- Set initial tech count for continent
				continentTechMinimum = otherPlayerTechCount
			end
			if otherPlayerTechCount < continentTechMinimum then
				-- Set lowest tech count for continent
				continentTechMinimum = otherPlayerTechCount
			end
        end
    end

    return playerTechCount, continentTechMinimum
end

local function GetOutgoingRoutesCount(playerID)
    local highestTradeRouteCount = 0

    -- Count outgoing trade routes for the player
    local playerOutgoingRoutes = Players[playerID]:GetTrade():CountOutgoingRoutes()
    print("playerOutgoingRoutes = "..tostring(playerOutgoingRoutes))

    -- Get highest outgoing route count among all other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        if otherPlayerID ~= playerID then
            if IsHistoricalVictoryPlayer(otherPlayerID) and HasPlayerSpawned(otherPlayerID) then
                local otherPlayerOutgoingRoutes = Players[otherPlayerID]:GetTrade():CountOutgoingRoutes()
                if otherPlayerOutgoingRoutes > highestTradeRouteCount then
                    highestTradeRouteCount = otherPlayerOutgoingRoutes
                end
            end

        end
    end

    return playerOutgoingRoutes, highestTradeRouteCount
end

local function GetTradeRoutesCount(playerID)
    local highestTradeRouteCount = 0

    -- Count total number of routes for the player
    local playerOutgoingRoutes = Players[playerID]:GetTrade():CountOutgoingRoutes()
    print("playerOutgoingRoutes = "..tostring(playerOutgoingRoutes))
    local playerIncomingRoutes = ExposedMembers.HSD_GetTotalIncomingRoutes(playerID)
    print("playerIncomingRoutes = "..tostring(playerIncomingRoutes))
    local playerTradeRoutes = playerOutgoingRoutes + playerIncomingRoutes

    -- Get highest route count among all other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        if otherPlayerID ~= playerID then
            if IsHistoricalVictoryPlayer(otherPlayerID) and HasPlayerSpawned(otherPlayerID) then
                local otherPlayerOutgoingRoutes = Players[otherPlayerID]:GetTrade():CountOutgoingRoutes()
                local otherplayerIncomingRoutes = ExposedMembers.HSD_GetTotalIncomingRoutes(otherPlayerID)
                local otherPlayerTradeRoutes = otherPlayerOutgoingRoutes + otherplayerIncomingRoutes
                if otherPlayerTradeRoutes > highestTradeRouteCount then
                    highestTradeRouteCount = otherPlayerTradeRoutes
                end
            end

        end
    end

    return playerTradeRoutes, highestTradeRouteCount
end

local function GetCitiesWithTradingPosts(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local citiesWithTradingPosts = 0
    local totalCities = 0

    for _, city in playerCities:Members() do
        totalCities = totalCities + 1
        local hasTradingPost = ExposedMembers.HSD_GetTradingPost(city, playerID)
        if hasTradingPost then
            citiesWithTradingPosts = citiesWithTradingPosts + 1
        end
    end

    return citiesWithTradingPosts, totalCities
end

local function HasTradeRouteWithEveryPlayerOnContinent(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local playerContinent = nil
    local playersOnContinent = {}
    local continentPlayersWithTradingPost = 0
    
    -- Determine the player's home continent by checking their capital city's continent
    local capitalCity = playerCities:GetCapitalCity()
    if capitalCity then
        local capitalX, capitalY = capitalCity:GetX(), capitalCity:GetY()
        local capitalPlot = Map.GetPlot(capitalX, capitalY)
        playerContinent = capitalCity:GetPlot():GetContinentType()
    end
    
    -- If the player's capital city's continent is not found, return counts as zero
    if not playerContinent then
        print("No home continent found for the player.")
        return 0, 0
    end
    
    -- Track all players with cities on the player's home continent
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        if (otherPlayerID ~= playerID) and (not otherPlayer:IsBarbarian()) and (not IsFreeCityPlayer(otherPlayer)) then
            local otherPlayerCities = Players[otherPlayerID]:GetCities()
            for _, city in otherPlayerCities:Members() do
                if city:GetContinentType() == playerContinent then
                    if not playersOnContinent[otherPlayerID] then
                        playersOnContinent[otherPlayerID] = true
                    end
                    local hasTradingPost = ExposedMembers.HSD_GetTradingPostFromPlayer(otherplayerID, playerID)
                    if hasTradingPost then
                        continentPlayersWithTradingPost = continentPlayersWithTradingPost + 1
                        break -- Found a trading post in this city, no need to check more of their cities
                    end
                end
            end
        end
    end

    local totalPlayersOnContinent = 0
    for _ in pairs(playersOnContinent) do
        totalPlayersOnContinent = totalPlayersOnContinent + 1
    end
    
    return continentPlayersWithTradingPost, totalPlayersOnContinent
end

local function HasUnlockedAllCivicsForEra(playerID, eraType)
    local player = Players[playerID]
    local playerCulture = player:GetCulture()

    -- Loop through all civics and check if each civic in the specified era is unlocked
    for civic in GameInfo.Civics() do
        if civic.EraType == eraType then
            if not playerCulture:HasCivic(civic.Index) then
                -- If even one civic in the era is not unlocked, return false
                return false
            end
        end
    end

    -- All civics in the era are unlocked
    return true
end

local function GetHighestProduction(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local totalProduction = 0
    local highestOtherPlayerProduction = 0

    -- Calculate total production for the specified player
    for _, city in playerCities:Members() do
        local productionYield = city:GetYield(YieldTypes.PRODUCTION)
        totalProduction = totalProduction + productionYield
    end

    -- Compare against production of all other players
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayer = Players[otherPlayerID]
            local otherPlayerTotalProduction = 0

            for _, city in otherPlayer:GetCities():Members() do
                local productionYield = city:GetYield(YieldTypes.PRODUCTION)
                otherPlayerTotalProduction = otherPlayerTotalProduction + productionYield
            end

            if otherPlayerTotalProduction > highestOtherPlayerProduction then
                highestOtherPlayerProduction = otherPlayerTotalProduction
            end
        end
    end

    print("Total Production for PlayerID " .. tostring(playerID) .. ": " .. tostring(totalProduction))
    print("Highest Production among other players: " .. tostring(highestOtherPlayerProduction))

    return totalProduction, highestOtherPlayerProduction
end


local function GetHighestFaithPerTurn(playerID)
    -- Get player faith per turn
    local player = Players[playerID]
    local playerFaithPerTurn = player:GetReligion():GetFaithYield()
    print("playerFaithPerTurn is "..tostring(playerFaithPerTurn))

    -- Get highest faith per turn count of all other players
    local highestFaithPerTurn = 0
    local allPlayerIDs = PlayerManager.GetAliveMajorIDs()  -- Using GetAliveMajorIDs to exclude city-states and other non-major civs
    for _, otherPlayerID in ipairs(allPlayerIDs) do
        if otherPlayerID ~= playerID then
            local otherPlayer = Players[otherPlayerID]
            local otherFaithPerTurn = otherPlayer:GetReligion():GetFaithYield()
            if otherFaithPerTurn > highestFaithPerTurn then
                highestFaithPerTurn = otherFaithPerTurn
            end
        end
    end
    print("highestFaithPerTurn is "..tostring(highestFaithPerTurn))

    return playerFaithPerTurn, highestFaithPerTurn
end


local function GetPlayerGold(playerID)
    local player = Players[playerID]
    if player then
        local playerTreasury = player:GetTreasury()
        local goldAmount = playerTreasury:GetGoldBalance()
        return goldAmount
    else
        print("Invalid player ID: " .. tostring(playerID))
        return 0
    end
end

local function GetHighestGoldPerTurn(playerID)
    local playerTreasury = Players[playerID]:GetTreasury()
    local playerGPT = playerTreasury:GetGoldYield() - playerTreasury:GetTotalMaintenance()

    local highestOtherGPT = 0
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherplayerTreasury = Players[otherPlayerID]:GetTreasury()
            local otherPlayerGPT = otherplayerTreasury:GetGoldYield() - otherplayerTreasury:GetTotalMaintenance()

            if otherPlayerGPT > highestOtherGPT then
                highestOtherGPT = otherPlayerGPT
            end
        end
    end

    return playerGPT, highestOtherGPT
end

local function GetHighestCityPopulation(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local highestPopulation = 0
	local playerHighestPopulation = 0

    -- Get highest population of all cities
    for _, otherPlayer in ipairs(PlayerManager.GetAlive()) do
		if playerCities:GetCount() > 0 then
			for _, city in otherPlayer:GetCities():Members() do
				highestPopulation = math.max(highestPopulation, city:GetPopulation())
			end
		end
    end

    -- Get highest population of player cities
    for _, city in playerCities:Members() do
		if city:GetPopulation() > playerHighestPopulation then
			playerHighestPopulation = city:GetPopulation()
		end
    end

    return playerHighestPopulation, highestPopulation
end

local function GetHighestCulture(playerID)
    local playerCulture, highestCulture = ExposedMembers.HSD_GetCultureCounts(playerID)
    return playerCulture, highestCulture
end

local function GetPlayerTechCounts(playerID)
    local playerTechCount, highestTechCount = ExposedMembers.HSD_GetNumTechsResearched(playerID)
    return playerTechCount, highestTechCount
end

local function GetTourismCounts(playerID)
    local playerTourismCount, highestTourismCount = ExposedMembers.HSD_GetTourismCounts(playerID)
    return playerTourismCount, highestTourismCount
end

local function IsBuildingInCapital(playerID, buildingType)
    local player = Players[playerID]
    if not player then
        print("Player not found for playerID:", playerID)
        return false
    end

    local capital = player:GetCities():GetCapitalCity()
    if not capital then
        print("Capital city not found for playerID:", playerID)
        return false
    end

    if not GameInfo.Buildings[buildingType] then
        print("Building type not found:", buildingType)
        return false
    end

    local buildingIndex = GameInfo.Buildings[buildingType].Index
    return capital:GetBuildings():HasBuilding(buildingIndex)
end

local function GetHappiness(playerID)
    local player = Players[playerID]
    local ecstaticCitiesCount = 0
    local totalCitiesCount = 0
    local playerCities = player:GetCities()
    for _, city in playerCities:Members() do
        local happinessIndex = city:GetGrowth():GetHappiness()
        if GameInfo.Happinesses[happinessIndex].HappinessType == "HAPPINESS_ECSTATIC" then
            ecstaticCitiesCount = ecstaticCitiesCount + 1
        end
        totalCitiesCount = totalCitiesCount + 1
    end
    return ecstaticCitiesCount, totalCitiesCount
end

local function GetCitiesOnHomeContinent(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local homeContinent = nil
    local playerCityCount = 0
    local otherCityCount = 0

    -- Determine the player's home continent from their capital city
    local capitalCity = playerCities:GetCapitalCity()
    if capitalCity then
        homeContinent = capitalCity:GetPlot():GetContinentType()
    end

    -- Iterate through all cities to count those on the home continent
    for _, otherPlayer in ipairs(PlayerManager.GetAlive()) do
        for _, city in otherPlayer:GetCities():Members() do
            if city:GetPlot():GetContinentType() == homeContinent then
                if city:GetOwner() == playerID then
                    playerCityCount = playerCityCount + 1
                else
                    otherCityCount = otherCityCount + 1
                end
            end
        end
    end

    return playerCityCount, otherCityCount
end

local function GetCoastalCityCount(playerID)
    local player = Players[playerID]
    if not player then
        print("Player not found for playerID:", playerID)
        return 0
    end

    local playerCities = player:GetCities()
    local coastalCityCount = 0

    for _, city in playerCities:Members() do
        local cityPlot = Map.GetPlot(city:GetX(), city:GetY())

        -- Check adjacent plots for water
        for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
            local adjacentPlot = Map.GetAdjacentPlot(cityPlot:GetX(), cityPlot:GetY(), direction)
            if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
                coastalCityCount = coastalCityCount + 1
                break -- Found a water tile that is not a lake, no need to check other adjacent plots
            end
        end
    end

    return coastalCityCount
end

local function GetResourcePercentage(playerID, resourceType)
    local totalResourceCount = 0
    local playerResourceCount = 0
    local player = Players[playerID]

    -- Retrieve the resource data from the game property cache
    local resourceData = Game:GetProperty("HSD_ResourceData") or {}
    local resourcePlots = resourceData[resourceType]

    if not resourcePlots or #resourcePlots == 0 then
        print("No tiles found with resource " .. resourceType)
        return 0
    end

    -- Get the list of valid improvements for the resource
    local validImprovements = {}
    for row in GameInfo.Improvement_ValidResources() do
        if row.ResourceType == resourceType then
            table.insert(validImprovements, row.ImprovementType)
        end
    end

    -- Iterate through the plots of the specific resource
    for _, plotIndex in ipairs(resourcePlots) do
        local plot = Map.GetPlotByIndex(plotIndex)
        if plot then
            totalResourceCount = totalResourceCount + 1
            if plot:IsOwned() and plot:GetOwner() == playerID then
                -- Check if the plot has a valid improvement
                local improvementType = plot:GetImprovementType()
                local improvementInfo = GameInfo.Improvements[improvementType]
                if improvementInfo and tableContains(validImprovements, improvementInfo.ImprovementType) then
                    playerResourceCount = playerResourceCount + 1
                end
            end
        end
    end

    if totalResourceCount == 0 then
        print("No tiles found with resource " .. resourceType)
        return 0
    end

    local playerPercentage = (playerResourceCount / totalResourceCount) * 100
    return playerPercentage
end

local function GetPlayerFeaturePlotCount(playerID, featureType)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local featurePlotCount = 0

    -- Check if the feature type exists in the GameInfo table
    if not GameInfo.Features[featureType] then
        print("Feature type " .. tostring(featureType) .. " not found in GameInfo.")
        return featurePlotCount
    end

    local featureIndex = GameInfo.Features[featureType].Index

    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot:GetFeatureType() == featureIndex then
                    featurePlotCount = featurePlotCount + 1
                end
            end
        end
    end

    return featurePlotCount
end

local function GetNaturalWonderCount(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local controlledNaturalWonders = {}

    for _, city in playerCities:Members() do
        local CityUIDataList = ExposedMembers.GetPlayerCityUIDatas(playerID, city:GetID())
        for _, kCityUIDatas in pairs(CityUIDataList) do
            for _, kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
                local plot = Map.GetPlotByIndex(kCoordinates.plotID)
                if plot and plot:IsNaturalWonder() then
                    local featureType = plot:GetFeatureType()
                    controlledNaturalWonders[featureType] = true
                end
            end
        end
    end

    local count = 0
    for _ in pairs(controlledNaturalWonders) do count = count + 1 end

    return count
end

-- Helper function to get the alliance count of a specific player
local function GetAllianceCount(playerID)
    local playerDiplomacy = Players[playerID]:GetDiplomacy()
    local allianceCount = 0

    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            if playerDiplomacy:HasAlliance(otherPlayerID) then
                allianceCount = allianceCount + 1
            end
        end
    end

    return allianceCount
end

local function GetAllianceCount_AllPlayers(targetAllianceCount)
    -- Check if the game property is already set
    if Game:GetProperty("HSD_"..tostring(targetAllianceCount).."_ACTIVE_ALLIANCES") then
        return Game:GetProperty("HSD_"..tostring(targetAllianceCount).."_ACTIVE_ALLIANCES") -- End the function if the property is already set
    end

    -- Iterate through all alive major players
    for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local allianceCount = GetAllianceCount(playerID)

        -- Check if the player has reached the target alliance count
        if allianceCount >= targetAllianceCount then
            -- Set the game property with this player's ID
            Game:SetProperty("HSD_"..tostring(targetAllianceCount).."_ACTIVE_ALLIANCES", playerID)
            return Game:GetProperty("HSD_"..tostring(targetAllianceCount).."_ACTIVE_ALLIANCES") -- Exit the loop as we found the first player to reach the target
        end
    end
end

local function GetAllianceLevelCount(playerID)
    local playerDiplomacy = Players[playerID]:GetDiplomacy()
    local allianceCount = 0
    local maximumAllianceLevel = 3

    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            if playerDiplomacy:HasAlliance(otherPlayerID) then
                local allianceLevel = playerDiplomacy:GetAllianceLevel()
                print("Alliance level is "..tostring(allianceLevel))
                if allianceLevel == maximumAllianceLevel then
                    allianceCount = allianceCount + 1
                end
            end
        end
    end

    return allianceCount
end

local function GetDeclaredFriendsCount(playerID)
    local player = Players[playerID]
    local playerDiplomacy = player:GetDiplomacy()
    local playerFriendsCount = 0
    local highestOtherPlayerFriendsCount = 0

    -- Function to count the number of declared friends for a given player
    local function countDeclaredFriends(player)
        local friendsCount = 0
        for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
            if otherPlayerID ~= player:GetID() then
                if player:GetDiplomacy():HasDeclaredFriendship(otherPlayerID) then
                    friendsCount = friendsCount + 1
                end
            end
        end
        return friendsCount
    end

    -- Count the number of declared friends for the specified player
    playerFriendsCount = countDeclaredFriends(player)

    -- Count the number of declared friends for each other player and find the maximum
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayer = Players[otherPlayerID]
            local otherPlayerFriendsCount = countDeclaredFriends(otherPlayer)
            if otherPlayerFriendsCount > highestOtherPlayerFriendsCount then
                highestOtherPlayerFriendsCount = otherPlayerFriendsCount
            end
        end
    end

    return playerFriendsCount, highestOtherPlayerFriendsCount
end

local function GetCitiesInRange_Building(playerID, buildingID, range)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local buildingIndex = GameInfo.Buildings[buildingID].Index
    local citiesInRangeCount = 0

    -- Iterate through player's cities to find the city with the specified building
    for _, city in playerCities:Members() do
        if city:GetBuildings():HasBuilding(buildingIndex) then
            local buildingPlotIndex = city:GetBuildings():GetBuildingLocation(buildingIndex)
            local buildingPlot = Map.GetPlotByIndex(buildingPlotIndex)
            -- Get the building's plot coordinates
            if buildingPlot then
                local buildingX, buildingY = buildingPlot:GetX(), buildingPlot:GetY()
                citiesInRangeCount = CountCitiesInRange(buildingX, buildingY, range, playerID)
            end
        end
    end

    return citiesInRangeCount
end

local function GetReligiousCitiesCount(playerID)
    local player = Players[playerID]
    local playerReligionID = player:GetReligion():GetReligionTypeCreated()
    local playerReligiousCitiesCount = 0
    local otherReligionsCitiesCounts = {}
    print("playerReligionID is "..tostring(playerReligionID))

    -- Iterate through all cities on the map
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        for _, city in otherPlayer:GetCities():Members() do
            local cityReligion = city:GetReligion()
            local majorityReligion = cityReligion:GetMajorityReligion()
            print("majorityReligion is "..tostring(majorityReligion))
            -- Count cities for player's religion
            if majorityReligion == playerReligionID then
                playerReligiousCitiesCount = playerReligiousCitiesCount + 1
            elseif majorityReligion > 0 then
                -- Increment count for other religions
                if not otherReligionsCitiesCounts[majorityReligion] then
                    otherReligionsCitiesCounts[majorityReligion] = 1
                else
                    otherReligionsCitiesCounts[majorityReligion] = otherReligionsCitiesCounts[majorityReligion] + 1
                end
            end
        end
    end

    -- Find the highest number of cities converted by any single other religion
    local highestOtherReligionCitiesCount = 0
    for _, count in pairs(otherReligionsCitiesCounts) do
        if count > highestOtherReligionCitiesCount then
            highestOtherReligionCitiesCount = count
        end
    end

    return playerReligiousCitiesCount, highestOtherReligionCitiesCount
end

local function GetContinentsWithMajorityReligion(playerID)
    local player = Players[playerID]
    local playerReligionID = player:GetReligion():GetReligionTypeCreated()
    print("playerReligionID is "..tostring(playerReligionID))
    if playerReligionID == -1 then
        print("Player " .. tostring(playerID) .. " does not have a majority religion.")
        return 0
    end
    local continentsWithMajorityReligion = {}
    local continentReligionCounts = {}

    -- Iterate through all cities on the map
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        for _, city in otherPlayer:GetCities():Members() do
            local cityReligion = city:GetReligion()
            local majorityReligion = cityReligion:GetMajorityReligion()
            local cityPlot = city:GetPlot()
            local continentType = cityPlot:GetContinentType()

            -- Initialize continent religion count table
            if not continentReligionCounts[continentType] then
                continentReligionCounts[continentType] = {}
            end

            -- Initialize religion count for the continent
            if not continentReligionCounts[continentType][majorityReligion] then
                continentReligionCounts[continentType][majorityReligion] = 1
            else
                continentReligionCounts[continentType][majorityReligion] = continentReligionCounts[continentType][majorityReligion] + 1
            end
        end
    end

    -- Determine continents where player's religion is majority
    for continent, religions in pairs(continentReligionCounts) do
        local maxReligionCount = 0
        local maxReligion = nil
        for religion, count in pairs(religions) do
            if count > maxReligionCount then
                maxReligionCount = count
                maxReligion = religion
            end
        end
        if maxReligion == playerReligionID then
            table.insert(continentsWithMajorityReligion, continent)
        end
    end

    return #continentsWithMajorityReligion
end

local function GetCitiesFollowingReligion(playerID)
    local player = Players[playerID]
    local religionID = player:GetReligion():GetReligionTypeCreated()
    print("religionID is "..tostring(religionID))
    if religionID == -1 then
        print("Player " .. tostring(playerID) .. " does not have a majority religion.")
    end
    
    local citiesFollowingReligion = 0
    local totalCities = 0

    -- Iterate through player cities
    for _, city in player:GetCities():Members() do
        totalCities = totalCities + 1
        local cityReligion = city:GetReligion():GetMajorityReligion()

        -- Check if the city's majority religion matches the player's majority religion
        if cityReligion == religionID then
            citiesFollowingReligion = citiesFollowingReligion + 1
        end
    end

    return citiesFollowingReligion, totalCities
end

local function GetCitiesOnHomeContinentFollowingReligion(playerID)
    local player = Players[playerID]
    local playerReligionID = player:GetReligion():GetReligionTypeCreated()
    local playerCities = player:GetCities()
    local playerContinent = false

    -- Determine the player's home continent by checking their capital city's continent
    local capitalCity = playerCities:GetCapitalCity()
    if capitalCity then
        local cityPlot = capitalCity:GetPlot()
        playerContinent = cityPlot:GetContinentType()
    end

    -- If the player's capital city's continent is not found, return 0
    if not playerContinent then
        print("No home continent found for the player.")
        return 0, 0
    end

    local religiousCitiesCount = 0
    local nonReligiousCitiesCount = 0

    -- Iterate through all cities on the map
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        for _, city in otherPlayer:GetCities():Members() do
            local cityPlot = city:GetPlot()
            if cityPlot:GetContinentType() == playerContinent then
                local cityReligion = city:GetReligion()
                local majorityReligion = cityReligion:GetMajorityReligion()
                -- print("Majority religion is "..tostring(majorityReligion))
                if (playerReligionID ~= -1) and (majorityReligion == playerReligionID) then
                    religiousCitiesCount = religiousCitiesCount + 1
                else
                    nonReligiousCitiesCount = nonReligiousCitiesCount + 1
                end
            end
        end
    end

    return religiousCitiesCount, nonReligiousCitiesCount
end

local function GetGoldenAgeCount(playerID)
    local player = Players[playerID]
    local gameEraIndex = Game.GetEras():GetCurrentEra()
    print("Current era is "..tostring(gameEraIndex))
    local eraKey = "HSD_GOLDEN_AGE_ERA_" .. tostring(gameEraIndex)
    local goldenAge = ExposedMembers.HSD_GetGoldenAge(playerID)
    print("goldenAge is "..tostring(goldenAge))
    if goldenAge and (not player:GetProperty(eraKey)) then
        player:SetProperty(eraKey, true)
    end
    local totalGoldenAges = 0
    for eraIndex = 0, gameEraIndex do
        local eraPropertyKey = "HSD_GOLDEN_AGE_ERA_" .. tostring(eraIndex)
        if player:GetProperty(eraPropertyKey) then
            totalGoldenAges = totalGoldenAges + 1
        end
    end
    print("Total golden ages up to current era: " .. tostring(totalGoldenAges))
    return totalGoldenAges
end

-- ===========================================================================
-- EVENT HOOKS
-- ===========================================================================

local function HSD_OnBeliefAdded(playerID, beliefID)
    local player = Players[playerID]
    local beliefInfo = GameInfo.Beliefs[beliefID]
    local beliefKey = "HSD_" .. tostring(beliefInfo.BeliefType)
    if not Game:GetProperty(beliefKey) then
        Game:SetProperty(beliefKey, playerID)
        print("Recorded " .. beliefInfo.BeliefType .. " as first completed by player " .. tostring(playerID))
    end

    -- Record the number of beliefs in the player's religion
    local numBeliefs = ExposedMembers.HSD_GetNumBeliefs(playerID)
    local beliefCountKey = "HSD_TOTAL_BELIEFS_" .. tostring(playerID)
    Game:SetProperty(beliefCountKey, numBeliefs)
    print("Total beliefs for player " .. tostring(playerID) .. ": " .. tostring(numBeliefs))

    -- Record the first player to receive 2 beliefs
    if (numBeliefs >= 2) and (not Game:GetProperty("HSD_FIRST_2_BELIEFS")) then
        Game:SetProperty("HSD_FIRST_2_BELIEFS", playerID)
        print("Recorded first player to receive 2 beliefs as player #"..tostring(playerID))
    end
    -- Record the first player to receive 3 beliefs
    if (numBeliefs >= 3) and (not Game:GetProperty("HSD_FIRST_3_BELIEFS")) then
        Game:SetProperty("HSD_FIRST_3_BELIEFS", playerID)
        print("Recorded first player to receive 3 beliefs as player #"..tostring(playerID))
    end
    -- Record the first player to receive 4 beliefs
    if (numBeliefs >= 4) and (not Game:GetProperty("HSD_FIRST_4_BELIEFS")) then
        Game:SetProperty("HSD_FIRST_4_BELIEFS", playerID)
        print("Recorded first player to receive 4 beliefs as player #"..tostring(playerID))
    end
end

local function HSD_OnBuildingConstructed(playerID, cityID, buildingID, plotID, bOriginalConstruction)
    local buildingInfo = GameInfo.Buildings[buildingID]
    local buildingKey = "HSD_" .. tostring(buildingInfo.BuildingType)
    if not Game:GetProperty(buildingKey) then
        Game:SetProperty(buildingKey, playerID)
        print("Recorded " .. buildingInfo.BuildingType .. " as first completed by player " .. tostring(playerID))

        -- Check if the building completion is part of any active victory conditions
        local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
        local conditionsForPlayer = victoryConditions[playerID] or {}
        for _, victoryCondition in ipairs(conditionsForPlayer) do
            for _, objective in ipairs(victoryCondition.objectives) do
                if (objective.type == "FIRST_BUILDING_CONSTRUCTED") and (objective.id == buildingInfo.BuildingType) then
                    local iX, iY = Map.GetPlotByIndex(plotID):GetX(), Map.GetPlotByIndex(plotID):GetY()
                    -- Display in-game popup text
                    local message = Locale.Lookup("LOC_HSD_BUILDING_CONSTRUCTED_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(buildingInfo.Name))
                    Game.AddWorldViewText(0, message, iX, iY)
                    break
                end
            end
        end
    end
end

local function HSD_OnCityConquered(capturerID, ownerID, cityID, cityX, cityY)
    print("HSD_OnCityConquered detected")
    local player = Players[capturerID]
    local countedUnitTypes = {}

    local function IsMilitaryUnit(unit)
        local unitType = unit:GetType()
        local unitInfo = GameInfo.Units[unitType]
        return (unitInfo.FormationClass == "FORMATION_CLASS_LAND_COMBAT") or (unitInfo.FormationClass == "FORMATION_CLASS_NAVAL")
    end

    local function ProcessUnit(unit)
        if unit and unit:GetOwner() == capturerID and IsMilitaryUnit(unit) then
            local unitTypeName = GameInfo.Units[unit:GetType()].UnitType
            if not countedUnitTypes[unitTypeName] then
                local unitKey = "HSD_"..tostring(unitTypeName).."_CONQUER_COUNT"
                local conquerCount = player:GetProperty(unitKey) or 0
                conquerCount = conquerCount + 1
                player:SetProperty(unitKey, conquerCount)
                countedUnitTypes[unitTypeName] = true
            end
        end
    end

    local function GetPlotUnits(unitPlot)
        if unitPlot and unitPlot:GetUnitCount() > 0 then
            for _, unit in ipairs(Units.GetUnitsInPlot(unitPlot)) do
                ProcessUnit(unit)
            end
        end
    end

    GetPlotUnits(Map.GetPlot(cityX, cityY)) -- Process units on the city plot

    -- Check adjacent plots
    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(cityX, cityY, direction)
        if adjacentPlot then
            GetPlotUnits(adjacentPlot)
        end
    end
end

local function HSD_OnCivicCompleted(ePlayer, eCivic)
    -- print("ePlayer = " .. tostring(ePlayer) .. ", eCivic = " .. tostring(eCivic))
    local player = Players[ePlayer]

    if player then
        local playerCitiesCount = player:GetCities():GetCount()
        if playerCitiesCount >= 1 then
            local civicInfo = GameInfo.Civics[eCivic]
            if civicInfo then
                local civicKey = "HSD_" .. tostring(civicInfo.CivicType)
                if not Game:GetProperty(civicKey) then
                    Game:SetProperty(civicKey, ePlayer)
                    print("Recorded " .. civicKey .. " as first completed by player " .. tostring(ePlayer))
                else
                    -- print("Civic " .. civicKey .. " already recorded for another player.")
                end
            else
                print("Error: Civic information not found for eCivic = " .. tostring(eCivic))
            end
        else
            print("Player " .. tostring(ePlayer) .. " does not have any cities, ignoring civic completion.")
        end
    else
        print("Error: Player not found for ePlayer = " .. tostring(ePlayer))
    end
end

local function HSD_OnCityConvertedLoyalty(playerID, cityID, oldOwnerID)
    local playerKey = "HSD_LOYALTY_CONVERT_CITY_COUNT_" .. tostring(playerID)
    local cityConversionCount = Game:GetProperty(playerKey) or 0
    Game:SetProperty(playerKey, cityConversionCount + 1)
    print("Recorded ".. playerKey.. " as city conversion count for player ".. tostring(playerID).. " = ".. tostring(Game:GetProperty(playerKey)))
end

local function HSD_OnCityPopulationChanged(playerID, cityID, cityPopulation)
    local player = Players[playerID]
    local populationKey = "HSD_CITY_POPULATION_SIZE_" .. tostring(cityPopulation)
    if not Game:GetProperty(populationKey) then
        Game:SetProperty(populationKey, playerID)
        print("Player #" .. tostring(playerID).." recorded as first player with a city of size " .. tostring(cityPopulation))
    end
end

local function HSD_OnGameHistoryMoment(momentIndex, MomentHash)
    -- print("MomentID = " .. tostring(momentIndex) .. ", MomentHash = " .. tostring(MomentHash))
    local interestLevel = GameInfo.Moments[MomentHash].InterestLevel
    local momentType = GameInfo.Moments[MomentHash].MomentType
    -- print("momentType = " .. tostring(momentType))
	local momentTypeKey = "HSD_"..tostring(momentType)
    local momentCountKey = "HSD_"..tostring(momentType).."_COUNT"
    local momentData = ExposedMembers.HSD_GetMomentData(momentIndex)
    -- print("momentData.Type = " .. tostring(momentData.Type) .. ", momentData.Turn = " .. tostring(momentData.Turn) .. ", momentData.GameEra = " .. tostring(momentData.GameEra))
    -- local momentDate = Calendar.MakeYearStr(momentData.Turn)
    -- print("momentDate = " .. tostring(momentDate))
    -- local firstMoment = momentData.HasEverBeenCommemorated
    -- print("firstMoment = " .. tostring(firstMoment))
	local momentPlayerID = momentData.ActingPlayer
    local player = Players[momentPlayerID]

	-- Record every moment
	if not Game:GetProperty(momentTypeKey) then
		Game:SetProperty(momentTypeKey, momentPlayerID)
		print("Set property " .. momentTypeKey .. " for player " .. tostring(momentPlayerID))
	end

    -- Record number of times a player activated a moment
    local momentCount = player:GetProperty(momentCountKey) or 0
    player:SetProperty(momentCountKey, momentCount + 1)
end

local function HSD_OnGovernmentChanged(playerID, governmentID)
    local governmentInfo = GameInfo.Governments[governmentID]
    local governmentKey = "HSD_" .. tostring(governmentInfo.GovernmentType)
    -- Record first player to adopt government of this type
    if not Game:GetProperty(governmentKey) then
        Game:SetProperty(governmentKey, playerID)
        print("Recorded first adoption of government type " .. governmentInfo.GovernmentType .. " by player " .. tostring(playerID))
    else
        -- print(governmentInfo.GovernmentType .. " has already been adopted by another player.")
    end
    -- Record number of different governments the player has adopted
    local governmentCountKey = "HSD_GOVERNMENT_ADOPTED_COUNT_"..tostring(playerID)
    local governmentCount = Game:GetProperty(governmentCountKey) or 0
    Game:SetProperty(governmentCountKey, governmentCount + 1)
    print("Recorded ".. governmentCountKey.. " as government adopted count for player ".. tostring(playerID).. " = ".. tostring(Game:GetProperty(governmentCountKey)))
end

local function HSD_OnGreatPersonCreated(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
    local player = Players[playerID]
    local greatPersonClassInfo = GameInfo.GreatPersonClasses[greatPersonClassID]
    local greatPersonEra = GameInfo.GreatPersonIndividuals[greatPersonIndividualID].EraType
    print("Great person era is "..tostring(greatPersonEra))

    -- Record the total number of great person class created by the player
    local greatPersonClassKey = "HSD_GREAT_PERSON_TYPE_COUNT_"..tostring(greatPersonClassInfo.GreatPersonClassType)
    local greatPersonClassCount = player:GetProperty(greatPersonClassKey) or 0
    greatPersonClassCount = greatPersonClassCount + 1
    player:SetProperty(greatPersonClassKey, greatPersonClassCount)

    -- Record the total number of this type of great person from this era
    local greatPersonEraKey = "HSD_GREAT_PERSON_TYPE_ERA_COUNT_"..tostring(greatPersonClassInfo.GreatPersonClassType).."_"..tostring(greatPersonEra)
    local greatPersonEraCount = player:GetProperty(greatPersonEraKey) or 0
    greatPersonEraCount = greatPersonEraCount + 1
    player:SetProperty(greatPersonEraKey, greatPersonEraCount)
end

local function HSD_OnGreatPersonActivated(UnitOwner, unitID, GreatPersonType, GreatPersonClass)
    local player = Players[UnitOwner]
    local greatPersonClassInfo = GameInfo.GreatPersonClasses[GreatPersonClass]
    local greatPersonEra = GameInfo.GreatPersonIndividuals[GreatPersonType].EraType
    print("Great person era is "..tostring(greatPersonEra))

    -- Record total number of Great people activated by the player
    local greatPersonCountKey = "HSD_GREAT_PERSON_COUNT_"..tostring(UnitOwner)
    local greatPersonCount = Game:GetProperty(greatPersonCountKey) or 0
    greatPersonCount = greatPersonCount + 1
    Game:SetProperty(greatPersonCountKey, greatPersonCount)

    -- Record total number of Great people activated by the player from this era
    local greatPersonEraCountKey = "HSD_GREAT_PERSON_ERA_COUNT_"..tostring(greatPersonEra)
    local greatPersonEraCount = player:GetProperty(greatPersonEraCountKey) or 0
    greatPersonEraCount = greatPersonEraCount + 1
    player:SetProperty(greatPersonEraCountKey, greatPersonEraCount)

    -- Record first player to activate great person of this type
    if greatPersonClassInfo then
        local greatPersonKey = "HSD_" .. tostring(greatPersonClassInfo.GreatPersonClassType)
        -- Only record first player to activate great person of this type
        if not Game:GetProperty(greatPersonKey) then
            Game:SetProperty(greatPersonKey, UnitOwner)
            print("Recorded first activation of great person class " .. greatPersonClassInfo.GreatPersonClassType .. " by player " .. tostring(UnitOwner))
        else
            -- print(greatPersonClassInfo.GreatPersonClassType .. " has already been activated by another player.")
        end
    else
        print("Error: GreatPersonClass not found for " .. tostring(GreatPersonClass))
    end
end

local function HSD_OnPillage(UnitOwner, unitID, ImprovementType, BuildingType)
    -- print("HSD_OnPillage detected...")
    -- print("Pillaging player is #"..tostring(UnitOwner))
    local player = Players[UnitOwner]
    if player and IsHistoricalVictoryPlayer(UnitOwner) then
        -- print("Player is a historical victory player")
        local unit = player:GetUnits():FindID(unitID)
        if unit then
            -- Set pillage count for unitType as player property
            local unitTypeName = GameInfo.Units[unit:GetType()].UnitType
            -- print("unitTypeName is "..tostring(unitTypeName))
            local unitPillageCount = player:GetProperty("HSD_"..tostring(unitTypeName).."_PILLAGE_COUNT") or 0
            unitPillageCount = unitPillageCount + 1
            player:SetProperty("HSD_"..tostring(unitTypeName).."_PILLAGE_COUNT", unitPillageCount)

            -- Display a popup in-game if the victory condition is active
            local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
            local conditionsForPlayer = victoryConditions[UnitOwner] or {}
            if conditionsForPlayer then
                for _, victoryCondition in ipairs(conditionsForPlayer) do
                    for _, objective in ipairs(victoryCondition.objectives) do
                        if (objective.type == "UNIT_PILLAGE_COUNT") and (objective.id == unitTypeName) then
                            -- Display in-game popup text
                            local message = Locale.Lookup("LOC_HSD_PILLAGE_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(GameInfo.Units[unitTypeName].Name), unitPillageCount, objective.count)
                            Game.AddWorldViewText(0, message, unit:GetX(), unit:GetY())
                            break
                        end
                    end
                end
            end
        else
            print("WARNING: OnPillage did not detect a unit!")
        end
    end
end

-- TODO: Seperate the count and first to completion functions
local function HSD_OnProjectCompleted(playerID, cityID, projectID, buildingIndex, iX, iY, bCancelled)
    local player = Players[playerID]
    local projectInfo = GameInfo.Projects[projectID]
    local projectKey = "HSD_" .. tostring(projectInfo.ProjectType) .. "_FIRST_COMPLETED"

    -- Set turn project was first completed by any player
    if not Game:GetProperty(projectKey) then
        Game:SetProperty(projectKey, playerID)
        print("Recorded " .. projectInfo.ProjectType .. " as completed by player " .. tostring(playerID) .. " on turn " .. tostring(Game.GetCurrentGameTurn()))
    end

    -- Set project completed count
    local projectCountKey = "HSD_" .. tostring(projectInfo.ProjectType) .. "_PROJECT_COUNT"
    local projectCount = player:GetProperty(projectCountKey) or 0
    projectCount = projectCount + 1
    player:SetProperty(projectCountKey, projectCount)
    print("Project count is "..tostring(projectCount))

    -- Check if the project is part of any active victory conditions
    local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
    local conditionsForPlayer = victoryConditions[playerID] or {}
    for _, victoryCondition in ipairs(conditionsForPlayer) do
        for _, objective in ipairs(victoryCondition.objectives) do
            if (objective.type == "PROJECT_FIRST_COMPLETED") and (objective.id == projectInfo.ProjectType) then
                -- Display in-game popup text
                local message = Locale.Lookup("LOC_HSD_PROJECT_COMPLETED_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(projectInfo.Name))
                Game.AddWorldViewText(0, message, iX, iY)
                break
            end
            if (objective.type == "PROJECT_COUNT") and (objective.id == projectInfo.ProjectType) then
                -- Display in-game popup text
                local message = Locale.Lookup("LOC_HSD_PROJECT_COUNT_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(projectInfo.Name), tostring(objective.count))
                Game.AddWorldViewText(0, message, iX, iY)
                break
            end
        end
    end

end

local function HSD_OnTechCompleted(ePlayer, eTech)
    -- print("ePlayer = " .. tostring(ePlayer) .. ", eTech = " .. tostring(eTech))
    local player = Players[ePlayer]

    if player then
        local playerCitiesCount = player:GetCities():GetCount()
        if playerCitiesCount >= 1 then
            local techInfo = GameInfo.Technologies[eTech]
            if techInfo then
                local techKey = "HSD_" .. tostring(techInfo.TechnologyType)
                -- Check if the tech has not already been recorded
                if not Game:GetProperty(techKey) then
                    Game:SetProperty(techKey, ePlayer)
                    print("Recorded " .. techKey .. " as first completed by player " .. tostring(ePlayer))
                else
                    -- print("Tech " .. techKey .. " already recorded for another player.")
                end
            else
                print("Error: Tech information not found for eTech = " .. tostring(eTech))
            end
        else
            print("Player " .. tostring(ePlayer) .. " does not have any cities, ignoring tech completion.")
        end
    else
        print("Error: Player not found for ePlayer = " .. tostring(ePlayer))
    end
end

local function HSD_OnSpyMissionCompleted(playerID, missionID)
    local player = Players[playerID]
    -- Retrieve or initialize the table of completed missions
    local completedMissions = player:GetProperty("HSD_CompletedMissions") or {}
        
    -- Check if the missionID has not already been recorded
    if not completedMissions[missionID] then
        -- Record the mission as completed
        completedMissions[missionID] = true
        player:SetProperty("HSD_CompletedMissions", completedMissions)
            
        -- Count the total number of unique missions completed
        local totalUniqueMissions = 0
        for _ in pairs(completedMissions) do
            totalUniqueMissions = totalUniqueMissions + 1
        end
        
        -- Store the total count in another player property
        player:SetProperty("HSD_TotalUniqueMissionsCompleted", totalUniqueMissions)
            
        -- Optionally, log the completion for debugging
        print("Mission " .. tostring(missionID) .. " completed by player " .. tostring(playerID) .. ". Total unique missions completed: " .. tostring(totalUniqueMissions))
    else
        -- Optionally, log if the mission was already completed
        print("Mission " .. tostring(missionID) .. " already completed by player " .. tostring(playerID))
    end
end

local function HSD_OnUnitKilled(killedPlayerID, killedUnitID, playerID, unitID)
    -- print("HSD_OnUnitKilled detected...")
    -- print("Killing player is #"..tostring(playerID))
    local player = Players[playerID]
    local otherPlayer = Players[killedPlayerID]

    if not otherPlayer then
        print("WARNING: HSD_OnUnitKilled failed to detect a player for the unit that was killed")
        print("Continuing function...")
    end

    local function GetUnitEra(unit)
        local unitPrereqTech = GameInfo.Units[unit:GetType()].PrereqTech
        local unitPrereqCivic = GameInfo.Units[unit:GetType()].PrereqCivic
        local unitEra = 0 -- Era zero corresponds to the ancient era index
        if unitPrereqTech then
            local techInfo = GameInfo.Technologies[unitPrereqTech]
            if techInfo then
                unitEra = GameInfo.Eras[techInfo.EraType].Index
            end
        end
        if unitPrereqCivic then
            local civicInfo = GameInfo.Civics[unitPrereqCivic]
            if civicInfo then
                unitEra = GameInfo.Eras[civicInfo.EraType].Index
            end
        end
        if not unitPrereqTech and not unitPrereqCivic then
            print("Unit "..tostring(unit:GetType()).." has no prereq tech or civic, using default era value of "..tostring(unitEra))
        end
        return unitEra
    end

    if player and IsHistoricalVictoryPlayer(playerID) then
        -- print("Player is a historical victory player")
        -- local unit = player:GetUnits():FindID(unitID)
        local unit = UnitManager.GetUnit(playerID, unitID)
        if unit then
            -- Set kill count for unitType as player property
            local unitTypeName = GameInfo.Units[unit:GetType()].UnitType
            -- print("unitTypeName is "..tostring(unitTypeName))
            local unitKillCount = player:GetProperty("HSD_"..tostring(unitTypeName).."_KILL_COUNT") or 0
            unitKillCount = unitKillCount + 1
            player:SetProperty("HSD_"..tostring(unitTypeName).."_KILL_COUNT", unitKillCount)

            -- Set highest difference in eras between units killed by this unit type for the player
            local unitEraDifference = 0
            local unitPropertyKey = "HSD_"..tostring(unitTypeName).."_KILL_ERA_DIFFERENCE"
            local eraDifferenceProperty = player:GetProperty(unitPropertyKey) or -999 -- Arbitrary default value below the lowest possible era index (hopefully)
            local unitEra = GetUnitEra(unit)
            local otherUnit = UnitManager.GetUnit(killedPlayerID, killedUnitID)
            if otherUnit then
                local otherUnitTypeName = GameInfo.Units[otherUnit:GetType()].UnitType
                print("otherUnitTypeName is "..tostring(otherUnitTypeName))
                local killedUnitEra = GetUnitEra(otherUnit)
                print("Killed unit era is "..tostring(killedUnitEra))
                -- If the player unit kills a more advanced unit, the difference will be positive; less advanced will be negative
                unitEraDifference = killedUnitEra - unitEra
                if unitEraDifference > eraDifferenceProperty then
                    print("Highest era kill difference for "..tostring(unitTypeName).." by player #"..tostring(playerID).." is "..tostring(unitEraDifference))
                    player:SetProperty(unitPropertyKey, unitEraDifference)
                end
            else
                print("WARNING: HSD_OnUnitKilled failed to detect unit that was killed by player #"..tostring(playerID))
                print("Continuing function...")
            end

            -- Display a popup in-game if the victory condition is active
            local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
            local conditionsForPlayer = victoryConditions[playerID] or {}
            for _, victoryCondition in ipairs(conditionsForPlayer) do
                for _, objective in ipairs(victoryCondition.objectives) do
                    if (objective.type == "UNIT_KILL_COUNT") and (objective.id == unitTypeName) then
                        -- Display in-game popup text
                        local message = Locale.Lookup("LOC_HSD_KILL_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(GameInfo.Units[unitTypeName].Name), unitKillCount, objective.count)
                        Game.AddWorldViewText(0, message, unit:GetX(), unit:GetY())
                        break
                    end
                end
            end
        else
            print("WARNING: HSD_OnUnitKilled did not detect a unit!")
        end
    end
end

local function HSD_OnWarDeclared(firstPlayerID, secondPlayerID)
    -- local player = Players[firstPlayerID]
    -- local targetPlayer = Players[secondPlayerID]
    print("Player #"..tostring(firstPlayerID).." has declared war on player #"..tostring(secondPlayerID))
    -- Record the first player to declare war
    local propertyKey = "HSD_FIRST_WAR_DECLARED"
    if not Game:GetProperty(propertyKey) then
        Game:SetProperty(propertyKey, firstPlayerID)
        print("First war declared by player #"..tostring(firstPlayerID))
    end
end

local function HSD_OnWonderConstructed(iX, iY, buildingIndex, playerIndex, cityID, iPercentComplete, iUnknown)
    if iPercentComplete == 100 then  -- Ensure the wonder is fully constructed
        local buildingInfo = GameInfo.Buildings[buildingIndex]
        local wonderPlot = Map.GetPlot(iX, iY)
        local player = Players[playerIndex]
        if buildingInfo and buildingInfo.IsWonder then  -- Check if it's a wonder
            local wonderKey = "HSD_WONDER_" .. tostring(buildingInfo.BuildingType)

            -- Record the first player to complete this wonder
            if not Game:GetProperty(wonderKey) then
                Game:SetProperty(wonderKey, playerIndex)
                print("Recorded " .. buildingInfo.BuildingType .. " as first completed by player " .. tostring(playerIndex))
            else
                print(buildingInfo.BuildingType .. " has already been completed by another player.")
            end

            -- Check if the wonder completion is part of any active victory condition
            local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
            local conditionsForPlayer = victoryConditions[playerIndex] or {}
            for _, victoryCondition in ipairs(conditionsForPlayer) do
                for _, objective in ipairs(victoryCondition.objectives) do
                    if (objective.type == "WONDER_BUILT") and (objective.id == buildingInfo.BuildingType) then
                        -- Display in-game popup text
                        local message = Locale.Lookup("LOC_HSD_WONDER_CONSTRUCTED_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(buildingInfo.Name))
                        Game.AddWorldViewText(0, message, iX, iY)
                        -- break
                    end
                    if (objective.type == "WONDER_ADJACENT_IMPROVEMENT") and (objective.id == buildingInfo.BuildingType) then
                        -- Check for adjacent improvement
                        local objectiveMet = GetImprovementAdjacentPlot(objective.improvement, wonderPlot)
                        -- Set property
                        if objectiveMet then
                            local objectiveKey = "HSD_"..tostring(objective.improvement).."_ADJACENT_"..tostring(objective.id)
                            player:SetProperty(objectiveKey, Game.GetCurrentGameTurn())
                        end
                        -- Display in-game popup text
                        local message = Locale.Lookup("LOC_HSD_WONDER_CONSTRUCTED_FLOATER", "LOC_HSD_VICTORY_"..tostring(victoryCondition.playerTypeName).."_"..tostring(victoryCondition.index).."_NAME", Locale.Lookup(buildingInfo.Name))
                        Game.AddWorldViewText(0, message, iX, iY)
                        -- break
                    end
                end
            end
        else
            print("Error: Building index does not correspond to a wonder.")
        end
    end
end

-- ===========================================================================
-- PRIMARY FUNCTIONS
-- ===========================================================================

-- Helper function to evaluate and track all types of objectives
function EvaluateObjectives(player, condition)
    local objectivesMet = true
    local playerID = player:GetID()

    for index, obj in ipairs(condition.objectives) do
        local objectiveMet = false
		local current = 0
		local total = 0
        local propertyKey = "HSD_HISTORICAL_VICTORY_" .. condition.index .. "_OBJECTIVE_" .. index
		local isPlayerProperty = false
        local isEqual = false
        local isGreaterThan = false
        local isLesserThan = false

		if obj.type == "2_WONDERS_IN_CITY" then
			current = AreTwoWondersInSameCity(playerID, obj.firstID, obj.secondID) and 1 or 0
			total = 1
		elseif obj.type == "ALLIANCE_COUNT" then
			current = GetAllianceCount(playerID)
			total = obj.count
        elseif obj.type == "BORDERING_CITY_COUNT" then
			current = GetBorderingCitiesCount(playerID)
			total = obj.count
		elseif obj.type == "BUILDING_COUNT" then
			current = GetBuildingCount(playerID, obj.id)
			total = obj.count
		elseif obj.type == "BUILDING_IN_CAPITAL" then
			current = IsBuildingInCapital(playerID, obj.id) and 1 or 0
			total = 1
		elseif obj.type == "BUILDING_IN_EVERY_CITY" then
			current, total = GetCitiesWithBuilding(playerID, obj.id)
		elseif obj.type == "CITY_ADJACENT_TO_RIVER_COUNT" then
			current = GetCityAdjacentToRiverCount(playerID)
			total = obj.count
        elseif obj.type == "CITY_COUNT" then
			current = GetCitiesCount(playerID)
			total = obj.count
		elseif obj.type == "CITY_COUNT_EVERY_CONTINENT" then
			current, total = GetCityCountPerContinent(playerID, obj.count)
		elseif obj.type == "CITY_COUNT_FOREIGN_CONTINENT" then
			current = GetCitiesOnForeignContinents(playerID)
			total = obj.count
        elseif obj.type == "CITY_NAME_COUNT" then
            current = GetCitiesWithNameCount(playerID, obj.id)
            total = obj.count
		elseif obj.type == "CITY_WITH_FEATURE_COUNT" then
			current = GetCitiesWithFeatureCount(playerID, obj.id) or 0
			total = obj.count
		elseif obj.type == "CITY_WITH_IMPROVEMENT_COUNT" then
			current = GetCitiesWithImprovementCount(playerID, obj.id) or 0
			total = obj.count
		elseif obj.type == "COASTAL_CITY_COUNT" then
			current = GetCoastalCityCount(playerID)
			total = obj.count
        elseif obj.type == "COMPLETE_ESPIONAGE_MISSIONS" then
            current = player:GetProperty("HSD_TotalUniqueMissionsCompleted") or 0
            total = obj.count
		elseif obj.type == "CONTROL_ALL_ADJACENT_RIVER_TO_CAPITAL" then
			current, total = GetRiverOwnership(playerID)
        elseif obj.type == "CONVERT_MAJORITY_HOME_CONTINENT_RELIGION" then
            isGreaterThan = true
            current, total = GetCitiesOnHomeContinentFollowingReligion(playerID)
		elseif obj.type == "CONVERT_NUM_CONTINENTS" then -- UNTESTED
			current = GetContinentsWithMajorityReligion(playerID)
			total = obj.count
		elseif obj.type == "CONVERT_ALL_CITIES" then -- UNTESTED
			current, total = GetCitiesFollowingReligion(playerID)
        elseif obj.type == "DIFFERENT_GOVERNMENTS_ADOPTED" then
            current = Game:GetProperty("HSD_GOVERNMENT_ADOPTED_COUNT_"..tostring(playerID)) or 0
            total = obj.count
		elseif obj.type == "DISTRICT_COUNT" then
			current = GetDistrictTypeCount(playerID, obj.id)
			total = obj.count
		elseif obj.type == "DISTRICT_COUNT_CAPITAL_ADJACENT" then
			current = GetAdjacentDistrictsCapital(playerID)
			total = obj.count
        elseif obj.type == "ENVOYS_WITH_CITY_STATE" then
            current = GetHighestEnvoyCount(playerID)
            total = obj.count
		elseif obj.type == "FEATURE_COUNT" then
			current = GetPlayerFeaturePlotCount(playerID, obj.id)
			total = obj.count
        elseif obj.type == "FIRST_HISTORICAL_MOMENT" then
            isPlayerProperty = true
            current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
            total = playerID
		elseif obj.type == "FIRST_NUM_ACTIVE_ALLIANCES" then
            isPlayerProperty = true
			current = GetAllianceCount_AllPlayers(obj.count)
			total = playerID
		elseif obj.type == "FIRST_BUILDING_CONSTRUCTED" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
		elseif obj.type == "FIRST_CIVIC_RESEARCHED" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
        elseif obj.type == "FIRST_CITY_SIZE" then
            isPlayerProperty = true
            current = Game:GetProperty("HSD_CITY_POPULATION_SIZE_"..tostring(obj.count)) or -1 --playerID nil check
            total = playerID
		elseif obj.type == "FIRST_GOVERNMENT" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
		elseif obj.type == "FIRST_GREAT_PERSON_CLASS" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
        elseif obj.type == "FIRST_RELIGIOUS_BELIEFS" then
            isPlayerProperty = true
            current = Game:GetProperty("HSD_FIRST_"..tostring(obj.count).."_BELIEFS") or -1 --playerID nil check
            total = playerID
		elseif obj.type == "FIRST_TECH_RESEARCHED" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
		elseif obj.type == "FIRST_WAR_DECLARED" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
		elseif obj.type == "GOLD_COUNT" then
			current = GetPlayerGold(playerID)
			total = obj.count
        elseif obj.type == "GOLDEN_AGE_COUNT" then
            current = GetGoldenAgeCount(playerID)
            total = obj.count
		elseif obj.type == "GOVERNOR_IN_EVERY_CITY" then
			current, total = ExposedMembers.HSD_GetCitiesWithGovernors(playerID)
		elseif obj.type == "GREAT_PEOPLE_ACTIVATED" then
			current = Game:GetProperty("HSD_GREAT_PERSON_COUNT_"..tostring(playerID)) or 0
			total = obj.count
		elseif obj.type == "GREAT_PERSON_ERA_COUNT" then -- UNTESTED
			current = player:GetProperty("HSD_GREAT_PERSON_ERA_COUNT_"..tostring(obj.id)) or 0
			total = obj.count
		elseif obj.type == "GREAT_PERSON_TYPE_COUNT" then -- UNTESTED
			current = player:GetProperty("HSD_GREAT_PERSON_TYPE_COUNT_"..tostring(obj.id)) or 0
			total = obj.count
        elseif obj.type == "GREAT_PERSON_TYPE_FROM_ERA" then
            current = player:GetProperty("HSD_GREAT_PERSON_TYPE_ERA_COUNT_"..tostring(obj.id).."_"..tostring(obj.era)) or 0
            total = obj.count
        elseif obj.type == "GREAT_WORK_COUNT" then
            current = ExposedMembers.HSD_GetGreatWorksCount(playerID)
            total = obj.count
        elseif obj.type == "GREAT_WORK_TYPE_COUNT" then
            current = ExposedMembers.HSD_GetGreatWorkTypeCount(playerID, obj.id)
            total = obj.count
		elseif obj.type == "HAPPIEST_POPULATION" then
			current, total = GetHappiness(playerID)
		elseif obj.type == "HIGHEST_CITY_POPULATION" then
            isGreaterThan = true
			current, total = GetHighestCityPopulation(playerID)
		elseif obj.type == "HIGHEST_CULTURE" then
            isGreaterThan = true
			current, total = GetHighestCulture(playerID)
		elseif obj.type == "HIGHEST_FAITH_PER_TURN" then -- UNTESTED
            isGreaterThan = true
			current, total = GetHighestFaithPerTurn(playerID)
		elseif obj.type == "HIGHEST_GOLD_PER_TURN" then -- UNTESTED
            isGreaterThan = true
			current, total = GetHighestGoldPerTurn(playerID)
		elseif obj.type == "HIGHEST_PRODUCTION" then -- UNTESTED
            isGreaterThan = true
			current, total = GetHighestProduction(playerID)
		elseif obj.type == "HIGHEST_TECH_COUNT" then
            isGreaterThan = true
			current, total = GetPlayerTechCounts(playerID)
		elseif obj.type == "HIGHEST_TOURISM" then
            isGreaterThan = true
			current, total = GetTourismCounts(playerID)
		elseif obj.type == "HOLY_CITY_COUNT" then
			current = ExposedMembers.HSD_GetHolyCitiesCount(playerID)
            total = obj.count
		elseif obj.type == "IMPROVEMENT_COUNT" then
			current = GetImprovementCount(playerID, obj.id) or -1
			total = obj.count
		elseif obj.type == "IMPROVEMENT_YIELD_COUNT" then
			current = GetHighestImprovementYield(playerID, obj.id, obj.yield)
            total = obj.count
		elseif obj.type == "LAND_AREA_HOME_CONTINENT" then
			current = GetPercentLandArea_HomeContinent(playerID, obj.percent) or -1
			total = obj.percent
        elseif obj.type == "LOYALTY_CONVERT_CITY_COUNT" then -- UNTESTED
			current = Game:GetProperty("HSD_"..tostring(obj.type).."_"..tostring(playerID)) or 0
			total = obj.count
		elseif obj.type == "MAXIMUM_ALLIANCE_LEVEL_COUNT" then -- UNTESTED
			current = GetAllianceLevelCount(playerID)
			total = obj.count
		elseif obj.type == "MINIMUM_CONTINENT_TECH_COUNT" then
            isGreaterThan = true
			current, total = HasMoreTechsThanContinentMinimum(playerID, obj.continent)
        elseif obj.type == "MOMENT_COUNT" then
            current = player:GetProperty("HSD_"..tostring(obj.id).."_COUNT") or 0
            total = obj.count
		elseif obj.type == "MOST_ACTIVE_TRADEROUTES_ALL" then
            isGreaterThan = true
			current, total = GetTradeRoutesCount(playerID)
		elseif obj.type == "MOST_ARCTIC_TERRAIN" then
            isGreaterThan = true
			current, total = GetArcticTerrainCounts(playerID)
		elseif obj.type == "MOST_CITIES_FOLLOWING_RELIGION" then -- UNTESTED
            isGreaterThan = true
			current, total = GetReligiousCitiesCount(playerID)
		elseif obj.type == "MOST_CITIES_ON_HOME_CONTINENT" then
            isGreaterThan = true
			current, total = GetCitiesOnHomeContinent(playerID)
        elseif obj.type == "MOST_FRIENDS" then
            isGreaterThan = true
            current, total = GetDeclaredFriendsCount(playerID)
		elseif obj.type == "MOST_HILL_PLOTS" then
            isGreaterThan = true
			current, total = GetHillsCount(playerID)
		elseif obj.type == "MOST_OUTGOING_TRADE_ROUTES" then
            isGreaterThan = true
			current, total = GetOutgoingRoutesCount(playerID)
		elseif obj.type == "MOST_TERRAIN_TYPE" then
            isGreaterThan = true
			current, total = GetTerrainCounts(playerID, obj.id)
		elseif obj.type == "MOST_TERRAIN_CLASS" then
            isGreaterThan = true
			current, total = GetTerrainClassCounts(playerID, obj.id)
		elseif obj.type == "MOST_UNIT_DOMAIN_TYPE" then
            isGreaterThan = true
			current, total = GetUnitDomainCount(playerID, obj.id)
		elseif obj.type == "MOST_UNIT_FORMATION_CLASS_TYPE" then
            isGreaterThan = true
			current, total = GetUnitFormationClassCount(playerID, obj.id)
		elseif obj.type == "NATURAL_WONDER_COUNT" then
			current = GetNaturalWonderCount(playerID)
			total = obj.count
		elseif obj.type == "NUCLEAR_WEAPONS_COUNT" then
			current = GetNuclearWeaponCount(playerID)
			total = obj.count
		elseif obj.type == "NUM_CITIES_CAPITAL_RANGE" then
			current = GetNumCitiesWithinCapitalRange(playerID, obj.range)
			total = obj.count
		elseif obj.type == "NUM_CITIES_POP_SIZE" then
			current = GetNumCitiesWithPopulation(playerID, obj.cityNum, obj.popNum)
			total = obj.cityNum
		elseif obj.type == "OCCUPIED_CAPITAL_COUNT" then
			current = GetOccupiedCapitals(playerID)
			total = obj.count
		elseif obj.type == "PROJECT_COUNT" then
			current = player:GetProperty("HSD_"..tostring(obj.id).."_COUNT") or 0
			total = obj.count
		elseif obj.type == "PROJECT_FIRST_COMPLETED" then
            isPlayerProperty = true
			current = player:GetProperty("HSD_"..tostring(obj.id).."_FIRST_COMPLETED") or -1 --playerID nil check
			total = playerID
		elseif obj.type == "RESOURCE_MONOPOLY" then
			current = GetResourcePercentage(playerID, obj.id)
			total = obj.percent
		elseif obj.type == "ROUTE_COUNT" then
			current = GetTotalRoutePlots(playerID)
			total = obj.count
		elseif obj.type == "ROUTE_TYPE_COUNT" then
			current = GetRouteTypeCount(playerID, obj.id)
			total = obj.count
		elseif obj.type == "SUZERAINTY_COUNT" then
			current = GetSuzeraintyCount(playerID)
			total = obj.count
		elseif obj.type == "TERRITORY_CONTROL" then
			current = ControlsTerritory(playerID, obj.territory, obj.minimumSize) and 1 or 0
			total = 1
        elseif obj.type == "TRADING_POST_IN_EVERY_CITY" then
            current, total = ExposedMembers.HSD_GetCitiesWithTradingPosts(playerID)
        elseif obj.type == "TRADING_POST_WITH_ALL_PLAYERS_CONTINENT" then
            current, total = ExposedMembers.HSD_TradePostEveryPlayerOnContinent(playerID)
		elseif obj.type == "TOTAL_LAND_AREA" then
			current = GetPercentLandArea(playerID)
			total = obj.percent
		elseif obj.type == "UNIT_CONQUER_CITY_COUNT" then
			current = player:GetProperty("HSD_"..tostring(obj.id).."_CONQUER_COUNT") or 0
			total = obj.count
		elseif obj.type == "UNIT_COUNT" then
			current = GetUnitCount(playerID, obj.id)
			total = obj.count
		elseif obj.type == "UNIT_CLASS_COUNT" then -- UNTESTED
			current = GetUnitClassCount(playerID, obj.id)
			total = obj.count
		elseif obj.type == "UNIT_CLASS_PROMOTION_LEVEL" then -- UNTESTED
			current = ExposedMembers.HSD_GetUnitClassLevel(playerID, obj.id, obj.count)
			total = obj.count
		elseif obj.type == "UNIT_KILL_COUNT" then
			current = player:GetProperty("HSD_"..tostring(obj.id).."_KILL_COUNT") or 0
			total = obj.count
        elseif obj.type == "UNIT_KILL_ERA_DIFFERENCE" then
            current = player:GetProperty("HSD_"..tostring(obj.id).."_KILL_ERA_DIFFERENCE") or -999
            total = obj.count
		elseif obj.type == "UNIT_PILLAGE_COUNT" then
			current = player:GetProperty("HSD_"..tostring(obj.id).."_PILLAGE_COUNT") or 0
			total = obj.count
		elseif obj.type == "UNIT_PROMOTION_LEVEL" then
			current = ExposedMembers.HSD_GetUnitPromotionLevel(playerID, obj.id, obj.level)
			total = obj.count
		elseif obj.type == "UNLOCK_ALL_ERA_CIVICS" then
			current = HasUnlockedAllCivicsForEra(playerID, obj.id) and 1 or 0
			total = 1
		elseif obj.type == "WONDER_ADJACENT_IMPROVEMENT" then
			-- current = GetWonderAdjacentImprovement(playerID, obj.id, obj.improvement) and 1 or 0
            current = player:GetProperty("HSD_"..tostring(obj.improvement).."_ADJACENT_"..tostring(obj.id)) and 1 or 0
			total = 1
		elseif obj.type == "WONDER_BUILT" then
			isPlayerProperty = true
			current = Game:GetProperty("HSD_WONDER_"..tostring(obj.id)) or -1 --playerID nil check
			total = playerID
		elseif obj.type == "WONDER_BUILT_CITIES_IN_RANGE" then
			current = GetCitiesInRange_Building(playerID, obj.id, obj.range)
			total = obj.count
        elseif obj.type == "WONDER_CONTROL_ALL" then
            current, total = GetWondersCount(playerID)
		end

		if isPlayerProperty then
            -- Objective is met if the player detected is the local player (total == playerID)
			objectiveMet = current == total
            -- -- Display text instead of player IDs
            -- if (current == -1) then
            --     -- No player detected, display this via text
            --     current = "None"
            -- elseif (current >= 0) then
            --     -- Player ID detected, display the player name
            --     current = GameInfo.Civilizations[PlayerConfigurations[current]:GetCivilizationTypeName()].Name
            -- end
            -- -- Display the total as text
            -- total = GameInfo.Civilizations[PlayerConfigurations[total]:GetCivilizationTypeName()].Name
        elseif isEqual then
            objectiveMet = current == total
		elseif isGreaterThan then
			objectiveMet = current > total
		elseif isLesserThan then
			objectiveMet = current < total
		else
			objectiveMet = current >= total
		end

        -- Set property for this specific objective
		player:SetProperty(propertyKey, {current = current, total = total, objectiveMet = objectiveMet})

        -- If any objective is not met, objectivesMet becomes false
        objectivesMet = objectivesMet and objectiveMet
    end

    return objectivesMet
end

-- Main function that calls the victory condition checker and sets victory and score properties
function GetHistoricalVictoryConditions(iPlayer)
    local player = Players[iPlayer]
	if not IsHistoricalVictoryPlayer(iPlayer) or not HasPlayerSpawned(iPlayer) then
		return
	end
    local LeaderTypeName = PlayerConfigurations[iPlayer]:GetLeaderTypeName()
    local victoryConditionsCache = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
    local conditionsForPlayer = victoryConditionsCache[iPlayer] or {}

    local currentYear = ExposedMembers.GetCalendarTurnYear(Game.GetCurrentGameTurn())
    local previousYear = ExposedMembers.GetCalendarTurnYear(Game.GetCurrentGameTurn() - 1)
    local annoDominiYear = ConvertYearToAnnoDomini(currentYear)
	local gameEra = Game.GetEras():GetCurrentEra()

    -- print("previousYear is "..tostring(previousYear))
    -- print("currentYear is "..tostring(currentYear))

    for index, condition in ipairs(conditionsForPlayer or {}) do
        local isTimeConditionMet = condition.year == nil or (currentYear <= condition.year)
        local isTimeLimit = (condition.yearLimit ~= nil)
        local isTimeLimitReached = ((condition.yearLimit == "ON_YEAR") and ((condition.year >= previousYear) and (condition.year < currentYear)))
        local isTimeLimitFailed = false
		local isEraConditionMet = condition.era == nil or (GameInfo.Eras[condition.era].Index >= gameEra)
        local isEraObjectiveMet = condition.era == nil or (GameInfo.Eras[condition.era].Index == gameEra)
        local isEraLimitMet = condition.eraLimit == nil or ((condition.eraLimit == "END_ERA") and (ExposedMembers.GetEraCountdown() > 0))
        local victoryPropertyName = "HSD_HISTORICAL_VICTORY_" .. index
        local victoryAlreadySet = player:GetProperty(victoryPropertyName)

        -- print("yearLimit is "..tostring(condition.yearLimit))
        -- print("isTimeLimit is "..tostring(isTimeLimit))
        -- print("isTimeLimitReached is "..tostring(isTimeLimitReached))

        if isTimeConditionMet and isEraConditionMet and not victoryAlreadySet then
            if EvaluateObjectives(player, condition) then
                if isEraObjectiveMet and isEraLimitMet and not isTimeLimit then
                    -- If all objectives are met, set the main victory property
                    player:SetProperty(victoryPropertyName, Game.GetCurrentGameTurn())
                    -- Add to victory score
                    local victoryScore = player:GetProperty("HSD_HISTORICAL_VICTORY_SCORE") or 0
                    player:SetProperty("HSD_HISTORICAL_VICTORY_SCORE", victoryScore + condition.score)
                    -- Generate popup
                    local eventKey = GameInfo.EventPopupData["HSD_HISTORICAL_VICTORY_POPUP"].Type
                    local eventEffectString = Locale.Lookup("LOC_HSD_EVENT_HISTORICAL_VICTORY_MESSAGE", Locale.Lookup("LOC_HSD_VICTORY_"..tostring(condition.playerTypeName).."_"..tostring(condition.index).."_NAME"), tostring(annoDominiYear), Locale.Lookup(GameInfo.Leaders[LeaderTypeName].Name))
                    -- Show popup to all human players
                    local allPlayerIDs = PlayerManager.GetAliveIDs()
                    for _, playerID in ipairs(allPlayerIDs) do
                        local otherPlayer = Players[playerID]
                        if otherPlayer:IsHuman() then
                            ReportingEvents.Send("EVENT_POPUP_REQUEST", { ForPlayer = playerID, EventKey = eventKey, EventEffect = eventEffectString })
                        end
                    end
                    -- Show popup to local player
                    -- ReportingEvents.Send("EVENT_POPUP_REQUEST", { ForPlayer = iPlayer, EventKey = eventKey, EventEffect = eventEffectString })
                end
            end
        end
        if isTimeLimitReached and not victoryAlreadySet then
            if EvaluateObjectives(player, condition) then
                -- If all objectives are met, set the main victory property
                player:SetProperty(victoryPropertyName, Game.GetCurrentGameTurn())
                -- Add to victory score
                local victoryScore = player:GetProperty("HSD_HISTORICAL_VICTORY_SCORE") or 0
                player:SetProperty("HSD_HISTORICAL_VICTORY_SCORE", victoryScore + condition.score)
                -- Generate popup
                local eventKey = GameInfo.EventPopupData["HSD_HISTORICAL_VICTORY_POPUP"].Type
                local eventEffectString = Locale.Lookup("LOC_HSD_EVENT_HISTORICAL_VICTORY_MESSAGE", Locale.Lookup("LOC_HSD_VICTORY_"..tostring(condition.playerTypeName).."_"..tostring(condition.index).."_NAME"), tostring(annoDominiYear), Locale.Lookup(GameInfo.Leaders[LeaderTypeName].Name))
                -- Show popup to all human players
                local allPlayerIDs = PlayerManager.GetAliveIDs()
                for _, playerID in ipairs(allPlayerIDs) do
                    local otherPlayer = Players[playerID]
                    if otherPlayer:IsHuman() then
                        ReportingEvents.Send("EVENT_POPUP_REQUEST", { ForPlayer = playerID, EventKey = eventKey, EventEffect = eventEffectString })
                    end
                end
            else
                isTimeLimitFailed = true
                print("Time limit failed for player #"..tostring(iPlayer))
            end
        end
        if not victoryAlreadySet and (((not isTimeConditionMet) and (not isTimeLimit)) or ((not isEraConditionMet) and (GameInfo.Eras[condition.era].Index < gameEra)) or (isTimeLimit and isTimeLimitFailed)) then
            -- Objectives failed
            player:SetProperty(victoryPropertyName, -1)
        end
    end

    -- Create victory building if score threshold is reached
    local victoryPropertyName = "HSD_HISTORICAL_VICTORY_PROJECT_GRANTED"
    local victoryAlreadySet = player:GetProperty(victoryPropertyName)
    local totalVictoryScore = player:GetProperty("HSD_HISTORICAL_VICTORY_SCORE")
    if not victoryAlreadySet and totalVictoryScore and (totalVictoryScore >= iVictoryScoreToWin) then
		local victoryProjectBuilding = "BUILDING_HISTORICAL_VICTORY"
		if GameInfo.Buildings[victoryProjectBuilding] then
            local capital = player:GetCities():GetCapitalCity()
			local cityBuildQueue = capital:GetBuildQueue()
            if not capital:GetBuildings():HasBuilding(victoryProjectBuilding) then
                -- Create dummy building to apply effect
                cityBuildQueue:CreateIncompleteBuilding(GameInfo.Buildings[victoryProjectBuilding].Index, 100)
                -- Set property
                player:SetProperty(victoryPropertyName, true)
                -- Show popup
                local eventKey = GameInfo.EventPopupData["HSD_HISTORICAL_VICTORY_UNLOCKED_POPUP"].Type
                local eventEffectString = Locale.Lookup("LOC_HSD_EVENT_HISTORICAL_VICTORY_UNLOCKED_MESSAGE", Locale.Lookup(GameInfo.Leaders[LeaderTypeName].Name))
                ReportingEvents.Send("EVENT_POPUP_REQUEST", { ForPlayer = iPlayer, EventKey = eventKey, EventEffect = eventEffectString })
            end
		end
    end
end

-- ===========================================================================
-- INITIALIZATION
-- ===========================================================================

function HSD_InitVictoryMode()
	print("Initializing HistoricalVictory_Scripts.lua")
	territoryCache = ExposedMembers.HSD_GetTerritoryCache()
    CacheAllResourcePlots() -- Sets game property containing resource plots as table
    CacheVictoryConditions() -- Sets game property containing victory data as table
    Events.BeliefAdded.Add(HSD_OnBeliefAdded)
    Events.CityProjectCompleted.Add(HSD_OnProjectCompleted)
    Events.CityPopulationChanged.Add(HSD_OnCityPopulationChanged)
	Events.CivicCompleted.Add(HSD_OnCivicCompleted)
    Events.CulturalIdentityCityConverted.Add(HSD_OnCityConvertedLoyalty)
    Events.DiplomacyDeclareWar.Add(HSD_OnWarDeclared)
    Events.GameHistoryMomentRecorded.Add(HSD_OnGameHistoryMoment)
    Events.GovernmentChanged.Add(HSD_OnGovernmentChanged)
	Events.ResearchCompleted.Add(HSD_OnTechCompleted)
    Events.SpyMissionCompleted.Add(HSD_OnSpyMissionCompleted)
	Events.WonderCompleted.Add(HSD_OnWonderConstructed)
    Events.UnitGreatPersonCreated.Add(HSD_OnGreatPersonCreated)
	Events.UnitKilledInCombat.Add(HSD_OnUnitKilled)
    GameEvents.BuildingConstructed.Add(HSD_OnBuildingConstructed)
    GameEvents.CityConquered.Add(HSD_OnCityConquered)
	GameEvents.OnGreatPersonActivated.Add(HSD_OnGreatPersonActivated)
	GameEvents.OnPillage.Add(HSD_OnPillage)
	GameEvents.PlayerTurnStarted.Add(GetHistoricalVictoryConditions)
end

Events.LoadScreenClose.Add(HSD_InitVictoryMode)