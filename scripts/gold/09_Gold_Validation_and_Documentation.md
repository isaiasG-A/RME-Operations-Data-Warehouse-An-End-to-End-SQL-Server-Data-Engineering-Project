# Gold Layer — Implementation and Validation

## 1. Purpose

The Gold layer provides business-ready views for analyzing equipment failures and restoration time in the RME Operations Data Warehouse.

## 2. Gold Views

### `gold.dim_equipment`

**Purpose:** Provides descriptive information about equipment.

Attributes:
- `equipment_id`
- `equipment_name`
- `equipment_type`
- `area`

### `gold.fact_work_orders`

**Purpose:** Provides work-order details for equipment failure and restoration analysis.

**Grain:** One row per work order.

Attributes:
- `work_order_id`
- `equipment_id`
- `failure_datetime`
- `repair_start_datetime`
- `restoration_datetime`
- `failure_description`
- `repair_duration`
- `total_restoration_time`

## 3. Relationship

One equipment item can have multiple work orders.

- `dim_equipment.equipment_id` identifies each equipment item.
- `fact_work_orders.equipment_id` links each work order to its equipment.
- Relationship: One-to-many (1:M).

## 4. Derived Measures

| Measure | Calculation |
|---|---|
| `repair_duration` | Hours between repair start and restoration |
| `total_restoration_time` | Hours between failure and restoration |

The current view uses SQL Server `DATEDIFF(HOUR, ...)` and formats non-NULL results with the `hr` suffix.

**Important:** `DATEDIFF(HOUR, ...)` counts hour boundaries crossed, not exact elapsed hours. The formatted duration values are text, so they should not be used directly for numeric aggregation.

If a required timestamp is NULL, the corresponding duration remains NULL.

## 5. Validation Results

The following checks were performed:

| Validation | Result |
|---|---|
| `gold.fact_work_orders` row count | 25 |
| Duplicate `work_order_id` values | None found |
| Work orders without matching equipment | None found |
| Negative duration values | None found in the earlier numeric-duration version |
| Missing timestamp handling | NULL durations preserved |

These checks support the current model and its relationships. Validation results reflect the data and view versions checked at the time.

## 6. Scope

The Gold layer is focused on equipment failures and restoration time. Broader maintenance performance reporting is outside the current scope.

## 7. Implementation Files

- `08_Gold_Views.sql` — Gold view definitions.
- `09_Gold_Validation_and_Documentation.md` — Gold implementation notes and validation results.

## 8. Next Steps

- Review the complete project structure.
- Set up Git version control.
- Publish the project to GitHub for portfolio presentation.
