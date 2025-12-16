USE starship_relaunch;
GO

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NOT NULL
);

CREATE TABLE Connections (
    ConnectionID INT PRIMARY KEY IDENTITY(1,1),
    FromLocationID INT NOT NULL,
    ToLocationID INT NOT NULL,
    Direction NVARCHAR(50) NOT NULL
);

CREATE TABLE Items (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    LocationID INT NULL
);

CREATE TABLE Players (
    PlayerID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    LocationID INT NOT NULL,
    Health INT NOT NULL DEFAULT 100
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    PlayerID INT NOT NULL,
    ItemID INT NOT NULL
);
