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
