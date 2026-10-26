
/*
===============================================================================================
Script: Create Silver Tables
===============================================================================================
Script Purpose:
    Creates the Silver layer tables for the RME Operations Data Warehouse.
    These tables will store cleaned and transformed data from the Bronze layer.

WARNING:
    This script drops and recreates existing Silver tables.
    Any existing data in these tables will be permanently deleted.
===============================================================================================
*/

-- Create silver.equipment
IF OBJECT_ID('silver.equipment', 'U') IS NOT NULL
    DROP TABLE silver.equipment;
GO

CREATE TABLE silver.equipment (
    equipment_id NVARCHAR(50),
    equipment_name NVARCHAR(50),
    equipment_type NVARCHAR(50),
    area NVARCHAR(50),
    installation_date DATE,
    equipment_status NVARCHAR(50),
    dwh_create DATETIME2(0) DEFAULT SYSDATETIME()
);
GO

-- Create silver.inventory_transactions
IF OBJECT_ID('silver.inventory_transactions', 'U') IS NOT NULL
    DROP TABLE silver.inventory_transactions;
GO

CREATE TABLE silver.inventory_transactions (
    transaction_id NVARCHAR(50),
    part_id NVARCHAR(50),
    transaction_date DATE,
    transaction_type NVARCHAR(50),
    quantity_change INT,
    dwh_create DATETIME2(0) DEFAULT SYSDATETIME()
);
GO

-- Create silver.work_orders
IF OBJECT_ID('silver.work_orders', 'U') IS NOT NULL
    DROP TABLE silver.work_orders;
GO

CREATE TABLE silver.work_orders (
    work_order_id NVARCHAR(50),
    equipment_id NVARCHAR(50),
    reported_date DATETIME2(0),
    failure_datetime DATETIME2(0),
    repair_start_datetime DATETIME2(0),
    restoration_datetime DATETIME2(0),
    work_order_type NVARCHAR(50),
    priority NVARCHAR(50),
    work_order_status NVARCHAR(50),
    failure_description NVARCHAR(MAX),
    dwh_create DATETIME2(0) DEFAULT SYSDATETIME()
);
GO

-- Create silver.parts_usage
IF OBJECT_ID('silver.parts_usage', 'U') IS NOT NULL
    DROP TABLE silver.parts_usage;
GO

CREATE TABLE silver.parts_usage (
    usage_id NVARCHAR(50),
    work_order_id NVARCHAR(50),
    part_id NVARCHAR(50),
    quantity_used INT,
    usage_date DATE,
    dwh_create DATETIME2(0) DEFAULT SYSDATETIME()
);
GO

-- Create silver.parts
IF OBJECT_ID('silver.parts', 'U') IS NOT NULL
    DROP TABLE silver.parts;
GO

CREATE TABLE silver.parts (
    part_id NVARCHAR(50),
    part_name NVARCHAR(50),
    part_category NVARCHAR(50),
    manufacturer NVARCHAR(50),
    unit_cost DECIMAL(10,2),
    reorder_threshold INT,
    dwh_create DATETIME2(0) DEFAULT SYSDATETIME()
);
GO
