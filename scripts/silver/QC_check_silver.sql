-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No result
-- We select the newest record if we had to pick from duplicated data.


SELECT
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

----------------------------------------------------------------------------------------------------------------------------------------------

SELECT
*
FROM bronze.crm_cust_info
WHERE cst_id = 29449;
-------------------------------------------------------------------------------

-- ROW_NUMBER()
    -- Assigns a unique numer to each row in a result set, based on a defined order.

SELECT
*
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
)t WHERE flag_last = 1

------------------------------------------------------------------------------------------------

--QC: Check for unwanted spaces in string values.

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
