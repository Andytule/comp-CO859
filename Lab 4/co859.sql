/*******************************************************
Script: co859.sql
Author: Andy Le
Date: Oct 07, 2020
Description: Create co859 Database objects for Dr. Darla
I, Andy Le, student number 000805099, certify that this material is my originl work.
No other person's work has been used withut due acknowledgement and i have not
made my work available to anyone else
********************************************************/

-- Setting NOCOUNT ON suppresses completion messages for each INSERT
SET NOCOUNT ON

-- Set date format to year, month, day
SET DATEFORMAT ymd;

-- Make the master database the current database
USE master

-- If database co859 exists, drop it
IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'co859')
  DROP DATABASE co859;
GO

-- Create the co859 database
CREATE DATABASE co859;
GO

-- Make the co859 database the current database
USE [shiki's_shoe];

-- Create dental_services table
CREATE TABLE shiki_shoe_services (
  service_id INT PRIMARY KEY, 
  service_description VARCHAR(25), 
  service_type CHAR(1) CHECK (service_type IN ('A', 'B')), 
  price MONEY,
  sales_ytd MONEY); 

-- Create sales table
CREATE TABLE sales (
	sales_id INT PRIMARY KEY, 
	sales_date DATE, 
	amount MONEY, 
	service_id INT FOREIGN KEY REFERENCES shiki_shoe_services(service_id));
GO

-- Insert dental_services records
INSERT INTO shiki_shoe_services VALUES(100, 'Shoe Clean', 'B', 20.00, 120.00);
INSERT INTO shiki_shoe_services VALUES(200, 'Protective Treatment', 'B', 15.00, 90.00);
INSERT INTO shiki_shoe_services VALUES(300, 'Sole Swap', 'B', 25.00, 150.00);
INSERT INTO shiki_shoe_services VALUES(400, 'Air Paint', 'A', 35.00, 210.00);
INSERT INTO shiki_shoe_services VALUES(500, 'Custom Paint Design', 'A', 50.00, 300.00);

-- Insert sales records 
INSERT INTO sales VALUES(1, '2020-09-09', 25.00, 300);
INSERT INTO sales VALUES(2, '2020-09-09', 20.00, 100);
INSERT INTO sales VALUES(3, '2020-09-09', 25.00, 300);
INSERT INTO sales VALUES(4, '2020-09-09', 15.00, 200);
INSERT INTO sales VALUES(5, '2020-09-10', 35.00, 400);
INSERT INTO sales VALUES(6, '2020-09-10', 15.00, 200);
INSERT INTO sales VALUES(7, '2020-09-10', 50.00, 500);
INSERT INTO sales VALUES(8, '2020-09-11', 20.00, 100);
INSERT INTO sales VALUES(9, '2020-09-11', 35.00, 400);
INSERT INTO sales VALUES(10, '2020-09-11', 25.00, 300);
INSERT INTO sales VALUES(11, '2020-09-12', 50.00, 500);
INSERT INTO sales VALUES(12, '2020-09-14', 20.00, 100);
INSERT INTO sales VALUES(13, '2020-09-14', 35.00, 400);
INSERT INTO sales VALUES(14, '2020-09-15', 15.00, 200);
INSERT INTO sales VALUES(15, '2020-09-16', 50.00, 500);
INSERT INTO sales VALUES(16, '2020-09-16', 20.00, 100);
INSERT INTO sales VALUES(17, '2020-09-16', 50.00, 500);
INSERT INTO sales VALUES(18, '2020-09-17', 25.00, 300);
INSERT INTO sales VALUES(19, '2020-09-17', 20.00, 100);
INSERT INTO sales VALUES(20, '2020-09-18', 35.00, 400);
INSERT INTO sales VALUES(21, '2020-09-19', 25.00, 300);
INSERT INTO sales VALUES(22, '2020-09-19', 50.00, 500);
INSERT INTO sales VALUES(23, '2020-09-20', 25.00, 300);
INSERT INTO sales VALUES(24, '2020-09-20', 15.00, 200);
INSERT INTO sales VALUES(25, '2020-09-20', 50.00, 500);
INSERT INTO sales VALUES(26, '2020-09-20', 15.00, 200);
INSERT INTO sales VALUES(27, '2020-09-21', 35.00, 400);
INSERT INTO sales VALUES(28, '2020-09-22', 20.00, 100);
INSERT INTO sales VALUES(29, '2020-09-23', 35.00, 400);
INSERT INTO sales VALUES(30, '2020-09-23', 15.00, 200);
GO

-- Create index for shoe services
CREATE INDEX IX_shiki_shoe_services_service_description
ON shiki_shoe_services (service_description);
GO

-- Create view for services with price greater than average
CREATE VIEW high_end_services
AS
SELECT SUBSTRING(service_description, 1, 25) AS shoe_service, sales_ytd
FROM shiki_shoe_services
WHERE price > (SELECT AVG(price) FROM shiki_shoe_services);
GO

-- Verify inserts
CREATE TABLE verify (
  table_name varchar(30), 
  actual INT, 
  expected INT);
GO

INSERT INTO verify VALUES('shiki_shoe_services', (SELECT COUNT(*) FROM shiki_shoe_services), 5);
INSERT INTO verify VALUES('sales', (SELECT COUNT(*) FROM sales), 30);
PRINT 'Verification';
SELECT table_name, actual, expected, expected - actual discrepancy FROM verify;
DROP TABLE verify;
GO