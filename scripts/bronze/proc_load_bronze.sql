EXEC bronze.load_bronze;


-- BULK INSERT
	-- A method to load data into the data warehouse
	-- Loads tons of data from files like txt or csv into a table
	-- BULK INSERT is one operation that will load all the data in one execution

-- TRUNCATE: Quickly delete all rows from a table, resetting it to an empty state.
  -- The method we used is to delete the data from a table and then load data from the source
    -- Full load: load all the data from a source
  -- The idea is to refresh the info every time we run this code. We do this in case there is new data or changes in the file.
      -- we always get the newest data. 


-- HINT: Save frequently used SQL code in stored procedures in the database.
   -- Store Procedure folder inside Programmability folder

/*
===============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=================================================================================================
Script Purpose:
	This stored procedure loads data into the 'bronze' schema from external CSV files.
	It performs the following actions:
 	 - Truncates the bronze tables before loading data.
	 - Uses the `BULK INSERT` command to load data from CSV files into bronze tables.

Parameters:
	None.
 This stored procedure accepts no parameters and returns no values.

Usage Example:
	EXEC bronze.load_bronze;
======================================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN  
	-- Track ETL Duration:
      -- Helps to identify bottlenecks, optimize performance, monitor trends, detect issues
	  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	--SQL runs the TRY block, and if it fails, it runs the CATCH block to handle the error.
	
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		--Add PRINTS: Add prints to track execution, debug issues, and understand its flow.
		PRINT '=====================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=====================================================================';
	
		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncatting Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;
	
		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, -- By placing 2, we are telling SQL to skip the first row in the file because the actual data in the file starts from the second row and on
			FIELDTERMINATOR = ',', -- Telling SQL that a comma separates each data field
			TABLOCK -- Improves performance; the data can be seen while SQL is loading it. Table will be locked while SQL is loading it
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' --DATEDIFF(): Calculates the difference between two dates; returns days, months or years
		PRINT '---------------------------------------------------------------------------------------------------'

		-- Commas: file separators in CSV file

		--Testing Quality of Bronze table
		SELECT * FROM bronze.crm_cust_info

		-- QC: Check that the data has not shifted and is in the correct columns.

		SELECT COUNT(*) FROM bronze.crm_cust_info

		SET @start_time = GETDATE();
		PRINT '>> Truncatting Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
	
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		PRINT '---------------------------------------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncatting Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		PRINT '---------------------------------------------------------------------------------------------------'

		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------------------------------';
	
		PRINT '>> Truncatting Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
	
	    SET @start_time = GETDATE();
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		PRINT '---------------------------------------------------------------------------------------------------'

		PRINT '>> Truncatting Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		SET @start_time = GETDATE();
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		PRINT '---------------------------------------------------------------------------------------------------'

		PRINT '>> Truncatting Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		SET @start_time = GETDATE();
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		PRINT '---------------------------------------------------------------------------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT '================================================='
		PRINT 'Loading Bronze Layer is Completed'; 
		PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_start_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================='
		END TRY
		-- CATCH will be executed if an error is found in the TRY code.
	BEGIN CATCH
	PRINT '================================================================'
	PRINT 'Error Occurred During Loading Bronze Layer'
	PRINT 'Error Message:' + ERROR_MESSAGE();
	PRINT 'Error Message:' + CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR)
	PRINT '================================================================'
	END CATCH
END
