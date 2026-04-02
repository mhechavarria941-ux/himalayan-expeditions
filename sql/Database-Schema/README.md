# 🗂️ Database Schema - Table Structure

Contains the main database schema definition for the Himalayan Expeditions project. This folder holds all scripts related to creating and managing the database table structure.

---

## 📋 Files

### **00-create-main-tables-from-csv.sql** ⭐ PRIMARY
**Purpose**: Creates all 4 core tables from CSV source data  
**Tables Created**: 23 tables total (4 core + derived/lookup tables)  
**Columns**: 200+ columns across all tables  
**Run First**: Execute this script to initialize the database schema

**Core Tables Created**:
- `peaks` - Mountain reference data (480 rows)
- `exped` - Expedition records (11,425 rows)
- `members` - Participant/climber records (89,000 rows)
- `refer` - Source references and bibliography (15,586 rows)

**Derived/Lookup Tables Created**:
- `himalayan_data_dictionary` - Schema documentation
- `season_lookup` - Season classifications
- `citizenship_lookup` - Country reference data
- Additional administrative and reference tables (15+ more)

---

## 🔗 Using with ChartDB

**To view the table relationships in ChartDB:**

1. Open [ChartDB.io](https://chartdb.io)
2. Create a new diagram
3. Copy the entire content of `00-create-main-tables-from-csv.sql`
4. Paste into ChartDB's SQL editor
5. ChartDB will parse the CREATE TABLE statements and display:
   - ✅ All 23 tables
   - ✅ Column names and data types
   - ✅ Primary key relationships
   - ✅ Foreign key constraints
   - ✅ Table relationships diagram

---

## 📊 Schema Overview

```
PRIMARY TABLES:
├─ peaks (peakid)
│  └─ Foreign keys linked from exped
├─ exped (expid, year)
│  ├─ Links to peaks
│  └─ Links to refer
├─ members (membid, expid)
│  ├─ Links to exped
│  └─ Links to citizenship_lookup
└─ refer (refid)
   └─ Links to exped

LOOKUP/REFERENCE TABLES:
├─ himalayan_data_dictionary
├─ season_lookup
├─ citizenship_lookup
└─ [15+ additional administrative tables]

TOTAL: 23 tables, 200+ columns, 150,000+ rows
```

---

## 🚀 Quick Start

**Step 1**: Connect to Azure SQL Database
```sql
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U admin_ct -P demo123
```

**Step 2**: Run the schema creation script
```sql
sqlcmd -i Database-Schema/00-create-main-tables-from-csv.sql
```

**Step 3**: Verify tables were created
```sql
SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE';
```

---

## 📝 Table Statistics

| Table | Rows | Primary Key | Purpose |
|-------|------|-------------|---------|
| peaks | 480 | peakid | Mountain reference data |
| exped | 11,425 | expid + year | Expedition records |
| members | 89,000 | membid | Climber participant data |
| refer | 15,586 | refid | Source references |
| himalayan_data_dictionary | 221 | (defines columns) | Schema documentation |
| citizenship_lookup | 247 | citizen_code | Country/nationality codes |
| season_lookup | 5 | season | Climbing season names |
| *[14 more]* | *[varies]* | *[varies]* | Administrative/derived |

---

## 🔄 Data Flow

```
CSV Files (data/)
  │
  ├─ peaks.csv ────────────→ peaks table
  ├─ exped.csv ────────────→ exped table
  ├─ members.csv ──────────→ members table
  └─ refer.csv ────────────→ refer table
                               │
                               ↓
                    All 4 Core Tables Created
                               │
    (Used by all 15 analysis queries in Storytelling/)
```

---

## 💡 For Your Project

- **Schema Display**: Use this file to show table relationships in your presentation via ChartDB
- **Documentation**: Reference this when discussing database design
- **Reproducibility**: Anyone can run this script to recreate the exact database structure

---

*Last updated: April 2, 2026*  
*Status: Production-ready schema* ✅
