# 🗂️ Database Schema - Table Structure

Contains the main database schema definition for the Himalayan Expeditions project. This folder holds all scripts related to creating and managing the database table structure.

---

## 📋 Files

### **00-create-main-tables-from-csv.sql** ⭐ PRIMARY
**Purpose**: Creates all core tables from CSV source data  
**Tables Created**: 8 tables (4 core + 4 supporting)  
**Columns**: 200+ columns across all tables  
**Run First**: Execute this script to initialize the database schema

**CORE TABLES (4)** - Used in all analysis queries:
- `peaks` - Mountain reference data (23 columns, 480 rows)
- `exped` - Expedition records (65 columns, 11,425 rows)
- `members` - Participant/climber records (61 columns, 89,000 rows)
- `refer` - Source references and bibliography (12 columns, 15,586 rows)

**SUPPORTING TABLES (2)**:
- `himalayan_data_dictionary` - Schema documentation
- `audit_deleted_references` - Audit trail for data deletions

**LOOKUP TABLES (2)**:
- `season_lookup` - Climbing season reference
- `citizenship_lookup` - Country/nationality reference (247 entries)

---

### **01-export-all-table-schemas.sql** ⭐ NEW
Export script to list and view **all actual tables** currently in your Azure database
- Shows complete list of every table
- Displays column counts 
- Generates CREATE TABLE statements
- Use when you want to see what's really in the database

---

### **02-export-clean-schemas.sql** ⭐ NEW
Clean, formatted export for **ChartDB visualization**
- Better formatted CREATE TABLE output
- Easy to copy-paste into ChartDB
- Shows table statistics and details
- Ideal for diagram creation

---

### **HOW-TO-EXPORT-SCHEMAS.md** ⭐ NEW GUIDE
**Complete instructions** for:
- How to list all tables in your database
- How to export full schema definitions
- How to generate CREATE TABLE statements
- How to format for ChartDB
- Multiple methods (SQL Query, Azure Portal, SQL Server Management Studio)

**Start here** if you want to see all your tables!

## 🔗 Using with ChartDB

**What ChartDB will show**: 8 tables with all relationships

**To visualize the database structure:**

1. Open [ChartDB.io](https://chartdb.io)
2. Create a new diagram
3. Copy **just the CREATE TABLE statements** from `00-create-main-tables-from-csv.sql` (lines ~35-350)
4. Paste into ChartDB's SQL editor
5. ChartDB will parse and display:
   - ✅ All 8 tables
   - ✅ Column names and data types
   - ✅ Primary key relationships
   - ✅ Table structure diagram

*Tip: You only need the CREATE TABLE lines - skip the data INSERT statements at the bottom.*

---

## 📊 Schema Overview

```
CASCADE RELATIONSHIP:

peaks (peakid) ◄──────┐
                      │
exped (expid) ◄───────┴─── Foreign Key: peakid
├─ members (expid) ◄─────── Foreign Key: expid
└─ refer (expid) ◄─────────── Foreign Key: expid

LOOKUP TABLES:
├─ season_lookup ◄─────────── Referenced by exped.season
└─ citizenship_lookup ◄──────── Referenced by members.citizen

AUDIT TABLES:
└─ audit_deleted_references ◄── Track deletions

TOTAL: 8 tables, 200+ columns, 127,000+ rows
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

| Table | Rows | Columns | Primary Key | Purpose |
|-------|------|---------|------------|---------|
| peaks | 480 | 23 | peakid | Mountain reference data |
| exped | 11,425 | 65 | ExpeditionKey (autogen) | Expedition records |
| members | 89,000 | 61 | MemberKey (autogen) | Climber participant data |
| refer | 15,586 | 12 | ReferenceKey (autogen) | Source references |
| himalayan_data_dictionary | 221+ | 4 | DictionaryKey (autogen) | Schema documentation |
| citizenship_lookup | 247+ | 4 | citizen_key (autogen) | Country codes |
| season_lookup | 5 | 4 | season_id (autogen) | Climbing seasons |
| audit_deleted_references | *varies* | 8 | AuditID (autogen) | Deletion audit trail |
| **TOTAL** | **~127,000+** | **200+** | | |

---

## 🔄 Data Flow

```
CSV Files (data/himalayan_sources/)
  │
  ├─ peaks.csv (480 rows) ─────────────→ peaks table
  ├─ exped.csv (11,425 rows) ──────────→ exped table
  ├─ members.csv (89,000 rows) ───────→ members table
  └─ refer.csv (15,586 rows) ─────────→ refer table
                                          │
                                          ↓
                            DATA LOADED & READY
                                          │
    ┌───────────────────────┬────────────┴─────────────┬───────────────────┐
    │                       │                          │                   │
    ↓                       ↓                          ↓                   ↓
  Lookup Tables       Analysis Queries           Stored Procedures      Views
  (season, citizen)  (15 queries in              (Peak Risk SP)    (Member Analysis)
                     Storytelling/)
```

---

## 💡 For Your Project

- **ChartDB Visualization**: Copy-paste the CREATE TABLE statements into ChartDB.io to see all 8 tables
- **For Your Analysis**: Focus on the 4 core tables - all 15 queries use these
- **For Your Presentation**: Show the ChartDB diagram to explain database relationships
- **Reproducibility**: Anyone can run this script to recreate the exact database structure

---

## ❓ FAQ

**Q: Why does ChartDB show 8 tables instead of more?**  
A: The schema file creates exactly 8 tables: 4 core (peaks, exped, members, refer) + 2 supporting + 2 lookup tables. This is all that's needed for your analysis.

**Q: Do I need all 8 tables for my analysis?**  
A: Focus on the 4 core tables (peaks, exped, members, refer). The others are supporting/audit tables.

**Q: How do I copy code to ChartDB?**  
A: Copy lines 35-380 (just the CREATE TABLE statements), skip the INSERT statements at the bottom.

---

*Last updated: April 2, 2026*  
*Status: Production-ready schema* ✅
