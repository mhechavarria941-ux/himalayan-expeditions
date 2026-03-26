# Himalayan Expeditions Database - Data Normalization & Schema Design

A comprehensive SQL Server database project for normalizing and analyzing mountaineering expedition data from the Himalayas. This project demonstrates advanced database design principles including surrogate keys, lookup tables, and 3rd Normal Form (3NF) normalization.

## 📊 Project Overview

This database contains data about:
- **480 peaks** - Mountain information and first ascent records
- **11,425 expeditions** - Expedition details across different peaks and years
- **80,824 member records** - Individual climber participation data
- **15,586 references** - Bibliographic citations and literature

**Database Platform:** Azure SQL Server (cloud-based)

## 📂 Project Structure

```
himalayan-expeditions/
├── docs/                      # Documentation
│   ├── README.md             # Main project documentation
│   ├── PROCESS.md            # Complete 30-step implementation guide
│   ├── SCHEMA.md             # Full database schema documentation
│   └── GITHUB_SETUP.md       # GitHub setup instructions
├── sql/                       # SQL scripts
│   ├── himalayan_expedition_cleaning.sql    # Main normalization script
│   ├── load_sample_data.sql                 # Sample data loading
│   └── schema_for_chartdb.sql              # ChartDB ERD visualization
├── scripts/                   # Python and PowerShell automation
│   ├── generate_batched_sql.py             # CSV to SQL batch generator
│   └── execute_batches.ps1                 # Batch execution orchestrator
├── data/                      # Source data
│   └── himalayan_sources/    # CSV files
│       ├── peaks.csv         # Mountain/peak data (480 rows)
│       ├── exped.csv         # Expedition records (11,425 rows)
│       ├── members.csv       # Member participation (80,824 rows)
│       ├── refer.csv         # References (15,586 rows)
│       └── himalayan_data_dictionary.csv
├── archived/                  # Old test scripts and temporary files
├── .gitignore                # Git ignore patterns
└── LICENSE                   # Project license
```

## 🏗️ Architecture

### Phase 1: Data Import
- Imported 5 CSV files into base tables
- Total data: ~108,000 records

### Phase 2: Data Cleaning & Validation
- Identified and handled duplicate records
- Confirmed or created primary keys for all tables
- Created surrogate keys where business keys were insufficient

### Phase 3: Normalization
- Created lookup tables (season_lookup, citizenship_lookup)
- Decomposed expedition table into specialized child tables
- Established foreign key relationships
- Achieved 3rd Normal Form (3NF)

## 📁 Database Schema

### Core Tables
- **peaks** - Mountain peak master table (PK: peakid)
- **exped** - Expedition records (PK: ExpeditionKey - surrogate)
- **members** - Member participation records (PK: MemberKey - surrogate)
- **refer** - Bibliographic references (PK: ReferenceKey - surrogate)

### Lookup Tables
- **season_lookup** - Standardized expedition seasons
- **citizenship_lookup** - Member citizenship values

### Expedition Child Tables (Normalized)
- **expedition_timeline** - Chronology and dates
- **expedition_statistics** - Member counts, deaths, hired staff
- **expedition_style** - Traverse, ski, parapente information
- **expedition_oxygen** - Oxygen usage data
- **expedition_camps** - Camp and campsite details
- **expedition_incidents** - Accidents and achievements
- **expedition_admin** - Administrative metadata (agency, checksums)

## 🔑 Key Design Decisions

1. **Surrogate Keys**: Added INT IDENTITY keys to exped, members, and refer tables to guarantee uniqueness and support relationships

2. **Business Key Preservation**: Maintained unique constraints on natural business keys:
   - exped: (expid, year)
   - members: (membid, expid, myear)
   - refer: (refid, expid, ryear)

3. **Lookup Tables**: Normalized repeated values (season, citizenship) into separate lookup tables with foreign key relationships

4. **Table Decomposition**: Split expedition attributes into focused child tables to eliminate repeating groups and transitive dependencies

5. **Foreign Key Relationships**: Established referential integrity:
   - exped → peaks, season_lookup
   - members → exped, citizenship_lookup
   - refer → exped

## 📝 SQL Scripts

### Main Scripts
- `sql/himalayan_expedition_cleaning.sql` - Complete normalization script (includes all transformations)
- `sql/load_sample_data.sql` - Small sample dataset for testing
- `scripts/generate_batched_sql.py` - CSV to SQL batch generator
- `scripts/execute_batches.ps1` - Batch execution orchestrator

### Data Files
- `data/himalayan_sources/peaks.csv` - Peak master data (480 records)
- `data/himalayan_sources/exped.csv` - Expedition records (11,425 records)
- `data/himalayan_sources/members.csv` - Member participation (80,824 records)
- `data/himalayan_sources/refer.csv` - Bibliographic references (15,586 records)
- `data/himalayan_sources/himalayan_data_dictionary.csv` - Field definitions

## 🚀 Getting Started

### Prerequisites
- Azure SQL Database or SQL Server 2019+
- SQL Server Management Studio (SSMS) or Azure Data Studio
- sqlcmd command-line tool

### Installation

1. **Clone this repository**
   ```bash
   git clone https://github.com/yourusername/himalayan-expeditions.git
   cd himalayan-expeditions
   ```

2. **Create base tables**
   ```sql
   -- Run the CREATE TABLE statements from the SQL scripts
   ```

3. **Import CSV data**
   ```bash
   # Execute batched SQL files in order
   sqlcmd -S your-server -d your-database -U username -P password -i insert_peaks_*.sql
   sqlcmd -S your-server -d your-database -U username -P password -i insert_exped_*.sql
   sqlcmd -S your-server -d your-database -U username -P password -i insert_members_*.sql
   sqlcmd -S your-server -d your-database -U username -P password -i insert_refer_*.sql
   ```

4. **Run normalization script**
   ```bash
   sqlcmd -S your-server -d your-database -U username -P password -i himalayan_expedition_cleaning.sql
   ```

## 📊 Data Insights

### Key Statistics
```sql
SELECT 'peaks' AS TableName, COUNT(*) AS RowCount FROM peaks
UNION ALL SELECT 'exped', COUNT(*) FROM exped
UNION ALL SELECT 'members', COUNT(*) FROM members
UNION ALL SELECT 'refer', COUNT(*) FROM refer;
```

**Result:**
- peaks: 480
- exped: 11,425
- members: 80,824
- refer: 15,580 (after removing orphans)

## 🔍 Sample Queries

### Find expeditions on a specific peak
```sql
SELECT e.expid, e.[year], e.season, st.totmembers, st.smtmembers
FROM exped e
JOIN peaks p ON e.peakid = p.peakid
JOIN expedition_statistics st ON e.ExpeditionKey = st.ExpeditionKey
WHERE p.pkname = 'Ama Dablam'
ORDER BY e.[year];
```

### Member participation summary
```sql
SELECT p.fname, p.lname, COUNT(mp.MemberParticipationKey) AS expedition_count
FROM member_person p
LEFT JOIN member_participation mp ON p.PersonKey = mp.PersonKey
GROUP BY p.PersonKey, p.fname, p.lname
ORDER BY expedition_count DESC;
```

### Successful expeditions by season
```sql
SELECT s.SeasonName, COUNT(*) AS total_expeditions, 
       SUM(CAST(st.smtmembers AS INT)) AS total_summiteers
FROM exped e
JOIN season_lookup s ON e.SeasonKey = s.SeasonKey
JOIN expedition_statistics st ON e.ExpeditionKey = st.ExpeditionKey
WHERE e.claimed = 'FALSE' AND e.disputed = 'FALSE'
GROUP BY s.SeasonName;
```

## 📚 Documentation

See [PROCESS.md](./PROCESS.md) for detailed step-by-step process documentation.

See [SCHEMA.md](./SCHEMA.md) for complete schema documentation and ERD.

See [GITHUB_SETUP.md](./GITHUB_SETUP.md) for GitHub repository setup instructions.

## 🛠️ Technologies Used

- **Database**: Microsoft SQL Server / Azure SQL Database
- **ELT**: Python (CSV processing)
- **Scripting**: PowerShell, T-SQL
- **Version Control**: Git

## 📖 Project Background

This project is part of CAP2761C Intermediate Analytics course at Miami Dade College. It demonstrates:
- Data normalization and schema design
- Handling real-world data quality issues
- Surrogate key implementation
- Referential integrity and foreign keys
- Data decomposition and table relationships

## 📄 License

This project is open source and available for educational use.

## 👤 Author

Ricardo Molina  
Miami Dade College - CAP2761C Intermediate Analytics

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

**Last Updated:** March 26, 2026  
**Database Status:** ✅ Normalized to 3NF | ✅ All data imported | ✅ Foreign keys enforced
