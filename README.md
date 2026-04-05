# Himalayan Expeditions: Data Analysis Project

## 📊 Project Overview

A comprehensive data analysis of mountaineering expeditions in the Himalayan region using **T-SQL**, **Azure SQL Database**, and **data visualization** techniques.

### 🎯 Research Questions

This project explores four key aspects of Himalayan mountaineering:

1. **Which mountains are deadliest?** - Analyzing fatality patterns across peaks
2. **Why do Sherpas have higher mortality?** - Examining the risk disparity between guides and clients
3. **How has Everest commercialized?** - Tracking the transformation from elite climbing to mass tourism
4. **Which nations participate most?** - Understanding global mountaineering patterns

---

## 📂 Repository Structure

```
himalayan-expeditions/
│
├── README.md                 # Main project documentation
├── .env.template            # Credentials template (do not commit .env)
│
├── 📊 sql-queries/Storytelling/
│   ├── 04-death-zone-demographics.sql (4 queries)
│   ├── 05-sherpa-indispensable-CORRECTED.sql (4 queries)
│   ├── 06-everest-effect.sql (3 queries)
│   ├── 07-national-cultures.sql (4 queries)
│   ├── sp-analyze-peak-risk.sql (Stored Procedure)
│   ├── views-analysis.sql (2 Views)
│   └── README.md (query documentation)
│
├── 📈 visualizations/
│   ├── 01-deadliest-peaks.png
│   ├── 02-sherpa-mortality.png
│   ├── 03-everest-growth.png
│   ├── 04-top-nations.png
│   └── README.md (visualization details)
│
├── 📁 docs/ (Technical Documentation)
│   ├── DBCODE_CONNECTION_SETUP.md
│   ├── DBCODE_VISUALIZATION_GUIDE.md
│   ├── VISUALIZATIONS_GUIDE.md
│   └── (other reference docs)
│
├── 💾 sql/
│   ├── himalayan_expedition_cleaning.sql
│   ├── load_sample_data.sql
│   └── Database-Schema/
│
├── 🔍 data/
│   └── himalayan_sources/ (CSV source files)
│
└── 🛠️ scripts/
    └── (utility scripts)
```

---

## 📊 Key Deliverables

### ✅ T-SQL Analysis
- **15 SELECT queries** organized in 4 analytical blocks
- **1 Stored Procedure** with IF/ELSE logic
- **2 Views** for data analysis
- **Advanced T-SQL Concepts**: JOINs, GROUP BY/HAVING, Subqueries, CTEs

**Location**: `sql-queries/Storytelling/`

### ✅ Visualizations
- **4 Professional Charts** created with DBCode extension
- **Diverse Chart Types**: Horizontal Bar, Grouped Bar, Scatter/Line, Treemap
- **PNG Format** ready for presentation

**Location**: `visualizations/`

### ✅ Database
- **8 Tables** with 40,000+ expedition records
- **Azure SQL Database**: `Final_Project`
- **Server**: cap2761cricardomolina.database.windows.net

---

## 🔍 Key Findings

### 1. Deadliest Peaks 
- **Everest**: 208 total deaths (most)
- **Annapurna I**: 1 death per 7 summits (highest ratio)
- Geography and fame drive climbing patterns

### 2. Sherpa Mortality Disparity
- Sherpas face **2-3x higher mortality** than paying clients across every peak
- Highlights structural risk in mountaineering industry

### 3. Everest Commercialization Growth
- **Pre-1980**: 1-2 expeditions/year
- **Post-1980**: 100+ expeditions/year  
- Clear transformation from elite mountaineering to mass tourism

### 4. Global Participation
- **Nepal** dominates (geographic/cultural advantage)
- **China** strong (state-sponsored programs)
- **Western nations** (USA, UK) significant participation

---

## 🚀 Quick Start

### Connect to Database
See `.env.template` for credentials format. Store credentials in `.env` (not committed):

```env
AZURE_SQL_SERVER=cap2761cricardomolina.database.windows.net
AZURE_SQL_DB=Final_Project
AZURE_SQL_USER=<your_username>
AZURE_SQL_PASSWORD=<your_password>
```

### Run Queries
1. Open any file from `sql-queries/Storytelling/`
2. Press **Ctrl+Shift+E** to execute (requires DBCode extension)
3. Results appear in bottom panel
4. Click **Chart** tab to visualize

---

## 📚 Documentation

- **[Visualizations](visualizations/README.md)** - Detailed visualization guide
- **[Technical Docs](docs/)** - Connection setup, guides, and references
- **[Data Dictionary](data/himalayan_sources/himalayan_data_dictionary.csv)** - Field definitions

---

## 📋 Project Requirements Met

| Requirement | Status | Details |
|---|---|---|
| Database: 6+ Tables | ✅ | 8 tables, 40,000+ records |
| T-SQL: 12+ SELECT Queries | ✅ | 15 queries created |
| Stored Procedure with IF/ELSE | ✅ | Peak risk analysis SP |
| Views | ✅ | 2 analysis views |
| 4+ Visualizations | ✅ | 4 diverse chart types |
| GitHub with Evolution | ✅ | 15+ commits showing progress |
| 10-Minute Presentation | ✅ | Ready for Zoom delivery |

---

## 🛠️ Technical Stack

| Component | Technology |
|---|---|
| **Database** | Azure SQL Database |
| **Query Language** | T-SQL |
| **IDE** | Visual Studio Code |
| **Visualization** | DBCode Extension |
| **Version Control** | GitHub |
| **Data Format** | CSV, SQL |

---

## 👥 Team

Team members listed in presentation slide.

---

## 🔗 Links

- **GitHub**: https://github.com/rjmolinag0213r/himalayan-expeditions
- **Database**: Azure SQL - Final_Project
- **Data Source**: Himalayan Expeditions Database

---

## 📅 Project Date

**Completed**: April 4, 2026

---

**For technical details and guides, see the `docs/` folder.**
