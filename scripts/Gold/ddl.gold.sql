/*
***Objective***

This SQL script is designed to create the Gold Layer of a Data Warehouse using a Star Schema model,
transforming cleaned data from the Silver layer into analytics-ready structures.
  
  The script creates three key views:

1. 👤 Gold_Dim_Customers (Customer Dimension)
Consolidates customer data from multiple sources (CRM + ERP)
Cleans and standardizes attributes like Gender, Country, and Marital Status
Uses business logic to prioritize CRM data for gender
Generates a surrogate key (Customer_Key) for efficient joins
2. 📦 Gold_Dim_Products (Product Dimension)
Extracts active product records (filters historical data)
Enriches product data with Category and Subcategory hierarchy
Creates a surrogate key (Product_Key) for dimensional modeling
Prepares data for product-level analysis
3. 💰 Gold_Fact_Sales (Fact Table)
Stores transactional sales data
Links with Customer and Product dimensions using surrogate keys
Includes key business metrics:
Sales Amount
Quantity
Price
Enables analytical queries like:
Sales trends
Customer behavior
Product performance
  */
  
CREATE VIEW Gold_Dim_Customers As ---- FOR CUSTOMERS DIMENSION
SELECT
ROW_NUMBER() OVER (ORDER BY Cst_id)AS Customer_Key,
	ci.Cst_id as Customer_Id,
	ci.Cst_Key as Customer_Number,
	ci.Cst_FirstName as First_Name,
	ci.Cst_lastname as Last_Name,
	la.Country as Country,
	ci.Cst_Material_Status as Martial_Status,
	CASE WHEN ci.Cst_Gender != 'N/A' then ci.Cst_Gender --CRM IS THE MASTER FOR GENDER INFO
		ELSE COALESCE (ca.Gen, 'N/A')
	END AS Gender,
	ca.bdate as Birthdate,
	ci.Cst_Create_Date
FROM Silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.Cst_Key = ca.cid
left join Silver.erp_LOC_A101 la
on ci.Cst_Key = la.CID

---SELECT * FROM Gold_Dim_Customers
-----------------------------------------------------------------------------------
CREATE VIEW Gold_Dim_Products AS ---FOR PRODUCTS DIMENSION
SELECT 
ROW_NUMBER() OVER (ORDER BY pn.Prd_Start_Dt,pn.Prd_Key) AS Product_key,
pn.Prd_id AS Product_ID,
pn.Prd_Key AS Product_number,
pn.Prd_Nm AS Product_Name,
pn.cat_id AS Category_ID,
pc.Cat AS Category,
pc.SubCat AS SubCategory,
pc.Maintainence,
pn.Prd_cost AS Cost,
pn.Prd_Line AS Product_Line,
pn.Prd_Start_Dt As Start_Date
FROM Silver.crm_prod_info pn
LEFT JOIN Silver.erp_PX_CAT_G1V2 pc
ON pn.cat_id = pc.ID
WHERE pn.Prd_End_Dt IS NULL ---Filter out all Historical Data

---SELECT * FROM Gold_Dim_Products
------------------------------------------------------------------------------------
CREATE VIEW Gold_Fact_Sales AS ---FOR SALES FACT TABLE
SELECT 
sd.sales_ord_num AS Order_Number,
pr.Product_Key,
cu.Customer_Key,
sd.sls_order_dt AS Order_Date,
sd.sls_ship_dt AS Shipping_Date,
sd.sls_due_dt AS Due_Date,
sd.sls_sales AS Sales_Amount,
sd.sls_quantity AS Quantity,
sd.sls_price  AS Price
FROM Silver.crm_sales_info sd
LEFT JOIN Gold_Dim_Products pr
on sd.sls_prd_key = pr.Product_number
LEFT JOIN GOLD_Dim_Customers cu
ON sd.sls_cust_id = cu.Customer_Id

SELECT * FROM Gold_Fact_Sales
-------------------------------------------------------------------------------------
