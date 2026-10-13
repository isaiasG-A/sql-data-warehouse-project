--bronze.crm_prd_info QC



SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

 SELECT
 prd_id,
 prd_key,          --1: Column we need to extract from. 5: How many characters we want to extract    
 SUBSTRING(prd_key, 1, 5) AS cat_id, --Extracts a specific part of a string value.
 prd_nm,
 prd_cost,
 prd_line,
 prd_start_dt,
 prd_end_dt
 FROM bronze.crm_prd_info


 --changes made: erp: CO_RF while crm: CO-RF
   -- We need to replace the - on the ID for an underscore _

 SELECT
 prd_id,
 prd_key,          
 REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
 prd_nm,
 prd_cost,
 prd_line,
 prd_start_dt,
 prd_end_dt
 FROM bronze.crm_prd_info
 WHERE  REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')  NOT IN --Find category ID that is not in the second table "bronze.erp_px_cat_g1v2 ".
 (SELECT distinct id FROM bronze.erp_px_cat_g1v2) 
