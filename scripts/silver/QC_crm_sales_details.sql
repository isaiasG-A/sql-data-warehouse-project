-- Customer Sales Details (Silver)

SELECT
ls_ord_num,	
sls_prd_key,		
sls_cust_id,		
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL --QC 8 cause the date is 8 digits long
	 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- We cant CAST from INT to DATE. We need to CAST from VARCHAR to DATE\
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL --QC 8 cause the date is 8 digits long
	 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) -- We cant CAST from INT to DATE. We need to CAST from VARCHAR to DATE\
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL --QC 8 cause the date is 8 digits long
	 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) -- We cant CAST from INT to DATE. We need to CAST from VARCHAR to DATE\
END AS sls_due_dt,
sls_sales,
sls_quantity,	
sls_price		
FROM bronze.crm_sales_details

