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
