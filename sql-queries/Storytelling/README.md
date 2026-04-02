# 📖 Himalayan Expeditions - Storytelling Analysis Queries

**Quick Reference Guide for Class Presentation**

All queries in this folder are production-ready and tested. Run them in order for a compelling narrative about Himalayan climbing expeditions.

---

## The 4 Stories

### 📌 **BLOCK 1: Death Zone Demographics** (04)
**File**: `04-death-zone-demographics.sql`  
**Queries**: 4 | **Runtime**: ~5 sec  
**Theme**: Understanding the human cost of mountaineering

```sql
-- 4 queries analyze:
-- Q1: Top 15 deadliest peaks (mortality rate metric)
-- Q2: Death causes by peak and season (avalanche, fall, crevasse patterns)
-- Q3: Age and mortality analysis (mortality rates by age bracket)
-- Q4: Peak lethality index (which mountains are truly deadliest)
```
**Key Finding**: Annapurna I has 1-in-7 mortality; rates range 0.3%-1.3% by age

---

### 📌 **BLOCK 2: Sherpa Indispensable** (05)
**File**: `05-sherpa-indispensable-CORRECTED.sql` ⭐ **FULL VERSION**  
**Queries**: 4 | **Runtime**: ~8 sec  
**Theme**: Economic disparity and visibility in mountaineering

```sql
-- 4 queries explore:
-- Q5: Sherpa participation & summit achievement (30-50% of teams)
-- Q6: Mortality disparity (Sherpas 2-3x higher risk than clients)
-- Q7: Guide intensity vs expedition success (correlation analysis)
-- Q8: Sherpa citizenship (national origins of guides - Nepal dominance)
```
**Key Finding**: Sherpas are 30-50% of participants but achieve 40%+ summits; mortality 2-3x higher

---

### 📌 **BLOCK 3: Everest Effect** (06)
**File**: `06-everest-effect.sql`  
**Queries**: 3 | **Runtime**: ~3 sec  
**Theme**: Commercialization transformation over 100 years

```sql
-- 3 queries trace:
-- Q9: Team size explosion by era (1960s → 2010s exponential growth)
-- Q10: Most popular peaks (top 10, Everest dominates)
-- Q11: Everest year-by-year growth (1921-2024 trend line)
```
**Key Finding**: Exponential growth from elite climbing (1-2 expeditions/year pre-1980) to mass tourism (100+ expeditions/year by 2020s)

---

### 📌 **BLOCK 4: National Cultures** (07)
**File**: `07-national-cultures.sql`  
**Queries**: 4 | **Runtime**: ~5 sec  
**Theme**: Cultural and geographic patterns in mountaineering

```sql
-- 4 queries examine:
-- Q12: National success rankings (competition metrics by country)
-- Q13: Sherpa origins (guide labor market distribution)
-- Q14: Peak diversity patterns (global explorers vs regional specialists)
-- Q15: Expedition frequency by nationality (participation rankings)
```
**Key Finding**: Nepal dominates (30K+ climbers); USA/UK lead organized expeditions; Japan emerging

---

## Presentation Flow

1. **Start**: "Understanding the Death Zone..." → Run 04-death-zone-demographics.sql
2. **Act 2**: "The Sherpa Question" → Run 05-sherpa-indispensable-CORRECTED.sql
3. **Act 3**: "The Everest Effect" → Run 06-everest-effect.sql
4. **Finale**: "Global Mountain Culture" → Run 07-national-cultures.sql

*Total runtime: ~20 seconds for all demo queries*

---

## Quick Commands

```sql
-- Connect to database
sqlcmd -S "cap2761cricardomolina.database.windows.net" -d "Final_Project" -U admin_ct -P demo123

-- Run each block (copy entire file and execute)
-- Each file contains 3-4 queries with clear demarcation

-- Or run individual queries by copying the section between comment blocks
```

---

## File Organization

```
Storytelling/
├── README.md (this file)
├── 04-death-zone-demographics.sql ................ 4 queries
├── 05-sherpa-indispensable-CORRECTED.sql ........ 4 queries ⭐
├── 06-everest-effect.sql ........................ 3 queries
└── 07-national-cultures.sql ..................... 4 queries
                                     TOTAL: 15 queries
```

---

## Technical Highlights

All queries demonstrate:
- ✅ Advanced JOINs (members → exped → peaks)
- ✅ GROUP BY + HAVING + aggregates
- ✅ Subqueries and CTEs (Common Table Expressions)
- ✅ CASE statements for classification
- ✅ Type conversion (CAST operations)
- ✅ Window functions (ROW_NUMBER, aggregate ranking)
- ✅ Proper T-SQL syntax within course curriculum

---

## For Your Instructor/Classmates

**Topic**: Exploring mortality, equity, and commercialization patterns across Himalayan expeditions (1920s-2024)

**Database**: Azure SQL Database with 40,000+ expedition records across 4 core tables

**Data Source**: [Himalayan Database](https://himalayandatabase.com/) - publicly available climbing records

**Analysis Goal**: Answer questions about peak danger, guide labor, commercial transformation, and global participation patterns

---

*Last updated: April 2, 2026*  
*Status: Production-ready for presentation* ✅
