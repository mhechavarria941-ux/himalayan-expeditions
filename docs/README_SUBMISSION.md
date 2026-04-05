# Himalayan Expeditions Database Analysis

## Project Overview
A comprehensive SQL-based analysis of Himalayan climbing expeditions from 1920s to 2024, featuring 21 production-ready queries organized in 4 thematic storytelling blocks. This project analyzes mortality patterns, economic structures, commercialization trends, and cultural climbing patterns across the world's highest mountains.

## Database
- **Database**: Azure SQL Database (`Final_Project`)
- **Server**: `cap2761cricardomolina.database.windows.net`
- **Tables**: 4 core tables + data dictionary + derived tables
- **Records**: 40,000+ expedition records with 150+ attributes

## Project Structure

```
himalayan-expeditions/
├── README.md (this file)
├── sql/                          # Database setup & utility files
│   ├── schema_for_chartdb.sql   # Main schema definition
│   ├── sp-analyze-peak-risk.sql # Optional stored procedure
│   └── views-analysis.sql       # Optional analysis views
│
├── sql-queries/                  # 21 production queries
│   ├── 01-03: Setup queries     # Schema exploration & verification
│   ├── 04: Death Zone Demographics (4 queries)
│   ├── 05: Sherpa Indispensable (4 queries)  
│   ├── 06: Everest Effect (3 queries)
│   └── 07: National Cultures (4 queries)
│
├── docs/                         # Documentation
│   ├── README.md               # Project details
│   ├── SCHEMA.md               # Database schema reference
│   └── [other references]
│
└── data/                         # Source CSV files
    └── himalayan_sources/       # Original data files
```

## Query Blocks Summary

### Block 1: Death Zone Demographics (04) - 4 Queries
**Theme**: Understanding the human cost of mountaineering
- Query 1: Deadliest peaks by comparison metrics
- Query 2: Death causes by peak and season (avalanche, fall, crevasse)
- Query 3: Age and mortality analysis by experience level
- Query 4: Peak lethality index with correlations

**Key Finding**: Mortality rates vary 0.3%-1.3% by age group; peaks like Annapurna I have 1-in-7 fatality rates.

### Block 2: Sherpa Indispensable (05) - 4 Queries
**Theme**: Economic disparity and the role of guides
- Query 5: Sherpa/guide participation and summit rates
- Query 6: Mortality disparity between guides and paying climbers
- Query 7: Guide intensity correlation with expedition success
- Query 8: Sherpa citizenship and national origins

**Key Finding**: Sherpas comprise 30-50% of climbers but achieve 40%+ of summits; mortality 2-3x higher.

### Block 3: Everest Effect (06) - 3 Queries
**Theme**: Commercialization and mass tourism transformation
- Query 9: Team size explosion by historical era
- Query 10: Most popular peaks (Everest dominates with 2,344 expeditions)
- Query 11: Everest year-by-year growth since 1921 (1 expedition → 100+ per year)

**Key Finding**: Sharp growth from elite climbing (1960s) to mass industry (2010s).

### Block 4: National Cultures (07) - 4 Queries  
**Theme**: How nationality shapes climbing culture and outcomes
- Query 12: National success rankings by summit rates
- Query 13: Sherpa origins and guiding labor markets
- Query 14: Peak diversity by nation (global explorers vs. local specialists)
- Query 15: Expedition participation patterns by nationality

**Key Finding**: Nepal produces most climbers/guides; USA/UK lead participation; Japan emerging as skilled climbers.

## Technical Highlights

### Data Type Solutions
- All numeric/boolean columns stored as nvarchar(255)
- Solution: Applied CAST operations for all arithmetic operations
- Boolean values: Stored as 'TRUE'/'FALSE' strings (not 'T'/'F')

### Advanced SQL Techniques
- Window functions (ROW_NUMBER, running averages, OVER clauses)
- Complex CTEs (Common Table Expressions) for hierarchical analysis
- Subqueries and nested aggregations
- Multi-table JOINs with aggregate filtering
- CASE statements for classification and categorization

### Testing & Verification
- ✅ All 21 queries tested and verified working
- ✅ Data type conversions validated
- ✅ Performance optimized with proper indexing
- ✅ Example results included for reference

## Running the Queries

### Prerequisites
```sql
-- Ensure database is created and populated
USE Final_Project;
GO

-- Verify schema exists
SELECT * FROM information_schema.TABLES;
```

### Execute Block by Block
```sql
-- Block 1: Death Zone Demographics
sqlcmd -S server -d Final_Project -i sql-queries/04-death-zone-demographics.sql

-- Block 2: Sherpa Indispensable  
sqlcmd -S server -d Final_Project -i sql-queries/05-sherpa-indispensable-CORRECTED.sql

-- Block 3: Everest Effect
sqlcmd -S server -d Final_Project -i sql-queries/06-everest-effect.sql

-- Block 4: National Cultures
sqlcmd -S server -d Final_Project -i sql-queries/07-national-cultures.sql
```

## Key Statistics

| Metric | Value |
|--------|-------|
| Total Expeditions | 10,000+ |
| Total Participants | 150,000+ |
| Death Toll | 4,000+ |
| Deadliest Peak | Annapurna I (1 in 7 mortality) |
| Most Climbed Peak | Everest (2,344 expeditions) |
| Peak Nation | Nepal (30,000+ participants) |
| Era with Most Growth | 2000s → 2010s (1.4x increase) |

## Optional Components

### Stored Procedure: sp_AnalyzePeakRisk
Analyzes peak-specific risk metrics including mortality rates, mean age of climbers, and success correlations.

### Views: Peak & Member Analysis
- `vw_MemberExpeditionAnalysis`: Member demographics with expedition context
- `vw_PeakStatisticsSummary`: Comprehensive peak statistics with risk classification

## Class Submission Checklist

✅ All required queries working and tested  
✅ Comprehensive documentation and comments  
✅ Data type issues resolved and documented  
✅ Clean repository structure for submission  
✅ Example query results available  
✅ Schema and setup scripts included  
✅ Professional README and documentation  
✅ Git history maintained for tracking changes  

## Author & Submission
- **Student**: Ricardo Molina
- **Institution**: Miami Dade College
- **Course**: Final Database Project
- **Database**: Azure SQL Server
- **Project Date**: March-April 2026

---

**Ready for class submission!** 🏔️
