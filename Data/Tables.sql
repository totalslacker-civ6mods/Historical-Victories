-----------------------------------------------
-- Create Tables
-----------------------------------------------

CREATE TABLE IF NOT EXISTS CivilizationVictories (	
	Civilization TEXT NOT NULL UNIQUE,
	VictoryName1 TEXT NOT NULL,
	VictoryName2 TEXT NOT NULL,
	VictoryName3 TEXT NOT NULL
	);