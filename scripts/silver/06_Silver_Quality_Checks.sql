/*
===============================================================================================
Script: Silver Layer Quality Checks
Project: RME Operations Data Warehouse
===============================================================================================
Script Purpose:
    Validates data quality across the five Silver layer tables after transformation and loading.

Quality Dimensions:
    1. Primary Key Integrity       - Check for NULL and duplicate identifiers.
    2. Data Completeness           - Identify missing values in required columns.
    3. Data Consistency             - Check for unwanted whitespace and inconsistent values.
    4. Data Validity                - Identify invalid dates, timestamps, and numeric values.
    5. Referential Integrity        - Identify orphaned foreign keys.
    6. Load Validation              - Compare Silver row counts with expected source counts.

Expected Results:
    Most checks should return no rows. Any exceptions must be reviewed against business rules.
    NULL timestamps may be valid for work orders that have not reached the relevant milestone.

Note:
    These queries are diagnostic only. They do not modify data.

===============================================================================================
*/


/*
===============================================================================================
1. PRIMARY KEY VALIDATION
===============================================================================================
Purpose:
    Identify NULL or duplicate identifiers in each Silver table.

Expectation:
    No results.
===============================================================================================
*/

-- 1.1 Equipment
SELECT equipment_id, COUNT(*) AS record_count
FROM silver.equipment
GROUP BY equipment_id
HAVING equipment_id IS NULL OR COUNT(*) > 1;

-- 1.2 Work orders
SELECT work_order_id, COUNT(*) AS record_count
FROM silver.work_orders
GROUP BY work_order_id
HAVING work_order_id IS NULL OR COUNT(*) > 1;

-- 1.3 Parts
SELECT part_id, COUNT(*) AS record_count
FROM silver.parts
GROUP BY part_id
HAVING part_id IS NULL OR COUNT(*) > 1;

-- 1.4 Parts usage
SELECT usage_id, COUNT(*) AS record_count
FROM silver.parts_usage
GROUP BY usage_id
HAVING usage_id IS NULL OR COUNT(*) > 1;

-- 1.5 Inventory transactions
SELECT transaction_id, COUNT(*) AS record_count
FROM silver.inventory_transactions
GROUP BY transaction_id
HAVING transaction_id IS NULL OR COUNT(*) > 1;


/*
===============================================================================================
2. DATA COMPLETENESS
===============================================================================================
Purpose:
    Identify missing values in important identifiers and required attributes.

Expectation:
    No results for required fields. Review exceptions before deciding how to handle them.
===============================================================================================
*/

-- 2.1 Equipment: required attributes
SELECT *
FROM silver.equipment
WHERE equipment_id IS NULL
   OR equipment_name IS NULL
   OR area IS NULL;

-- 2.2 Work orders: required attributes
SELECT *
FROM silver.work_orders
WHERE work_order_id IS NULL
   OR equipment_id IS NULL
   OR work_order_status IS NULL;

-- 2.3 Parts: required attributes
SELECT *
FROM silver.parts
WHERE part_id IS NULL
   OR part_name IS NULL;

-- 2.4 Parts usage: required attributes
SELECT *
FROM silver.parts_usage
WHERE usage_id IS NULL
   OR work_order_id IS NULL
   OR part_id IS NULL
   OR quantity_used IS NULL;

-- 2.5 Inventory transactions: required attributes
SELECT *
FROM silver.inventory_transactions
WHERE transaction_id IS NULL
   OR part_id IS NULL
   OR transaction_date IS NULL
   OR transaction_type IS NULL
   OR quantity_change IS NULL;


/*
===============================================================================================
3. UNWANTED WHITESPACE
===============================================================================================
Purpose:
    Identify leading or trailing spaces in text columns.

Expectation:
    No results unless spaces are intentionally part of a value.
===============================================================================================
*/

-- 3.1 Equipment names
SELECT equipment_id, equipment_name
FROM silver.equipment
WHERE equipment_name <> TRIM(equipment_name);

-- 3.2 Equipment types and areas
SELECT equipment_id, equipment_type, area
FROM silver.equipment
WHERE equipment_type <> TRIM(equipment_type)
   OR area <> TRIM(area);

-- 3.3 Work-order descriptions
SELECT work_order_id, failure_description
FROM silver.work_orders
WHERE failure_description <> TRIM(failure_description);

-- 3.4 Part names and manufacturers
SELECT part_id, part_name, manufacturer
FROM silver.parts
WHERE part_name <> TRIM(part_name)
   OR manufacturer <> TRIM(manufacturer);


/*
===============================================================================================
4. DATA VALIDITY
===============================================================================================
Purpose:
    Identify invalid numeric values and inconsistent date/time sequences.

Expectation:
    No results unless an exception is valid under the business rules.
===============================================================================================
*/

-- 4.1 Parts: negative costs or reorder thresholds
SELECT *
FROM silver.parts
WHERE unit_cost < 0
   OR reorder_threshold < 0;

-- 4.2 Parts usage: nonpositive quantities
SELECT *
FROM silver.parts_usage
WHERE quantity_used <= 0;

-- 4.3 Work orders: reported date after failure datetime
SELECT *
FROM silver.work_orders
WHERE reported_date > failure_datetime;

-- 4.4 Work orders: repair starts before the reported date
SELECT *
FROM silver.work_orders
WHERE repair_start_datetime < reported_date;

-- 4.5 Work orders: restoration before repair start
SELECT *
FROM silver.work_orders
WHERE restoration_datetime < repair_start_datetime;

-- 4.6 Equipment: installation dates in the future
SELECT *
FROM silver.equipment
WHERE installation_date > CAST(GETDATE() AS DATE);

-- 4.7 Inventory transactions: zero quantity changes
SELECT *
FROM silver.inventory_transactions
WHERE quantity_change = 0;


/*
===============================================================================================
5. DATA STANDARDIZATION AND CONSISTENCY
===============================================================================================
Purpose:
    Review distinct values to identify unexpected labels or inconsistent categories.

Expectation:
    Values should follow the project's approved naming conventions.
===============================================================================================
*/

-- 5.1 Equipment areas
SELECT DISTINCT area
FROM silver.equipment
ORDER BY area;

-- 5.2 Equipment types
SELECT DISTINCT equipment_type
FROM silver.equipment
ORDER BY equipment_type;

-- 5.3 Equipment statuses
SELECT DISTINCT equipment_status
FROM silver.equipment
ORDER BY equipment_status;

-- 5.4 Work-order types, priorities, and statuses
SELECT DISTINCT work_order_type
FROM silver.work_orders
ORDER BY work_order_type;

SELECT DISTINCT priority
FROM silver.work_orders
ORDER BY priority;

SELECT DISTINCT work_order_status
FROM silver.work_orders
ORDER BY work_order_status;

-- 5.5 Part categories
SELECT DISTINCT part_category
FROM silver.parts
ORDER BY part_category;

-- 5.6 Inventory transaction types
SELECT DISTINCT transaction_type
FROM silver.inventory_transactions
ORDER BY transaction_type;


/*
===============================================================================================
6. IDENTIFIER STANDARDIZATION
===============================================================================================
Purpose:
    Verify that the original source prefixes were removed during Silver transformations.

Expectation:
    No results if all source identifiers used the expected prefixes and transformations.
===============================================================================================
*/

-- 6.1 Equipment IDs
SELECT *
FROM silver.equipment
WHERE equipment_id LIKE 'EQ-%';

-- 6.2 Work-order IDs
SELECT *
FROM silver.work_orders
WHERE work_order_id LIKE 'WO-%';

-- 6.3 Parts IDs
SELECT *
FROM silver.parts
WHERE part_id LIKE 'PART-%';

-- 6.4 Parts-usage IDs
SELECT *
FROM silver.parts_usage
WHERE usage_id LIKE 'USE-%';

-- 6.5 Inventory transaction IDs
SELECT *
FROM silver.inventory_transactions
WHERE transaction_id LIKE 'INV-%';


/*
===============================================================================================
7. REFERENTIAL INTEGRITY
===============================================================================================
Purpose:
    Identify records that reference missing parent records.

Expectation:
    No results for non-NULL foreign keys that are required to reference existing records.
===============================================================================================
*/

-- 7.1 Work orders referencing missing equipment
SELECT wo.work_order_id, wo.equipment_id
FROM silver.work_orders AS wo
LEFT JOIN silver.equipment AS e
    ON wo.equipment_id = e.equipment_id
WHERE wo.equipment_id IS NOT NULL
  AND e.equipment_id IS NULL;

-- 7.2 Parts usage referencing missing work orders
SELECT pu.usage_id, pu.work_order_id
FROM silver.parts_usage AS pu
LEFT JOIN silver.work_orders AS wo
    ON pu.work_order_id = wo.work_order_id
WHERE pu.work_order_id IS NOT NULL
  AND wo.work_order_id IS NULL;

-- 7.3 Parts usage referencing missing parts
SELECT pu.usage_id, pu.part_id
FROM silver.parts_usage AS pu
LEFT JOIN silver.parts AS p
    ON pu.part_id = p.part_id
WHERE pu.part_id IS NOT NULL
  AND p.part_id IS NULL;

-- 7.4 Inventory transactions referencing missing parts
SELECT it.transaction_id, it.part_id
FROM silver.inventory_transactions AS it
LEFT JOIN silver.parts AS p
    ON it.part_id = p.part_id
WHERE it.part_id IS NOT NULL
  AND p.part_id IS NULL;


/*
===============================================================================================
8. ROW COUNT VALIDATION
===============================================================================================
Purpose:
    Compare actual Silver row counts with the expected source row counts.

Expected Counts:
    equipment                = 13
    work_orders              = 25
    parts                    = 30
    parts_usage              = 24
    inventory_transactions   = 47
    Total                    = 139

Note:
    These counts are based on the project's expected source data. Investigate differences.
===============================================================================================
*/

SELECT 'silver.equipment' AS table_name, COUNT(*) AS row_count
FROM silver.equipment

UNION ALL

SELECT 'silver.work_orders', COUNT(*)
FROM silver.work_orders

UNION ALL

SELECT 'silver.parts', COUNT(*)
FROM silver.parts

UNION ALL

SELECT 'silver.parts_usage', COUNT(*)
FROM silver.parts_usage

UNION ALL

SELECT 'silver.inventory_transactions', COUNT(*)
FROM silver.inventory_transactions;


/*
===============================================================================================
END OF SILVER LAYER QUALITY CHECKS
===============================================================================================
*/
