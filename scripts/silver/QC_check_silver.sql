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
WHERE cst_firstname = TRIM(cst_firstname) --TRIM: Removes all leading and trailing spaces

--Solution

SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    cst_material_status,
    -- We dont want contractions in gender, full word instead of letter.
    CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
         WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
         ELSE 'n/a'
    END
    cst_create_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t
WHERE flag_last = 1;

------------------------------------------------------------------------

--QC: Check the consistency of values in low cardinality columns

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
