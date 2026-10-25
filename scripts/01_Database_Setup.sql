
/*
=====================================================================\
Create Database 'RME_Operations_DW' & Schemas
=====================================================================
Script Purpose:
	This script creates a new database named 'RME_Operations_DW' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', and 'gold'


WARNING
	 - Running this script will drop the entire 'RME_Operations_DW'' database if it exists.
   All data in the database will be permanently deleted. Proceed with caution and ensure you have
   proper backups before running this script.
*/


USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RME_Operations_DW')
BEGIN
	ALTER DATABASE RME_Operations_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE RME_Operations_DW;
END;
GO


-- Create the database
CREATE DATABASE RME_Operations_DW;
GO

USE RME_Operations_DW;
GO


-- Create Medallion Architecture schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO 

CREATE SCHEMA gold;
GO
