-- SQL for the Books table

USE mydb;

CREATE TABLE IF NOT EXISTS Books(Id INTEGER PRIMARY KEY, 
    Title VARCHAR(100), Author VARCHAR(60));
INSERT INTO Books VALUES(1,'War and Peace','Leo Tolstoy');
INSERT INTO Books VALUES(2,'The Brothers Karamazov','Fyodor Dostoyevsky');
INSERT INTO Books VALUES(3,'Paradise Lost','John Milton');
INSERT INTO Books VALUES(4,'Crime and Punishment','Fyodor Dostoyevsky');
INSERT INTO Books VALUES(5,'Cousin Bette','Honore de Balzac');
