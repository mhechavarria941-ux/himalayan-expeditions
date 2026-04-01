# Himalayan Expeditions Database - Complete Setup Guide

**Repository:** `https://github.com/rjmolinag0213r/himalayan-expeditions`

---

## ⛅ ARCHITECTURE: Azure Cloud Database

This project is built to run on **Microsoft Azure SQL Database** (cloud-based SQL Server).

**Database Location:** `cap2761cricardomolina.database.windows.net`  
**Database Name:** `Final_Project`  
**Authentication:** SQL Server Authentication

---

## 📋 Prerequisites

Before running this project, you need:

### 1. Azure SQL Database Connection
- **Server:** `cap2761cricardomolina.database.windows.net`
- **Database:** `Final_Project`
- **Username:** `admin_ct`
- **Password:** `Demo123456`
- **Port:** 1433 (default)

### 2. Required Software
- **SQL Server Management Studio (SSMS)** - Download from Microsoft
- **PowerShell 5.1+** (Windows built-in)
- **SQL Command-line Tool (sqlcmd)** - Comes with SSMS
- **PowerShell Modules:** 
  - `System.Data.SqlClient` (pre-installed with .NET Framework)

### 3. Required Source Data
All CSV files must be present in project:
```
data/himalayan_sources/
├── peaks.csv (480 rows)
├── exped.csv (11,425 rows)
├── members.csv (89,000 rows)
├── refer.csv (15,586 rows)
└── himalayan_data_dictionary.csv
```

---

## 🚀 Step-by-Step Execution Order

### **STEP 1: Verify Azure Connection**
```powershell
sqlcmd -S "cap2761cricardomolina.database.windows.net" `
        -d "Final_Project" `
        -U "admin_ct" `
        -P "Demo123456" `
        -Q "SELECT @@VERSION"
```
✅ If connection succeeds, you'll see SQL Server version info

---

### **STEP 2: Create Database Schema**
**File:** `sql/schema_for_chartdb.sql`

Creates all base tables with proper column definitions:
- `peaks` (480 rows expected)
- `exped` (11,425 rows expected)
- `members` (89,000 rows expected)
- `refer` (15,586 rows expected)

**Run in Azure:**
```powershell
sqlcmd -S "cap2761cricardomolina.database.windows.net" `
        -d "Final_Project" `
        -U "admin_ct" `
        -P "Demo123456" `
        -i "sql\schema_for_chartdb.sql"
```

✅ **Expected Output:**
```
Schema creation completed successfully.
4 core tables created: peaks, exped, members, refer
Schema matches CSV structure with all columns populated.
```

---

### **STEP 3: Load Data from CSV Files**
**File:** `scripts/bulk_load_csv.ps1`

Bulk imports all CSV data into Azure tables using PowerShell.

**Run from project root:**
```powershell
cd "path\to\himalayan-expeditions"
powershell -ExecutionPolicy Bypass -File "scripts\bulk_load_csv.ps1"
```

**What it does:**
1. Disables foreign key constraints temporarily
2. Truncates existing data
3. Batch imports peaks.csv (480 rows)
4. Batch imports exped.csv (11,425 rows)
5. Batch imports members.csv (89,000 rows)
6. Batch imports refer.csv (15,586 rows)
7. Re-enables foreign key constraints
8. Verifies row counts

✅ **Expected Output:**
```
Connecting to Azure SQL Database...
[OK] Connected successfully

Loading data\himalayan_sources\peaks.csv into peaks...
  [OK] peaks : 480 rows inserted

Loading data\himalayan_sources\exped.csv into exped...
  [OK] exped : 11425 rows inserted

Loading data\himalayan_sources\members.csv into members...
  [OK] members : 89000 rows inserted

Loading data\himalayan_sources\refer.csv into refer...
  [OK] refer : 15586 rows inserted

===================================
FINAL ROW COUNTS (VERIFICATION)
===================================
peaks : 480 rows
exped : 11425 rows
members : 89000 rows
refer : 15586 rows

[OK] Data load complete!
```

---

### **STEP 4: Normalize Database to 3rd Normal Form (3NF)**
**File:** `sql/himalayan_expedition_cleaning.sql`

Creates normalized/decomposition tables:
- **Expedition Tables:** timeline, routes, outcomes, statistics, oxygen, camps, incidents, reference_summary, admin, style
- **Member Tables:** person, participation, routes, summits
- **Lookup Tables:** season_lookup, citizenship_lookup

**Run in Azure:**
```powershell
sqlcmd -S "cap2761cricardomolina.database.windows.net" `
        -d "Final_Project" `
        -U "admin_ct" `
        -P "Demo123456" `
        -i "sql\himalayan_expedition_cleaning.sql"
```

⏱️ **Runtime:** ~5-10 minutes (creates 20+ normalized tables)

✅ **Expected Output:**
```
========= EXPEDITION DECOMPOSITION COMPLETE =========
[Table creation for expedition_timeline, expedition_routes, etc.]

===================================
   SCHEMA NORMALIZATION COMPLETE
===================================
All normalized tables created.
All redundant columns removed.
Database is now in 3NF.
```

---

### **STEP 5: Populate Decomposition Tables**
**File:** `sql/populate_decomposition_tables.sql`

Extracts and normalizes member data into 4 decomposition tables:
- `member_person` - Unique member details (99 rows)
- `member_participation` - Member-expedition participation (89,000 rows)
- `member_routes` - Routes per member per expedition (267,000 rows)
- `member_summits` - Summit attempts per member per expedition (267,000 rows)

**Run in Azure:**
```powershell
sqlcmd -S "cap2761cricardomolina.database.windows.net" `
        -d "Final_Project" `
        -U "admin_ct" `
        -P "Demo123456" `
        -i "sql\populate_decomposition_tables.sql"
```

✅ **Expected Output:**
```
========== POPULATING MEMBER_PERSON ==========
member_person rows inserted: 99

========== POPULATING MEMBER_PARTICIPATION ==========
member_participation rows inserted: 89000

========== POPULATING MEMBER_ROUTES ==========
member_routes rows inserted: 267000

========== POPULATING MEMBER_SUMMITS ==========
member_summits rows inserted: 267000

===================================
DECOMPOSITION TABLE ROW COUNTS
===================================
member_participation : 89000 rows
member_person : 99 rows
member_routes : 267000 rows
member_summits : 267000 rows
```

---

## ✅ Final Verification

After all steps, verify the complete database structure:

```powershell
sqlcmd -S "cap2761cricardomolina.database.windows.net" `
        -d "Final_Project" `
        -U "admin_ct" `
        -P "Demo123456" `
        -Q "SELECT 'peaks' AS [Table], COUNT(*) FROM dbo.peaks 
            UNION ALL SELECT 'exped', COUNT(*) FROM dbo.exped 
            UNION ALL SELECT 'members', COUNT(*) FROM dbo.members 
            UNION ALL SELECT 'refer', COUNT(*) FROM dbo.refer
            UNION ALL SELECT 'member_person', COUNT(*) FROM dbo.member_person
            UNION ALL SELECT 'member_participation', COUNT(*) FROM dbo.member_participation
            UNION ALL SELECT 'member_routes', COUNT(*) FROM dbo.member_routes
            UNION ALL SELECT 'member_summits', COUNT(*) FROM dbo.member_summits
            ORDER BY [Table]"
```

**Expected Result:**
```
Table                     Rows
------------------------  -------
exped                     11,425
member_participation      89,000
member_person                 99
member_routes            267,000
member_summits           267,000
members                   89,000
peaks                        480
refer                     15,586
```

---

## 📊 Database Statistics

| Component | Count |
|-----------|-------|
| **Base Tables** | 4 (peaks, exped, members, refer) |
| **Normalized Tables** | 14 (10 expedition + 4 member decompositions) |
| **Lookup Tables** | 2 (season_lookup, citizenship_lookup) |
| **Total Tables** | ~20 |
| **Total Rows** | ~500,000+ |
| **Normalization Level** | 3NF (Third Normal Form) |

---

## 🔧 Troubleshooting

### Connection Failed
**Error:** `Login failed for user 'admin_ct'`
- Verify credentials are correct
- Check internet connection to Azure
- Ensure firewall allows port 1433
- Verify Azure SQL firewall rules allow your IP

### File Not Found
**Error:** `Could not open file 'sql/schema_for_chartdb.sql'`
- Ensure you're running from project root directory
- Check file path is correct (case-sensitive after first run)

### Out of Memory
**Error:** `Memory quota exceeded`
- Azure database may be at capacity
- Wait a few minutes and retry
- Contact Azure support if persistent

### Foreign Key Constraint Errors
**Solution:** Already handled by scripts
- FK constraints are automatically disabled/re-enabled
- Safe to run multiple times (idempotent)

---

## 📝 Script Details

| Script | Type | Purpose | Runtime |
|--------|------|---------|---------|
| `schema_for_chartdb.sql` | DDL | Create base tables | 1-2 min |
| `bulk_load_csv.ps1` | PowerShell | Load CSV data | 10-15 min |
| `himalayan_expedition_cleaning.sql` | DDL/DML | Create normalized tables | 5-10 min |
| `populate_decomposition_tables.sql` | DML | Populate decomposition tables | 5-10 min |

---

## 🌍 Azure Cloud Architecture

### Network Topology
```
┌─────────────────────────┐
│   Your Computer         │
│  Windows/PowerShell     │
└────────────┬────────────┘
             │ (Internet)
             │ Port: 1433
             ↓
┌─────────────────────────────────────┐
│   Microsoft Azure (Cloud)           │
│  ├─ SQL Database Server             │
│  │  cap2761cricardomolina.database  │
│  │  .windows.net                    │
│  │                                  │
│  └─ Database: Final_Project         │
│     ├─ peaks                        │
│     ├─ exped                        │
│     ├─ members                      │
│     ├─ refer                        │
│     ├─ member_person                │
│     ├─ member_participation         │
│     ├─ member_routes                │
│     └─ member_summits               │
└─────────────────────────────────────┘
```

### Data Flow
```
CSV Files (Local)
    ↓
PowerShell Script
    ↓
Azure SQL Database
    ↓
Normalized Tables
    ↓
Ready for Analysis
```

---

## 📚 File Structure

```
himalayan-expeditions/
├── data/
│   └── himalayan_sources/
│       ├── peaks.csv
│       ├── exped.csv
│       ├── members.csv
│       ├── refer.csv
│       └── himalayan_data_dictionary.csv
│
├── sql/
│   ├── schema_for_chartdb.sql          (Step 2)
│   ├── bulk_load_data.sql              (Alternative: SQL-based load)
│   ├── himalayan_expedition_cleaning.sql (Step 4)
│   └── populate_decomposition_tables.sql (Step 5)
│
├── scripts/
│   ├── bulk_load_csv.ps1               (Step 3)
│   ├── execute_batches.ps1             (Batch processing)
│   └── generate_batched_sql.py         (Helper)
│
├── sql-queries/
│   ├── 01-schema-exploration.sql
│   ├── 02-row-count-analysis.sql
│   └── 03-data-dictionary-population.sql
│
├── docs/
│   ├── README.md
│   ├── PROCESS.md
│   ├── GITHUB_SETUP.md
│   └── SCHEMA.md
│
└── scripts/
    └── bulk_load_csv.ps1
```

---

## 🎯 Quick Reference: One-Command Execution

Run each command in sequence:

```powershell
# Step 2: Create Schema
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U "admin_ct" -P "Demo123456" -i "sql\schema_for_chartdb.sql"

# Step 3: Load Data (from project root)
cd "path\to\himalayan-expeditions"
powershell -ExecutionPolicy Bypass -File "scripts\bulk_load_csv.ps1"

# Step 4: Normalize
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U "admin_ct" -P "Demo123456" -i "sql\himalayan_expedition_cleaning.sql"

# Step 5: Populate Decomposition Tables
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U "admin_ct" -P "Demo123456" -i "sql\populate_decomposition_tables.sql"
```

---

## ✨ Success Indicators

When everything is working correctly, you will have:

✅ 8+ tables in `Final_Project` database  
✅ 126,491 rows in base tables  
✅ 623,099 rows total across all tables  
✅ All foreign key relationships intact  
✅ Database normalized to 3NF  
✅ No errors in any script execution  
✅ All decomposition tables populated  

---

**Last Updated:** March 31, 2026  
**Repository:** https://github.com/rjmolinag0213r/himalayan-expeditions  
**Cloud Platform:** Microsoft Azure SQL Database
