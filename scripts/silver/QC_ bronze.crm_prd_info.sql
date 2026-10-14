--bronze.crm_prd_info QC



SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 --changes made: erp: CO_RF while crm: CO-RF
   -- We need to replace the - in the ID with an underscore _
   -- The ID in the category table 'bronze. erp_px_cat_g1v2 ' is the same as the first 5 characters of the product info table 'bronze.erp_px_cat_g1v2'

 SELECT
 prd_id,
 prd_key,          
        --SUBSTRING: Extracts a specific part of a string value	
				        -- 1. column we want to extract from, 2. Position from the column we want to extract, 3. Number of characters that we want to extract
						            -- Replacing score with underscore so IDs can match between the two tables,
 REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
 SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- product key is needed so we can connect this table with 'sales details' table
 prd_nm,
 ISNULL(prd_cost, 0) AS prd_cost, --Instead of displaying a NULL, we will display 0. --If there were negative numbers, we will also adjust the query to not display it
 --Quick CASE WHEN: Ideal for simple value mapping
  -- If there are complex conditions, then this simple CASE/WHEN is not going to work
 CASE UPPER (TRIM(prd_line))
	  WHEN 'M' THEN 'Mountain' -- Full names instead of having abbreviations. UPPER & TRIM are used to make sure we are selecting the data correctly
	  WHEN 'S' THEN 'Mountain'
	  WHEN 'T' THEN 'Touring'
	  ELSE 'n/a'
END AS prd_line,
 prd_start_dt,
 prd_end_dt
 FROM bronze.crm_prd_info                
   

   /* QC  Check
  Filters our unmatched data after applying transformation
    WHERE  REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')  NOT IN --Find category ID that is not in the second table "bronze.erp_px_cat_g1v2 ".
     (SELECT distinct id FROM bronze.erp_px_cat_g1v2) 
   */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT *  FROM bronze.erp_px_cat_g1v2
 SELECT * FROM bronze.crm_prd_info
 SELECT * FROM bronze.crm_sales_details


 --video: https://youtu.be/SSKVgrwhzus?t=93138
