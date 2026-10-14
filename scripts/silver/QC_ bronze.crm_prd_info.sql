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
   -- The ID in the category table 'bronze.erp_px_cat_g1v2', is the same as the first 5 characters of the product info table 'bronze.erp_px_cat_g1v2'

 SELECT
 prd_id,
 prd_key,          
        --SUBSTRING: Extracts a specific part of a string value	
				        -- 1. column we want to extract from, 2. Position from the column we want to extract, 3. Number of characters that we want to extract
						            -- Replacing score with underscore so IDs can match between the two tables,
 REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
 SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- product key is needed so we can connect this table with 'sales details' table
 prd_nm,
 prd_cost,
 prd_line,
 prd_start_dt,
 prd_end_dt
 FROM bronze.crm_prd_info                
   

   /* QC  Check
  Filters our unmatched data after applying transformation
    WHERE  REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')  NOT IN --Find category ID that is not in the second table "bronze.erp_px_cat_g1v2 ".
     (SELECT distinct id FROM bronze.erp_px_cat_g1v2) 
   */
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 SELECT *  FROM bronze.erp_px_cat_g1v2
 SELECT * FROM bronze.crm_prd_info
 SELECT * FROM bronze.crm_sales_details


 --video: https://youtu.be/SSKVgrwhzus?t=92964
