# 🏭 RME Operations Data Warehouse

**An end-to-end SQL Server Data Engineering portfolio project**

Building a data warehouse that simulates Reliability, Maintenance, and Engineering (RME) operations at a fictional fulfillment center. This project demonstrates how raw operational data can be loaded, transformed, validated, and prepared for analytics using SQL Server and T-SQL.

> 📌 **Project status:** Bronze and Silver layers implemented; Gold views and validation are in progress.

All datasets are fictional and created for educational and portfolio purposes.

---

## 📑 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [💼 Business Objectives](#-business-objectives)
- [🏗️ Data Architecture](#️-data-architecture)
- [🗂️ Source Datasets](#️-source-datasets)
- [🛠️ Technologies](#️-technologies)
- [⚙️ Data Engineering Workflow](#️-data-engineering-workflow)
- [📊 Gold Layer Data Model](#-gold-layer-data-model)
- [📁 Repository Structure](#-repository-structure)
- [🚀 Getting Started](#-getting-started)
- [✅ Data Quality](#-data-quality)

## 🎯 Project Overview

The RME Operations Data Warehouse is designed to simulate operational data from a fictional fulfillment center. It brings together information about equipment, work orders, spare-parts usage, and inventory movements in a structured data warehouse.

The project follows the **Medallion Architecture**, organizing data into three layers:

- **Bronze:** Raw source data loaded into SQL Server.
- **Silver:** Cleaned, standardized, and validated data.
- **Gold:** Curated views designed to support reporting and analytical queries.

The primary focus of the initial analytical model is **equipment failures and restoration time**.

## 💼 Business Objectives

The warehouse is designed to support analysis of:

- 🔧 Equipment failure patterns across operational areas.
- ⏱️ Time between repair start and equipment restoration.
- 📉 Total restoration time from failure to restoration.
- 🏭 Equipment attributes and their relationship to work-order history.

Future extensions may explore spare-parts consumption, inventory movements, and replenishment needs.

## 🏗️ Data Architecture

```text
         📂 Fictional CSV Source Files
                     |
                     ▼
          ┌─────────────────────┐
          │   🥉 BRONZE LAYER   │
          │  Raw source data    │
          └─────────────────────┘
                     |
                     ▼
          ┌─────────────────────┐
          │   🥈 SILVER LAYER   │
          │ Clean & standardize │
          │ Data quality checks │
          └─────────────────────┘
                     |
                     ▼
          ┌─────────────────────┐
          │    🥇 GOLD LAYER    │
          │ Curated SQL views   │
          │ Analytical datasets │
          └─────────────────────┘
                     |
                     ▼
          📊 Reporting & Analysis
```

## 🗂️ Source Datasets

The project uses five fictional CSV files.

| File | Grain | Description |
|---|---|---|
| `equipment.csv` | One row per equipment asset | Equipment identifiers, names, types, areas, installation dates, and status |
| `work_orders.csv` | One row per work order | Reported dates, failure and repair timestamps, status, priority, and failure descriptions |
| `parts.csv` | One row per part | Part names, categories, manufacturers, unit costs, and reorder thresholds |
| `parts_usage.csv` | One row per part-usage line | Parts used on work orders, quantities, and usage dates |
| `inventory_transactions.csv` | One row per inventory movement | Inventory transaction dates, types, parts, and quantity changes |

The datasets are intended to represent related operational processes. Their relationships are validated as part of the data quality workflow.

## 🛠️ Technologies

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Relational database and data warehouse platform |
| SQL Server Management Studio (SSMS) | Database development and administration |
| T-SQL | Data definition, transformation, loading, and validation |
| CSV | Source data format |
| Git and GitHub | Version control and project documentation |
| draw.io | Data modeling and architecture diagrams |

## ⚙️ Data Engineering Workflow

### 1. 🥉 Bronze — Raw Data Ingestion

- Created Bronze tables to represent the source CSV structures.
- Loaded CSV data into SQL Server using `BULK INSERT`.
- Developed a stored procedure to reload the Bronze tables.
- Added basic load timing and error-handling logic.

### 2. 🥈 Silver — Transformation and Quality

- Created Silver tables with appropriate data types.
- Standardized identifiers by removing source-system prefixes.
- Cleaned equipment names by removing matching area prefixes.
- Preserved native date/time values and `NULL` timestamps.
- Developed validation queries for duplicates, missing values, invalid values, and referential integrity.

### 3. 🥇 Gold — Analytical Views

The initial Gold layer focuses on equipment and work-order analysis.

| View | Purpose |
|---|---|
| `gold.dim_equipment` | Equipment attributes for analytical context |
| `gold.fact_work_orders` | Work-order failure and restoration timestamps, descriptions, and derived duration fields |

The fact view is designed at **one row per work order**. It connects to the equipment dimension through `equipment_id`.

## 📊 Gold Layer Data Model

The initial logical data model follows a simple dimensional structure:

```text
┌──────────────────────┐
│   dim_equipment      │
├──────────────────────┤
│ PK equipment_id      │
│    equipment_name    │
│    equipment_type    │
│    area              │
└──────────┬───────────┘
           │
           │ 1 : Many
           ▼
┌──────────────────────────┐
│     fact_work_orders     │
├──────────────────────────┤
│ PK work_order_id         │
│ FK equipment_id          │
│    failure_datetime      │
│    repair_start_datetime │
│    restoration_datetime  │
│    failure_description  │
│    repair_duration       │
│    total_restoration_time│
└──────────────────────────┘
```

**Derived measures:**

- **Repair duration:** Time between repair start and restoration.
- **Total restoration time:** Time between failure and restoration.

Missing timestamps are preserved as `NULL` when a duration cannot be calculated. The current view formats duration values with an `hr` suffix for readability.

## 📁 Repository Structure

```text
RME-Operations-Data-Warehouse/
│
├── datasets/      # Fictional CSV source datasets
├── docs/          # Project documentation and data models
├── scripts/       # SQL database, loading, and transformation scripts
├── tests/         # Data quality and validation scripts
├── LICENSE        # MIT License
└── README.md      # Project overview and documentation
```

## 🚀 Getting Started

### Prerequisites

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Git (optional for cloning and version control)

### Setup

1. Clone or download this repository.
2. Open SQL Server Management Studio and connect to your SQL Server instance.
3. Review the SQL scripts in the `scripts/` directory.
4. Execute the database setup and table creation scripts in the documented order.
5. Configure the CSV file paths in the Bronze loading procedure for your local environment.
6. Load the Bronze layer, then run the Silver transformation and validation scripts.
7. Create and query the Gold views.

> ⚠️ **Note:** Update file paths in the loading scripts to match your local machine. The scripts are being developed for a SQL Server environment and may require configuration before execution.

## ✅ Data Quality

The project includes checks designed to identify:

- Duplicate or missing business identifiers.
- Missing values in required fields.
- Unwanted whitespace in text attributes.
- Invalid or inconsistent date/time sequences.
- Unexpected identifier prefixes.
- Orphan records caused by missing dimension or parent records.
- Unexpected row-count differences between layers.

Validation results are documented as the project evolves. Some checks are diagnostic and depend on confirming the relevant business rules.


---

## 👤 Author

**Isaias**

