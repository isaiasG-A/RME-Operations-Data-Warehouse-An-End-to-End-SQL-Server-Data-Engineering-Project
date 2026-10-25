/*
=================================================
DDL Script: Create Bronze Tables
================================================
Script Purpose:
	This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
	Run this script to redefine the DDL structure of 'bronze' tables

Bronze Layer Rules:
    - Use the bronze schema for all raw source tables.
    - Preserve original source column names.
    - Keep transformations and data-quality corrections
      out of the Bronze layer.
    - Avoid constraints that prevent raw source records
      from being loaded and inspected.


WARNING: 
	Rerunning this script drops and recreates the Bronze tables, deleting their existing data.
*/

USE RME_Operations_DW;
GO

IF OBJECT_ID ('bronze.equipment', 'U') IS NOT NULL
	DROP TABLE bronze.equipment;
GO

CREATE TABLE bronze.equipment (
	equipment_id NVARCHAR(50),
	equipment_name NVARCHAR(50),
	equipment_type NVARCHAR(50),
	area NVARCHAR(50),
	installation_date DATE,
	equipment_status NVARCHAR(50) 
);

IF OBJECT_ID ('bronze.inventory_transactions', 'U') IS NOT NULL
	DROP TABLE bronze.inventory_transactions;
GO

CREATE TABLE bronze.inventory_transactions (
	transaction_id NVARCHAR(50),
	part_id NVARCHAR(50),
	transaction_date DATE,
	transaction_type NVARCHAR(50),
	quantity_change INT
);

IF OBJECT_ID ('bronze.work_orders', 'U') IS NOT NULL
	DROP TABLE bronze.work_orders;
GO

CREATE TABLE bronze.work_orders (
	work_order_id NVARCHAR(50),
	equipment_id NVARCHAR(50),
	reported_date DATETIME,
	failure_datetime DATETIME,
	repair_start_datetime DATETIME,
	restoration_datetime DATETIME,
	work_order_type NVARCHAR(50),
	priority NVARCHAR(50),
	work_order_status NVARCHAR(50),
	failure_description NVARCHAR(MAX)
);

IF OBJECT_ID ('bronze.parts_usage', 'U') IS NOT NULL
	DROP TABLE bronze.parts_usage;
GO

CREATE TABLE bronze.parts_usage (
	usage_id NVARCHAR(50),
	work_order_id NVARCHAR(50),
	part_id NVARCHAR(50),
	quantity_used INT,
	usage_date DATE
);

IF OBJECT_ID ('bronze.parts', 'U') IS NOT NULL
	DROP TABLE bronze.parts;
GO

CREATE TABLE bronze.parts (
	part_id NVARCHAR(50),
	part_name NVARCHAR(50),
	part_category NVARCHAR(50),
	manufacturer NVARCHAR(50),
	unit_cost DECIMAL(10,2),
	reorder_threshold INT
);
