-- Customer Sales Details (Silver)
PRINT '>> Truncating Table: silver.crm_sales_details'
TRUNCATE TABLE silver.crm_sales_details
PRINT '>> Inserting Table: silver.crm_sales_details'
INSERT INTO silver.crm_sales_details (
	ls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price	
)
SELECT
ls_ord_num,	
sls_prd_key,		
sls_cust_id,		
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL --QC 8 cause the date is 8 digits long
	 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- We can't CAST from INT to DATE. We need to CAST from VARCHAR to DATE
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
	 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
	 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
END AS sls_due_dt,
CASE WHEN sls_sales <=0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)  --ABS(): Returns a absolute value of a number. Converts negative to positive
	   THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
sls_quantity,	
CASE WHEN sls_price IS NULL OR sls_price <= 0
	   THEN sls_sales / NULLIF(sls_quantity, 0) -- We don't want a 0 or the code will break. We replace 0 with NULL
	 ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details

SELECT * FROM silver.crm_sales_details

---------------------------------------------------------------------------------------------------------------------------------------------

--Order Date must always be earlier than the Shipping Date or Due Date
-- Business Rule: 
   -- ∑ Sales = Quantity * Price
   -- X Negative, Zeros, Nulls are Not Allowed!

   --Before making changes to the data, ask the experts how to proceed and how the data is supposed to be.
--For this project: If Sales is negative, zero, or null, derive it using Quantity and Price.
  -- If Price is zero or null, calculate it using Sales and Quantity.
  -- If Price is negative, convert it to a positive value.

SELECT
sls_sales AS old_sls_sales,  
sls_price AS old_sls_price,
sls_quantity,
CASE WHEN sls_sales <=0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)  --ABS(): Returns a absolute value of a number. Converts negative to positive
	   THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
	   THEN sls_sales / NULLIF(sls_quantity, 0) -- We don't want a 0, or the code will break. We replace 0 with NULL
	 ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details


WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

