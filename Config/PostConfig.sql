-----------------------------------------------
-- GameModePlayerItemOverrides
-----------------------------------------------
	
-- Historical Victories List

INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName1 FROM CivilizationVictories WHERE Civilization = LeaderType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);
	
INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER_2', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName2 FROM CivilizationVictories WHERE Civilization = LeaderType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);
	
INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER_3', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName3 FROM CivilizationVictories WHERE Civilization = LeaderType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);

INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName1 FROM CivilizationVictories WHERE Civilization = CivilizationType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = CivilizationType) AND NOT EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);
	
INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER_2', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName2 FROM CivilizationVictories WHERE Civilization = CivilizationType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = CivilizationType) AND NOT EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);
	
INSERT OR REPLACE INTO GameModePlayerItemOverrides (GameModeType, Domain, CivilizationType, LeaderType, Type, Icon, Name, Description, SortIndex)
	SELECT	'GAMEMODE_HISTORICAL_VICTORY', Domain, CivilizationType, LeaderType, 'HSD_HISTORICAL_VICTORY_PLAYER_3', 'ICON_GAMEMODE_HISTORICAL_VICTORY', "LOC_HSD_HISTORICAL_VICTORY_NAME", (SELECT VictoryName3 FROM CivilizationVictories WHERE Civilization = CivilizationType), 7
	FROM Players WHERE Domain='Players:Expansion2_Players' AND EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = CivilizationType) AND NOT EXISTS (SELECT * FROM CivilizationVictories WHERE Civilization = LeaderType);