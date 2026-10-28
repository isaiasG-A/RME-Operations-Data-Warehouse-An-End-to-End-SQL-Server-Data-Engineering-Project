/*
================================================================================
Gold Layer: Views
================================================================================
Purpose:
    Create business-ready views for equipment failure and restoration analysis.

Views:
    gold.dim_equipment
    gold.fact_work_orders
================================================================================
*/

-- 1. Equipment Dimension
CREATE VIEW gold.dim_equipment AS
SELECT
    equipment_id,
    equipment_name,
    equipment_type,
    area
FROM silver.equipment;
GO

-- 2. Work Orders Fact
CREATE VIEW gold.fact_work_orders AS
SELECT
    work_order_id,
    equipment_id,
    failure_datetime,
    repair_start_datetime,
    restoration_datetime,
    failure_description,
    DATEDIFF(HOUR, repair_start_datetime, restoration_datetime) AS repair_duration,
    DATEDIFF(HOUR, failure_datetime, restoration_datetime) AS total_restoration_time
FROM silver.work_orders;
GO
