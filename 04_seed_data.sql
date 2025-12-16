USE starship_relaunch;
GO

-- Insert Locations
INSERT INTO Locations (Name, Description) VALUES
('Bridge', 'The command center of the starship.'),
('Engine Room', 'Where the ship’s power core hums.'),
('Cargo Bay', 'Storage area filled with supplies.');

-- Insert Connections
INSERT INTO Connections (FromLocationID, ToLocationID, Direction) VALUES
(1, 2, 'south'), (2, 1, 'north'),
(2, 3, 'east'), (3, 2, 'west');

-- Insert Items
INSERT INTO Items (Name, Description, LocationID) VALUES
('Wrench', 'A sturdy tool for repairs.', 2),
('Medkit', 'Restores health.', 3);

-- Insert Player
INSERT INTO Players (Name, LocationID, Health) VALUES
('Captain', 1, 100);
