-- Table definitions for the tournament project.

-- Delete the table/view if it exists
DROP VIEW IF EXISTS evenrows;
DROP VIEW IF EXISTS oddrows;
DROP VIEW IF EXISTS even;
DROP VIEW IF EXISTS odd;
DROP VIEW IF EXISTS rows;
DROP VIEW IF EXISTS stand;
DROP VIEW IF EXISTS countmatch;
DROP VIEW IF EXISTS rank;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Players;

-- Create table Players
CREATE TABLE Players(
id SERIAL PRIMARY KEY,
fullname TEXT
);

-- Create table Matches
CREATE TABLE Matches(
winner INTEGER REFERENCES Players (id),
loser INTEGER REFERENCES Players (id)
);

-- Create some Views

-- Create a View which shows id and fullname of players in order of the number of the wins.
CREATE VIEW rank as SELECT id,fullname,count(winner) as wins from players left join matches on id=winner group by id order by wins desc;

-- Create a View which shows  each player and how many matches he did
CREATE VIEW countmatch as SELECT id, count(id) as matches from players right join matches on id=winner or id=loser group by id order by matches;

-- Create a View which shows rank and countmatch toghether
CREATE VIEW stand as SELECT rank.id,fullname,wins,coalesce(matches,0) as matches from countmatch right join rank on rank.id=countmatch.id order by wins desc;

-- Create a View which contain id and fullname from stand and another coloumn "row" that number the rows
CREATE VIEW rows as SELECT row_number() over() as row, id, fullname from stand;

-- Create a View which take the odd rows from rows
CREATE VIEW odd as SELECT id,fullname from rows where (row % 2) = 1;

-- Create a View which take the even rows from rows
CREATE VIEW even as SELECT id,fullname from rows where (row % 2) = 0;

-- Create a View which is odd plus a column that number the rows
CREATE VIEW oddrows as SELECT row_number() over() as row, id, fullname from odd;

-- Create a View which is even plus a column that number the rows
CREATE VIEW evenrows as SELECT row_number() over() as row, id, fullname from even;
