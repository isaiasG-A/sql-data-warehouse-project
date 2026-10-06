

/* --Header comments must be added at the start of each script

=====================================================================\
Create Database 'DataWarehouse' & Schemas
=====================================================================
Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the datbase: 'bronze', 'silver', and 'gold'
*/


/*  WARNING
 - Running this script will drop the entire 'DataWarehouse' database if it exists.
   All data in the database will be permanently deletes. Proceed with caution and ensure you have
   proper backups before running this script.


*/

 -- switch to database master
USE master;
GO

-- DROP and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-----------------------------------------------------------------------------------------------------------------

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- 1. Create Schemas: Folder/container to keep things organized
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO --GO: separate baches when working with multiple SQL statements.
