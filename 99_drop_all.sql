USE master;
GO

IF DB_ID('starship_relaunch') IS NOT NULL
BEGIN
    ALTER DATABASE starship_relaunch SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE starship_relaunch;
END;
GO
