# Database Table Structure Documentation

**Updated**: March 31, 2026

## Overview

The Himalayan Expeditions database consists of 21 normalized tables organized into 5 main categories. This document explains the structure, relationships, and key design decisions.

---

## Table Categories

### 1. CORE TABLES (4 tables)
Foundational tables containing primary data after CSV import.

#### peaks (23 columns)
**Source**: peaks.csv  
**Primary Key**: peakid  
**Purpose**: Master reference table for all mountains/peaks

```
Structure:
├── Identification: peakid, pkname, pkname2
├── Physical: heightm, heightf, location, region, himal
├── Access: open, unlisted, trekking, trekyear, restrict
├── First Ascent: pexpid, psummiters, psmtnote
├── Admin: phost, pstatus, pyear, pseason, pmonth, pday, pcountry
└── Count: 480 rows
```

#### exped (65 columns)
**Source**: exped.csv  
**Primary Key**: ExpeditionKey (IDENTITY surrogate)  
**Business Key**: UNIQUE(expid, year)  
**Purpose**: Central expedition facts table; contains detailed expedition logistics and results

```
Structure:
├── Identification: expid, year, season, peakid
├── Location: host, nation, countries, approach, route1-4
├── Dates: bcdate, smtdate, smttime, smtdays, totdays, termdate
├── Success: success1-4, ascent1-4, claimed, disputed
├── Team: leaders, sponsor, nations
├── Participants: totmembers, smtmembers, nohired, tothired, smthired, comrte, stdrte, primrte, primmem, primref, primid
├── Fatalities: mdeaths, hdeaths
├── Oxygen: o2used, o2none, o2climb, o2descent, o2sleep, o2medical, o2taken, o2unkwn
├── Admin: termreason, termnote, campsites, camps, rope, highpoint
├── Climbing Style: traverse, ski, parapente, achieve
├── Special Notes: othersmts, accidents, agency
└── Count: 11,425 rows
```

#### members (43 columns)
**Source**: members.csv  
**Primary Key**: MemberKey (IDENTITY surrogate)  
**Business Key**: UNIQUE(membid, expid, myear)  
**Purpose**: Individual climber participation records; normalized from denormalized source

```
Structure:
├── Identification: membid, expid, peakid, myear, mseason
├── Participation: status, leader, hired, sherpa, tibetan
├── Details: fname, lname, sex, yob, citizen, residence, occupation
├── Summit Attempts (1-3):
│   ├── msmtdate1-3: Summit date
│   ├── msmttime1-3: Summit time
│   ├── mroute1-3: Route taken
│   └── mascent1-3: Ascent description
├── Outcomes: msuccess, mclaimed, mdisputed, msolo, death
├── Climbing Style: mtraverse, mski, mparapente
├── Performance: mspeed, mhighpt, mperhighpt
├── Oxygen: mo2used, mo2none, mo2climb
└── Count: 80,824 rows (with member_person decomposition: 4 unique)
```

#### refer (12 columns)
**Source**: refer.csv  
**Primary Key**: ReferenceKey (IDENTITY surrogate)  
**Business Key**: UNIQUE(refid, expid, ryear)  
**Purpose**: Bibliographic references for expeditions

```
Structure:
├── Identification: refid, expid, ryear
├── Content: rtype, rjrnl, rauthor, rtitle, rpublisher
├── Details: rpubdate, rlanguage, rcitation
└── Count: 15,586 rows (after removal of 8 orphans without ExpeditionKey: 15,578 rows)
```

---

### 2. LOOKUP TABLES (2 tables)
Normalized reference tables for eliminating data redundancy.

#### season_lookup (3 columns)
**Purpose**: Standardize expedition season values

```
Columns:
├── SeasonKey (PK, IDENTITY)
├── SeasonName (UNIQUE): Spring, Autumn, Winter, Summer, Pre-monsoon, Post-monsoon
└── Description: Human-readable season information
```

#### citizenship_lookup (3 columns)
**Purpose**: Standardize member citizenship values

```
Columns:
├── CitizenshipKey (PK, IDENTITY)
├── CitizenshipName (UNIQUE): Country names
└── Description: Country descriptions

Note: Populated from DISTINCT citizen values in members table
```

---

### 3. EXPEDITION DECOMPOSITION TABLES (11 tables)
Normalized child tables created by splitting expedition attributes to achieve 3NF.

#### expedition_timeline
**Purpose**: Chronological expeditions information
```
├── TimelineKey (PK, IDENTITY)
├── ExpeditionKey (FK) → exped
├── bcdate: Base camp date
├── highpoint_date: High point date
├── termination_date: End date
└── termination_reason: Reason for conclusion
```

#### expedition_routes
**Purpose**: Route information for each expedition
```
├── RouteKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── RouteNumber: Sequence (1-4)
├── RouteDescription: Path description
└── ApproachDescription: Approach notes
```

#### expedition_outcomes
**Purpose**: Success/failure results
```
├── OutcomeKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── success1-4: Boolean success per attempt
├── ascent1-4: Ascent type per attempt
├── claimed, disputed: Claim status
├── termination_reason
└── termination_note
```

#### expedition_statistics
**Purpose**: Team composition and results
```
├── StatisticsKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── total_members: Total climbers
├── summit_members: Successful summiteers
├── members_hired: Hired staff count
├── members_deaths: Fatality count
├── hired_deaths: Hired staff fatalities
└── other_summits: Other peaks summited (same expedition)
```

#### expedition_style
**Purpose**: Climbing style/methods used
```
├── StyleKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── traverse: Boolean
├── ski: Boolean
├── parapente: Boolean
├── speed_climb: Boolean
└── style_notes: Description
```

#### expedition_oxygen
**Purpose**: Oxygen usage details
```
├── OxygenKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── o2_used: Boolean used
├── o2_none: Boolean not used
├── o2_climb: Used for climbing
├── o2_descent: Used for descent
├── o2_sleep: Used for sleeping
├── o2_medical: Used for medical
├── o2_taken: Total bottles
└── o2_unknown: Unknown usage
```

#### expedition_camps
**Purpose**: Camp and campsite information
```
├── CampKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── base_camp_date: BC establish date
├── high_point_elevation: Highest reached
├── total_camps: How many camps used
├── rope_used: Meters of rope deployed
└── campsites_description: Camp locations
```

#### expedition_incidents
**Purpose**: Notable events, accidents, achievements
```
├── IncidentKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── incidents_description: What happened
├── achievements_description: Notable achievements
└── incident_type: Type of event
```

#### expedition_reference_summary
**Purpose**: Expedition references aggregated
```
├── ReferenceKey (PK)
├── ExpeditionKey (FK)
├── reference_count: How many references
└── reference_citations: Citation text
```

#### expedition_admin
**Purpose**: Administrative metadata
```
├── AdminKey (PK, IDENTITY)
├── ExpeditionKey (FK)
├── agency: Coordinating agency
├── standard_route: Standard/established route flag
├── commercial_route: Commercial route flag
├── primary_route: Primary route designation
├── primary_reference: Primary source reference
└── checksum: Data integrity checksum
```

---

### 4. MEMBER DECOMPOSITION TABLES (3 tables)
Normalized member information decomposed from flattened structure.

#### member_person
**Purpose**: Unique individual climber information
```
├── PersonKey (PK, IDENTITY)
├── membid (UQ): Member ID
├── CitizenshipKey (FK) → citizenship_lookup
├── fname, lname: Full name
├── sex: Gender
├── yob: Year of birth
├── residence: Home address/country
├── occupation: Profession
├── hcn: Himalayan climbing number
└── Row Count: Unique members from all expeditions
```

#### member_participation
**Purpose**: Member participation in specific expeditions
```
├── MemberParticipationKey (PK, IDENTITY)
├── LegacyMemberKey: Original row key from members
├── PersonKey (FK) → member_person
├── ExpeditionKey (FK) → exped
├── Status, Role: leader, deputy, hired, sherpa, tibetan
├── Details: myear, mseason, expid, peakid
├── Summit Info: msuccess, mclaimed, disputed, solo
├── Style: mtraverse, mski, mparapente
├── Performance: mspeed, mhighpt, mperhighpt
└── Row Count: One per member-expedition participation
```

#### member_routes
**Purpose**: Route attempts by each member
```
├── MemberRouteKey (PK, IDENTITY)
├── MemberParticipationKey (FK) → member_participation
├── RouteNumber: Sequence (1-3)
├── RouteDescription: mroute1-3 values
└── Row Count: Populated from where mroute NOT NULL
```

#### member_summits
**Purpose**: Successful summit recordings
```
├── MemberSummitKey (PK, IDENTITY)
├── MemberParticipationKey (FK)
├── SummitNumber: Sequence (1-3)
├── SummitDate: msmtdate1-3
├── SummitTime: msmttime1-3
├── AscentDescription: mascent1-3
└── Row Count: Populated from where msmtdate NOT NULL
```

---

### 5. AUDIT & METADATA TABLE (1 table)

#### himalayan_data_dictionary
**Purpose**: Document database structure and source mapping

```
├── DataDictionaryKey (PK)
├── TableName: Table that column belongs to
├── ColumnName: Column name
├── DataType: SQL data type used
└── SourceCSV: Which CSV file this came from

Initial Rows: 16 (sample for documentation)
Note: This table documents the schema structure for reference
```

---

## Key Design Principles

### 1. Surrogate Keys for System Reliability
```
exped.ExpeditionKey INT IDENTITY(1,1) PRIMARY KEY
members.MemberKey INT IDENTITY(1,1) PRIMARY KEY
refer.ReferenceKey INT IDENTITY(1,1) PRIMARY KEY

Reason: Natural keys (expid, year) have duplicates across ~100 year history
        Surrogate keys guarantee uniqueness for FK relationships
```

### 2. Business Key Preservation
```
UNIQUE CONSTRAINT on exped (expid, [year])
UNIQUE CONSTRAINT on members (membid, expid, myear) 
UNIQUE CONSTRAINT on refer (refid, expid, ryear)

Reason: Maintains real-world uniqueness for data integrity verification
        Allows complex queries on business keys
```

### 3. Foreign Key Relationships
```
exped → peaks(peakid)           [Each expedition climbs one peak]
exped → season_lookup           [Standardized seasons]
members → exped(ExpeditionKey)  [Members participate in expeditions]
members → citizenship_lookup    [Standardized citizenships]
refer → exped(ExpeditionKey)    [References document expeditions]
member_routes → member_participation
member_summits → member_participation

Benefit: Referential integrity - prevents orphan records
```

### 4. Normalization to 3NF
- **1NF**: All columns contain atomic (non-repeating) values
  - member_routes & member_summits tables handle multiple (1-3) summit attempts
  
- **2NF**: No partial dependencies on composite keys
  - Each non-key column depends on full PK
  
- **3NF**: No transitive dependencies
  - Example: Citizenship not stored redundantly; references lookup via FK

---

## Sample Data Loaded

**Total Records Inserted**: 99 records + metadata

| Table | Records |
|-------|---------|
| peaks | 4 |
| exped | 5 |
| members | 4 |
| refer | 5 |
| season_lookup | 1 |
| citizenship_lookup | 1 |
| member_person | 4 |
| member_participation | 4 |
| member_routes | 4 |
| member_summits | 2 |
| Data Dictionary | 16 |

**Focus Expedition**: AMAD01101 (Ama Dablam 2001, Australia)
- 4 climbers
- 2 successful summits
- Complete route and summit data

---

## Related Scripts

1. **schema_for_chartdb.sql** - CREATE TABLE statements for all 21 tables
2. **load_sample_data.sql** - INSERT sample data for testing
3. **himalayan_expedition_cleaning.sql** - Normalization and validation logic
4. **sql-queries/** - Exploration and analysis queries

---

## Connection & Deployment

- **Environment**: Azure SQL Server or SQL Server 2019+
- **Database**: himalayan_expeditions (local) or Final_Project (Azure)
- **Authentication**: Windows Auth (local) or SQL Auth (Azure)
- **All tables**: dbo schema

## Usage

```sql
-- View all expedition details with peak names
SELECT e.expid, p.pkname, e.year, e.totmembers, e.smtmembers
FROM exped e
JOIN peaks p ON e.peakid = p.peakid
ORDER BY e.year DESC;

-- Find members from specific country
SELECT p.PersonKey, p.fname, p.lname, c.CitizenshipName, COUNT(*) AS expeditions
FROM member_person p
JOIN citizenship_lookup c ON p.CitizenshipKey = c.CitizenshipKey
JOIN member_participation mp ON p.PersonKey = mp.PersonKey
GROUP BY p.PersonKey, p.fname, p.lname, c.CitizenshipName;

-- Analyze summit success rates
SELECT 
    COUNT(*) AS total_attempts,
    SUM(CASE WHEN msuccess = 1 THEN 1 ELSE 0 END) AS successful,
    ROUND(100.0 * SUM(CASE WHEN msuccess = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate
FROM member_participation;
```
