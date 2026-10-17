--Quality Checks
-- Check for Nulls or Duplicates in Priary Key
-- Expectation: No Result

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

--------------------------------------------------------------------------------------------------------------

-- Data Standarization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info
