-- SQL for the Cars table

USE mydb;
CREATE TABLE IF NOT EXISTS Cars(Id INTEGER PRIMARY KEY, Name VARCHAR(50), 
Cost INTEGER);
INSERT INTO Cars VALUES(1,'Audi',52642);
INSERT INTO Cars VALUES(2,'Mercedes',57127);
INSERT INTO Cars VALUES(3,'Skoda',9000);
INSERT INTO Cars VALUES(4,'Volvo',29000);
INSERT INTO Cars VALUES(5,'Bentley',350000);
INSERT INTO Cars VALUES(6,'Citroen',21000);
INSERT INTO Cars VALUES(7,'Hummer',41400);
INSERT INTO Cars VALUES(8,'Volkswagen',21600);