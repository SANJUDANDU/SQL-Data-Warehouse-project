/*
=====================================
Description: This script is used to create DDL for Silver layer in Data Warehouse.

SCRIPT PURPOSE:
1. This script creates tables in the Silver layer of the Data Warehouse.
2. It checks if the tables already exist and drops them before creating new ones to ensure a clean slate for the Silver layer.
3. Each table is designed to hold specific types of data related to CRM and ERP systems, with appropriate data types and default values for the creation date.
USAGE NOTES:
- Execute this script in the context of the Silver layer database to create the necessary tables for storing cleaned and transformed data.
- Ensure that the Silver layer database is properly configured and accessible before running this script.
=====================================
*/

IF OBJECT_ID('Silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_cust_info;

Create table Silver.crm_cust_info(
		Cst_id INT,
		Cst_Key NVARCHAR(50),
		Cst_FirstName NVARCHAR(50),
		Cst_LastName NVARCHAR(50),
		Cst_Material_Status NVARCHAR(50),
		Cst_Gender NVARCHAR(50),
		Cst_Create_Date DATE,
		dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--Creating table for crm.prod.info

IF OBJECT_ID('Silver.crm_prod_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_prod_info;

Create table Silver.crm_prod_info(
		Prd_id  INT,
		cat_id NVARCHAR(50),
		Prd_Key  NVARCHAR(50),
		Prd_Nm  NVARCHAR(50),
		Prd_cost  INT,
		Prd_Line NVARCHAR(50),
		Prd_Start_Dt DATE,
		Prd_End_Dt DATE,
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);

--Creating table for crm.sales.info

IF OBJECT_ID('Silver.crm_sales_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_sales_info;

Create table Silver.crm_sales_info(
	sales_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--Creating table for erp.cust.az12

IF OBJECT_ID('Silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE Silver.erp_cust_az12;

CREATE TABLE Silver.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	Gen NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
	);

--Creating table for erp.loc.a101

IF OBJECT_ID('Silver.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE Silver.erp_LOC_A101;

CREATE TABLE Silver.erp_LOC_A101(
	CID NVARCHAR(50),
	Country NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--Creating table for erp.PX_CAT_G1V2

IF OBJECT_ID('Silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE Silver.erp_PX_CAT_G1V2;

CREATE TABLE Silver.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	Cat NVARCHAR(50),
	SubCat NVARCHAR(50),
	Maintainence NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
