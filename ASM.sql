Create database ASM

Use ASM;

CREATE TABLE Team (
    TeamID int identity(1, 1) PRIMARY KEY NOT NULL,
    TeamName varchar(255) NOT NULL,
    EstablishedYear int NOT NULL,
    Stadium varchar(255) NOT NULL
);

CREATE TABLE Coach (
    CoachID int identity(1, 1) PRIMARY KEY NOT NULL,
    CoachName varchar(255) NOT NULL,
    DateOfBirth Date not null,
	TeamID int foreign key references Team(TeamID),
);

CREATE TABLE Player (
    PlayerID int identity(1, 1) PRIMARY KEY NOT NULL,
    PlayerName varchar(255) NOT NULL,
    DateOfBirth Date not null,
	Position varchar(255) not null,
	Nationnality varchar(255) not null,
	JerseyNumber int not null,
	TeamID int foreign key references Team(TeamID),
);

CREATE TABLE Match (
    MatchID int identity(1, 1) PRIMARY KEY NOT NULL,
    HomeTeam varchar(255) NOT NULL,
	AwayTeam varchar(255) not null,
    MatchDate Date not null,
);

CREATE TABLE Scored (
    PlayerID int foreign key references Player(PlayerID),
	MatchID int foreign key references Match(MatchID),
	Goal int,
	GoalTime int,
	YellowCard int,
	RedCard int,
	Primary Key(PlayerID, MatchID),
);

-------------------------------------------------

-- Insert data into the "Team" table
INSERT INTO Team (TeamName, EstablishedYear, Stadium)
VALUES
    ('Team A', 1990, 'Stadium A'),
    ('Team B', 1985, 'Stadium B'),
    ('Team C', 2000, 'Stadium C');

-- Insert data into the "Coach" table
INSERT INTO Coach (CoachName, DateOfBirth, TeamID)
VALUES
    ('Coach 1', '1975-03-15', 1),
    ('Coach 2', '1980-05-20', 2),
    ('Coach 3', '1982-08-10', 3);

	-- Insert data into the "Player" table
INSERT INTO Player (PlayerName, DateOfBirth, Position, Nationnality, JerseyNumber, TeamID)
VALUES
    ('Player 1', '1995-06-25', 'Forward', 'Nationality 1', 10, 1),
    ('Player 2', '1990-02-18', 'Midfielder', 'Nationality 2', 7, 2),
    ('Player 3', '1998-12-03', 'Defender', 'Nationality 3', 5, 3),
	('Player 4', '1994-07-12', 'Goalkeeper', 'Nationality 4', 1, 1),
    ('Player 5', '1992-04-28', 'Midfielder', 'Nationality 5', 8, 1),
    ('Player 6', '1996-09-30', 'Defender', 'Nationality 6', 4, 2),
    ('Player 7', '1993-11-08', 'Forward', 'Nationality 7', 9, 2),
    ('Player 8', '1991-02-15', 'Midfielder', 'Nationality 8', 6, 3),
    ('Player 9', '1997-06-05', 'Defender', 'Nationality 9', 3, 3);

-- Insert data into the "Match" table
INSERT INTO Match (HomeTeam, AwayTeam, MatchDate)
VALUES
    ('Team A', 'Team B', '2023-10-15'),
    ('Team B', 'Team C', '2023-10-20'),
    ('Team A', 'Team C', '2023-10-25');

-- Insert data into the "Scored" table
INSERT INTO Scored (PlayerID, MatchID, Goal, GoalTime, YellowCard, RedCard)
VALUES
    (1, 1, 2, 60, 1, 0),
    (2, 2, 1, 75, 0, 1),
    (3, 3, 0, 0, 1, 0),
	(4, 1, 1, 30, 0, 0),
    (5, 2, 2, 65, 1, 0),
    (6, 3, 0, 0, 0, 0),
    (7, 1, 1, 55, 1, 0),
    (8, 2, 1, 70, 0, 0),
    (9, 3, 3, 80, 2, 1);

SELECT * FROM Team;
SELECT * FROM Coach;
SELECT * FROM Player;
SELECT * FROM Match;
SELECT * FROM Scored;

-- Filter and retrieve players born from the year 1995 and onwards
SELECT * FROM Player
WHERE YEAR(DateOfBirth) >= 1995;

-- This query retrieves player names and their team names by joining the "Player" and "Team" tables.
SELECT P.PlayerName, T.TeamName
FROM Player AS P
JOIN Team AS T ON P.TeamID = T.TeamID;

-- This query finds the sum number of goals scored per match by summing the goals from the "Scored" table and counting the matches
SELECT SUM(Goal) AS SumGoalsPerMatch
FROM Scored
GROUP BY MatchID;

-- Subquery that retrieves the names and jersey numbers of players who are part of teams established in the year 1995 or later
SELECT PlayerName, JerseyNumber, TeamID
FROM Player
WHERE TeamID IN (
    SELECT TeamID
    FROM Team
    WHERE EstablishedYear >= 1995
);

-- Trigger to check the player's age
CREATE TRIGGER Trg_PlayerYear
ON Player
After INSERT, UPDATE
AS
BEGIN
    DECLARE @CurrentDate DATE;
	DECLARE @insertDate DATE;
	DECLARE @MinPlayerAge INT;

    SET @CurrentDate = GETDATE();
	SET @MinPlayerAge = 16;
    
	select @insertDate = i.DateOfBirth
	from inserted i

    IF (YEAR(@CurrentDate) - YEAR(@insertDate) < @MinPlayerAge)
    BEGIN
        print('The player is not old enough to play')
		Rollback transaction
    END
END;

-- EX for Trigger
INSERT INTO Player (PlayerName, DateOfBirth, Position, Nationnality, JerseyNumber, TeamID)
VALUES
    ('Player 10', '2015-06-25', 'Forward', 'Nationality 10', 30, 1);


-- Function calculates the total number of goals in a match
CREATE FUNCTION GetTotalGoalsForMatch (@MatchID int)
RETURNS int
AS
BEGIN
    DECLARE @TotalGoals int;

    SELECT @TotalGoals = SUM(Goal)
    FROM Scored
    WHERE MatchID = @MatchID;

    RETURN @TotalGoals;
END;

DECLARE @MatchID int;
SET @MatchID = 1; 

SELECT dbo.GetTotalGoalsForMatch(@MatchID) AS TotalGoals;

-- Function creates a table containing players playing in a match
CREATE FUNCTION GetPlayersForMatch (@MatchID int)
RETURNS @PlayerList TABLE (
    PlayerID int,
    PlayerName varchar(255),
    DateOfBirth date,
    Position varchar(255),
    Nationnality varchar(255),
    JerseyNumber int,
    TeamID int
)
AS
BEGIN
    INSERT INTO @PlayerList
    SELECT P.PlayerID, P.PlayerName, P.DateOfBirth, P.Position, P.Nationnality, P.JerseyNumber, P.TeamID
    FROM Player AS P
    JOIN Scored AS S ON P.PlayerID = S.PlayerID
    WHERE S.MatchID = @MatchID;

    RETURN;
END;

CREATE FUNCTION GetPlayersForMatch2 (@MatchID int)
RETURNS TABLE
AS
RETURN
(
    SELECT P.PlayerID, P.PlayerName, P.DateOfBirth, P.Position, P.Nationnality, P.JerseyNumber, P.TeamID
    FROM Player AS P
    WHERE EXISTS (
        SELECT 1
        FROM Scored AS S
        WHERE P.PlayerID = S.PlayerID
        AND S.MatchID = @MatchID
    )
);

DECLARE @MatchID int;
SET @MatchID = 1; 

SELECT * FROM dbo.GetPlayersForMatch(@MatchID);
SELECT * FROM dbo.GetPlayersForMatch2(@MatchID);

-- Procedure finds players with birth years within a certain range
CREATE PROCEDURE GetPlayersByBirthYearRange
AS
BEGIN
    SELECT *
    FROM Player
    WHERE YEAR(DateOfBirth) BETWEEN 1995 AND 2000;
END;

EXEC GetPlayersByBirthYearRange;
