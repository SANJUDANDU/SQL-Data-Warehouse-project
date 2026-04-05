/*
============================================
Quality Checks and Data Cleaning in Silver Layer
===========================================
script purpose:
1. Truncating existing data: The procedure starts by truncating the target tables in the Silver layer to ensure that 
   old data is removed before new data is loaded.
2. Data transformation: The script includes various transformations such as trimming whitespace, standardizing values
   (e.g., converting, gender, marital status), and handling missing or invalid data (e.g., setting future birthdates to NULL).
3. Logging: The procedure includes print statements to log the progress of the data loading process, which can be helpful for monitoring and debugging.
   Overall, this script is a crucial part of the ETL (Extract, Transform, Load) process in a data warehouse, ensuring that the data in the Silver layer is clean,
   consistent, and ready for analysis.

   usage notes:
   - Ensure that the Bronze layer tables are populated with data before executing this procedure, 
   as it relies on the data in those tables to load into the Silver layer.
   EXEC Silver.Load_Silver;
-----------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE Silver.Load_Silver AS
BEGIN

DECLARE @start_time DATETIME, @end_time DATETIME;
		BEGIN TRY
			PRINT'=====================================';
			PRINT 'Loading data into Silver tables...';
			PRINT'=====================================';

			PRINT'------------------------------------------------';
			PRINT 'Loading CRM TABLES';
			PRINT'------------------------------------------------';


TRUNCATE TABLE Silver.crm_cust_info;
SET @start_time= GETDATE();
PRINT '>>Truncating Bronze.crm_cust_info';
INSERT INTO Silver.crm_cust_info(
       Cst_id
      ,Cst_Key
      ,Cst_FirstName
      ,Cst_LastName
      ,Cst_Material_Status
      ,Cst_Gender
      ,Cst_Create_Date
)

SELECT 
Cst_id,
Cst_Key,
TRIM(Cst_FirstName) AS Cst_FirstName,
TRIM(Cst_LastName) AS Cst_LastName,

CASE WHEN UPPER(TRIM(Cst_Material_Status)) ='S' THEN 'Single'
	 WHEN UPPER(TRIM(Cst_Material_Status)) = 'M' THEN 'Married'
	 ELSE 'N/A'
END Cst_Material_Status,

CASE WHEN UPPER(TRIM(Cst_Gender)) ='F' THEN 'Female'
	 WHEN UPPER(TRIM(Cst_Gender)) = 'M' THEN 'Male'
	 ELSE 'N/A'
END Cst_Gender,
Cst_Create_Date
FROM (
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY  Cst_id ORDER BY cst_Create_Date DESC) AS Flag_Last
FROM Bronze.crm_cust_info
)t
WHERE FLAG_LAST= 1;

SELECT * FROM Silver.crm_cust_info;
            PRINT'------------------------------------------------';
			PRINT 'Loading ERP TABLES';
			PRINT'------------------------------------------------';

TRUNCATE TABLE Silver.erp_cust_az12

INSERT INTO Silver.erp_cust_az12 (
            cid,
            bdate,
            Gen
)
SELECT 
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
            ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() THEN NULL
         ELSE bdate
    END AS bdate,
    CASE  WHEN  UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
          WHEN  UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
          ELSE 'N/A'
    END AS gen
  FROM Bronze.erp_cust_az12



--SELECT * FROM Silver.erp_cust_az12

TRUNCATE TABLE Silver.erp_LOC_A101
INSERT INTO Silver.erp_LOC_A101 (
            CID,
            Country
)
SELECT
      REPLACE (CID ,'-' , '') AS CID,
      CASE WHEN TRIM(COUNTRY) = 'DE' THEN 'Germany'
           WHEN TRIM(COUNTRY) IN ('US', 'USA')  THEN 'United States'
           WHEN TRIM(COUNTRY) = '' OR COUNTRY IS NULL THEN 'N/A'
           ELSE TRIM(Country)
           END AS COUNTRY
FROM Bronze.erp_LOC_A101 

TRUNCATE TABLE Silver.erp_PX_CAT_G1V2
INSERT INTO Silver.erp_PX_CAT_G1V2 (
            ID,
            Cat,
            SubCat,
            Maintainence
)
SELECT
ID,
Cat,
SubCat,
Maintainence
FROM Bronze.erp_PX_CAT_G1V2

--SELECT * FROM Silver.erp_PX_CAT_G1V2
END
  


