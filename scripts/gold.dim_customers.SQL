
/*--TIP: After Joining table, check if any duplicates were introduced by the join logic.

SELECT cst_id, COUNT(*) FROM
	(
	T GROUP BY cst_id
HAVING COUNT(*) > 1 --Finding any duplicates
*/

-- Rename columns to friendly, meaningful names
 /* General Principles
     - Naming Conventions: Use snake_case, with lowercase letters and underscores (_) to separate words.
	 - Language: Use English for all names.
	 - Avoid Reserved Words: Do not use SQL reserved words as object names.
 */

 -- Surrogate Key: System-generated unique identifier assigned to each record in a table.
     -- Only used to connect our data model and not depend always 
--Objects in GOLD layer are going to be virtual. So we will use a VIEW

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_material_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender
			ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ci.cst_create_date AS create_date,
	ca.bdate AS birthday,
	la.cntry AS country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
	
