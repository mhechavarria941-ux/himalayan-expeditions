# Himalayan Expeditions Analysis Queries

## Production Query Files (ALL TESTED & WORKING)

### Setup & Verification (01-03)
- **01-schema-exploration.sql**: Verify database schema and table structure
- **02-row-count-analysis.sql**: Count records and data distribution  
- **03-data-dictionary-population.sql**: Load/verify data dictionary

### Block 1: Death Zone Demographics (04)
**File**: `04-death-zone-demographics.sql`  
**Queries**: 4 | **Records Analyzed**: 150,000+ | **Focus**: Mortality patterns by age, location, season
- Query 1: Top 15 deadliest peaks with mortality metrics
- Query 2: Death causes by peak and season (avalanche, fall, crevasse, etc.)
- Query 3: Age and mortality analysis (rate by age bracket)
- Query 4: Peak lethality index correlations

**Key Findings**: Annapurna I deadliest (1/7 mortality); mortality ranges 0.3%-1.3% by age

### Block 2: Sherpa Indispensable (05)
**File**: `05-sherpa-indispensable-CORRECTED.sql` ⭐ **FULL VERSION - RECOMMENDED**  
**Queries**: 4 | **Records Analyzed**: 150,000+ | **Focus**: Economic and social equity in mountaineering
- Query 5: Sherpa participation rates and summit achievement with window functions
- Query 6: Mortality disparity between guides/Sherpas and paying climbers
- Query 7: Guide intensity vs. expedition success and safety outcomes
- Query 8: Sherpa citizenship and national economic patterns

**Key Findings**: Sherpas 30-50% of participants, achieve 40%+summits, mortality 2-3x higher

### Block 3: Everest Effect (06)
**File**: `06-everest-effect.sql`  
**Queries**: 3 | **Records Analyzed**: 10,000+ | **Focus**: Commercialization transformation over time
- Query 9: Team size explosion by era (1960s→2010s)
- Query 10: Most popular peaks (Everest 2,344 expeditions)
- Query 11: Everest year-by-year growth (1921-2024)

**Key Findings**: Exponential growth from elite climbing (1-2 expeditions/year pre-1980s) to mass tourism (100+ expeditions/year by 2020s)

### Block 4: National Cultures (07)
**File**: `07-national-cultures.sql`  
**Queries**: 4 | **Records Analyzed**: 150,000+ | **Focus**: Cultural and geographic patterns in mountaineering
- Query 12: National success rankings by competition metrics
- Query 13: Sherpa origins and guide labor market distribution
- Query 14: Peak diversity patterns (global explorers vs. regional specialists)
- Query 15: Expedition participation frequency by nationality

**Key Findings**: Nepal dominates (30K+ climbers); USA/UK lead organized expeditions; Japan emerging climbers

## Quick Start

```sql
-- Connect to database
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U admin_ct -P demo123

-- Run any query block
sqlcmd -i sql-queries/04-death-zone-demographics.sql
sqlcmd -i sql-queries/05-sherpa-indispensable-CORRECTED.sql
sqlcmd -i sql-queries/06-everest-effect.sql
sqlcmd -i sql-queries/07-national-cultures.sql
```

## Technical Details

### All Queries Feature:
✅ Comprehensive storytelling comments  
✅ Research questions and data context  
✅ Advanced SQL techniques (CTEs, window functions, subqueries)  
✅ Proper type conversions (nvarchar → INT/FLOAT/BOOLEAN)  
✅ Tested and verified with production data  

### Data Type Conversions Used:
- Numeric: `CAST(column AS INT)` or `CAST(column AS FLOAT)`
- Boolean: Compare to 'TRUE'/'FALSE' (not 'T'/'F')
- Dates: `CAST(year AS INT)` for year-based grouping
- Aggregates: Division operations use `/ NULLIF(..., 0)` to prevent divide-by-zero

## Statistics

| Item | Count |
|------|-------|
| Total Query Files | 7 |
| Production Queries | 15 |
| Total Query Lines | 850+ |
| Records Analyzed | 300,000+ |
| Database Tables | 4 core + 3 optional |
| Tested & Working | 100% ✅ |

## For Class Submission

This directory contains a production-ready set of 15 analysis queries organized into 4 thematic storytelling blocks. Every query has been:
- ✅ Tested with real data
- ✅ Documented with business context and expected insights
- ✅ Optimized for Himalayan expedition analytics
- ✅ Formatted for easy reading and modification

Perfect for: School project, business analysis, data visualization, and further research!
