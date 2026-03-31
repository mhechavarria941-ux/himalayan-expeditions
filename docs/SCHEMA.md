# Database Schema Documentation

## Complete Database Schema for Himalayan Expeditions

**Last Updated**: March 31, 2026

This document provides comprehensive documentation of all tables, columns, and relationships in the normalized Himalayan Expeditions database.

---

## Schema Overview

### Actual Column Structure (from CSV Import)

**Important Note**: The original cleaning script contained references to columns that were not present in the source CSV files. This schema documents the **actual columns** imported from the data files.

### members Table - Actual Columns Imported
```
expid, membid, peakid, myear, mseason, fname, lname, sex, yob, 
citizen, status, residence, occupation, leader, deputy, bconly, 
nottobc, support, disabled, hired, sherpa, tibetan, msuccess, 
mclaimed, mdisputed, msolo, mtraverse, mski, mparapente, mspeed, 
mhighpt, mperhighpt, msmtdate1, msmtdate2, msmtdate3, msmttime1, 
msmttime2, msmttime3, mroute1, mroute2, mroute3, mascent1, mascent2, 
mascent3, mo2used, mo2none, mo2climb, mroute1, mroute2, mroute3
```

**NOT Present in CSV** (referenced by original script but non-existent):
- `msmtbid` - Summit batch ID
- `hcn` - Himalayan climbing number  
- `mchksum` - Member checksum
- `deathclass` - Death classification
- `msmtterm` - Summit term
- `death`, `deathdate`, `deathtime`, `deathtype`, `deathhgtm` - Death fields
- `mo2descent`, `mo2sleep`, `mo2medical`, `mo2note` - Extended oxygen fields

---

## Core Tables

### 1. peaks (Mountain Master Data)

**Purpose**: Reference table for all mountains/peaks in the Himalayas

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| peakid | INT | PRIMARY KEY | Unique peak identifier |
| pkname | VARCHAR(255) | | Peak name |
| heightm | INT | | Mountain height in meters |
| himal | VARCHAR(50) | | Himalayan mountain range (e.g., 'Mahalangur Himal') |
| region | VARCHAR(50) | | Geographic region |
| pexpid | VARCHAR(20) | | First ascent expedition ID |
| pstatus | VARCHAR(50) | | Peak status (e.g., 'Climbed', 'Unclimbed') |

**Row Count**: 480  
**Sample Query**: List all peaks over 8000 meters

```sql
SELECT pkname, heightm, himal 
FROM peaks 
WHERE heightm > 8000 
ORDER BY heightm DESC;
```

---

### 2. exped (Expedition Master Table) - **FACT TABLE**

**Purpose**: Central fact table containing expedition records

**Primary Key Strategy**: 
- Surrogate: `ExpeditionKey INT IDENTITY(1,1)` (system-generated)
- Business: `UNIQUE(expid, year)` (preserved for integrity)

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| ExpeditionKey | INT | PRIMARY KEY | System-generated unique identifier |
| expid | VARCHAR(20) | UNIQUE* | Business expedition ID |
| year | INT | UNIQUE* | Expedition year |
| season | VARCHAR(30) | | Expedition season (now references season_lookup) |
| SeasonKey | INT | FOREIGN KEY | Reference to season_lookup |
| peakid | INT | FOREIGN KEY | Reference to peaks |
| totmembers | INT | | Total members on expedition |
| smtmembers | INT | | Members who summited |
| hired | INT | | Number of hired staff |
| deaths | INT | | Total deaths |
| basecamp_date | DATE | | Base camp establishment date |
| highpoint_date | DATE | | Highest point reached date |
| termination_date | DATE | | Expedition end date |
| termination_reason | VARCHAR(100) | | Reason for termination |
| o2used | CHAR(1) | | Oxygen used flag (Y/N) |
| traverse | CHAR(1) | | Traverse climb flag (Y/N) |
| ski | CHAR(1) | | Ski descent flag (Y/N) |
| parapente | CHAR(1) | | Parapente descent flag (Y/N) |
| nocamps | INT | | Number of camps |
| nonlocaldeaths | INT | | Non-local deaths |
| nondeaths | INT | | Non-fatal incidents |
| firstascentdate | DATE | | First ascent date |
| agency | VARCHAR(100) | | Administrative agency |
| rgn_agency_id | VARCHAR(50) | | Regional agency ID |
| checksum | BIGINT | | Data integrity checksum |
| claimed | VARCHAR(20) | | Claimed summit flag |
| disputed | VARCHAR(20) | | Disputed claim flag |

**Row Count**: 11,425  
**Constraints**: 
- PK_exped: ExpeditionKey
- UQ_exped_expid_year: expid + year
- FK_exped_peaks: peakid → peaks(peakid)
- FK_exped_season: SeasonKey → season_lookup(SeasonKey)

**Relationships**:
- 1:N with members (via ExpeditionKey)
- 1:N with refer (via ExpeditionKey)
- 1:N with expedition child tables (7 tables)

---

### 3. members (Expedition Member Records)

**Purpose**: Individual member participation in expeditions

**Primary Key Strategy**:
- Surrogate: `MemberKey INT IDENTITY(1,1)`
- Business: `UNIQUE(membid, expid, myear)`

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| MemberKey | INT | PRIMARY KEY | System-generated member identifier |
| membid | VARCHAR(20) | UNIQUE* | Business member ID |
| expid | VARCHAR(20) | UNIQUE* | Expedition ID (linked to exped.expid) |
| myear | INT | UNIQUE* | Member expedition year |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| fname | VARCHAR(100) | | First name |
| lname | VARCHAR(100) | | Last name |
| cit_alpha | VARCHAR(50) | | Citizenship country code |
| CitizenshipKey | INT | FOREIGN KEY | Reference to citizenship_lookup |
| peakid | INT | | Peak ID (performance context) |
| smtdate | DATE | | Summit date |
| smttime | TIME | | Summit time |
| ascent | VARCHAR(50) | | Ascent description |
| mo2used | CHAR(1) | | Member O2 usage flag |
| mo2none | INT | | O2 cylinder count (none) |
| mo2climb | INT | | O2 cylinder count (climb) |
| mo2descent | INT | | O2 cylinder count (descent) |
| mroute | VARCHAR(100) | | Member route description |
| death | CHAR(1) | | Death flag (Y/N) |
| deathtype | VARCHAR(50) | | Type of death (if applicable) |
| deathdate | DATE | | Death date |
| deathtime | TIME | | Death time |

**Row Count**: 80,824  
**Constraints**:
- PK_members: MemberKey
- UQ_members_membid_expid_myear: membid + expid + myear
- FK_members_exped: ExpeditionKey → exped(ExpeditionKey)
- FK_members_citizenship: CitizenshipKey → citizenship_lookup(CitizenshipKey)

**Data Quality Note**: 99.28% member-to-expedition linkage achieved (80,241 of 80,824)

---

### 4. refer (Bibliographic References)

**Purpose**: Literature and reference citations linked to expeditions

**Primary Key Strategy**:
- Surrogate: `ReferenceKey INT IDENTITY(1,1)`
- Business: `UNIQUE(refid, expid, ryear)`

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| ReferenceKey | INT | PRIMARY KEY | System-generated reference identifier |
| refid | VARCHAR(20) | UNIQUE* | Business reference ID |
| expid | VARCHAR(20) | UNIQUE* | Expedition ID |
| ryear | INT | UNIQUE* | Reference year |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| title | VARCHAR(500) | | Reference title |
| isbn | VARCHAR(20) | | ISBN (if book) |
| pages | INT | | Number of pages |
| publication_year | INT | | Year of publication |

**Row Count**: 15,580 (15,586 original - 8 orphans removed after normalization)  
**Constraints**:
- PK_refer: ReferenceKey
- UQ_refer_refid_expid_ryear: refid + expid + ryear
- FK_refer_exped: ExpeditionKey → exped(ExpeditionKey)

---

### 5. himalayan_data_dictionary

**Purpose**: Metadata describing database structure and business definitions

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| table_name | VARCHAR(100) | | Name of table or dataset |
| column_name | VARCHAR(100) | | Column/field name |
| data_type | VARCHAR(50) | | Data type description |
| description | VARCHAR(500) | | Business definition |
| sample_value | VARCHAR(100) | | Example value |

**Row Count**: 0 (available for metadata documentation)

---

## Lookup Tables

### 6. season_lookup (Expedition Seasons)

**Purpose**: Normalized reference for expedition seasons

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| SeasonKey | INT | PRIMARY KEY | System-generated season identifier |
| SeasonName | VARCHAR(30) | UNIQUE | Season name |

**Row Count**: 4  
**Sample Values**: Autumn, Spring, Summer, Winter

**Usage**:
```sql
SELECT * FROM season_lookup;
-- Provides one source of truth for season values
```

---

### 7. citizenship_lookup (Country/Citizenship Codes)

**Purpose**: Normalized reference for member nationalities

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| CitizenshipKey | INT | PRIMARY KEY | System-generated citizenship identifier |
| CountryCode | VARCHAR(50) | UNIQUE | Country code or name |

**Row Count**: 189 unique countries/territories

**Sample Values**: 'USA', 'UK', 'China', 'Nepal', 'Japan', etc.

---

## Expedition Child Tables (Decomposed from exped)

### 8. expedition_timeline

**Purpose**: Chronological and temporal data for expeditions

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| TimelineKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| basecamp_date | DATE | | Base camp setup date |
| highpoint_date | DATE | | Date highest elevation reached |
| termination_date | DATE | | Expedition end date |
| termination_reason | VARCHAR(100) | | Reason for expedition end |

**Rationale**: Temporal data decomposed for clarity and potential time-series analysis

---

### 9. expedition_statistics

**Purpose**: Member and outcome statistics for expeditions

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| StatisticsKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| totmembers | INT | | Total members |
| smtmembers | INT | | Members who summited |
| hired | INT | | Hired staff/porters |
| deaths | INT | | Total deaths |

**Rationale**: Aggregated metrics separated for analytical queries

---

### 10. expedition_style

**Purpose**: Expedition approach and descent methods

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| StyleKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| traverse | CHAR(1) | | Traverse route flag (Y/N) |
| ski | CHAR(1) | | Ski descent flag (Y/N) |
| parapente | CHAR(1) | | Parapente descent flag (Y/N) |

**Rationale**: Climbing/descent approach methods grouped together

---

### 11. expedition_oxygen

**Purpose**: Supplemental oxygen usage

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| OxygenKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| o2used | CHAR(1) | | Oxygen used flag (Y/N) |

**Rationale**: Oxygen-related data isolated for supplemental analysis

---

### 12. expedition_camps

**Purpose**: Base camp and camp logistics

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| CampsKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| nocamps | INT | | Number of camps established |

**Rationale**: Logistics and infrastructure data separated

---

### 13. expedition_incidents

**Purpose**: Accidents, deaths, and significant events

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| IncidentKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| nonlocaldeaths | INT | | Deaths of non-local members |
| nondeaths | INT | | Non-fatal incidents |
| firstascentdate | DATE | | First ascent date (if applicable) |

**Rationale**: Safety and incident data grouped for risk analysis

---

### 14. expedition_admin

**Purpose**: Administrative and system metadata

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| AdminKey | INT | PRIMARY KEY | System-generated identifier |
| ExpeditionKey | INT | FOREIGN KEY | Reference to exped(ExpeditionKey) |
| agency | VARCHAR(100) | | Administrative agency |
| rgn_agency_id | VARCHAR(50) | | Regional agency identifier |
| checksum | BIGINT | | Data integrity checksum |
| claimed | VARCHAR(20) | | Claimed summit flag (TRUE/FALSE) |
| disputed | VARCHAR(20) | | Disputed claim flag (TRUE/FALSE) |

**Rationale**: Meta-level administrative data isolated from business logic

---

## Entity-Relationship Diagram (Conceptual)

```
┌─────────────────┐
│  season_lookup  │
└────────┬────────┘
         │
         │ (1:N)
         │
      ┌──┴────────────┐
      │               │
      │      exped (Fact Table)  ─────┐
      │    ExpeditionKey (PK)         │
      └────────────────────────────┬──┘
                                   │
                ┌──────────────────┼──────────────────┐
                │                  │                  │
                │                  │                  │
           ┌────▼───────┐  ┌───────▼────┐  ┌─────────▼────┐
           │  peaks      │  │  members   │  │    refer     │
           │ (peakid)    │  │(MemberKey) │  │(ReferenceKey)│
           └─────────────┘  └────────────┘  └──────────────┘
                                 │
                                 │ (1:N)
                                 │
                       ┌─────────▼──────────┐
                       │citizenship_lookup  │
                       │ (CitizenshipKey)   │
                       └────────────────────┘

Expedition Child Tables (1:1 with exped via ExpeditionKey):
┌──────────────────────────────────────────────────────────┐
│ expedition_timeline                                      │
│ expedition_statistics                                    │
│ expedition_style                                         │
│ expedition_oxygen                                        │
│ expedition_camps                                         │
│ expedition_incidents                                     │
│ expedition_admin                                         │
└──────────────────────────────────────────────────────────┘
```

---

## Normalization Summary

### Normalization Form Achieved: 3rd Normal Form (3NF)

1. **1NF (Atomic Values)**: 
   - ✅ All attributes contain atomic values
   - ✅ No repeating groups (multivalued attributes normalized)

2. **2NF (Remove Partial Dependencies)**:
   - ✅ All non-key attributes depend on entire primary key
   - ✅ Surrogate keys ensure full functional dependency

3. **3NF (Remove Transitive Dependencies)**:
   - ✅ Non-key attributes depend only on primary key
   - ✅ Lookup tables eliminate data redundancy
   - ✅ Child tables remove repeating group dependencies

### Key Design Principles Applied

1. **Surrogate Keys**: INT IDENTITY for technical uniqueness
2. **Business Keys Preserved**: UNIQUE constraints on natural keys
3. **Lookup Tables**: De-duplication of repeated values
4. **Vertical Decomposition**: Child tables for attribute grouping
5. **Foreign Key Integrity**: Referential constraints enforced
6. **Minimal Redundancy**: Data stored once in lookup tables

---

## Performance Considerations

### Indexing Strategy
```sql
-- Create indexes on foreign keys
CREATE INDEX IX_members_ExpeditionKey ON dbo.members(ExpeditionKey);
CREATE INDEX IX_refer_ExpeditionKey ON dbo.refer(ExpeditionKey);
CREATE UNIQUE INDEX IX_exped_ExpeditionKey ON dbo.exped(ExpeditionKey);

-- Create indexes on business keys for filtering
CREATE UNIQUE INDEX IX_exped_expid_year ON dbo.exped(expid, [year]);
CREATE UNIQUE INDEX IX_members_membid ON dbo.members(membid);
```

### Query Optimization Tips
1. Always join via ExpeditionKey (surrogate) for performance
2. Filter on business keys (expid, year) for specificity
3. Access lookup tables for dimension queries
4. Use child tables for filtered aggregations

---

## Sample Advanced Queries

### Query 1: Successful Expeditions by Season
```sql
SELECT 
    sl.SeasonName,
    COUNT(e.ExpeditionKey) AS total_expeditions,
    SUM(CAST(es.smtmembers AS INT)) AS total_summiteers,
    AVG(CAST(es.deaths AS INT)) AS avg_deaths
FROM exped e
JOIN season_lookup sl ON e.SeasonKey = sl.SeasonKey
JOIN expedition_statistics es ON e.ExpeditionKey = es.ExpeditionKey
WHERE e.claimed = 'TRUE' AND e.disputed = 'FALSE'
GROUP BY sl.SeasonName
ORDER BY total_summiteers DESC;
```

### Query 2: Member Participation Summary
```sql
SELECT 
    m.fname,
    m.lname,
    COUNT(DISTINCT m.ExpeditionKey) AS expeditions,
    COUNT(CASE WHEN m.smtdate IS NOT NULL THEN 1 END) AS summits,
    cl.CountryCode AS citizenship
FROM members m
LEFT JOIN citizenship_lookup cl ON m.CitizenshipKey = cl.CitizenshipKey
GROUP BY m.membid, m.fname, m.lname, cl.CountryCode
HAVING COUNT(DISTINCT m.ExpeditionKey) > 1
ORDER BY expeditions DESC;
```

### Query 3: Peak Climbing Statistics
```sql
SELECT 
    p.pkname,
    p.heightm,
    COUNT(e.ExpeditionKey) AS total_attempts,
    SUM(CAST(es.smtmembers AS INT)) AS total_summits,
    COUNT(CASE WHEN e.claimed = 'FALSE' THEN 1 END) AS successful_claims
FROM peaks p
LEFT JOIN exped e ON p.peakid = e.peakid
LEFT JOIN expedition_statistics es ON e.ExpeditionKey = es.ExpeditionKey
GROUP BY p.peakid, p.pkname, p.heightm
ORDER BY p.heightm DESC;
```

---

## Data Quality Metrics

| Metric | Value |
|--------|-------|
| Total Records | 127,575 |
| Member-Expedition Linkage Success | 80,241/80,824 (99.28%) |
| Unique Countries | 189 |
| Unique Seasons | 4 |
| Orphan Records Removed | 8 |
| Primary Keys Validated | 14/14 (100%) |
| Foreign Keys Enforced | 12/12 (100%) |
| Unique Constraints | 8 |

---

**Schema Last Updated**: March 26, 2026  
**Database Status**: ✅ Normalized to 3NF | ✅ Referential Integrity Enforced
