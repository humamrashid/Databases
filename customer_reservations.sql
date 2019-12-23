-- SQL for the Customers, Reservations tables

USE mydb;

CREATE TABLE IF NOT EXISTS Customers(CustomerId INTEGER AUTO_INCREMENT 
    PRIMARY KEY, Name VARCHAR(55));
INSERT INTO Customers(Name) VALUES('Paul Novak');
INSERT INTO Customers(Name) VALUES('Terry Neils');
INSERT INTO Customers(Name) VALUES('Jack Fonda');
INSERT INTO Customers(Name) VALUES('Tom Willis');

CREATE TABLE IF NOT EXISTS Reservations(Id INTEGER AUTO_INCREMENT
    PRIMARY KEY, CustomerId INTEGER, Day DATE);
INSERT INTO Reservations(CustomerId, Day) VALUES(1, '2009-11-22');
INSERT INTO Reservations(CustomerId, Day) VALUES(2, '2009-11-28');
INSERT INTO Reservations(CustomerId, Day) VALUES(2, '2009-11-29');
INSERT INTO Reservations(CustomerId, Day) VALUES(1, '2009-11-29');
INSERT INTO Reservations(CustomerId, Day) VALUES(3, '2009-12-2');
