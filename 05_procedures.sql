USE starship_relaunch;
GO

-- Look Around
CREATE OR ALTER PROCEDURE usp_lookAround
    @PlayerID INT
AS
BEGIN
    DECLARE @LocationID INT;
    SELECT @LocationID = LocationID FROM Players WHERE PlayerID = @PlayerID;

    SELECT Name, Description FROM Locations WHERE LocationID = @LocationID;

    SELECT Direction, L.Name AS Destination
    FROM Connections C
    JOIN Locations L ON C.ToLocationID = L.LocationID
    WHERE C.FromLocationID = @LocationID;

    SELECT Name, Description
    FROM Items
    WHERE LocationID = @LocationID;
END;
GO

-- Move Player
CREATE OR ALTER PROCEDURE usp_movePlayer
    @PlayerID INT,
    @Direction NVARCHAR(50)
AS
BEGIN
    DECLARE @CurrentLocationID INT, @NewLocationID INT;

    SELECT @CurrentLocationID = LocationID FROM Players WHERE PlayerID = @PlayerID;

    SELECT @NewLocationID = ToLocationID
    FROM Connections
    WHERE FromLocationID = @CurrentLocationID AND Direction = @Direction;

    IF @NewLocationID IS NOT NULL
    BEGIN
        UPDATE Players SET LocationID = @NewLocationID WHERE PlayerID = @PlayerID;
        EXEC usp_lookAround @PlayerID;
    END
    ELSE
    BEGIN
        PRINT 'You cannot go that way.';
    END
END;
GO

-- Pick Up Item
CREATE OR ALTER PROCEDURE usp_pickUpItem
    @PlayerID INT,
    @ItemID INT
AS
BEGIN
    DECLARE @LocationID INT, @ItemLocationID INT;

    SELECT @LocationID = LocationID FROM Players WHERE PlayerID = @PlayerID;
    SELECT @ItemLocationID = LocationID FROM Items WHERE ItemID = @ItemID;

    IF @LocationID = @ItemLocationID
    BEGIN
        INSERT INTO Inventory (PlayerID, ItemID) VALUES (@PlayerID, @ItemID);
        UPDATE Items SET LocationID = NULL WHERE ItemID = @ItemID;
        PRINT 'Item picked up successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Item is not in this location.';
    END
END;
GO
