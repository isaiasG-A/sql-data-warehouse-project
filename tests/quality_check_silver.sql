/*
=========================================================================================================
Quality Checks
=======================================================================================================

Scripts Purpose:
	This script performs various quality checks for data consistency, accuracy, and standardization across the 'silver' schema. It includes checks for:
	 - Null or duplicate primary keys.
	 - Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading the Silver Layer.
	- Investigate and resolve any discrepancies found during the checks.
====================================================================================================================================================================
*/
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-----------------------------------------------------------------------------------------------------

-- Check for unwanted Spaces
-- Expectation: No Results

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

------------------------------------------------------------------------------------------------------

--Check for NULLs or Negative Numbers
-- Expectation: No results

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

----------------------------------------------------------------------------------------------------------

-- Check for invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--------------------------------------------------------------------------------------------------------------

-- Data Standarization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info
