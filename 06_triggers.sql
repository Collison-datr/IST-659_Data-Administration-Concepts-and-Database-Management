USE starship_relaunch;
GO

-- Log Player Moves
CREATE OR ALTER TRIGGER trg_players_move_log
ON Players
AFTER UPDATE
AS
BEGIN
    IF UPDATE(LocationID)
    BEGIN
        DECLARE @PlayerID INT, @NewLocationID INT;
        SELECT @PlayerID = INSERTED.PlayerID, @NewLocationID = INSERTED.LocationID
        FROM INSERTED;

        PRINT 'Player ' + CAST(@PlayerID AS NVARCHAR) + ' moved to location ' + CAST(@NewLocationID AS NVARCHAR);
    END
END;
GO

-- Audit Inventory Changes
CREATE OR ALTER TRIGGER trg_inventory_audit
ON Inventory
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED)
        PRINT 'Item added to inventory.';
    IF EXISTS (SELECT * FROM DELETED)
        PRINT 'Item removed from inventory.';
END;
GO
