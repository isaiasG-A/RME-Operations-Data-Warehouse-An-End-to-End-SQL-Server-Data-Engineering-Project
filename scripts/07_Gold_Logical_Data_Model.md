# Gold Layer — Logical Data Model

## 1. Business Goal

Analyze equipment failures and restoration time to understand when equipment fails and how long it takes to restore it.

## 2. Data Model

The initial Gold model uses a Star Schema approach with one equipment dimension and one work-order fact entity.

### Entity: `dim_equipment`

**Purpose:** Store descriptive information about equipment.

| Attribute | Key | Description |
|---|---|---|
| `equipment_id` | PK | Unique identifier for equipment |
| `equipment_name` | — | Name of the equipment |
| `equipment_type` | — | Type of equipment |
| `area` | — | Area where the equipment is located |

### Entity: `fact_work_orders`

**Purpose:** Support analysis of equipment failures and restoration time.

**Grain:** One row per work order.

| Attribute | Key | Description |
|---|---|---|
| `work_order_id` | PK | Unique identifier for the work order |
| `equipment_id` | FK | Identifies the associated equipment |
| `failure_datetime` | — | Date and time the failure occurred |
| `repair_start_datetime` | — | Date and time repair began |
| `restoration_datetime` | — | Date and time equipment was restored |
| `failure_description` | — | Description of the failure |

## 3. Relationship

One equipment item can have multiple work orders.

- `dim_equipment.equipment_id` is the primary identifier for equipment.
- `fact_work_orders.equipment_id` references `dim_equipment.equipment_id`.
- Relationship cardinality: **One-to-many (1:M)**.

## 4. Derived Measures

The following measures are derived from timestamps. They are logical calculations, not confirmed physical columns.

| Measure | Calculation |
|---|---|
| `repair_duration` | `restoration_datetime` − `repair_start_datetime` |
| `total_restoration_time` | `restoration_datetime` − `failure_datetime` |

A measure cannot be calculated when a required timestamp is missing or invalid.

## 5. Data Validation

The following checks were performed against the current Silver data:

- No duplicate `equipment_id` values were returned by the duplicate check.
- No NULL `equipment_id` values were returned by the equipment NULL check.
- No work orders without matching equipment records were returned by the relationship check.

These results support the proposed identifiers and relationship for the current data. Database constraints have not yet been implemented.

## 6. Scope

This model focuses specifically on equipment failures and restoration time. Broader maintenance performance reporting is outside the current scope.

## 7. Implementation Status

This document describes the logical model. Gold views and physical database objects have not yet been implemented.

