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
-------------------------------------------------------------------------------------------------------
--Solution

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_material_status,
    cst_gndr,
    cst_create_date)

SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
     CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
          WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'  
          ELSE 'n/a'
     END cst_material_status,
    -- We dont want contractions in gender, full word instead of letter.
    CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
         WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
         ELSE 'n/a'
    END cst_gndr,
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



-- Quality of Silver: Re-run the quality queries check queries from the bronze layer to verify the quality of data in the silver layer

--1. Check for duplicated IDs
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--2. Check for unwanted spaces
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--3. Data Standarization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

--Final Look
SELECT * FROM silver.crm_cust_info
