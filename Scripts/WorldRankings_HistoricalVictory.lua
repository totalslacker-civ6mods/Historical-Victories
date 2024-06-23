-- Copyright 2018, Firaxis Games
-- WorldRankings_HistoricalVictory.lua
-- Credit: Leugi's Victory Projects mod
-- Author: totalslacker
-- ===========================================================================
-- Includes
-- ===========================================================================
include("WorldRankings");
include("HistoricalVictory_Data");

print("Loading Historical Victory World Rankings replace UI...")

-- ===========================================================================
-- Helper tables for Historical Victory Mode
-- ===========================================================================

-- Add victory objective types here to prevent them from displaying their count in-game
local HideObjectiveCount = {
	["FIRST_BUILDING_CONSTRUCTED"] = true,
	["FIRST_CIVIC_RESEARCHED"] = true,
	["FIRST_GOVERNMENT"] = true,
	["FIRST_GREAT_PERSON_CLASS"] = true,
	["FIRST_TECH_RESEARCHED"] = true,
	["WONDER_ADJACENT_IMPROVEMENT"] = true,
	["WONDER_BUILT"] = true,
}

-- ===========================================================================
-- Helper Functions for Historical Victory Mode
-- ===========================================================================

local function GetObjectiveDetails(objective)
    local detailsText = ""
    local type = objective.type

    if type == "2_WONDERS_IN_CITY" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.firstID, objective.secondID)
    elseif type == "ALLIANCE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "BORDERING_CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "BUILDING_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name), objective.count)
    elseif type == "BUILDING_IN_CAPITAL" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name))
    elseif type == "BUILDING_IN_EVERY_CITY" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name))
    elseif type == "CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CITY_COUNT_EVERY_CONTINENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CITY_COUNT_FOREIGN_CONTINENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CITY_ADJACENT_TO_CAPITAL_SEA_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CITY_NAME_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count, objective.id)
    elseif type == "CITY_WITH_FEATURE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count, objective.id)
    elseif type == "CITY_WITH_IMPROVEMENT_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count, objective.id)
    elseif type == "COASTAL_CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
	elseif type == "COMPLETE_ESPIONAGE_MISSIONS" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CONTROL_ALL_ADJACENT_RIVER_TO_CAPITAL" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
	elseif type == "CONVERT_MAJORITY_HOME_CONTINENT_RELIGION" then
		detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "CONVERT_NUM_CONTINENTS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "CONVERT_ALL_CITIES" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
	elseif type == "DIFFERENT_GOVERNMENTS_ADOPTED" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "DISTRICT_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Districts[objective.id].Name), objective.count)
    elseif type == "DISTRICT_COUNT_CAPITAL_ADJACENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "DISTRICT_ON_NUM_CONTINENTS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Districts[objective.id].Name), objective.count)
    elseif type == "ENVOYS_WITH_CITY_STATE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "FEATURE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Features[objective.id].Name), objective.count)
    elseif type == "FIRST_NUM_ACTIVE_ALLIANCES" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "FIRST_BUILDING_CONSTRUCTED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name))
	elseif type == "FIRST_CITY_SIZE" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "FIRST_CIVIC_RESEARCHED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Civics[objective.id].Name))
	elseif type == "FIRST_HISTORICAL_MOMENT" then
		-- detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup("LOC_HSD_"..tostring(objective.id)))
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Moments[objective.id].Name))
    elseif type == "FIRST_GOVERNMENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Governments[objective.id].Name))
    elseif type == "FIRST_GREAT_PERSON_CLASS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.GreatPersonClasses[objective.id].Name))
	elseif type == "FIRST_RELIGIOUS_BELIEFS" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "FIRST_TECH_RESEARCHED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Technologies[objective.id].Name))
    elseif type == "FIRST_WAR_DECLARED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "GOLD_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "GOLDEN_AGE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "GOVERNOR_IN_EVERY_CITY" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "GREAT_PEOPLE_ACTIVATED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "GREAT_PERSON_ERA_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Eras[objective.id].Name), objective.count)
    elseif type == "GREAT_PERSON_TYPE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.GreatPersonClasses[objective.id].Name), objective.count)
	elseif type == "GREAT_PERSON_TYPE_FROM_ERA" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.GreatPersonClasses[objective.id].Name), Locale.Lookup(GameInfo.Eras[objective.era].Name), objective.count)
	elseif type == "GREAT_WORK_COUNT" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
	elseif type == "GREAT_WORK_TYPE_COUNT" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.GreatWorkObjectTypes[objective.id].Name), objective.count)
    elseif type == "HAPPIEST_POPULATION" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_CITY_POPULATION" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_CULTURE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_FAITH_PER_TURN" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_GOLD_PER_TURN" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_PRODUCTION" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_TECH_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HIGHEST_TOURISM" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "HOLY_CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "LAND_AREA_HOME_CONTINENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.percent)
    elseif type == "LOYALTY_CONVERT_CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "IMPROVEMENT_COUNT" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Improvements[objective.id].Name), objective.count)
    elseif type == "IMPROVEMENT_YIELD_COUNT" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Improvements[objective.id].Name), Locale.Lookup(GameInfo.Yields[objective.yield].Name), objective.count)
    elseif type == "MAXIMUM_ALLIANCE_LEVEL_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "MINIMUM_CONTINENT_TECH_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.continent)
    elseif type == "MOMENT_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..objective.id.."_COUNT", objective.count)
    elseif type == "MOST_ACTIVE_TRADEROUTES_ALL" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_ARCTIC_TERRAIN" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_CITIES_FOLLOWING_RELIGION" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_CITIES_ON_HOME_CONTINENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_HILL_PLOTS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
	elseif type == "MOST_FRIENDS" then
		detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_OUTGOING_TRADE_ROUTES" then
        detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "MOST_TERRAIN_TYPE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Terrains[objective.id].Name))
    elseif type == "MOST_TERRAIN_CLASS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.TerrainClasses[objective.id].Name))
    elseif type == "MOST_UNIT_DOMAIN_TYPE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.id)
    elseif type == "MOST_UNIT_FORMATION_CLASS_TYPE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.UnitFormationClasses[objective.id].Name))
    elseif type == "NATURAL_WONDER_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "NUCLEAR_WEAPONS_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "NUM_CITIES_CAPITAL_RANGE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count, objective.range)
    elseif type == "NUM_CITIES_POP_SIZE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.cityNum, objective.popNum)
    elseif type == "OCCUPIED_CAPITAL_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "PROJECT_COMPLETED" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Projects[objective.id].Name))
    elseif type == "PROJECT_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Projects[objective.id].Name), objective.count)
    elseif type == "RESOURCE_MONOPOLY" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Resources[objective.id].Name), objective.percent)
    elseif type == "ROUTE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "ROUTE_TYPE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Routes[objective.id].Name), objective.count)
    elseif type == "SUZERAINTY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.count)
    elseif type == "TERRITORY_CONTROL" then
        local territoryTypeName = objective.territory:lower()
        detailsText = Locale.Lookup("LOC_HSD_"..type, territoryTypeName, objective.minimumSize)
    elseif type == "TOTAL_LAND_AREA" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, objective.percent)
	elseif type == "TRADING_POST_IN_EVERY_CITY" then
		detailsText = Locale.Lookup("LOC_HSD_"..type)
	elseif type == "TRADING_POST_WITH_ALL_PLAYERS_CONTINENT" then
		detailsText = Locale.Lookup("LOC_HSD_"..type)
    elseif type == "UNIT_CONQUER_CITY_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count)
    elseif type == "UNIT_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count)
    elseif type == "UNIT_CLASS_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.UnitPromotionClasses[objective.id].Name), objective.count)
    elseif type == "UNIT_CLASS_PROMOTION_LEVEL" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.UnitPromotionClasses[objective.id].Name), objective.count, objective.level)
    elseif type == "UNIT_KILL_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count)
	elseif type == "UNIT_KILL_ERA_DIFFERENCE" then
		detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count)
    elseif type == "UNIT_PILLAGE_COUNT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count)
    elseif type == "UNIT_PROMOTION_LEVEL" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Units[objective.id].Name), objective.count, objective.level)
    elseif type == "UNLOCK_ALL_ERA_CIVICS" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Eras[objective.id].Name))
    elseif type == "WONDER_ADJACENT_IMPROVEMENT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name), Locale.Lookup(GameInfo.Improvements[objective.improvement].Name))
    elseif type == "WONDER_BUILT" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name))
    elseif type == "WONDER_BUILT_CITIES_IN_RANGE" then
        detailsText = Locale.Lookup("LOC_HSD_"..type, Locale.Lookup(GameInfo.Buildings[objective.id].Name), objective.count, objective.range)
	elseif type == "WONDER_CONTROL_ALL" then
		detailsText = Locale.Lookup("LOC_HSD_"..type)
    else
        detailsText = "Generic victory details text for type: " .. type
    end

    return detailsText
end	

local function GetVictoryTimeLimit(victory)
	local detailsText = false
	local year = victory.year
	local yearLimit = victory.yearLimit
	local era = victory.era
	local eraLimit = victory.eraLimit
	if year then
		if year < 0 then
			year = year*(-1)
			year = tostring(year).."BC"
		elseif year >= 0 then
			year = tostring(year).."AD"
		end
		detailsText = tostring(year)
		-- Time condition only checked on year, not before
		if yearLimit and (yearLimit == "ON_YEAR") then
			detailsText = "On ".. detailsText
		else
			detailsText = "By ".. detailsText
		end
	end
	if era then
		if detailsText then
			-- Append era after year
			detailsText = detailsText..", "
		else
			-- No year
			detailsText = ""
		end
		if eraLimit and (eraLimit == "END_ERA") then
			-- Time condition only checked during the era countdown
			detailsText = detailsText.."End of "
		end
		detailsText = detailsText .. Locale.Lookup(GameInfo.Eras[era].Name)
	end
	if not detailsText then
		detailsText = ""
	end
	return detailsText
end

-- ===========================================================================
-- Constants
-- ===========================================================================
-- Victory project for the Historical Victory Mode
local PROJECT_HISTORICAL_VICTORY = GameInfo.Projects["PROJECT_HISTORICAL_VICTORY"].Index

local PADDING_GENERIC_ITEM_BG:number = 25;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local DATA_FIELD_SELECTION:string = "Selection";
local PADDING_TAB_BUTTON_TEXT:number = 27;

local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_ScienceTeamIM:table = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.ScienceViewStack);
local m_ScienceHeaderIM:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MARS_BASE"],
};
local EXOPLANET_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EXOPLANET_EXPEDITION"],
};
local SCIENCE_PROJECTS_EXP2:table = {
	EARTH_SATELLITE_EXP2_PROJECT_INFOS,
	MOON_LANDING_EXP2_PROJECT_INFOS,
	MARS_COLONY_EXP2_PROJECT_INFOS,
	EXOPLANET_EXP2_PROJECT_INFOS
};

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS_EXP2");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_4")
};

-- ===========================================================================
-- Cached Functions
-- ===========================================================================
BASE_PopulateTabs = PopulateTabs;
BASE_AddTab = AddTab;
BASE_AddExtraTab = AddExtraTab;
BASE_OnTabClicked = OnTabClicked;
BASE_PopulateGenericInstance = PopulateGenericInstance;
BASE_PopulateGenericTeamInstance = PopulateGenericTeamInstance;
BASE_GetDefaultStackSize = GetDefaultStackSize;
BASE_GetCulturalVictoryAdditionalSummary = GetCulturalVictoryAdditionalSummary;
BASE_GatherCultureData = GatherCultureDatam

g_victoryData.VICTORY_DIPLOMATIC = {
	GetText = function(p)
		local total = GlobalParameters.DIPLOMATIC_VICTORY_POINTS_REQUIRED;
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return Locale.Lookup("LOC_WORLD_RANKINGS_DIPLOMATIC_POINTS_TT", current, total);
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return current;
	end,
	AdditionalSummary = function(p) return GetDiplomaticVictoryAdditionalSummary(p) end
};

g_victoryData.VICTORY_HISTORICAL_VICTORY = {
	GetText = function(p)
		local CivilizationTypeName = PlayerConfigurations[p:GetID()]:GetCivilizationTypeName()
		local LeaderTypeName = PlayerConfigurations[p:GetID()]:GetLeaderTypeName()
		local total = 3
		local current = 0
		local hasFirstGoal = 0
		local hasSecondGoal = 0
		local hasThirdGoal = 0
		local strFirstChallenge = ""
		local strSecondChallenge = ""
		local strThirdChallenge = ""
		local VictorySummaryIntro = ""
		local nTurn = Game.GetCurrentGameTurn()
		-- Get the current player score or set to zero if doesn't exist yet
		if (p:IsAlive()) then
			current = p:GetProperty("HSD_HISTORICAL_VICTORY_SCORE")
			if current == nil then current = 0 end
		end
		local totalVictorySummary:string = ""
		-- Check if leader victories are enabled and change to the leader name instead
        local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
        local civilizationInfo = victoryConditions[p:GetID()] or {}
		local playerTypeName = CivilizationTypeName
		if civilizationInfo then
			-- Iterate through victories
			for _, victories in ipairs(civilizationInfo) do
				playerTypeName = victories.playerTypeName
				break
			end
		end
		-- if MapConfiguration.GetValue("CivilizationVictoryOnly") then
		-- 	CivilizationTypeName = LeaderTypeName
		-- end
		-- Check if player has historical victory conditions
		-- if not HSD_victoryConditionsConfig[CivilizationTypeName] then
		-- 	if HSD_victoryConditionsConfig[PlayerConfigurations[p:GetID()]:GetCivilizationTypeName()] then
		-- 		-- print("Leader not detected on historical victory list, defaulting to Civilization victory")
		-- 		CivilizationTypeName = PlayerConfigurations[p:GetID()]:GetCivilizationTypeName()
		-- 	elseif(HSD_victoryConditionsConfig[PlayerConfigurations[p:GetID()]:GetLeaderTypeName()])then
		-- 		-- print("Civilization not detected on historical victory list, defaulting to Leader victory")
		-- 		CivilizationTypeName = PlayerConfigurations[p:GetID()]:GetLeaderTypeName()
		-- 	else
		-- 		-- print("Civilization and Leader not detected on historical victory list, defaulting to Generic victory")
		-- 		CivilizationTypeName = "GENERIC"
		-- 	end
		-- end
		-- Check if the player has completed any challenges and set them to the default value if not detected
		local  firstGoal = p:GetProperty("HSD_HISTORICAL_VICTORY_1"); if firstGoal == nil then firstGoal = 0 end;
		local  secondGoal = p:GetProperty("HSD_HISTORICAL_VICTORY_2"); if secondGoal == nil then secondGoal = 0 end;
		local  thirdGoal = p:GetProperty("HSD_HISTORICAL_VICTORY_3"); if thirdGoal == nil then thirdGoal = 0 end;

		if p:GetStats():GetNumProjectsAdvanced(PROJECT_HISTORICAL_VICTORY) >= 1 or firstGoal >= 1 then hasFirstGoal = 1 end;
		if p:GetStats():GetNumProjectsAdvanced(PROJECT_HISTORICAL_VICTORY) >= 1 or secondGoal >= 1 then hasSecondGoal = 1 end;
		if p:GetStats():GetNumProjectsAdvanced(PROJECT_HISTORICAL_VICTORY) >= 1 or thirdGoal >= 1 then hasThirdGoal = 1 end;

		local completed = {}
		if hasFirstGoal + hasSecondGoal + hasThirdGoal ~= 0 then

			if hasFirstGoal == 1 then
				local projectTurn = p:GetProperty("HSD_HISTORICAL_VICTORY_1")
				if projectTurn == nil then projectTurn = nTurn end
				local projectDate:string = Calendar.MakeYearStr(projectTurn);
				strFirstChallenge = Locale.Lookup("LOC_HSD_VICTORY_COMPLETED_TOOLTIP", Locale.Lookup("LOC_HSD_VICTORY_"..tostring(playerTypeName).."_1_NAME"), projectDate)
				table.insert(completed, strFirstChallenge)
			end
			if hasSecondGoal == 1 then
				local projectTurn = p:GetProperty("HSD_HISTORICAL_VICTORY_2")
				if projectTurn == nil then projectTurn = nTurn end
				local projectDate:string = Calendar.MakeYearStr(projectTurn);
				strSecondChallenge = Locale.Lookup("LOC_HSD_VICTORY_COMPLETED_TOOLTIP", Locale.Lookup("LOC_HSD_VICTORY_"..tostring(playerTypeName).."_2_NAME"), projectDate)
				table.insert(completed, strSecondChallenge)
			end
			if hasThirdGoal == 1 then
				local projectTurn = p:GetProperty("HSD_HISTORICAL_VICTORY_3")
				if projectTurn == nil then projectTurn = nTurn end
				local projectDate:string = Calendar.MakeYearStr(projectTurn);
				strThirdChallenge = Locale.Lookup("LOC_HSD_VICTORY_COMPLETED_TOOLTIP", Locale.Lookup("LOC_HSD_VICTORY_"..tostring(playerTypeName).."_3_NAME"), projectDate)
				table.insert(completed, strThirdChallenge)
			end
		end

		table.sort(completed)

		local totalVictorySummary = VictorySummaryIntro

		for i, v in ipairs(completed) do
			totalVictorySummary = totalVictorySummary .. v
		end

		return Locale.Lookup("LOC_HSD_VICTORY_OVERALL_TOOLTIP", current, total, totalVictorySummary);
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetProperty("HSD_HISTORICAL_VICTORY_SCORE")
			if current == nil then current = 1 end
		end

		return current;
	end,
	AdditionalSummary = function(p) return GetDiplomaticVictoryAdditionalSummary(p) end
};

-- ===========================================================================
-- Overrides
-- ===========================================================================
function OnTabClicked(tabInst:table, onClickCallback:ifunction)
	return function()
		DeselectPreviousTab();
		DeselectExtraTabs();
		tabInst.Selection:SetHide(false);
		onClickCallback();
	end
end

BASE_PopulateOverallInstance = PopulateOverallInstance;
function PopulateOverallInstance(instance:table, victoryType:string, typeText:string)
	BASE_PopulateOverallInstance(instance, victoryType, typeText);

	if victoryType == "VICTORY_HISTORICAL_VICTORY" then
		color = UI.GetColorValue("COLOR_SELECTED_TEXT");
		instance.VictoryBanner:SetColor(color);
		instance.VictoryLabelGradient:SetColor(color);
	end
	if victoryType == "VICTORY_DIPLOMATIC" then
		color = UI.GetColorValue("COLOR_PLAYER_LIGHT_BLUE");
		instance.VictoryBanner:SetColor(color);
		instance.VictoryLabelGradient:SetColor(color);
	end

end


local m_iTurnsTillCulturalVictory:number = -1;

function PopulateCultureInstance(instance:table, playerData:table)
	local pPlayer:table = Players[playerData.PlayerID];

	PopulatePlayerInstanceShared(instance, playerData.PlayerID, 7);

	instance.VisitingTourists:SetText(playerData.NumVisitingUs .. "/" .. playerData.NumRequiredTourists);

	--
	-- Since Tourists can overflow now we gotta take care of that
	--

	local percentage = playerData.NumVisitingUs / playerData.NumRequiredTourists
	if percentage > 1 then percentage = 1 end

	instance.TouristsFill:SetPercent(percentage);
	instance.VisitingUsContainer:SetHide(playerData.PlayerID == g_LocalPlayerID);

	local backColor, _ = UI.GetPlayerColors(playerData.PlayerID);
	local brighterBackColor = UI.DarkenLightenColor(backColor,35,255);
	if(playerData.PlayerID == g_LocalPlayerID or g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(playerData.PlayerID)) then
		instance.DomesticTouristsIcon:SetColor(brighterBackColor);
	else
		instance.DomesticTouristsIcon:SetColor(UI.GetColorValue(1, 1, 1, 0.35));
	end
	instance.DomesticTourists:SetText(playerData.NumStaycationers);

	if(instance.TurnsTillVictory) then
		local iTurnsTillVictory:number = playerData.TurnsTillCulturalVictory;
		if iTurnsTillVictory == nil then iTurnsTillVictory = -1 end
		if(iTurnsTillVictory > 0 and iTurnsTillVictory >= m_iTurnsTillCulturalVictory) then
			instance.TurnsTillVictory:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS", iTurnsTillVictory));
			instance.TurnsTillVictory:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS_TT", iTurnsTillVictory));
			instance.TurnsTillVictory:SetHide(false);
		else
			instance.TurnsTillVictory:SetHide(true);
		end
	end

	if (g_LocalPlayer ~= nil) then
		local pLocalPlayerCulture:table = g_LocalPlayer:GetCulture();
		instance.VisitingUsTourists:SetText(pLocalPlayerCulture:GetTouristsFrom(playerData.PlayerID));
		instance.VisitingUsTourists:SetToolTipString(pLocalPlayerCulture:GetTouristsFromTooltip(playerData.PlayerID));
		instance.VisitingUsIcon:SetToolTipString(pLocalPlayerCulture:GetTouristsFromTooltip(playerData.PlayerID));
	end
end


function PopulateOverallPlayerIconInstance(instance:table, victoryType:string, teamData:table, iconSize:number)
	-- Take the player ID from the first team member who should be the only team member
	local playerID:number = Teams[teamData.TeamID][1];
	local playerData:table = teamData.PlayerData[playerID];
	if(playerData ~= nil) then
		local civIconManager = CivilizationIcon:AttachInstance(instance);
		local details:string = playerData.FirstTiebreakSummary;
		if playerData.FirstTiebreakSummary ~= playerData.SecondTiebreakSummary then
			details = details .. "[NEWLINE]" .. playerData.SecondTiebreakSummary;
		end
		if playerData.AdditionalSummary and playerData.AdditionalSummary ~= "" then
			details = details .. "[NEWLINE]" .. playerData.AdditionalSummary;
		end
		civIconManager:SetLeaderTooltip(playerID, details);
		civIconManager:UpdateIconFromPlayerID(playerID);

		local _, civIcon:string = GetCivNameAndIcon(playerID);
		instance.CivIconFaded:SetIcon(civIcon);
		local VictoryPercentage = teamData.TeamScore
		if VictoryPercentage > 1 then VictoryPercentage = 1 end
		instance.CivIcon:SetPercent(VictoryPercentage);
		instance.CivIconBacking:SetPercent(VictoryPercentage);
		--
		if victoryType == "VICTORY_HISTORICAL_VICTORY" then
			local total = 3
			local AItotal = 3
			if Players[playerID]:IsHuman() == false then total = AItotal end;
			local current = Players[playerID]:GetProperty("HSD_HISTORICAL_VICTORY_SCORE")
			if current == nil then current = 0 end
			local percentage = current/total
			if percentage > 1 then percentage = 1 end
			instance.CivIcon:SetPercent(percentage);
			instance.CivIconBacking:SetPercent(percentage);
		end
		--
		instance.TeamRibbon:SetHide(true);
		return instance;
	end
end


function PopulateGenericTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateGenericInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, true);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then

		local detailsText:string = "";
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);

		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
				local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
				if playerData ~= nil then
					civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
				end
			else
				local requirementState:string = GameEffects.GetRequirementState(requirementID);
				local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
				if requirementState == "Met" or requirementState == "AlwaysMet" then
					detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
				else
					detailsText = detailsText .. "[ICON_Bolt]";
				end
				detailsText = detailsText .. requirementDetails.ID;
			end
			instance.Details:SetText(detailsText);
		end
	else
		instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end

	instance.ButtonFrame:SetSizeY(itemSize);
end

function PopulateGenericInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	if showTeamDetails then
		local requirementSetID:number = Game.GetVictoryRequirements(Players[playerData.PlayerID]:GetTeam(), victoryType);
		if requirementSetID ~= nil and requirementSetID ~= -1 then

			local detailsText:string = "";
			local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);

			if innerRequirements ~= nil then
				for _, requirementID in ipairs(innerRequirements) do

					if detailsText ~= "" then
						detailsText = detailsText .. "[NEWLINE]";
					end

					local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
					if requirementKey == nil then requirementKey = "nil" end
						local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);
					--else
					--	local requirementText:string = nil
					--end
					if requirementText ~= nil and requirementText ~= "nil" then
						detailsText = detailsText .. requirementText;
						local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
						civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
					else
						local requirementState:string = GameEffects.GetRequirementState(requirementID);
						local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
						if requirementDetails.ID ~= nil then
							if requirementState == "Met" or requirementState == "AlwaysMet" then
								detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
							else
								detailsText = detailsText .. "[ICON_Bolt]";
							end
							detailsText = detailsText .. requirementDetails.ID;
						end
					end
				end
			else
				detailsText = "";
			end
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end

	instance.ButtonBG:SetSizeY(itemSize);
end

function PopulateHistoricalVictoryInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	local detailsText:string = "";
	local CivilizationTypeName = PlayerConfigurations[playerData.PlayerID]:GetCivilizationTypeName()
	detailsText = GetHistoricDetails(detailsText, CivilizationTypeName, playerData.PlayerID)
	instance.Details:SetText(detailsText);
	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end

	instance.ButtonBG:SetSizeY(itemSize);
end

function GetHistoricDetails(detailsText: string, CivilizationTypeName: string, PlayerID: number)
	local player = Players[PlayerID]
	local defaultTypeName = CivilizationTypeName
	local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions") or {}
	-- local victoriesForPlayer = victoryConditions[PlayerID] or {}

	-- local LeaderTypeName = HSD_victoryConditionsConfig[PlayerConfigurations[PlayerID]:GetLeaderTypeName()]
	-- local playerTypeName = LeaderTypeName

	-- Check if leader victories are enabled and change to the leader name instead
	-- if MapConfiguration.GetValue("bCivilizationVictory") then
	-- 	playerTypeName = CivilizationTypeName
	-- end

	-- Check if the CivilizationTypeName is in the list for predefined victory objectives
    -- local civilizationInfo = HSD_victoryConditionsConfig[playerTypeName] -- TODO: Delete
	local civilizationInfo = victoryConditions[PlayerID] -- TODO: Generic condition not working because players get empty tables
	if not civilizationInfo then
		if HSD_victoryConditionsConfig[PlayerConfigurations[PlayerID]:GetCivilizationTypeName()] then
			-- print("Leader not detected on historical victory list, defaulting to Civilization victory")
			defaultTypeName = PlayerConfigurations[PlayerID]:GetCivilizationTypeName()
			civilizationInfo = HSD_victoryConditionsConfig[defaultTypeName]
		elseif(HSD_victoryConditionsConfig[PlayerConfigurations[PlayerID]:GetLeaderTypeName()])then
			-- print("Civilization not detected on historical victory list, defaulting to Leader victory")
			defaultTypeName = PlayerConfigurations[PlayerID]:GetLeaderTypeName()
			civilizationInfo = HSD_victoryConditionsConfig[defaultTypeName]
		else
			-- print("Civilization and Leader not detected on historical victory list, defaulting to Generic victory")
			defaultTypeName = "GENERIC_CIVILIZATION"
			-- Don't update civilizationInfo, using generic conditions
		end
	end
    if civilizationInfo then
		-- Iterate through victories
        for i, victories in ipairs(civilizationInfo) do
			local playerTypeName = victories.playerTypeName
            local victoryType = victories.index
            local objectiveCount = #victories.objectives
			local objectiveTable = victories.objectives
            local victoryStatus = player:GetProperty("HSD_HISTORICAL_VICTORY_".. i)
			-- if not victoryStatus then victoryStatus = 0 end -- nil check
			if (g_LocalPlayer:GetDiplomacy():HasMet(PlayerID)) or (g_LocalPlayer:GetID() == PlayerID) then
				-- Display victory status
				-- detailsText = detailsText .. "[COLOR:ButtonCS]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. victoryType .. "_NAME" ) .. "[ENDCOLOR] : "
				detailsText = detailsText .. "[COLOR:ButtonCS]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. victoryType .. "_NAME" ) .. "[ENDCOLOR] : [COLOR:NeutralCS]" .. GetVictoryTimeLimit(victories) .."[ENDCOLOR]"
				if not victoryStatus then
					-- Not yet completed
					detailsText = detailsText .. "[ICON_Bolt]"
				elseif victoryStatus == -1 then
					-- Failed
					detailsText = detailsText .. "[ICON_Checkfail]"
				elseif victoryStatus >= 0 then
					-- Completed
					detailsText = detailsText .. "[ICON_Checksuccess]"
				else
					-- Unknown
					detailsText = detailsText .. "[ICON_Checkfail]"
				end
				detailsText = detailsText .. "[NEWLINE]"
			else
				-- Unknown player, display nothing
			end

			-- Iterate through individual victory objectives
			-- for j = 1, objectiveCount do
			for j, objective in ipairs(objectiveTable) do

				local objectiveStatus = player:GetProperty("HSD_HISTORICAL_VICTORY_" .. victoryType .. "_OBJECTIVE_" .. j)
				local current = 0
				local total = 0
				local objectiveMet = false

				if objectiveStatus then
					current = objectiveStatus.current
					total = objectiveStatus.total
					objectiveMet = objectiveStatus.objectiveMet
					-- print(tostring(objective.type))
					-- print("Current: " .. tostring(current))
					-- print("Total: " .. tostring(total))
					-- print("Objective Met: " .. tostring(objectiveMet))
				end

				if not objectiveStatus then objectiveStatus = 0 end -- nil check

				if (g_LocalPlayer:GetDiplomacy():HasMet(PlayerID)) or (g_LocalPlayer:GetID() == PlayerID) then
					-- Display objective status
					-- detailsText = detailsText .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. victoryType .. "_DETAILS_ROW_" .. j) .. " : "
					detailsText = detailsText .. GetObjectiveDetails(objective) .. " : "
					if not objectiveMet and ((objectiveStatus == 0) or (current <= total) or (current == "None")) then
						-- Not yet completed
						if not HideObjectiveCount[objective.type] then
							detailsText = detailsText.."[COLOR_Civ6Red] ".. Locale.Lookup("LOC_HSD_OBJECTIVE_STATUS", current, total) .."[ENDCOLOR]"
						end
						detailsText = detailsText.." [ICON_Bolt]"
					elseif objectiveMet then
						-- Completed
						if not HideObjectiveCount[objective.type] then
							detailsText = detailsText.."[COLOR_Civ6Yellow] ".. Locale.Lookup("LOC_HSD_OBJECTIVE_STATUS", current, total) .."[ENDCOLOR]"
						end
						detailsText = detailsText.." [ICON_Checksuccess]"
						-- detailsText = detailsText .."[COLOR_Civ6Yellow] ".. Locale.Lookup("LOC_HSD_OBJECTIVE_STATUS", current, total) .."[ENDCOLOR]".. " [ICON_Checksuccess]"
					else
						-- Failed
						detailsText = detailsText .. "[ICON_Checkfail]"
					end
					detailsText = detailsText .. "[NEWLINE]"
				else
					-- Unknown player, display nothing
				end
			end
        end
    else
        -- Add default logic or use default value
		for i = 1, 3 do
            local victoryType = i
			local objectiveCount = 3
            local victoryStatus = player:GetProperty("HSD_HISTORICAL_VICTORY_".. i)
			if not victoryStatus then victoryStatus = 0 end -- nil check
			-- Display generic victory status for all players
			if (g_LocalPlayer:GetDiplomacy():HasMet(PlayerID)) or (g_LocalPlayer:GetID() == PlayerID) then
				-- Display victory status
				detailsText = detailsText .. "[COLOR:ButtonCS]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. defaultTypeName .. "_" .. victoryType .. "_NAME" ) .. "[ENDCOLOR] : "
				if victoryStatus == 0 then
					-- Not yet completed
					detailsText = detailsText .. "[ICON_Bolt]"
				elseif victoryStatus == 1 then
					-- Completed
					detailsText = detailsText .. "[ICON_Checksuccess]"
				else
					-- Failed
					detailsText = detailsText .. "[ICON_Checkfail]"
				end
				detailsText = detailsText .. "[NEWLINE]"
			else
				-- Unknown player, display nothing
			end

			for i = 1, objectiveCount do
				local objectiveStatus = player:GetProperty("HSD_HISTORICAL_VICTORY_" .. victoryType .. "_OBJECTIVE_" .. i)
				if not objectiveStatus then objectiveStatus = 0 end -- nil check
				-- Only display generic objectives for the human player
				if (g_LocalPlayer:GetID() == PlayerID) then
					-- Display objective status
					detailsText = detailsText .. Locale.Lookup("LOC_HSD_VICTORY_" .. defaultTypeName .. "_" .. victoryType .. "_DETAILS_ROW_" .. i)
					if objectiveStatus == 0 then
						-- Not yet completed
						detailsText = detailsText .. "[ICON_Bolt]"
					elseif objectiveStatus == 1 then
						-- Completed
						detailsText = detailsText .. "[ICON_Checksuccess]"
					else
						-- Failed
						detailsText = detailsText .. "[ICON_Checkfail]"
					end
					detailsText = detailsText .. "[NEWLINE]"
				else
					-- Unknown player, display nothing
				end
			end
		end
    end

    return detailsText
end


-- ===========================================================================
--	Culture victory update
-- ===========================================================================
function GetCulturalVictoryAdditionalSummary(pPlayer:table)
	if (g_LocalPlayer == nil) then
		return "";
	end

	local iPlayerID:number = pPlayer:GetID();
	local pLocalPlayerCulture:table = g_LocalPlayer:GetCulture();
	local pOtherPlayerCulture:table = pPlayer:GetCulture();
	if (pLocalPlayerCulture == nil or pOtherPlayerCulture == nil) then
		return "";
	end

	local tSummaryStrings = {};

	-- Base game additional summary, if any
	local baseDetails:string = BASE_GetCulturalVictoryAdditionalSummary(pPlayer);
	if (baseDetails ~= nil and baseDetails ~= "") then
		table.insert(tSummaryStrings, baseDetails);
	end

	-- Cultural Dominance summaries

	-- This is us, show the quantity of civs we dominate or that dominate us
	if (iPlayerID == g_LocalPlayerID) then
		local iNumWeDominate:number = 0;
		local iNumDominateUs:number = 0;
		for _, iLoopID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if (iLoopID ~= g_LocalPlayerID) then
				if (pLocalPlayerCulture:IsDominantOver(iLoopID)) then
					iNumWeDominate = iNumWeDominate + 1;
				else
					local pLoopPlayerCulture = Players[iLoopID]:GetCulture();
					if (pLoopPlayerCulture ~= nil and pLoopPlayerCulture:IsDominantOver(g_LocalPlayerID)) then
						iNumDominateUs = iNumDominateUs + 1;
					end
				end
			end
		end

		if iNumWeDominate > 0 then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_NUM_WE_DOMINATE", iNumWeDominate));
		end
		if iNumDominateUs > 0 then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_NUM_DOMINATE_US", iNumDominateUs));
		end
	else
		-- Are we/they culturally dominant
		if (pLocalPlayerCulture:IsDominantOver(iPlayerID)) then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_WE_ARE_DOMINANT"));
		elseif (pOtherPlayerCulture:IsDominantOver(g_LocalPlayerID)) then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_THEY_ARE_DOMINANT"));
		end
	end

	return FormatTableAsNewLineString(tSummaryStrings);
end

-- ===========================================================================
--	Called when Science tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScience()
	ResetState(ViewScience);
	Controls.ScienceView:SetHide(false);

	ChangeActiveHeader("VICTORY_TECHNOLOGY", m_ScienceHeaderIM, Controls.ScienceViewHeader);
	PopulateGenericHeader(RealizeScienceStackSize, SCIENCE_TITLE, "", SCIENCE_DETAILS, SCIENCE_ICON);

	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0, 0, 0, 0 }; -- initialize with 3 elements
	local finishedProjects:table = { {}, {}, {}, {} };

	local bHasSpaceport:boolean = false;
	if (g_LocalPlayer ~= nil) then
		for _,district in g_LocalPlayer:GetDistricts():Members() do
			if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
				bHasSpaceport = true;
				break;
			end
		end

		local pPlayerStats:table = g_LocalPlayer:GetStats();
		local pPlayerCities:table = g_LocalPlayer:GetCities();
		for _, city in pPlayerCities:Members() do
			local pBuildQueue:table = city:GetBuildQueue();
			-- 1st milestone - satellite launch
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
			progressResults[1] = currentProgress / totalCost;

			-- 2nd milestone - moon landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
			progressResults[2] = currentProgress / totalCost;

			-- 3rd milestone - mars landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
			progressResults[3] = currentProgress / totalCost;

			-- 4th milestone - exoplanet expeditiion
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
			progressResults[4] = currentProgress / totalCost;
		end
	end

	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";
			if(nextStep == "") then
				nextStep = GetNextStepForScienceProject(g_LocalPlayer, SCIENCE_PROJECTS_EXP2[i], bHasSpaceport, finishedProjects[i]);
			end
		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. SCIENCE_REQUIREMENTS[i] .. "[NEWLINE]";
	end

	-- Final milestone - Earning Victory Points (Light Years)
	local totalLightYears:number = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();
	local lightYears = g_LocalPlayer:GetStats():GetScienceVictoryPoints();
	if (lightYears < totalLightYears) then
		progressText = progressText .. "[ICON_Bolt]";
	else
		progressText = progressText .. "[ICON_CheckmarkBlue]";
	end
	progressText = progressText .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_FINAL", totalLightYears);

	g_activeheader.AdvisorTextCentered:SetText(progressText);
    if (nextStep ~= "") then
        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP", nextStep));
	else
		-- If the user One More Turns, this keeps rolling in the DLL and makes us look goofy.
		if lightYears > totalLightYears then
			lightYears = totalLightYears;
		end

        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_HAS_MOVED", lightYears, totalLightYears));
    end

	m_ScienceIM:ResetInstances();
	m_ScienceTeamIM:ResetInstances();

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			if #team > 1 then
				PopulateScienceTeamInstance(m_ScienceTeamIM:GetInstance(), teamID);
			else
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateScienceInstance(m_ScienceIM:GetInstance(), pPlayer);
				end
			end
		end
	end

	RealizeScienceStackSize();
end

function GetNextStepForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	if(not bHasSpaceport) then
		return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name));
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(not playerTech:HasTech(tech.Index)) then
				return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name));
			end
		end

		if(not finishedProjects[i]) then
			return Locale.Lookup(projectInfo.Name);
		end
	end
	return "";
end

function PopulateScienceInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);

	-- Progress Data to be returned from function
	local progressData = nil;

	local bHasSpaceport:boolean = false;
	for _,district in pPlayer:GetDistricts():Members() do
		if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
			bHasSpaceport = true;
			break;
		end
	end

	local pPlayerStats:table = pPlayer:GetStats();
	local pPlayerCities:table = pPlayer:GetCities();
	local projectTotals:table = { 0, 0, 0, 0 };
	local projectProgresses:table = { 0, 0, 0, 0 };
	local finishedProjects:table = { {}, {}, {}, {} };
	for _, city in pPlayerCities:Members() do
		local pBuildQueue:table = city:GetBuildQueue();

		-- 1st milestone - satelite launch
		for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[1][i] = false;
			if projectProgress ~= 0 then
				projectTotals[1] = projectTotals[1] + projectCost;
				projectProgresses[1] = projectProgresses[1] + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
		end

		-- 2nd milestone - moon landing
		for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[2][i] = false;
			if projectProgress ~= 0 then
				projectTotals[2] = projectTotals[2] + projectCost;
				projectProgresses[2] = projectProgresses[2] + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
		end

		-- 3rd milestone - mars landing
		for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[3][i] = false;
			projectTotals[3] = projectTotals[3] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[3] = projectProgresses[3] + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
		end

		-- 4th milestone - exoplanet expedition
		for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[4][i] = false;
			projectTotals[4] = projectTotals[4] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[4] = projectProgresses[4] + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
		end
	end

	-- Save data to be returned
	progressData = {};
	progressData.playerID = playerID;
	progressData.projectTotals = projectTotals;
	progressData.projectProgresses = projectProgresses;
	progressData.bHasSpaceport = bHasSpaceport;
	progressData.finishedProjects = finishedProjects;

	PopulateScienceProgressMeters(instance, progressData);

	return progressData;
end

function GetTooltipForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	local result:string = "";

	-- Only show spaceport for first tooltip
	if bHasSpaceport ~= nil then
		if(bHasSpaceport) then
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name)) .. "[NEWLINE]";
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(playerTech:HasTech(tech.Index)) then
				result = result .. "[ICON_CheckmarkBlue]";
			else
				result = result .. "[ICON_Bolt]";
			end
			result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name)) .. "[NEWLINE]";
		end

		if(finishedProjects[i]) then
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup(projectInfo.Name);
		if(i < numProjectInfos) then result = result .. "[NEWLINE]"; end
	end

	return result;
end

function PopulateScienceProgressMeters(instance:table, progressData:table)
	local pPlayer = Players[progressData.playerID];

	for i = 1, 4 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(progressData.projectProgresses[i] == 0);
		instance["ObjBar_" .. i]:SetPercent(progressData.projectProgresses[i] / progressData.projectTotals[i]);
		instance["ObjToggle_ON_" .. i]:SetHide(progressData.projectTotals[i] == 0 or progressData.projectProgresses[i] ~= progressData.projectTotals[i]);
	end

    instance["ObjHidden_5"]:SetHide(true);
    -- if bar 4 is at 100%, light up bar 5
    if ((progressData.projectProgresses[4] >= progressData.projectTotals[4]) and (progressData.projectTotals[4] ~= 0)) then
		local lightYears = pPlayer:GetStats():GetScienceVictoryPoints();
		local lightYearsPerTurn = pPlayer:GetStats():GetScienceVictoryPointsPerTurn();
		local totalLightYears = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();

		instance["ObjFill_5"]:SetHide(false);
        instance["ObjToggle_ON_5"]:SetHide(lightYears == 0 or lightYears < lightYearsPerTurn);
        -- my test save returns a larger value for light years than for years needed, so guard against drawing errors
        if lightYears > totalLightYears then
            lightYears = totalLightYears;
        end
        instance["ObjBar_5"]:SetPercent(lightYears/totalLightYears);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_IS_MOVING", lightYearsPerTurn));
    else
        instance["ObjFill_5"]:SetHide(true);
        instance["ObjToggle_ON_5"]:SetHide(true);
        instance["ObjBar_5"]:SetPercent(0);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NO_LAUNCH"));
    end

	instance.ObjBG_1:SetToolTipString(GetTooltipForScienceProject(pPlayer, EARTH_SATELLITE_EXP2_PROJECT_INFOS, progressData.bHasSpaceport, progressData.finishedProjects[1]));
	instance.ObjBG_2:SetToolTipString(GetTooltipForScienceProject(pPlayer, MOON_LANDING_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[2]));
	instance.ObjBG_3:SetToolTipString(GetTooltipForScienceProject(pPlayer, MARS_COLONY_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[3]));
	instance.ObjBG_4:SetToolTipString(GetTooltipForScienceProject(pPlayer, EXOPLANET_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[4]));
end

-- ===========================================================================
--	Called once during Init
-- ===========================================================================
function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	g_ExtraTabsIM:ResetInstances();
	g_TabSupportIM:ResetInstances();

	-- Deselect previously selected tab
	if g_TabSupport then
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();
	end

	-- Create TabSupport object
	g_TabSupport = CreateTabs(Controls.TabContainer, 42, 44, UI.GetColorValueFromHexLiteral(0xFF331D05));

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);

	local p = Players[Game:GetLocalPlayer()]

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE")) then
		BASE_AddTab(TAB_SCORE, ViewScore);
	end
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		AddTab(TAB_SCIENCE, ViewScience);
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		g_CultureInst = AddTab(TAB_CULTURE, ViewCulture);
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		AddTab(TAB_DOMINATION, ViewDomination);
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		AddTab(TAB_RELIGION, ViewReligion);
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
   	local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
            if (victoryType == "VICTORY_DIPLOMATIC") then
                AddTab(Locale.Lookup("LOC_TOOLTIP_DIPLOMACY_CONGRESS_BUTTON"), function() ViewDiplomatic(victoryType); end);
            elseif (victoryType == "VICTORY_HISTORICAL_VICTORY") then
				 AddTab(Locale.Lookup(row.Name), function() ViewHistorical(victoryType); end);
            else
                AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
			end
		end
	end

	if m_TotalTabSize > (Controls.TabContainer:GetSizeX()*2) then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	Controls.ExpandExtraTabs:SetHide(true);

	g_TabSupport.SelectTab(defaultTab);
	g_TabSupport.CenterAlignTabs(0, 450, 32);
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = g_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > (Controls.TabContainer:GetSizeX() * 2) then
		g_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else
		g_TabSupport.AddTab(tabInst.Button, OnTabClicked(tabInst, onClickCallback));
	end

	return tabInst.Button;
end

function AddExtraTab(label:string, onClickCallback:ifunction)
	local extraTabInst:table = g_ExtraTabsIM:GetInstance();

	extraTabInst.Button:SetText(label);
	extraTabInst.Button:RegisterCallback(Mouse.eLClick, OnExtraTabClicked(extraTabInst, onClickCallback));

	local textControl = extraTabInst.Button:GetTextControl();
	local textSize:number = textControl:GetSizeX();
	extraTabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	extraTabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	local tabSize:number = extraTabInst.Button:GetSizeX();
	if tabSize > m_MaxExtraTabSize then
		m_MaxExtraTabSize = tabSize;
	end

	table.insert(m_ExtraTabs, extraTabInst);
end

function ViewHistorical(victoryType:string)
	ResetState(function() ViewHistorical(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
    if victoryInfo.Icon ~= nil then
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, victoryInfo.Icon);
    else
		local details = Locale.Lookup("LOC_HSD_VICTORY_INTRO")
		local player = Players[Game:GetLocalPlayer()]
		local CivilizationTypeName = PlayerConfigurations[player:GetID()]:GetCivilizationTypeName()
		local defaultTypeName = CivilizationTypeName
		local victoryConditions = Game:GetProperty("HSD_PlayerVictoryConditions")
		local civilizationInfo = victoryConditions[player:GetID()]
		local playerTypeName = defaultTypeName
		if civilizationInfo then
			-- Iterate through victories
			for _, victories in ipairs(civilizationInfo) do
				playerTypeName = victories.playerTypeName
				break
			end
		end
		details = GetHistoricHeader(details, playerTypeName)
		PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, details, ICON_GENERIC);
    end

	local genericData:table = GatherGenericData();

	g_GenericIM:ResetInstances();
	g_GenericTeamIM:ResetInstances();

	local ourData:table = {};

	for i, teamData in ipairs(genericData) do
		local ourTeamData:table = { teamData, score };

		ourTeamData.teamData = teamData;
		local progress = Game.GetVictoryProgressForTeam(victoryType, teamData.TeamID);
		if progress == nil then
			progress = 0;
		end
		ourTeamData.score = progress;

		table.insert(ourData, ourTeamData);
	end

	table.sort(ourData, function(a, b)
		return a.score > b.score;
	end);

	for i, theData in ipairs(ourData) do
		if #theData.teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(g_GenericTeamIM:GetInstance(), theData.teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			local pPlayer:table = Players[theData.teamData.PlayerData[1].PlayerID];
			if pPlayer ~= nil then
				local pStats:table = pPlayer:GetStats();
				if pStats == nil then
					UI.DataError("Stats not found for PlayerID:" .. theData.teamData.PlayerData[1].PlayerID .. "! WorldRankings XP2");
					return;
				end
				-- Unused tooltips
				-- local CivilizationTypeName = PlayerConfigurations[theData.teamData.PlayerData[1].PlayerID]:GetCivilizationTypeName()
				-- if CivilizationTypeName == "CIVILIZATION_ROME" then
					-- -- uiGenericInstance.ButtonBG:SetToolTipString("Build the Colosseum");
				-- else
					-- -- uiGenericInstance.ButtonBG:SetToolTipString("Historical Challenges Completed: " .. tostring(HSD_HISTORICAL_VICTORY_SCORE));
				-- end
			end
			PopulateHistoricalVictoryInstance(uiGenericInstance, theData.teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function GetHistoricHeader(details:string, playerTypeName:string)
	-- Check if the CivilizationTypeName of the player is in the list for historical victories
    local civilizationInfo = HSD_victoryConditionsConfig[playerTypeName]
    if civilizationInfo then
		-- Iterate three times to generate the formatted header text for each of the three victory types.
		-- Concatenate victory type name and description to the 'details' string, with proper color formatting.
		-- The names and descriptions are dynamically retrieved based on the CivilizationTypeName and the iteration index (i).
        -- for i = 1, 3 do
        --     details = details .. "[COLOR:ButtonCS]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. i .. "_NAME") .. "[ENDCOLOR][NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. i .. "_DESC") .. "[NEWLINE]"
		-- end
		for i, victories in ipairs(civilizationInfo) do
			details = details .. "[COLOR:ButtonCS]" .. Locale.Lookup("LOC_HSD_VICTORY_" .. playerTypeName .. "_" .. i .. "_NAME") .. "[ENDCOLOR] : [COLOR:NeutralCS]"..GetVictoryTimeLimit(victories).."[ENDCOLOR][NEWLINE][ICON_BULLET]"
			local objectives = victories.objectives
			for i, objective in ipairs(objectives) do
				local objectiveDetails =  GetObjectiveDetails(objective)
				details = details .. objectiveDetails .. ". "
			end
			details = details .. "[NEWLINE]"
        end
    else
        print("WARNING: GetHistoricHeader() did not detect a predefined Civilization. Using generic Civ details...")
        -- for i = 1, 3 do
        --     details = details .. Locale.Lookup("LOC_HSD_VICTORY_GENERIC_" .. i .. "_NAME") .. Locale.Lookup("LOC_HSD_VICTORY_GENERIC_" .. i .. "_DESC")
        -- end
    end

    return details
end

function ViewDiplomatic(victoryType:string)
	ResetState(function() ViewDiplomatic(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
    if victoryInfo.Icon ~= nil then
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, victoryInfo.Icon);
    else
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);
    end

	local genericData:table = GatherGenericData();

	g_GenericIM:ResetInstances();
	g_GenericTeamIM:ResetInstances();

	local ourData:table = {};

	for i, teamData in ipairs(genericData) do
		local ourTeamData:table = { teamData, score };

		ourTeamData.teamData = teamData;
		local progress = Game.GetVictoryProgressForTeam(victoryType, teamData.TeamID);
		if progress == nil then
			progress = 0;
		end
		ourTeamData.score = progress;

		table.insert(ourData, ourTeamData);
	end

	table.sort(ourData, function(a, b)
		return a.score > b.score;
	end);

	for i, theData in ipairs(ourData) do
		if #theData.teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(g_GenericTeamIM:GetInstance(), theData.teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			local pPlayer:table = Players[theData.teamData.PlayerData[1].PlayerID];
			if pPlayer ~= nil then
				local pStats:table = pPlayer:GetStats();
				if pStats == nil then
					UI.DataError("Stats not found for PlayerID:" .. theData.teamData.PlayerData[1].PlayerID .. "! WorldRankings XP2");
					return;
				end
				uiGenericInstance.ButtonBG:SetToolTipString(pStats:GetDiplomaticVictoryPointsTooltip());
			end
			PopulateGenericInstance(uiGenericInstance, theData.teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function GetDiplomaticVictoryAdditionalSummary(pPlayer:table)
	-- Add or override in expansions
	return "";
end

function GetDefaultStackSize()
    return 265;
end

-- ===========================================================================
-- Constructor
-- ===========================================================================
function Initialize()
	ToggleExtraTabs(); -- Start with extra tabs opened so DiplomaticVictory tab is visible by default
end
Initialize();

BASE_OnInit = OnInit;
function OnInit(isReload:boolean)
	BASE_OnInit(isReload);

end

function ReInitProject(playerID)
	if playerID ~= Game.GetLocalPlayer() then return end
	OnInit(true)
end

Events.CityProjectCompleted.Add(ReInitProject);