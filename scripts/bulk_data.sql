-- BULK INSERT
	-- A method to load data into the data warehouse
	-- Loads tons of data from files like txt or csv into a table
	-- BULK INSERT is one operation that will load all the data in one execution
	 
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Isaias\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2, -- By placing 2, we are telling SQL to skip the first row in the file because the actual data in the file starts from the second row and on
	FIELDTERMINATOR = ',', -- Telling SQL that each data is separated by a comma
	TABLOCK -- Performace keyword where the data can be seen while SQL is loading it. Table will be locked while SQL is loading it
);

-- Commas: file separators in csv file

--Testing Quality of Bronze table
SELECT * FROM bronze.crm_cust_info
