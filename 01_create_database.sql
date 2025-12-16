-- create game database if it does not exist
IF DB_ID('starship_relaunch') IS NOT NULL
BEGIN
    ALTER DATABASE starship_relaunch SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE starship_relaunch;
END;
GO

CREATE DATABASE starship_relaunch;
GO

-- use the game database
USE starship_relaunch;
GO
