--Create database 'DataWarehouse'--

use master;
--CREATE DATABASE 'DataWarehouse'--

create database DataWarehouse;

USE DataWarehouse;
GO
--CREATING SCHEMAS--

CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO


--Creating DDL for bronze layer--
--Creating table for crm.cust.info--

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

Create table bronze.crm_cust_info(
		Cst_id INT,
		Cst_Key NVARCHAR(50),
		Cst_FirstName NVARCHAR(50),
		Cst_LastName NVARCHAR(50),
		Cst_Material_Status NVARCHAR(50),
		Cst_Gender NVARCHAR(50),
		Cst_Create_Date DATE
);

--Creating table for crm.prod.info

IF OBJECT_ID('bronze.crm_prod_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prod_info;

Create table bronze.crm_prod_info(
		Prd_id  INT,
		Prd_Key  NVARCHAR(50),
		Prd_Nm  NVARCHAR(50),
		Prd_cost  INT,
		Prd_Line NVARCHAR(50),
		Prd_Start_Dt DATETIME,
		Prd_End_Dt DATETIME
	);

--Creating table for crm.sales.info

IF OBJECT_ID('bronze.crm_sales_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_info;

Create table bronze.crm_sales_info(
	sales_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

--Creating table for erp.cust.az12

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE Bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	Gen NVARCHAR(50)
	);

--Creating table for erp.loc.a101

IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;

CREATE TABLE Bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	Country NVARCHAR(50)
);

--Creating table for erp.PX_CAT_G1V2

IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2;


CREATE TABLE Bronze.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	Cat NVARCHAR(50),
	SubCat NVARCHAR(50),
	Maintainence NVARCHAR(50)
);
-----------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[Load_Bronze_Tables] AS
BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME;
		BEGIN TRY
			PRINT'=====================================';
			PRINT 'Loading data into Bronze tables...';
			PRINT'=====================================';

			PRINT'------------------------------------------------';
			PRINT 'Loading CRM TABLES';
			PRINT'------------------------------------------------';

		--TRUNCATE TABLE is a T-SQL command used to delete all rows from a table while keeping the table structure intact. It is faster than using the DELETE statement without a WHERE clause because it does not log individual row deletions.
		
		SET @start_time= GETDATE();

		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>Truncating Bronze.crm_cust_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		TRUNCATE TABLE Bronze.crm_cust_info


		--BULK INSERT is a T-SQL command used to import data from a file into a SQL Server table. The command allows you to specify various options for how the data should be imported, such as the field terminator, row terminator, and whether to ignore the first row (which often contains headers).
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.crm_cust_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		BULK INSERT Bronze.crm_cust_info

		FROM 'C:\Users\vigne\Downloads\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM Bronze.crm_cust_info;

		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';

		------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>Truncating Bronze.crm_prd_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		TRUNCATE TABLE [Bronze].[crm_prod_info]

		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.crm_prd_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		BULK INSERT Bronze.crm_prod_info
		FROM 'C:\Users\vigne\Downloads\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM [Bronze].[crm_prod_info];
		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';
		----------------------------------------------------------------------------

		SELECT COUNT(*) FROM [Bronze].[crm_sales_info]
		SET @start_time= GETDATE();
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>Truncating Bronze.crm_sales_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		TRUNCATE TABLE [Bronze].[crm_sales_info]

		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.crm_sales_info';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		BULK INSERT [Bronze].[crm_sales_info]
		FROM 'C:\Users\vigne\Downloads\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM [Bronze].[crm_sales_info];
		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';
		---------------------------------------------------------------------
		SET @start_time= GETDATE();
			PRINT'------------------------------------------------';
			PRINT 'Loading ERP TABLES';
			PRINT'------------------------------------------------';

			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
			PRINT '>>Truncating Bronze.erp_cust_az12';
			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		TRUNCATE TABLE [Bronze].[erp_cust_az12]

		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.erp_cust_az12';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
           
		BULK INSERT [Bronze].[erp_cust_az12]
		FROM 'C:\Users\vigne\Downloads\datasets\source_erp\cust_az12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM [Bronze].[erp_cust_az12]
		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';
		------------------------------------------------------------------------
		SET @start_time= GETDATE();
			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
			PRINT '>>Truncating Bronze.erp_LOC_A101';
			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		TRUNCATE TABLE [Bronze].[erp_LOC_A101]
 
		 PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.erp_LOC_A101';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		BULK INSERT [Bronze].[erp_LOC_A101]
		FROM 'C:\Users\vigne\Downloads\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM [Bronze].[erp_LOC_A101]
		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';
		---------------------------------------------------------------------------
		SET @start_time= GETDATE();
			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
			PRINT '>>Truncating Bronze.erp_PX_CAT_G1V2';
			PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		TRUNCATE TABLE [Bronze].[erp_PX_CAT_G1V2]
 
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT '>>INSERTING DATA INTO Bronze.erp_PX_CAT_G1V2';
		PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

		BULK INSERT [Bronze].[erp_PX_CAT_G1V2]
		FROM 'C:\Users\vigne\Downloads\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--CHECKING THE DATA
		SELECT * FROM [Bronze].[erp_PX_CAT_G1V2]
		SET @end_time= GETDATE();
		print'>>Load Duartion: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' SECONDS';
		-----------------------------------------------------------------------------

			PRINT'============================================================';
			PRINT 'Data loading into Bronze tables completed successfully!';
			PRINT'============================================================';
	END TRY
		BEGIN CATCH
		PRINT'==============================================================================';
			PRINT 'Error occurred while loading data into Bronze tables:';
			PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
			PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER()AS NVARCHAR);
			PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE()AS NVARCHAR);
			PRINT'==========================================================================';
			
		END CATCH
END

EXECUTE [dbo].[Load_Bronze_Tables]

