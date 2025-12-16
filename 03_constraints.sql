USE starship_relaunch;
GO

ALTER TABLE Connections
ADD CONSTRAINT FK_Connections_From FOREIGN KEY (FromLocationID) REFERENCES Locations(LocationID),
    CONSTRAINT FK_Connections_To FOREIGN KEY (ToLocationID) REFERENCES Locations(LocationID);

ALTER TABLE Items
ADD CONSTRAINT FK_Items_Location FOREIGN KEY (LocationID) REFERENCES Locations(LocationID);

ALTER TABLE Players
ADD CONSTRAINT FK_Players_Location FOREIGN KEY (LocationID) REFERENCES Locations(LocationID);

ALTER TABLE Inventory
ADD CONSTRAINT FK_Inventory_Player FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    CONSTRAINT FK_Inventory_Item FOREIGN KEY (ItemID) REFERENCES Items(ItemID);
