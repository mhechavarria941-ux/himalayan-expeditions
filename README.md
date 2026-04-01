# Himalayan Expeditions Database - Data Normalization & Schema Design

A comprehensive **Azure SQL Database** project for normalizing and analyzing mountaineering expedition data. This project demonstrates advanced database design principles including surrogate keys, lookup tables, and 3rd Normal Form (3NF) normalization.

---

## 🚀 QUICK START - Azure Cloud Database

**This repository is designed to run on Microsoft Azure SQL Database (cloud-hosted).**

### ⏱️ Complete Setup Time: ~30-45 minutes

For detailed step-by-step instructions with exact commands and expected outputs, see:
### 👉 **[AZURE_SETUP_GUIDE.md](docs/AZURE_SETUP_GUIDE.md)**

**Quick Reference - 5 Steps:**
1. Verify Azure connection
2. Create schema: `sql/schema_for_chartdb.sql`
3. Load CSV data: `scripts/bulk_load_csv.ps1`
4. Normalize database: `sql/himalayan_expedition_cleaning.sql`
5. Populate decomposition: `sql/populate_decomposition_tables.sql`

---

## 📊 Project Overview

### Data Content
- **480 peaks** - Mountain information and first ascent records
- **11,425 expeditions** - Expedition details across different peaks and years
- **89,000 member records** - Individual climber participation data
- **15,586 references** - Bibliographic citations and literature
- **~623,000 total rows** - After normalization to 3NF

### Database Platform
- **Cloud Provider:** Microsoft Azure
- **Database Type:** SQL Server
- **Server:** `YOUR_SERVER.database.windows.net` 🔐 See AZURE_SETUP_GUIDE.md for connection details
- **Authentication:** SQL Server (username/password)

### Final Schema
- **4 base tables** - Original data (peaks, exped, members, refer)
- **14 normalized tables** - 3NF decomposition + lookups
- **100% normalized** - No data redundancy

---

## 📂 Project Structure

```
himalayan-expeditions/
│
├── 📖 docs/
│   ├── AZURE_SETUP_GUIDE.md      ⭐ START HERE - Complete setup instructions
│   ├── README.md                 # This file
│   ├── PROCESS.md                # Detailed implementation history
│   ├── SCHEMA.md                 # Database schema documentation
│   └── GITHUB_SETUP.md           # GitHub repository setup
│
├── 📊 sql/                       # SQL Scripts (in execution order)
│   ├── schema_for_chartdb.sql              # (Step 2) Create base tables
│   ├── bulk_load_data.sql                  # (Step 3) SQL-based load (optional)
│   ├── himalayan_expedition_cleaning.sql   # (Step 4) Normalize to 3NF
│   └── populate_decomposition_tables.sql   # (Step 5) Fill member decompositions
│
├── 💾 scripts/
│   ├── bulk_load_csv.ps1         # (Step 3) PowerShell CSV loader
│   ├── execute_batches.ps1       # Batch processing helper
│   └── generate_batched_sql.py   # Python CSV to SQL converter
│
├── 🔍 sql-queries/
│   ├── 01-schema-exploration.sql     # Explore table structures
│   ├── 02-row-count-analysis.sql     # Verify data counts
│   └── 03-data-dictionary-population.sql  # Metadata tracking
│
├── 📁 data/
│   └── himalayan_sources/
│       ├── peaks.csv                 # 480 peak records
│       ├── exped.csv                 # 11,425 expedition records
│       ├── members.csv               # 89,000 member records
│       ├── refer.csv                 # 15,586 reference records
│       └── himalayan_data_dictionary.csv
│
└── README.md, .gitignore, etc.
```

---

## 🔄 Execution Order (Critical)

Scripts MUST be run in this exact order:

| Step | Script | Type | Purpose | Time |
|------|--------|------|---------|------|
| 1 | (Verify Connection) | Manual | Test Azure connectivity | 1 min |
| **2** | `schema_for_chartdb.sql` | DDL | Create base tables | 1-2 min |
| **3** | `bulk_load_csv.ps1` | PowerShell | Load CSV data | 10-15 min |
| **4** | `himalayan_expedition_cleaning.sql` | DDL/DML | Normalize to 3NF | 5-10 min |
| **5** | `populate_decomposition_tables.sql` | DML | Fill decomposition tables | 5-10 min |

⚠️ **Running out of order will cause errors!**

---

## 📋 Prerequisites

### Required
- [ ] Azure SQL Database access credentials
- [ ] SQL Server Management Studio (SSMS) or sqlcmd
- [ ] PowerShell 5.1+ (Windows default)
- [ ] All CSV files in `data/himalayan_sources/`

### Optional but Recommended
- [ ] Git for version control
- [ ] Python 3.7+ (for advanced scripts)
- [ ] VS Code with SQL extensions

---

## ✅ Verification: Did It Work?

After completing all 5 steps, run this query:

```sql
SELECT 'peaks' AS [Table], COUNT(*) FROM dbo.peaks
UNION ALL SELECT 'exped', COUNT(*) FROM dbo.exped
UNION ALL SELECT 'members', COUNT(*) FROM dbo.members
UNION ALL SELECT 'refer', COUNT(*) FROM dbo.refer
UNION ALL SELECT 'member_person', COUNT(*) FROM dbo.member_person
UNION ALL SELECT 'member_participation', COUNT(*) FROM dbo.member_participation
UNION ALL SELECT 'member_routes', COUNT(*) FROM dbo.member_routes
UNION ALL SELECT 'member_summits', COUNT(*) FROM dbo.member_summits
ORDER BY [Table]
```

**Expected Result:**
```
Table                  Rows
─────────────────────  ──────────
exped                  11,425
member_participation   89,000
member_person              99
member_routes         267,000
member_summits        267,000
members                89,000
peaks                     480
refer                  15,586
```

✅ **If all rows match above → Success!**

---

## 📚 Documentation Map

| Document | Purpose |
|----------|---------|
| **AZURE_SETUP_GUIDE.md** | 👉 **START HERE** - Complete setup with all commands |
| README.md | Project overview (this file) |
| PROCESS.md | Detailed 30-step implementation walkthrough |
| SCHEMA.md | Database schema design documentation |
| GITHUB_SETUP.md | How to clone and set up this repository |

---

## 🏗️ Database Architecture

### Schema Layers

**Layer 1: Raw Data (Base Tables)**
- `peaks` - Peak information (480 rows)
- `exped` - Expedition records (11,425 rows)
- `members` - Member participation (89,000 rows)
- `refer` - References (15,586 rows)

**Layer 2: Normalized Tables**
- `expedition_timeline` - Expedition dates/duration
- `expedition_routes` - Routes per expedition
- `expedition_outcomes` - Results/summits
- `expedition_statistics` - Climbers, deaths, oxygen
- And 10 more expedition decompositions...

**Layer 3: Member Decompositions**
- `member_person` - 99 unique individuals
- `member_participation` - 89,000 individual participations
- `member_routes` - 267,000 route entries
- `member_summits` - 267,000 summit entries

**Layer 4: Lookups**
- `season_lookup` - Spring, Summer, Autumn, Winter
- `citizenship_lookup` - Country/citizenship mappings

---

## 🎯 Key Features

✅ **Fully Normalized** - 3rd Normal Form (3NF)  
✅ **Surrogate Keys** - ExpeditionKey, MemberKey, etc.  
✅ **Referential Integrity** - Foreign key relationships  
✅ **Lookup Tables** - Eliminate data redundancy  
✅ **Decomposition Tables** - One row per attribute  
✅ **Cloud-Ready** - Runs on Azure SQL Database  
✅ **Scalable** - Handles 500K+ rows  
✅ **Idempotent Scripts** - Safe to run multiple times  

---

## 🔧 Common Tasks

### View All Tables
```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME
```

### Count All Rows
```sql
EXEC sp_MSForEachTable 'SELECT ''?'' AS TableName, COUNT(*) AS RowCount FROM ?'
```

### Check Foreign Key Relationships
```sql
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
```

### Export Data to CSV
```powershell
sqlcmd -S "server" -d "database" -Q "SELECT * FROM table" -o "output.txt"
```

---

## 📞 Troubleshooting

**Q: Connection fails to Azure**  
A: Verify credentials, check firewall, ensure Azure SQL firewall rules allow your IP

**Q: Scripts run multiple times?**  
A: All scripts are idempotent (safe to re-run). They clean up before creating.

**Q: Row counts don't match?**  
A: Verify CSV files are in `data/himalayan_sources/` and not corrupted

**Q: Out of memory error?**  
A: Azure database may be at capacity. Wait and retry, or check Azure quotas.

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Mar 31, 2026 | Initial release - Full 3NF normalization |
| 0.5 | Mar 30, 2026 | Schema design and planning |
| 0.1 | Mar 15, 2026 | Project initiation |

---

## 👤 Author

**Ricardo Molina**  
Intermediate Analytics Course - Final Project  
Miami Dade College

---

## 📄 License

This project is for educational purposes as a course final project.

---

## 🔗 Repository

**GitHub:** https://github.com/rjmolinag0213r/himalayan-expeditions

---

## ⭐ Quick Links

- 📖 [**Azure Setup Guide**](docs/AZURE_SETUP_GUIDE.md) - **START HERE**
- 📊 [Schema Details](docs/SCHEMA.md)
- 📋 [Implementation Process](docs/PROCESS.md)
- 🔧 [GitHub Setup](docs/GITHUB_SETUP.md)

---

**Last Updated:** March 31, 2026  
**Database:** Azure SQL Database  
**Status:** ✅ Production Ready
