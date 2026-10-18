SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
	 ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female' 
     WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male' 
     WHEN TRIM(gen) = 'M' THEN 'Male'
	 ELSE 'n/a'
END as gen
FROM bronze.erp_cust_az12


--QC
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)
--------------------------------------------------------------------------------------------
-- Data Standarization & Consitency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12
