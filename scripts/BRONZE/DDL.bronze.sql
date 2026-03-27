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
