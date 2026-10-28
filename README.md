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
- [🗺️ Roadmap](#️-roadmap)
- [📚 Learning Outcomes](#-learning-outcomes)

---

## 🎯 Project Overview

The RME Operations Data Warehouse is designed to simulate operational data from a fictional fulfillment center. It brings together information about equipment, work orders, spare-parts usage, and inventory movements in a structured data warehouse.

The project follows the **Medallion Architecture**, organizing data into three layers:

- **Bronze:** Raw source data loaded into SQL Server.
- **Silver:** Cleaned, standardized, and validated data.
- **Gold
