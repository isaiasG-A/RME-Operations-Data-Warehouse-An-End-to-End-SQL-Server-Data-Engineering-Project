/*
===============================================================================================
Script: Load Silver Layer
===============================================================================================
Script Purpose:
    Transforms, cleans, and loads data from the Bronze layer into the Silver layer of the
    RME Operations Data Warehouse.

    This script performs a full refresh of the Silver tables by truncating existing data
    and inserting transformed data from the corresponding Bronze tables.

Transformations Performed:
    -- Data Normalization & Standardization
        - Standardizes equipment, work order, parts usage, parts, and inventory transaction
          identifiers by removing their respective prefixes.

    -- Equipment Name Transformation
        - Removes the area prefix from equipment names when it matches the area value followed
          by a space.
        - Preserves the original equipment name when the prefix does not match the area.

    -- Data Type Handling
        - Preserves date, date/time, and numeric values in their appropriate data types
          during the Silver load.
        - Retains NULL values in date/time columns when source timestamps are missing.

Data Loading:
    -- Full Refresh
        - Truncates existing Silver table data before loading the latest Bronze data.
        - Uses explicit INSERT column lists to define the target columns.

Target Tables:
    - silver.equipment
    - silver.work_orders
    - silver.parts_usage
    - silver.parts
    - silver.inventory_transactions

Notes:
    - Bronze data remains unchanged during the transformation process.
    - The dwh_create column is populated through its default constraint when omitted from
      the INSERT column lists.
    - Data quality validation is performed separately after loading.

===============================================================================================
*/

-- 1. Transform and load equipment

PRINT '>> Truncating Table: silver.equipment';
TRUNCATE TABLE silver.equipment;

PRINT '>> Inserting Table: silver.equipment';

INSERT INTO silver.equipment (
    equipment_id,
    equipment_name,
    equipment_type,
    area,
    installation_date,
    equipment_status
)
SELECT
    CASE
        WHEN equipment_id LIKE 'EQ-%'
            THEN SUBSTRING(equipment_id, 4, LEN(equipment_id))
        ELSE equipment_id
    END AS equipment_id,
    CASE
        WHEN LEFT(equipment_name, LEN(area) + 1) = area + ' '
            THEN STUFF(equipment_name, 1, LEN(area) + 1, '')
        ELSE equipment_name
    END AS equipment_name,
    equipment_type,
    area,
    installation_date,
    equipment_status
FROM bronze.equipment;


-- 2. Transform and load work_orders

PRINT '>> Truncating Table: silver.work_orders';
TRUNCATE TABLE silver.work_orders;

PRINT '>> Inserting Table: silver.work_orders';

INSERT INTO silver.work_orders (
    work_order_id,
    equipment_id,
    reported_date,
    failure_datetime,
    repair_start_datetime,
    restoration_datetime,
    work_order_type,
    priority,
    work_order_status,
    failure_description
)
SELECT
    CASE
        WHEN work_order_id LIKE 'WO-%'
            THEN SUBSTRING(work_order_id, 4, LEN(work_order_id))
        ELSE work_order_id
    END AS work_order_id,
    CASE
        WHEN equipment_id LIKE 'EQ-%'
            THEN SUBSTRING(equipment_id, 4, LEN(equipment_id))
        ELSE equipment_id
    END AS equipment_id,
    reported_date,
    failure_datetime,
    repair_start_datetime,
    restoration_datetime,
    work_order_type,
    priority,
    work_order_status,
    failure_description
FROM bronze.work_orders;


-- 3. Transform and load parts_usage

PRINT '>> Truncating Table: silver.parts_usage';
TRUNCATE TABLE silver.parts_usage;

PRINT '>> Inserting Table: silver.parts_usage';

INSERT INTO silver.parts_usage (
    usage_id,
    work_order_id,
    part_id,
    quantity_used,
    usage_date
)
SELECT
    CASE
        WHEN usage_id LIKE 'USE-%'
            THEN SUBSTRING(usage_id, 5, LEN(usage_id))
        ELSE usage_id
    END AS usage_id,
    CASE
        WHEN work_order_id LIKE 'WO-%'
            THEN SUBSTRING(work_order_id, 4, LEN(work_order_id))
        ELSE work_order_id
    END AS work_order_id,
    CASE
        WHEN part_id LIKE 'PART-%'
            THEN SUBSTRING(part_id, 6, LEN(part_id))
        ELSE part_id
    END AS part_id,
    quantity_used,
    usage_date
FROM bronze.parts_usage;


-- 4. Transform and load parts

PRINT '>> Truncating Table: silver.parts';
TRUNCATE TABLE silver.parts;

PRINT '>> Inserting Table: silver.parts';

INSERT INTO silver.parts (
    part_id,
    part_name,
    part_category,
    manufacturer,
    unit_cost,
    reorder_threshold
)
SELECT
    CASE
        WHEN part_id LIKE 'PART-%'
            THEN SUBSTRING(part_id, 6, LEN(part_id))
        ELSE part_id
    END AS part_id,
    part_name,
    part_category,
    manufacturer,
    unit_cost,
    reorder_threshold
FROM bronze.parts;


-- 5. Transform and load inventory_transactions

PRINT '>> Truncating Table: silver.inventory_transactions';
TRUNCATE TABLE silver.inventory_transactions;

PRINT '>> Inserting Table: silver.inventory_transactions';

INSERT INTO silver.inventory_transactions (
    transaction_id,
    part_id,
    transaction_date,
    transaction_type,
    quantity_change
)
SELECT
    CASE
        WHEN transaction_id LIKE 'INV-%'
            THEN SUBSTRING(transaction_id, 5, LEN(transaction_id))
        ELSE transaction_id
    END AS transaction_id,
    CASE
        WHEN part_id LIKE 'PART-%'
            THEN SUBSTRING(part_id, 6, LEN(part_id))
        ELSE part_id
    END AS part_id,
    transaction_date,
    transaction_type,
    quantity_change
FROM bronze.inventory_transactions;
