-- BULK INSERT
	-- A method to load data into the data warehouse
	-- Loads tons of data from files like txt or csv into a table
	-- BULK INSERT is one operation that will load all the data in one execution

-- TRUNCATE: Quickly delete all rows from a table reseting it to an empty state.
  -- The method we used is to delete the data from a table and then load data from th source
    -- Full load: load all the data from a source
  -- The idea is to refresh the info everytime we run this code. We do this so in case new data or changes in the file.
      -- we always get the newest data. 
      
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2, -- By placing 2, we are telling SQL to skip the first row in the file because the actual data in the file starts from the second row and on
	FIELDTERMINATOR = ',', -- Telling SQL that each data is separated by a comma
	TABLOCK -- Improves Performace, keyword where the data can be seen while SQL is loading it. Table will be locked while SQL is loading it


)

-- Commas: file separators in csv file

--Testing Quality of Bronze table
SELECT * FROM bronze.crm_cust_info

-- QC: Check that the data has not shifted and is in the correct columns.

SELECT COUNT(*) FROM bronze.crm_cust_info




TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK 
)

TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)


TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Admin\Desktop\SQL Warehouse project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)
