/*
=====================================================
Script: Load Silver Layer
=====================================================
*/

-- 1. Transform and load equipment

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
FROM bronze.equipment
ORDER BY equipment_id ASC;

-- 2. Transform and load work_orders

-- 3. Transform and load parts

-- 4. Transform and load parts_usage

-- 5. Transform and load inventory_transactions



