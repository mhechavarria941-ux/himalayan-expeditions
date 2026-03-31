/*
=========================================================
HIMALAYAN EXPEDITION DATABASE CLEANING
INDEX OF STEPS
=========================================================


1. Duplicate Checks
   a. exped — no duplicates found
   b. peaks — no duplicates found
   c. members — no duplicates found
   d. refer — no duplicates found


2. Primary Key Evaluation
   a. exped — expid reused → surrogate key required
   b. peaks — peakid valid PK
   c. members — composite key (membid + expid + myear)
   d. refer — composite key (refid + expid + ryear)


3. Surrogate Key Implementation
   a. exped → ExpeditionKey added
   b. peaks → confirmed clean PK
   c. members → MemberKey added
   d. refer → ReferenceKey added


4. Lookup Table Normalization
   a. season_lookup created and linked to exped
   b. citizenship_lookup created and linked to members


5. exped Decomposition
   a. expedition_timeline
   b. expedition_routes
   c. expedition_outcomes
   d. expedition_statistics
   e. expedition_style
   f. expedition_oxygen
   g. expedition_camps
   h. expedition_incidents
   i. expedition_reference_summary
   j. expedition_admin


6. Relationship Enforcement & Cleanup
   a. members linked to exped
   b. refer linked to exped, orphan rows removed
   c. redundant columns dropped
   d. data dictionary rebuilt
   e. peaks PK enforced


7. Final Normalization & Validation
   a. transitive dependencies identified
   b. members fully normalized:
      - member_person
      - member_participation
      - member_routes
      - member_summits
   c. dictionary updated
   d. peaks dependency tested
   e. pexpid dependency confirmed (1-to-1)
   f. schema finalized as 3NF
=========================================================

1.Searching through the existing tables for duplicates, starting with exped as it seems to be the main table.

a.exped*/

SELECT *,
       COUNT(*) AS duplicate_count
FROM dbo.exped
GROUP BY
    expid, peakid, [year], season, host, route1, route2, route3, route4,
    nation, leaders, sponsor, success1, success2, success3, success4,
    ascent1, ascent2, ascent3, ascent4, claimed, disputed, countries,
    approach, bcdate, smtdate, smttime, smtdays, totdays, termdate,
    termreason, termnote, highpoint, traverse, ski, parapente, camps,
    rope, totmembers, smtmembers, mdeaths, tothired, smthired, hdeaths,
    nohired, o2used, o2none, o2climb, o2descent, o2sleep, o2medical,
    o2taken, o2unkwn, othersmts, campsites, accidents, achievment,
    agency, comrte, stdrte, primrte, primmem, primref, primid, chksum
HAVING COUNT(*) > 1;

/*results: no duplicated rows;

b.peaks*/

SELECT *,
       COUNT(*) AS duplicate_count
FROM dbo.peaks
GROUP BY
    peakid, pkname, pkname2, location, heightm, heightf, himal, region,
    [open], unlisted, trekking, trekyear, [restrict], phost, pstatus,
    pyear, pseason, pmonth, pday, pexpid, pcountry, psummiters, psmtnote
HAVING COUNT(*) > 1;

/*results: no duplicated rows;

c.members*/

SELECT
       COUNT(*) AS duplicate_count
FROM dbo.members
GROUP BY
    expid, membid, peakid, myear, mseason
HAVING COUNT(*) > 1;

/*results: no duplicated rows;

d.refer*/

SELECT
       COUNT(*) AS duplicate_count
FROM dbo.refer
GROUP BY
    expid, refid, ryear, rtype, rjrnl, rauthor, rtitle, rpublisher,
    rpubdate, rlanguage, rcitation, ryak94
HAVING COUNT(*) > 1;

/*results: no duplicated rows; 

table himalayan_data_dictionary is not included as it is a reference table and does not contain data about expeditions, peaks, or members.

2. In the same table order, we will now search for primary key candidates. starting with ID related columns, we will search for unique 
combinations. If no ID column shows potential for being a primary key, we will consider alternatives.

a.exped: there are three possible primary key candidates: expid, peakid, and primid, if this failed, consider alternatives.

*/

SELECT 'expid' AS column_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT expid) AS distinct_values,
       COUNT(*) - COUNT(DISTINCT expid) AS duplicate_count
FROM dbo.exped

UNION ALL

SELECT 'peakid',
       COUNT(*),
       COUNT(DISTINCT peakid),
       COUNT(*) - COUNT(DISTINCT peakid)
FROM dbo.exped

UNION ALL

SELECT 'primid',
       COUNT(*),
       COUNT(DISTINCT primid),
       COUNT(*) - COUNT(DISTINCT primid)
FROM dbo.exped;

/* results: expid has very little duplicates, it is an ideal PK. proceed to explore duplicates. peakid can work as a foraign key. ;

b. peaks: there are two possible primary key candidates: peakid and pexpid, if this failed, consider alternatives.
*/

SELECT 'peakid' AS column_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT peakid) AS distinct_values,
       COUNT(*) - COUNT(DISTINCT peakid) AS duplicate_count
FROM dbo.peaks

UNION ALL

SELECT 'pexpid',
       COUNT(*),
       COUNT(DISTINCT pexpid),
       COUNT(*) - COUNT(DISTINCT pexpid)
FROM dbo.peaks;

/* results: peakid has no duplicates, it is an ideal PK.  ;

c. members: there are two possible primary key candidates: membid,expid,peakid,msmtbid,hcn, if this failed, consider alternatives.
*/

SELECT 'membid' AS column_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT membid) AS distinct_values,
       COUNT(*) - COUNT(DISTINCT membid) AS duplicate_count
FROM dbo.members

UNION ALL

SELECT 'expid',
       COUNT(*),
       COUNT(DISTINCT expid),
       COUNT(*) - COUNT(DISTINCT expid)
FROM dbo.members

UNION ALL

SELECT 'peakid',
       COUNT(*),
       COUNT(DISTINCT peakid),
       COUNT(*) - COUNT(DISTINCT peakid)
FROM dbo.members

UNION ALL
SELECT 'expid',
       COUNT(*),
       COUNT(DISTINCT expid),
       COUNT(*) - COUNT(DISTINCT expid)
FROM dbo.members

-- Invalid column 'msmtbid' - commented out
-- UNION ALL
-- SELECT 'msmtbid',
--        COUNT(*),
--        COUNT(DISTINCT msmtbid),
--        COUNT(*) - COUNT(DISTINCT msmtbid)
-- FROM dbo.members

-- Invalid column 'hcn' - commented out
-- UNION ALL
-- SELECT 'hcn',
--        COUNT(*),
--        COUNT(DISTINCT hcn),
--        COUNT(*) - COUNT(DISTINCT hcn)
-- FROM dbo.members;

/* results: No valid PK candidates, proceed with alternative exploration (composite or surrogate keys). ;
d. refer: there are two possible primary key candidates: refid and expid, if this failed, consider alternatives.
*/

SELECT 'refid' AS column_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT refid) AS distinct_values,
       COUNT(*) - COUNT(DISTINCT refid) AS duplicate_count
FROM dbo.refer

UNION ALL

SELECT 'expid',
       COUNT(*),
       COUNT(DISTINCT expid),
       COUNT(*) - COUNT(DISTINCT expid)
FROM dbo.refer;

/* results: no ideal PK candidates, proceed with alternative exploration (composite or surrogate keys). ;

3. After identifying potential primary key candidates, we will now look for null values in such, and look for the possbility of using composite or surrogate keys if necessary.

a.exped:
*/
SELECT COUNT(*) AS null_or_blank_expid
FROM dbo.exped
WHERE expid IS NULL OR LTRIM(RTRIM(expid)) = '';

/* No nulls, now lets analyze the duplicates */

SELECT expid, COUNT(*) AS cnt
FROM dbo.exped
GROUP BY expid
HAVING COUNT(*) > 1
ORDER BY cnt DESC, expid;

/* expid "EVER21101", "EVER22101", "EVER24101", and "KANG10101" are duplicated, analysis continues: 
*/
SELECT *
FROM dbo.exped
WHERE expid IN (
    SELECT expid
    FROM dbo.exped
    GROUP BY expid
    HAVING COUNT(*) > 1
)
ORDER BY expid;

/*Many differences found in between duplicated expid's. seemingly every 100 years, the expid is reused. in order to have a proper PK, a surrogate key would be needed.
This code will be used to alter the current table structure and add the surrogate: */

-- a.1) Add surrogate key column
ALTER TABLE dbo.exped
ADD ExpeditionKey INT IDENTITY(1,1);
GO


-- a.2) Set it as PRIMARY KEY
BEGIN TRY
    ALTER TABLE dbo.exped
    ADD CONSTRAINT PK_exped PRIMARY KEY (ExpeditionKey);
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() IN (1505, 1779, 1750)
        PRINT 'INFO: PK_exped constraint already exists.';
    ELSE
        THROW;
END CATCH;
GO


-- a.3) Preserve business uniqueness (expid + year = real-world identifier)
BEGIN TRY
    ALTER TABLE dbo.exped
    ADD CONSTRAINT UQ_exped_expid_year UNIQUE (expid, [year]);
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() IN (1505, 1779, 1750, 2714)
        PRINT 'INFO: UQ_exped_expid_year constraint already exists.';
    ELSE
        THROW;
END CATCH;
GO


-- a.4) Verify for duplicates and nulls

SELECT TOP 10 ExpeditionKey, expid, [year], peakid
FROM dbo.exped
ORDER BY ExpeditionKey;
GO
-- Due to editor errors, aditional code to enforce PK is added:

SELECT kc.name AS constraint_name,
       kc.type_desc,
       c.name AS column_name
FROM sys.key_constraints kc
JOIN sys.index_columns ic
    ON kc.parent_object_id = ic.object_id
   AND kc.unique_index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE kc.parent_object_id = OBJECT_ID('dbo.exped');
--key enfonced, duplicates and nulls cleaned.

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ExpeditionKey) AS distinct_keys,
    COUNT(*) - COUNT(DISTINCT ExpeditionKey) AS duplicate_count
FROM dbo.exped;

--nulls: clean

SELECT COUNT(*) AS null_count
FROM dbo.exped
WHERE ExpeditionKey IS NULL;

/*b. peaks: 
*/
SELECT COUNT(*) AS null_or_blank_peakid
FROM dbo.peaks
WHERE peakid IS NULL OR LTRIM(RTRIM(peakid)) = '';

/* No nulls, nor duplicates, ready to proceed*/

/*c. members: 
Looking for a combination of columns that uniquely identifies each row, such as memberid and expid, 
If no memberid is reused after 100 years such as expid, then we can just use those two, otherwise, myear will most likely be used as well.

Distinct count of expeditiosn per memberid */
SELECT 
    membid,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(expid, '|', myear)) AS distinct_expeditions
FROM dbo.members
GROUP BY membid
HAVING COUNT(DISTINCT CONCAT(expid, '|', myear)) > 1
ORDER BY distinct_expeditions DESC, membid;

--looking for duplicates in the combination of membid and expid
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        COALESCE(membid,''), '|',
        COALESCE(expid,'')
    )) AS distinct_combo,
    COUNT(*) - COUNT(DISTINCT CONCAT(
        COALESCE(membid,''), '|',
        COALESCE(expid,'')
    )) AS duplicate_count
FROM dbo.members;

--35 duplicated founds, we will require a more complex combination of columns, using myear as well.

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        COALESCE(membid,''), '|',
        COALESCE(expid,''), '|',
        COALESCE(myear,'')
    )) AS distinct_combo
FROM dbo.members;

--confirming that the combination of membid, expid, and myear is unique, proceeding with the creation of a surrogate key.

-- c.1) Add surrogate key column to members

IF COL_LENGTH('dbo.members', 'MemberKey') IS NULL
BEGIN
    ALTER TABLE dbo.members
    ADD MemberKey INT IDENTITY(1,1);
END;
GO

-- c.2) Set MemberKey as PRIMARY KEY

IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [type] = 'PK'
      AND [name] = 'PK_members'
)
BEGIN
    ALTER TABLE dbo.members
    ADD CONSTRAINT PK_members PRIMARY KEY (MemberKey);
END;
GO

-- c.3) Preserve business uniqueness, membid + expid + myear
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [type] = 'UQ'
      AND [name] = 'UQ_members_membid_expid_myear'
)
BEGIN
    ALTER TABLE dbo.members
    ADD CONSTRAINT UQ_members_membid_expid_myear UNIQUE (membid, expid, myear);
END;
GO

-- c.4) Validate the surrogate key

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT MemberKey) AS distinct_member_keys,
    COUNT(*) - COUNT(DISTINCT MemberKey) AS duplicate_memberkey_count
FROM dbo.members;
GO

SELECT COUNT(*) AS null_memberkey_count
FROM dbo.members
WHERE MemberKey IS NULL;
GO

SELECT TOP 10 MemberKey, membid, expid, myear, peakid, fname, lname
FROM dbo.members
ORDER BY MemberKey;
GO

---- Due to editor errors, aditional code to enforce PK is added:
SELECT kc.name AS constraint_name,
       kc.type_desc,
       c.name AS column_name
FROM sys.key_constraints kc
JOIN sys.index_columns ic
    ON kc.parent_object_id = ic.object_id
   AND kc.unique_index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE kc.parent_object_id = OBJECT_ID('dbo.members');
--key enfonced, duplicates and nulls cleaned.

/*d. refer: finding the grain for refer table, knowing neither refir nor expid are ideal PK candidates, an attempt of both together might be the answer:
*/
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        COALESCE(refid,''), '|',
        COALESCE(expid,'')
    )) AS distinct_combo
FROM dbo.refer;

--there are 4 duplicated founds within that combinati, including ryear as well and testing for trimming issues:

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        LTRIM(RTRIM(COALESCE(refid,''))), '|',
        LTRIM(RTRIM(COALESCE(expid,''))), '|',
        LTRIM(RTRIM(COALESCE(ryear,'')))
    )) AS distinct_combo
FROM dbo.refer;

--after correcting the trimming, there are no duplicate, checking for nulls:

SELECT 'refid' AS column_name, COUNT(*) AS null_or_blank_count
FROM dbo.refer
WHERE refid IS NULL OR LTRIM(RTRIM(refid)) = ''

UNION ALL

SELECT 'expid', COUNT(*)
FROM dbo.refer
WHERE expid IS NULL OR LTRIM(RTRIM(expid)) = ''

UNION ALL

SELECT 'ryear', COUNT(*)
FROM dbo.refer
WHERE ryear IS NULL OR LTRIM(RTRIM(ryear)) = '';

--no nulls. proceeding with the surrogate key creation:
-- d.1) Add surrogate key column to refer

IF COL_LENGTH('dbo.refer', 'ReferenceKey') IS NULL
BEGIN
    ALTER TABLE dbo.refer
    ADD ReferenceKey INT IDENTITY(1,1);
END;
GO

-- d.2) Set ReferenceKey as PRIMARY KEY
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [type] = 'PK'
      AND [name] = 'PK_refer'
)
BEGIN
    ALTER TABLE dbo.refer
    ADD CONSTRAINT PK_refer PRIMARY KEY (ReferenceKey);
END;
GO

-- d.3) Preserve business uniqueness, using the cleaned business key columns
-- Note: constraint itself uses raw columns, so this assumes stored values are already acceptable.
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [type] = 'UQ'
      AND [name] = 'UQ_refer_refid_expid_ryear'
)
BEGIN
    ALTER TABLE dbo.refer
    ADD CONSTRAINT UQ_refer_refid_expid_ryear UNIQUE (refid, expid, ryear);
END;
GO


-- d.4) Validate surrogate key

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ReferenceKey) AS distinct_reference_keys,
    COUNT(*) - COUNT(DISTINCT ReferenceKey) AS duplicate_referencekey_count
FROM dbo.refer;
GO

SELECT COUNT(*) AS null_referencekey_count
FROM dbo.refer
WHERE ReferenceKey IS NULL;
GO

SELECT TOP 10 ReferenceKey, refid, expid, ryear, rtype, rtitle
FROM dbo.refer
ORDER BY ReferenceKey;
GO
/*No duplicates or nulls, surrogate key successfully implemented. No Key enforcement needed neither. 

4. Looking for candidate lookup tables based on non-key columns to separate and normalize database. 

a."season" becomes a candidate for a lookup table, as it is repeated across multiple tables and has a limited set of values (e.g., Spring, Summer, Autumn, Winter).
*/
-- A) Create season lookup table
IF OBJECT_ID('dbo.season_lookup', 'U') IS NOT NULL
    DROP TABLE dbo.season_lookup;
GO

CREATE TABLE dbo.season_lookup (
    SeasonKey INT IDENTITY(1,1) PRIMARY KEY,
    SeasonName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- B) Populate season lookup from exped
INSERT INTO dbo.season_lookup (SeasonName)
SELECT DISTINCT LTRIM(RTRIM(season))
FROM dbo.exped
WHERE season IS NOT NULL
  AND LTRIM(RTRIM(season)) <> '';
GO

-- C) Add FK column to exped

IF COL_LENGTH('dbo.exped', 'SeasonKey') IS NULL
BEGIN
    ALTER TABLE dbo.exped
    ADD SeasonKey INT NULL;
END;
GO


-- D) Populate exped.SeasonKey

UPDATE e
SET e.SeasonKey = s.SeasonKey
FROM dbo.exped e
JOIN dbo.season_lookup s
    ON LTRIM(RTRIM(e.season)) = s.SeasonName;
GO


-- E) Validate season mapping

SELECT COUNT(*) AS unmatched_exped_season_rows
FROM dbo.exped
WHERE season IS NOT NULL
  AND LTRIM(RTRIM(season)) <> ''
  AND SeasonKey IS NULL;
GO

SELECT TOP 20 ExpeditionKey, expid, [year], season, SeasonKey
FROM dbo.exped
ORDER BY ExpeditionKey;
GO


-- F) Add FK constraint

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE [name] = 'FK_exped_season_lookup'
)
BEGIN
    ALTER TABLE dbo.exped
    ADD CONSTRAINT FK_exped_season_lookup
    FOREIGN KEY (SeasonKey) REFERENCES dbo.season_lookup(SeasonKey);
END;
GO

--b. "citizenship" in members could be normalized into a separate table, especially if there are many repeated values and potential for additional attributes (e.g., country code, continent).

-- A) Create citizenship lookup table

IF OBJECT_ID('dbo.citizenship_lookup', 'U') IS NOT NULL
    DROP TABLE dbo.citizenship_lookup;
GO

CREATE TABLE dbo.citizenship_lookup (
    CitizenshipKey INT IDENTITY(1,1) PRIMARY KEY,
    CitizenshipName NVARCHAR(255) NOT NULL UNIQUE
);
GO

-- B) Populate citizenship lookup from members

INSERT INTO dbo.citizenship_lookup (CitizenshipName)
SELECT DISTINCT LTRIM(RTRIM(citizen))
FROM dbo.members
WHERE citizen IS NOT NULL
  AND LTRIM(RTRIM(citizen)) <> '';
GO

-- C) Add FK column to members

IF COL_LENGTH('dbo.members', 'CitizenshipKey') IS NULL
BEGIN
    ALTER TABLE dbo.members
    ADD CitizenshipKey INT NULL;
END;
GO

-- D) Populate members.CitizenshipKey

UPDATE m
SET m.CitizenshipKey = c.CitizenshipKey
FROM dbo.members m
JOIN dbo.citizenship_lookup c
    ON LTRIM(RTRIM(m.citizen)) = c.CitizenshipName;
GO

-- E) Validate citizenship mapping

SELECT COUNT(*) AS unmatched_member_citizen_rows
FROM dbo.members
WHERE citizen IS NOT NULL
  AND LTRIM(RTRIM(citizen)) <> ''
  AND CitizenshipKey IS NULL;
GO

SELECT TOP 20 MemberKey, membid, expid, myear, citizen, CitizenshipKey
FROM dbo.members
ORDER BY MemberKey;
GO

-- F) Add FK constraint

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE [name] = 'FK_members_citizenship_lookup'
)
BEGIN
    ALTER TABLE dbo.members
    ADD CONSTRAINT FK_members_citizenship_lookup
    FOREIGN KEY (CitizenshipKey) REFERENCES dbo.citizenship_lookup(CitizenshipKey);
END;
GO


/*5. After creating lookup tables for season and citzenship, it is sensible to decompose the exped teble as well, 
creating a new table for expedition details that are not directly related to the main expedition information. 
This would help in normalizing the database and improving data integrity.*/

/* =========================================================
   0) SAFETY CHECKS / EXPECTED EXISTING TABLES
   Assumes:
   - dbo.exped has ExpeditionKey PK already
   - dbo.peaks has peakid PK already
   - dbo.season_lookup exists and dbo.exped.SeasonKey populated
   ========================================================= */

-- Optional quick checks
SELECT TOP 1 ExpeditionKey FROM dbo.exped;
SELECT TOP 1 peakid FROM dbo.peaks;
GO

/* =========================================================
   1) EXPEDITION_TIMELINE
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_timeline', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_timeline;
GO

CREATE TABLE dbo.expedition_timeline (
    ExpeditionTimelineKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    bcdate NVARCHAR(255) NULL,
    smtdate NVARCHAR(255) NULL,
    smttime NVARCHAR(255) NULL,
    smtdays NVARCHAR(255) NULL,
    totdays NVARCHAR(255) NULL,
    termdate NVARCHAR(255) NULL,
    termreason NVARCHAR(MAX) NULL,
    termnote NVARCHAR(MAX) NULL,
    CONSTRAINT PK_expedition_timeline PRIMARY KEY (ExpeditionTimelineKey),
    CONSTRAINT UQ_expedition_timeline_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_timeline_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_timeline (
    ExpeditionKey, bcdate, smtdate, smttime, smtdays, totdays, termdate, termreason, termnote
)
SELECT
    ExpeditionKey, bcdate, smtdate, smttime, smtdays, totdays, termdate, termreason, termnote
FROM dbo.exped;
GO

/* =========================================================
   2) EXPEDITION_ROUTES
   One row per expedition route entry
   ========================================================= */
IF OBJECT_ID('dbo.expedition_routes', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_routes;
GO

CREATE TABLE dbo.expedition_routes (
    ExpeditionRouteKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    RouteNumber INT NOT NULL,
    RouteDescription NVARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_expedition_routes PRIMARY KEY (ExpeditionRouteKey),
    CONSTRAINT UQ_expedition_routes UNIQUE (ExpeditionKey, RouteNumber),
    CONSTRAINT FK_expedition_routes_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_routes (ExpeditionKey, RouteNumber, RouteDescription)
SELECT ExpeditionKey, 1, LTRIM(RTRIM(route1))
FROM dbo.exped
WHERE route1 IS NOT NULL AND LTRIM(RTRIM(route1)) <> ''
UNION ALL
SELECT ExpeditionKey, 2, LTRIM(RTRIM(route2))
FROM dbo.exped
WHERE route2 IS NOT NULL AND LTRIM(RTRIM(route2)) <> ''
UNION ALL
SELECT ExpeditionKey, 3, LTRIM(RTRIM(route3))
FROM dbo.exped
WHERE route3 IS NOT NULL AND LTRIM(RTRIM(route3)) <> ''
UNION ALL
SELECT ExpeditionKey, 4, LTRIM(RTRIM(route4))
FROM dbo.exped
WHERE route4 IS NOT NULL AND LTRIM(RTRIM(route4)) <> '';
GO

/* =========================================================
   3) EXPEDITION_OUTCOMES
   One row per expedition outcome entry
   ========================================================= */
IF OBJECT_ID('dbo.expedition_outcomes', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_outcomes;
GO

CREATE TABLE dbo.expedition_outcomes (
    ExpeditionOutcomeKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    OutcomeNumber INT NOT NULL,
    SuccessStatus NVARCHAR(MAX) NULL,
    AscentDescription NVARCHAR(MAX) NULL,
    CONSTRAINT PK_expedition_outcomes PRIMARY KEY (ExpeditionOutcomeKey),
    CONSTRAINT UQ_expedition_outcomes UNIQUE (ExpeditionKey, OutcomeNumber),
    CONSTRAINT FK_expedition_outcomes_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_outcomes (ExpeditionKey, OutcomeNumber, SuccessStatus, AscentDescription)
SELECT ExpeditionKey, 1, success1, ascent1
FROM dbo.exped
WHERE (success1 IS NOT NULL AND LTRIM(RTRIM(success1)) <> '')
   OR (ascent1 IS NOT NULL AND LTRIM(RTRIM(ascent1)) <> '')
UNION ALL
SELECT ExpeditionKey, 2, success2, ascent2
FROM dbo.exped
WHERE (success2 IS NOT NULL AND LTRIM(RTRIM(success2)) <> '')
   OR (ascent2 IS NOT NULL AND LTRIM(RTRIM(ascent2)) <> '')
UNION ALL
SELECT ExpeditionKey, 3, success3, ascent3
FROM dbo.exped
WHERE (success3 IS NOT NULL AND LTRIM(RTRIM(success3)) <> '')
   OR (ascent3 IS NOT NULL AND LTRIM(RTRIM(ascent3)) <> '')
UNION ALL
SELECT ExpeditionKey, 4, success4, ascent4
FROM dbo.exped
WHERE (success4 IS NOT NULL AND LTRIM(RTRIM(success4)) <> '')
   OR (ascent4 IS NOT NULL AND LTRIM(RTRIM(ascent4)) <> '');
GO

/* =========================================================
   4) EXPEDITION_STATISTICS
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_statistics', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_statistics;
GO

CREATE TABLE dbo.expedition_statistics (
    ExpeditionStatisticsKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    totmembers NVARCHAR(255) NULL,
    smtmembers NVARCHAR(255) NULL,
    mdeaths NVARCHAR(255) NULL,
    tothired NVARCHAR(255) NULL,
    smthired NVARCHAR(255) NULL,
    hdeaths NVARCHAR(255) NULL,
    nohired NVARCHAR(255) NULL,
    highpoint NVARCHAR(255) NULL,
    CONSTRAINT PK_expedition_statistics PRIMARY KEY (ExpeditionStatisticsKey),
    CONSTRAINT UQ_expedition_statistics_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_statistics_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_statistics (
    ExpeditionKey, totmembers, smtmembers, mdeaths, tothired, smthired, hdeaths, nohired, highpoint
)
SELECT
    ExpeditionKey, totmembers, smtmembers, mdeaths, tothired, smthired, hdeaths, nohired, highpoint
FROM dbo.exped;
GO

/* =========================================================
   5) EXPEDITION_STYLE
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_style', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_style;
GO

CREATE TABLE dbo.expedition_style (
    ExpeditionStyleKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    claimed NVARCHAR(255) NULL,
    disputed NVARCHAR(255) NULL,
    traverse NVARCHAR(255) NULL,
    ski NVARCHAR(255) NULL,
    parapente NVARCHAR(255) NULL,
    CONSTRAINT PK_expedition_style PRIMARY KEY (ExpeditionStyleKey),
    CONSTRAINT UQ_expedition_style_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_style_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_style (
    ExpeditionKey, claimed, disputed, traverse, ski, parapente
)
SELECT
    ExpeditionKey, claimed, disputed, traverse, ski, parapente
FROM dbo.exped;
GO

/* =========================================================
   6) EXPEDITION_OXYGEN
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_oxygen', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_oxygen;
GO

CREATE TABLE dbo.expedition_oxygen (
    ExpeditionOxygenKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    o2used NVARCHAR(255) NULL,
    o2none NVARCHAR(255) NULL,
    o2climb NVARCHAR(255) NULL,
    o2descent NVARCHAR(255) NULL,
    o2sleep NVARCHAR(255) NULL,
    o2medical NVARCHAR(255) NULL,
    o2taken NVARCHAR(255) NULL,
    o2unkwn NVARCHAR(255) NULL,
    CONSTRAINT PK_expedition_oxygen PRIMARY KEY (ExpeditionOxygenKey),
    CONSTRAINT UQ_expedition_oxygen_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_oxygen_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_oxygen (
    ExpeditionKey, o2used, o2none, o2climb, o2descent, o2sleep, o2medical, o2taken, o2unkwn
)
SELECT
    ExpeditionKey, o2used, o2none, o2climb, o2descent, o2sleep, o2medical, o2taken, o2unkwn
FROM dbo.exped;
GO

/* =========================================================
   7) EXPEDITION_CAMPS
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_camps', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_camps;
GO

CREATE TABLE dbo.expedition_camps (
    ExpeditionCampsKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    camps NVARCHAR(MAX) NULL,
    campsites NVARCHAR(MAX) NULL,
    CONSTRAINT PK_expedition_camps PRIMARY KEY (ExpeditionCampsKey),
    CONSTRAINT UQ_expedition_camps_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_camps_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_camps (
    ExpeditionKey, camps, campsites
)
SELECT
    ExpeditionKey, camps, campsites
FROM dbo.exped;
GO

/* =========================================================
   8) EXPEDITION_INCIDENTS
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_incidents', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_incidents;
GO

CREATE TABLE dbo.expedition_incidents (
    ExpeditionIncidentsKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    accidents NVARCHAR(MAX) NULL,
    achievment NVARCHAR(MAX) NULL,
    CONSTRAINT PK_expedition_incidents PRIMARY KEY (ExpeditionIncidentsKey),
    CONSTRAINT UQ_expedition_incidents_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_incidents_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_incidents (
    ExpeditionKey, accidents, achievment
)
SELECT
    ExpeditionKey, accidents, achievment
FROM dbo.exped;
GO

/* =========================================================
   9) EXPEDITION_REFERENCE_SUMMARY
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_reference_summary', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_reference_summary;
GO

CREATE TABLE dbo.expedition_reference_summary (
    ExpeditionReferenceSummaryKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    comrte NVARCHAR(MAX) NULL,
    stdrte NVARCHAR(MAX) NULL,
    primrte NVARCHAR(MAX) NULL,
    primmem NVARCHAR(MAX) NULL,
    primref NVARCHAR(MAX) NULL,
    primid NVARCHAR(255) NULL,
    CONSTRAINT PK_expedition_reference_summary PRIMARY KEY (ExpeditionReferenceSummaryKey),
    CONSTRAINT UQ_expedition_reference_summary_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_reference_summary_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_reference_summary (
    ExpeditionKey, comrte, stdrte, primrte, primmem, primref, primid
)
SELECT
    ExpeditionKey, comrte, stdrte, primrte, primmem, primref, primid
FROM dbo.exped;
GO

/* =========================================================
   10) EXPEDITION_ADMIN
   One row per expedition
   ========================================================= */
IF OBJECT_ID('dbo.expedition_admin', 'U') IS NOT NULL
    DROP TABLE dbo.expedition_admin;
GO

CREATE TABLE dbo.expedition_admin (
    ExpeditionAdminKey INT IDENTITY(1,1) NOT NULL,
    ExpeditionKey INT NOT NULL,
    agency NVARCHAR(MAX) NULL,
    othersmts NVARCHAR(MAX) NULL,
    chksum NVARCHAR(255) NULL,
    CONSTRAINT PK_expedition_admin PRIMARY KEY (ExpeditionAdminKey),
    CONSTRAINT UQ_expedition_admin_ExpeditionKey UNIQUE (ExpeditionKey),
    CONSTRAINT FK_expedition_admin_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey)
);
GO

INSERT INTO dbo.expedition_admin (
    ExpeditionKey, agency, othersmts, chksum
)
SELECT
    ExpeditionKey, agency, othersmts, chksum
FROM dbo.exped;
GO

/* =========================================================
   11) CONNECT MEMBERS TO EXPED WITH EXPEDITIONKEY
   Uses natural business match: expid + myear = exped.expid + exped.year
   ========================================================= */
IF COL_LENGTH('dbo.members', 'ExpeditionKey') IS NULL
BEGIN
    ALTER TABLE dbo.members
    ADD ExpeditionKey INT NULL;
END;
GO

UPDATE m
SET m.ExpeditionKey = e.ExpeditionKey
FROM dbo.members m
JOIN dbo.exped e
    ON LTRIM(RTRIM(m.expid)) = LTRIM(RTRIM(e.expid))
   AND LTRIM(RTRIM(m.myear)) = LTRIM(RTRIM(e.[year]));
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE [name] = 'FK_members_exped'
)
BEGIN
    ALTER TABLE dbo.members
    ADD CONSTRAINT FK_members_exped
    FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey);
END;
GO

/* =========================================================
   12) CONNECT REFER TO EXPED WITH EXPEDITIONKEY
   Uses natural business match: expid + ryear = exped.expid + exped.year
   ========================================================= */
IF COL_LENGTH('dbo.refer', 'ExpeditionKey') IS NULL
BEGIN
    ALTER TABLE dbo.refer
    ADD ExpeditionKey INT NULL;
END;
GO

UPDATE r
SET r.ExpeditionKey = e.ExpeditionKey
FROM dbo.refer r
JOIN dbo.exped e
    ON LTRIM(RTRIM(r.expid)) = LTRIM(RTRIM(e.expid))
   AND LTRIM(RTRIM(r.ryear)) = LTRIM(RTRIM(e.[year]));
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE [name] = 'FK_refer_exped'
)
BEGIN
    ALTER TABLE dbo.refer
    ADD CONSTRAINT FK_refer_exped
    FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey);
END;
GO

/* =========================================================
   13) VALIDATION QUERIES
   ========================================================= */

-- Child table counts
SELECT 'expedition_timeline' AS table_name, COUNT(*) AS row_count FROM dbo.expedition_timeline
UNION ALL
SELECT 'expedition_routes', COUNT(*) FROM dbo.expedition_routes
UNION ALL
SELECT 'expedition_outcomes', COUNT(*) FROM dbo.expedition_outcomes
UNION ALL
SELECT 'expedition_statistics', COUNT(*) FROM dbo.expedition_statistics
UNION ALL
SELECT 'expedition_style', COUNT(*) FROM dbo.expedition_style
UNION ALL
SELECT 'expedition_oxygen', COUNT(*) FROM dbo.expedition_oxygen
UNION ALL
SELECT 'expedition_camps', COUNT(*) FROM dbo.expedition_camps
UNION ALL
SELECT 'expedition_incidents', COUNT(*) FROM dbo.expedition_incidents
UNION ALL
SELECT 'expedition_reference_summary', COUNT(*) FROM dbo.expedition_reference_summary
UNION ALL
SELECT 'expedition_admin', COUNT(*) FROM dbo.expedition_admin;
GO

-- Unmatched child connections
SELECT 'members_unmatched_expeditionkey' AS check_name, COUNT(*) AS unmatched_rows
FROM dbo.members
WHERE ExpeditionKey IS NULL
UNION ALL
SELECT 'refer_unmatched_expeditionkey', COUNT(*)
FROM dbo.refer
WHERE ExpeditionKey IS NULL;
GO

-- Sample joined view
SELECT TOP 20
    e.ExpeditionKey,
    e.expid,
    e.[year],
    e.peakid,
    p.pkname,
    s.SeasonName,
    st.totmembers,
    ox.o2used
FROM dbo.exped e
LEFT JOIN dbo.peaks p
    ON e.peakid = p.peakid
LEFT JOIN dbo.season_lookup s
    ON e.SeasonKey = s.SeasonKey
LEFT JOIN dbo.expedition_statistics st
    ON e.ExpeditionKey = st.ExpeditionKey
LEFT JOIN dbo.expedition_oxygen ox
    ON e.ExpeditionKey = ox.ExpeditionKey
ORDER BY e.ExpeditionKey;
GO

/* There are unmatched child connections, further investigation needed to understand if they are due to data quality issues or if they represent expeditions without members/references. 
The new structure allows for better data integrity and easier querying of expedition details.*/

SELECT TOP 50
    m.membid,
    m.expid AS members_expid,
    m.myear,
    e.expid AS exped_expid,
    e.[year]
FROM dbo.members m
LEFT JOIN dbo.exped e
    ON LTRIM(RTRIM(m.expid)) = LTRIM(RTRIM(e.expid))
   AND LTRIM(RTRIM(m.myear)) = LTRIM(RTRIM(e.[year]))
WHERE e.ExpeditionKey IS NULL;
--testing for AMAD expid pattern, to understand if there is a specific issue with those:
SELECT TOP 50 expid, [year], peakid
FROM dbo.exped
WHERE expid LIKE 'AMAD%';

SELECT TOP 50
    m.expid,
    m.myear,
    e.expid,
    e.[year]
FROM dbo.members m
LEFT JOIN dbo.exped e
    ON LTRIM(RTRIM(m.expid)) = LTRIM(RTRIM(e.expid))
WHERE e.ExpeditionKey IS NULL;

--seems that year is the problem, there are many expid's with year 0 in members,but not in exped.

UPDATE dbo.members
SET ExpeditionKey = NULL;

UPDATE m
SET m.ExpeditionKey = e.ExpeditionKey
FROM dbo.members m
JOIN dbo.exped e
    ON LTRIM(RTRIM(m.expid)) = LTRIM(RTRIM(e.expid));

--check for unmatched again:

SELECT COUNT(*) AS unmatched
FROM dbo.members
WHERE ExpeditionKey IS NULL;

--final sructure and sanity check: 

--Null check:
SELECT COUNT(*) AS null_expeditionkey_count
FROM dbo.members
WHERE ExpeditionKey IS NULL;

--Broken Key check

SELECT COUNT(*) AS broken_member_links
FROM dbo.members m
LEFT JOIN dbo.exped e
    ON m.ExpeditionKey = e.ExpeditionKey
WHERE e.ExpeditionKey IS NULL;

--joining sample:

SELECT TOP 20
    m.MemberKey,
    m.membid,
    m.expid AS members_expid,
    m.myear,
    m.ExpeditionKey,
    e.expid AS exped_expid,
    e.[year] AS exped_year,
    e.peakid
FROM dbo.members m
LEFT JOIN dbo.exped e
    ON m.ExpeditionKey = e.ExpeditionKey
ORDER BY m.MemberKey;

--coverage check. This will help us understand how many member records are now properly linked to expeditions through the new ExpeditionKey,
--and how many still have issues (null or broken links).
SELECT 
    COUNT(*) AS total_member_rows,
    COUNT(m.ExpeditionKey) AS populated_expeditionkey_rows
FROM dbo.members m;

--so far we have the following: parent tables, child tables, lookup tables, and PK/FK relationships.

--6. Validation of refer table:

SELECT COUNT(*) AS null_expeditionkey_count
FROM dbo.refer
WHERE ExpeditionKey IS NULL;

--8 null values found

SELECT
    r.ReferenceKey,
    r.refid,
    r.expid,
    r.ryear
FROM dbo.refer r
WHERE r.ExpeditionKey IS NULL
ORDER BY r.expid, r.ryear;

--some data is likely missing from the parent table.

SELECT *
FROM dbo.exped
WHERE expid IN ('JANE19101', 'JETH74101');

/*These expid values do not exist in the exped table, resulting in orphan reference records that cannot be linked through the defined relationship.
Since these records cannot be linked to any expedition, and the refer table is consider of lesser importance for the overall analysis,
we will delete the 8 records with null ExpeditionKey to maintain data integrity and avoid confusion in future analyses. */

DELETE FROM dbo.refer
WHERE ExpeditionKey IS NULL;

--final check for refer:

SELECT COUNT(*) 
FROM dbo.refer
WHERE ExpeditionKey IS NULL;

--no nulls, next is to enforce relationship

ALTER TABLE dbo.refer
ADD CONSTRAINT FK_refer_exped
FOREIGN KEY (ExpeditionKey)
REFERENCES dbo.exped(ExpeditionKey);

--seems like the relationship is already enforced, no need to do it again.

SELECT name, type_desc
FROM sys.objects
WHERE name = 'FK_refer_exped';

--relationship exists, no need to create it again, but adding the check for safety:

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_refer_exped'
)
BEGIN
    ALTER TABLE dbo.refer
    ADD CONSTRAINT FK_refer_exped
    FOREIGN KEY (ExpeditionKey)
    REFERENCES dbo.exped(ExpeditionKey);
END;

--removing old, unused atributes to clear schema

BEGIN TRANSACTION;

-- =========================================================
-- 1) Drop old duplicated columns from dbo.exped
-- =========================================================
ALTER TABLE dbo.exped DROP COLUMN
    season,

    bcdate,
    smtdate,
    smttime,
    smtdays,
    totdays,
    termdate,
    termreason,
    termnote,

    route1,
    route2,
    route3,
    route4,

    success1,
    success2,
    success3,
    success4,
    ascent1,
    ascent2,
    ascent3,
    ascent4,

    totmembers,
    smtmembers,
    mdeaths,
    tothired,
    smthired,
    hdeaths,
    nohired,
    highpoint,

    claimed,
    disputed,
    traverse,
    ski,
    parapente,

    o2used,
    o2none,
    o2climb,
    o2descent,
    o2sleep,
    o2medical,
    o2taken,
    o2unkwn,

    camps,
    campsites,

    accidents,
    achievment,

    comrte,
    stdrte,
    primrte,
    primmem,
    primref,
    primid,

    agency,
    othersmts,
    chksum;
GO

-- =========================================================
-- 2) Drop old duplicated columns from dbo.members
-- =========================================================
ALTER TABLE dbo.members DROP COLUMN
    citizen;
GO

COMMIT TRANSACTION;

--checking
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'exped'
ORDER BY ORDINAL_POSITION;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'members'
ORDER BY ORDINAL_POSITION;

--updating the data dictionary:

BEGIN TRANSACTION;

-- =========================================================
-- 1) Remove old dictionary rows for affected tables
-- =========================================================
DELETE FROM dbo.himalayan_data_dictionary
WHERE Column1 IN (
    'exped',
    'members',
    'refer',
    'peaks',
    'season_lookup',
    'citizenship_lookup',
    'expedition_timeline',
    'expedition_routes',
    'expedition_outcomes',
    'expedition_statistics',
    'expedition_style',
    'expedition_oxygen',
    'expedition_camps',
    'expedition_incidents',
    'expedition_reference_summary',
    'expedition_admin'
);

-- =========================================================
-- 2) Insert updated dictionary rows for final schema
-- Format:
-- Column1 = table name
-- Column2 = column name (NULL means table-level definition)
-- Column3 = definition
-- =========================================================

INSERT INTO dbo.himalayan_data_dictionary (Column1, Column2, Column3)
VALUES

-- =========================================================
-- peaks
-- =========================================================
('peaks', NULL, 'Peak master table. One row represents one mountain or peak.'),
('peaks', 'peakid', 'Primary key of the peaks table. Unique identifier for each peak.'),
('peaks', 'pkname', 'Primary peak name.'),
('peaks', 'pkname2', 'Alternate peak name.'),
('peaks', 'location', 'Location description of the peak.'),
('peaks', 'heightm', 'Peak height in meters.'),
('peaks', 'heightf', 'Peak height in feet.'),
('peaks', 'himal', 'Himalayan range grouping or region family.'),
('peaks', 'region', 'Regional classification of the peak.'),
('peaks', 'open', 'Indicates whether the peak is open to expeditions.'),
('peaks', 'unlisted', 'Indicates whether the peak is unlisted or unofficial in some contexts.'),
('peaks', 'trekking', 'Indicates trekking peak status.'),
('peaks', 'trekyear', 'Year related to trekking peak designation.'),
('peaks', 'restrict', 'Restriction information for the peak.'),
('peaks', 'phost', 'Host or administrative ownership information related to the peak.'),
('peaks', 'pstatus', 'Status of the peak in the original dataset.'),
('peaks', 'pyear', 'Peak-related year field from the original dataset.'),
('peaks', 'pseason', 'Peak-related season field from the original dataset.'),
('peaks', 'pmonth', 'Peak-related month field from the original dataset.'),
('peaks', 'pday', 'Peak-related day field from the original dataset.'),
('peaks', 'pexpid', 'Peak-related expedition identifier from the original dataset.'),
('peaks', 'pcountry', 'Country associated with the peak.'),
('peaks', 'psummiters', 'Number of summiteers associated with the peak-related record.'),
('peaks', 'psmtnote', 'Peak-related summit note or comments.'),

-- =========================================================
-- season_lookup
-- =========================================================
('season_lookup', NULL, 'Lookup table for expedition seasons. One row represents one standardized season category.'),
('season_lookup', 'SeasonKey', 'Primary key of season_lookup. Surrogate identifier for a season category.'),
('season_lookup', 'SeasonName', 'Standardized season value such as Spring, Summer, Autumn, or Winter.'),

-- =========================================================
-- citizenship_lookup
-- =========================================================
('citizenship_lookup', NULL, 'Lookup table for member citizenship categories. One row represents one standardized citizenship value.'),
('citizenship_lookup', 'CitizenshipKey', 'Primary key of citizenship_lookup. Surrogate identifier for a citizenship category.'),
('citizenship_lookup', 'CitizenshipName', 'Standardized citizenship value used to classify member origin.'),

-- =========================================================
-- exped
-- =========================================================
('exped', NULL, 'Core expedition table. One row represents one expedition. This is the central parent entity in the normalized schema.'),
('exped', 'ExpeditionKey', 'Primary key of the expedition table. Surrogate identifier assigned to each expedition row.'),
('exped', 'expid', 'Source expedition identifier from the original dataset. Used with year as the business-level unique identifier.'),
('exped', 'year', 'Expedition year. Used with expid to distinguish expeditions whose source identifier repeats across years.'),
('exped', 'peakid', 'Foreign key to peaks. Identifies the peak associated with the expedition.'),
('exped', 'SeasonKey', 'Foreign key to season_lookup. Standardized season classification of the expedition.'),
('exped', 'host', 'Host country or administrative context of the expedition.'),
('exped', 'nation', 'Expedition national affiliation or sponsoring nation.'),
('exped', 'leaders', 'Leader or leaders of the expedition.'),
('exped', 'sponsor', 'Sponsor information for the expedition.'),
('exped', 'approach', 'Approach route or access description for the expedition.'),

-- =========================================================
-- members
-- =========================================================
('members', NULL, 'Member participation table. One row represents one member participation record associated with one expedition.'),
('members', 'MemberKey', 'Primary key of the members table. Surrogate identifier assigned to each member participation row.'),
('members', 'ExpeditionKey', 'Foreign key to exped. Links the member record to its parent expedition.'),
('members', 'CitizenshipKey', 'Foreign key to citizenship_lookup. Standardized citizenship classification for the member.'),
('members', 'membid', 'Source member identifier from the original dataset. Not used alone as the final primary key.'),
('members', 'expid', 'Source expedition identifier carried in the member record. Retained for traceability and source reference.'),
('members', 'peakid', 'Peak identifier carried in the source member record.'),
('members', 'myear', 'Member record year from the original dataset. Used in business-key analysis of member participation identity.'),
('members', 'mseason', 'Member-related season field from the original dataset.'),
('members', 'fname', 'Member first name.'),
('members', 'lname', 'Member last name.'),
('members', 'sex', 'Member sex or gender field.'),
('members', 'yob', 'Year of birth of the member.'),
('members', 'status', 'Status of the member in the original dataset.'),
('members', 'residence', 'Residence of the member.'),
('members', 'occupation', 'Occupation of the member.'),
('members', 'leader', 'Indicates whether the member was a leader.'),
('members', 'deputy', 'Indicates whether the member was a deputy leader.'),
('members', 'bconly', 'Indicates whether the member reached base camp only.'),
('members', 'nottobc', 'Indicates whether the member did not go to base camp.'),
('members', 'support', 'Indicates support role.'),
('members', 'disabled', 'Indicates disability-related field from the source dataset.'),
('members', 'hired', 'Indicates whether the member was hired staff.'),
('members', 'sherpa', 'Indicates whether the member was a Sherpa.'),
('members', 'tibetan', 'Indicates whether the member was Tibetan.'),
('members', 'msuccess', 'Member summit success indicator.'),
('members', 'mclaimed', 'Member-level claimed success field.'),
('members', 'mdisputed', 'Member-level disputed success field.'),
('members', 'msolo', 'Indicates whether the member climbed solo.'),
('members', 'mtraverse', 'Indicates whether the member completed a traverse.'),
('members', 'mski', 'Indicates whether the member used skiing in the expedition context.'),
('members', 'mparapente', 'Indicates whether the member used parapente/paragliding.'),
('members', 'mspeed', 'Indicates speed-related ascent field.'),
('members', 'mhighpt', 'Highest point reached by the member.'),
('members', 'mperhighpt', 'Member performance or percent-highpoint related field from the source dataset.'),
('members', 'msmtdate1', 'Member summit date field 1.'),
('members', 'msmtdate2', 'Member summit date field 2.'),
('members', 'msmtdate3', 'Member summit date field 3.'),
('members', 'msmttime1', 'Member summit time field 1.'),
('members', 'msmttime2', 'Member summit time field 2.'),
('members', 'msmttime3', 'Member summit time field 3.'),
('members', 'mroute1', 'Member route field 1.'),
('members', 'mroute2', 'Member route field 2.'),
('members', 'mroute3', 'Member route field 3.'),
('members', 'mascent1', 'Member ascent field 1.'),
('members', 'mascent2', 'Member ascent field 2.'),
('members', 'mascent3', 'Member ascent field 3.'),
('members', 'mo2used', 'Member oxygen-used field.'),
('members', 'mo2none', 'Member no-oxygen field.'),
('members', 'mo2climb', 'Member oxygen-on-climb field.'),
('members', 'mo2descent', 'Member oxygen-on-descent field.'),
('members', 'mo2sleep', 'Member oxygen-during-sleep field.'),
('members', 'mo2medical', 'Member oxygen-for-medical-use field.'),
('members', 'mo2note', 'Member oxygen notes.'),
('members', 'death', 'Indicates whether the member died.'),
('members', 'deathdate', 'Date of member death.'),
('members', 'deathtime', 'Time of member death.'),
('members', 'deathtype', 'Type/category of death.'),
('members', 'deathhgtm', 'Height in meters at which death occurred.'),
('members', 'deathclass', 'Classification of member death.'),
('members', 'msmtbid', 'Member summit bid identifier or related field from the source dataset.'),
('members', 'msmtterm', 'Member summit termination or related narrative field.'),
('members', 'hcn', 'Source field from the original dataset retained for traceability.'),
('members', 'mchksum', 'Checksum or source control field for the member record.'),

-- =========================================================
-- refer
-- =========================================================
('refer', NULL, 'Reference table. One row represents one bibliographic or reference record associated with one expedition.'),
('refer', 'ReferenceKey', 'Primary key of the refer table. Surrogate identifier assigned to each reference record.'),
('refer', 'ExpeditionKey', 'Foreign key to exped. Links the reference record to its parent expedition.'),
('refer', 'refid', 'Source reference identifier from the original dataset.'),
('refer', 'expid', 'Source expedition identifier recorded in the reference table.'),
('refer', 'ryear', 'Reference year from the original dataset.'),
('refer', 'rtype', 'Reference type or classification.'),
('refer', 'rjrnl', 'Reference journal or publication outlet.'),
('refer', 'rauthor', 'Reference author or authors.'),
('refer', 'rtitle', 'Reference title.'),
('refer', 'rpublisher', 'Reference publisher information.'),
('refer', 'rpubdate', 'Reference publication date.'),
('refer', 'rlanguage', 'Reference language.'),
('refer', 'rcitation', 'Full reference citation text.'),
('refer', 'ryak94', 'Source-specific reference field retained from the original dataset.'),

-- =========================================================
-- expedition_timeline
-- =========================================================
('expedition_timeline', NULL, 'Child table of exped containing expedition chronology, dates, duration, and termination details.'),
('expedition_timeline', 'ExpeditionTimelineKey', 'Primary key of expedition_timeline.'),
('expedition_timeline', 'ExpeditionKey', 'Foreign key to exped. Links the timeline record to its expedition.'),
('expedition_timeline', 'bcdate', 'Base camp date.'),
('expedition_timeline', 'smtdate', 'Summit date.'),
('expedition_timeline', 'smttime', 'Summit time.'),
('expedition_timeline', 'smtdays', 'Number of days to summit.'),
('expedition_timeline', 'totdays', 'Total duration of the expedition in days.'),
('expedition_timeline', 'termdate', 'Expedition termination date.'),
('expedition_timeline', 'termreason', 'Reason for expedition termination.'),
('expedition_timeline', 'termnote', 'Additional termination notes.'),

-- =========================================================
-- expedition_routes
-- =========================================================
('expedition_routes', NULL, 'Child table of exped containing normalized expedition route entries. One row represents one route associated with one expedition.'),
('expedition_routes', 'ExpeditionRouteKey', 'Primary key of expedition_routes.'),
('expedition_routes', 'ExpeditionKey', 'Foreign key to exped. Links the route entry to its expedition.'),
('expedition_routes', 'RouteNumber', 'Sequence number indicating which original route field the row came from.'),
('expedition_routes', 'RouteDescription', 'Route description associated with the expedition.'),

-- =========================================================
-- expedition_outcomes
-- =========================================================
('expedition_outcomes', NULL, 'Child table of exped containing normalized outcome and ascent entries. One row represents one outcome entry for one expedition.'),
('expedition_outcomes', 'ExpeditionOutcomeKey', 'Primary key of expedition_outcomes.'),
('expedition_outcomes', 'ExpeditionKey', 'Foreign key to exped. Links the outcome row to its expedition.'),
('expedition_outcomes', 'OutcomeNumber', 'Sequence number indicating which original success/ascent pair the row came from.'),
('expedition_outcomes', 'SuccessStatus', 'Outcome success value from the original expedition record.'),
('expedition_outcomes', 'AscentDescription', 'Outcome ascent description from the original expedition record.'),

-- =========================================================
-- expedition_statistics
-- =========================================================
('expedition_statistics', NULL, 'Child table of exped containing quantitative expedition statistics and measurable counts.'),
('expedition_statistics', 'ExpeditionStatisticsKey', 'Primary key of expedition_statistics.'),
('expedition_statistics', 'ExpeditionKey', 'Foreign key to exped. Links the statistics record to its expedition.'),
('expedition_statistics', 'totmembers', 'Total number of expedition members.'),
('expedition_statistics', 'smtmembers', 'Number of members who summited.'),
('expedition_statistics', 'mdeaths', 'Number of member deaths.'),
('expedition_statistics', 'tothired', 'Total hired personnel.'),
('expedition_statistics', 'smthired', 'Number of hired personnel who summited.'),
('expedition_statistics', 'hdeaths', 'Number of hired personnel deaths.'),
('expedition_statistics', 'nohired', 'Field related to non-hired participation from the original dataset.'),
('expedition_statistics', 'highpoint', 'Highest point reached by the expedition.'),

-- =========================================================
-- expedition_style
-- =========================================================
('expedition_style', NULL, 'Child table of exped containing expedition style and classification flags.'),
('expedition_style', 'ExpeditionStyleKey', 'Primary key of expedition_style.'),
('expedition_style', 'ExpeditionKey', 'Foreign key to exped. Links the style record to its expedition.'),
('expedition_style', 'claimed', 'Indicates whether summit success was claimed.'),
('expedition_style', 'disputed', 'Indicates whether summit success was disputed.'),
('expedition_style', 'traverse', 'Indicates whether the expedition involved a traverse.'),
('expedition_style', 'ski', 'Indicates whether the expedition involved skiing.'),
('expedition_style', 'parapente', 'Indicates whether the expedition involved parapente/paragliding.'),

-- =========================================================
-- expedition_oxygen
-- =========================================================
('expedition_oxygen', NULL, 'Child table of exped containing expedition-level oxygen usage information.'),
('expedition_oxygen', 'ExpeditionOxygenKey', 'Primary key of expedition_oxygen.'),
('expedition_oxygen', 'ExpeditionKey', 'Foreign key to exped. Links the oxygen record to its expedition.'),
('expedition_oxygen', 'o2used', 'Indicates whether oxygen was used.'),
('expedition_oxygen', 'o2none', 'Indicates whether no oxygen was used.'),
('expedition_oxygen', 'o2climb', 'Indicates whether oxygen was used during climbing.'),
('expedition_oxygen', 'o2descent', 'Indicates whether oxygen was used during descent.'),
('expedition_oxygen', 'o2sleep', 'Indicates whether oxygen was used while sleeping.'),
('expedition_oxygen', 'o2medical', 'Indicates whether oxygen was used for medical purposes.'),
('expedition_oxygen', 'o2taken', 'Indicates whether oxygen was carried or taken.'),
('expedition_oxygen', 'o2unkwn', 'Indicates whether oxygen usage is unknown.'),

-- =========================================================
-- expedition_camps
-- =========================================================
('expedition_camps', NULL, 'Child table of exped containing camp and campsite information.'),
('expedition_camps', 'ExpeditionCampsKey', 'Primary key of expedition_camps.'),
('expedition_camps', 'ExpeditionKey', 'Foreign key to exped. Links the camps record to its expedition.'),
('expedition_camps', 'camps', 'Camp information from the original expedition record.'),
('expedition_camps', 'campsites', 'Campsite details from the original expedition record.'),

-- =========================================================
-- expedition_incidents
-- =========================================================
('expedition_incidents', NULL, 'Child table of exped containing incident, accident, and achievement narratives.'),
('expedition_incidents', 'ExpeditionIncidentsKey', 'Primary key of expedition_incidents.'),
('expedition_incidents', 'ExpeditionKey', 'Foreign key to exped. Links the incidents record to its expedition.'),
('expedition_incidents', 'accidents', 'Accident or incident information associated with the expedition.'),
('expedition_incidents', 'achievment', 'Achievement narrative associated with the expedition.'),

-- =========================================================
-- expedition_reference_summary
-- =========================================================
('expedition_reference_summary', NULL, 'Child table of exped containing expedition route/reference summary metadata.'),
('expedition_reference_summary', 'ExpeditionReferenceSummaryKey', 'Primary key of expedition_reference_summary.'),
('expedition_reference_summary', 'ExpeditionKey', 'Foreign key to exped. Links the reference summary record to its expedition.'),
('expedition_reference_summary', 'comrte', 'Commercial route field retained from the original expedition record.'),
('expedition_reference_summary', 'stdrte', 'Standard route field retained from the original expedition record.'),
('expedition_reference_summary', 'primrte', 'Primary route field retained from the original expedition record.'),
('expedition_reference_summary', 'primmem', 'Primary member-related field retained from the original expedition record.'),
('expedition_reference_summary', 'primref', 'Primary reference-related field retained from the original expedition record.'),
('expedition_reference_summary', 'primid', 'Primary identifier/reference summary field retained from the original expedition record.'),

-- =========================================================
-- expedition_admin
-- =========================================================
('expedition_admin', NULL, 'Child table of exped containing administrative or support metadata.'),
('expedition_admin', 'ExpeditionAdminKey', 'Primary key of expedition_admin.'),
('expedition_admin', 'ExpeditionKey', 'Foreign key to exped. Links the admin record to its expedition.'),
('expedition_admin', 'agency', 'Agency associated with the expedition.'),
('expedition_admin', 'othersmts', 'Other summits field retained from the original expedition record.'),
('expedition_admin', 'chksum', 'Checksum or administrative control field retained from the original expedition record.');

COMMIT TRANSACTION;

--found out that peaks doesnt have a pk defined
SELECT kc.name AS constraint_name,
       kc.type_desc,
       c.name AS column_name
FROM sys.key_constraints kc
JOIN sys.index_columns ic
    ON kc.parent_object_id = ic.object_id
   AND kc.unique_index_id = ic.index_id
JOIN sys.columns c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE kc.parent_object_id = OBJECT_ID('dbo.peaks');
--peaks was updated as nullable

UPDATE dbo.peaks
SET peakid = LTRIM(RTRIM(peakid));

ALTER TABLE dbo.peaks
ALTER COLUMN peakid NVARCHAR(255) NOT NULL;

ALTER TABLE dbo.peaks
ADD CONSTRAINT PK_peaks PRIMARY KEY (peakid);

--updating dictionary

BEGIN TRANSACTION;

-- =========================================================
-- PRIMARY KEYS
-- =========================================================

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of the peaks table. Unique, non-null identifier for each peak.'
WHERE Column1 = 'peaks' AND Column2 = 'peakid';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of the exped table. Surrogate key uniquely identifying each expedition.'
WHERE Column1 = 'exped' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of the members table. Surrogate key uniquely identifying each member record.'
WHERE Column1 = 'members' AND Column2 = 'MemberKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of the refer table. Surrogate key uniquely identifying each reference record.'
WHERE Column1 = 'refer' AND Column2 = 'ReferenceKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of season_lookup. Surrogate identifier for each season category.'
WHERE Column1 = 'season_lookup' AND Column2 = 'SeasonKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Primary key of citizenship_lookup. Surrogate identifier for each citizenship category.'
WHERE Column1 = 'citizenship_lookup' AND Column2 = 'CitizenshipKey';


-- =========================================================
-- FOREIGN KEYS
-- =========================================================

-- exped → peaks
UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to peaks. Links expedition to its associated peak.'
WHERE Column1 = 'exped' AND Column2 = 'peakid';

-- exped → season_lookup
UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to season_lookup. Standardized season classification of the expedition.'
WHERE Column1 = 'exped' AND Column2 = 'SeasonKey';

-- members → exped
UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links member to its expedition.'
WHERE Column1 = 'members' AND Column2 = 'ExpeditionKey';

-- members → citizenship_lookup
UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to citizenship_lookup. Standardized citizenship classification for the member.'
WHERE Column1 = 'members' AND Column2 = 'CitizenshipKey';

-- refer → exped
UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links reference to its expedition.'
WHERE Column1 = 'refer' AND Column2 = 'ExpeditionKey';


-- =========================================================
-- CHILD TABLE FOREIGN KEYS (all expedition-based)
-- =========================================================

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links timeline data to its expedition.'
WHERE Column1 = 'expedition_timeline' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links route records to their expedition.'
WHERE Column1 = 'expedition_routes' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links outcome records to their expedition.'
WHERE Column1 = 'expedition_outcomes' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links statistics to their expedition.'
WHERE Column1 = 'expedition_statistics' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links style attributes to their expedition.'
WHERE Column1 = 'expedition_style' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links oxygen usage data to their expedition.'
WHERE Column1 = 'expedition_oxygen' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links camp data to their expedition.'
WHERE Column1 = 'expedition_camps' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links incident data to their expedition.'
WHERE Column1 = 'expedition_incidents' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links reference summary data to their expedition.'
WHERE Column1 = 'expedition_reference_summary' AND Column2 = 'ExpeditionKey';

UPDATE dbo.himalayan_data_dictionary
SET Column3 = 'Foreign key to exped. Links administrative data to their expedition.'
WHERE Column1 = 'expedition_admin' AND Column2 = 'ExpeditionKey';


COMMIT TRANSACTION;
--Ready for ERD creation and further analysis.
--NOTE: dbo.members can still be decomposed into more functional tables if needed.

--exporting schema for further analysis:

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;

---

SELECT 
    tc.TABLE_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
ORDER BY tc.TABLE_NAME; 

-- conclusion, there exist transitative dependencies, fuerther normalization is required.

--6. member table requires granulation to split entities, eliminate repetitive entities and transitative dependencies.

/* =========================================================
   MEMBERS FULL NORMALIZATION
   Goal:
   1) Split person-level data from participation-level data
   2) Normalize repeating member route fields
   3) Normalize repeating member summit date/time/ascent fields
   4) Preserve traceability to old dbo.members via MemberKey
   Assumes:
   - dbo.members already has MemberKey PK
   - dbo.members already has ExpeditionKey FK
   - dbo.members already has CitizenshipKey FK
   ========================================================= */

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
GO

/* =========================================================
   0) SAFETY CHECKS
   ========================================================= */
SELECT TOP 1 MemberKey, membid, ExpeditionKey, CitizenshipKey
FROM dbo.members;
GO

/* =========================================================
   1) PERSON TABLE
   One row per real person/business identity
   Grain: one person
   Business key used: membid
   ========================================================= */
IF OBJECT_ID('dbo.member_person', 'U') IS NOT NULL
    DROP TABLE dbo.member_person;
GO

CREATE TABLE dbo.member_person (
    PersonKey INT IDENTITY(1,1) NOT NULL,
    membid NVARCHAR(255) NOT NULL,
    CitizenshipKey INT NULL,
    fname NVARCHAR(255) NULL,
    lname NVARCHAR(255) NULL,
    sex NVARCHAR(50) NULL,
    yob NVARCHAR(50) NULL,
    residence NVARCHAR(255) NULL,
    occupation NVARCHAR(255) NULL,
    hcn NVARCHAR(255) NULL,
    CONSTRAINT PK_member_person PRIMARY KEY (PersonKey),
    CONSTRAINT UQ_member_person_membid UNIQUE (membid),
    CONSTRAINT FK_member_person_citizenship
        FOREIGN KEY (CitizenshipKey) REFERENCES dbo.citizenship_lookup(CitizenshipKey)
);
GO

INSERT INTO dbo.member_person (
    membid,
    CitizenshipKey,
    fname,
    lname,
    sex,
    yob,
    residence,
    occupation,
    hcn
)
SELECT
    x.membid,
    x.CitizenshipKey,
    x.fname,
    x.lname,
    x.sex,
    x.yob,
    x.residence,
    x.occupation,
    x.hcn
FROM
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY membid
               ORDER BY MemberKey
           ) AS rn
    FROM dbo.members
    WHERE membid IS NOT NULL
      AND LTRIM(RTRIM(membid)) <> ''
) x
WHERE x.rn = 1;
GO

/* Validation */
SELECT 
    COUNT(*) AS total_person_rows,
    COUNT(DISTINCT membid) AS distinct_membid_rows
FROM dbo.member_person;
GO

/* =========================================================
   2) PARTICIPATION TABLE
   One row per member participation in an expedition
   Grain: one person in one expedition record
   Uses old MemberKey for traceability
   ========================================================= */
IF OBJECT_ID('dbo.member_participation', 'U') IS NOT NULL
    DROP TABLE dbo.member_participation;
GO

CREATE TABLE dbo.member_participation (
    MemberParticipationKey INT IDENTITY(1,1) NOT NULL,
    LegacyMemberKey INT NOT NULL,
    PersonKey INT NOT NULL,
    ExpeditionKey INT NULL,

    expid NVARCHAR(255) NULL,
    peakid NVARCHAR(255) NULL,
    myear NVARCHAR(50) NULL,
    mseason NVARCHAR(100) NULL,
    [status] NVARCHAR(255) NULL,

    leader NVARCHAR(50) NULL,
    deputy NVARCHAR(50) NULL,
    bconly NVARCHAR(50) NULL,
    nottobc NVARCHAR(50) NULL,
    support NVARCHAR(50) NULL,
    disabled NVARCHAR(50) NULL,
    hired NVARCHAR(50) NULL,
    sherpa NVARCHAR(50) NULL,
    tibetan NVARCHAR(50) NULL,

    msuccess NVARCHAR(50) NULL,
    mclaimed NVARCHAR(50) NULL,
    mdisputed NVARCHAR(50) NULL,
    msolo NVARCHAR(50) NULL,
    mtraverse NVARCHAR(50) NULL,
    mski NVARCHAR(50) NULL,
    mparapente NVARCHAR(50) NULL,
    mspeed NVARCHAR(255) NULL,
    mhighpt NVARCHAR(255) NULL,
    mperhighpt NVARCHAR(255) NULL,

    mo2used NVARCHAR(50) NULL,
    mo2none NVARCHAR(50) NULL,
    mo2climb NVARCHAR(50) NULL,
    mo2descent NVARCHAR(50) NULL,
    mo2sleep NVARCHAR(50) NULL,
    mo2medical NVARCHAR(50) NULL,
    mo2note NVARCHAR(MAX) NULL,

    death NVARCHAR(50) NULL,
    deathdate NVARCHAR(255) NULL,
    deathtime NVARCHAR(255) NULL,
    deathtype NVARCHAR(255) NULL,
    deathhgtm NVARCHAR(255) NULL,
    deathclass NVARCHAR(255) NULL,

    msmtbid NVARCHAR(255) NULL,
    msmtterm NVARCHAR(MAX) NULL,
    mchksum NVARCHAR(255) NULL,

    CONSTRAINT PK_member_participation PRIMARY KEY (MemberParticipationKey),
    CONSTRAINT UQ_member_participation_legacy UNIQUE (LegacyMemberKey),
    CONSTRAINT FK_member_participation_person
        FOREIGN KEY (PersonKey) REFERENCES dbo.member_person(PersonKey),
    CONSTRAINT FK_member_participation_exped
        FOREIGN KEY (ExpeditionKey) REFERENCES dbo.exped(ExpeditionKey),
    CONSTRAINT FK_member_participation_peaks
        FOREIGN KEY (peakid) REFERENCES dbo.peaks(peakid)
);
GO

INSERT INTO dbo.member_participation (
    LegacyMemberKey,
    PersonKey,
    ExpeditionKey,
    expid,
    peakid,
    myear,
    mseason,
    [status],
    leader,
    deputy,
    bconly,
    nottobc,
    support,
    disabled,
    hired,
    sherpa,
    tibetan,
    msuccess,
    mclaimed,
    mdisputed,
    msolo,
    mtraverse,
    mski,
    mparapente,
    mspeed,
    mhighpt,
    mperhighpt,
    mo2used,
    mo2none,
    mo2climb,
    mo2descent,
    mo2sleep,
    mo2medical,
    mo2note,
    death,
    deathdate,
    deathtime,
    deathtype,
    deathhgtm,
    deathclass,
    msmtbid,
    msmtterm,
    mchksum
)
SELECT
    m.MemberKey,
    p.PersonKey,
    m.ExpeditionKey,
    m.expid,
    m.peakid,
    m.myear,
    m.mseason,
    m.[status],
    m.leader,
    m.deputy,
    m.bconly,
    m.nottobc,
    m.support,
    m.disabled,
    m.hired,
    m.sherpa,
    m.tibetan,
    m.msuccess,
    m.mclaimed,
    m.mdisputed,
    m.msolo,
    m.mtraverse,
    m.mski,
    m.mparapente,
    m.mspeed,
    m.mhighpt,
    m.mperhighpt,
    m.mo2used,
    m.mo2none,
    m.mo2climb,
    m.mo2descent,
    m.mo2sleep,
    m.mo2medical,
    m.mo2note,
    m.death,
    m.deathdate,
    m.deathtime,
    m.deathtype,
    m.deathhgtm,
    m.deathclass,
    m.msmtbid,
    m.msmtterm,
    m.mchksum
FROM dbo.members m
JOIN dbo.member_person p
    ON m.membid = p.membid;
GO

/* Validation */
SELECT 
    COUNT(*) AS old_members_rows
FROM dbo.members;

SELECT 
    COUNT(*) AS new_participation_rows
FROM dbo.member_participation;
GO

/* =========================================================
   3) MEMBER ROUTES
   One row per participation route
   ========================================================= */
IF OBJECT_ID('dbo.member_routes', 'U') IS NOT NULL
    DROP TABLE dbo.member_routes;
GO

CREATE TABLE dbo.member_routes (
    MemberRouteKey INT IDENTITY(1,1) NOT NULL,
    MemberParticipationKey INT NOT NULL,
    RouteNumber INT NOT NULL,
    RouteDescription NVARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_member_routes PRIMARY KEY (MemberRouteKey),
    CONSTRAINT UQ_member_routes UNIQUE (MemberParticipationKey, RouteNumber),
    CONSTRAINT FK_member_routes_participation
        FOREIGN KEY (MemberParticipationKey)
        REFERENCES dbo.member_participation(MemberParticipationKey)
);
GO

INSERT INTO dbo.member_routes (
    MemberParticipationKey,
    RouteNumber,
    RouteDescription
)
SELECT mp.MemberParticipationKey, 1, LTRIM(RTRIM(m.mroute1))
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE m.mroute1 IS NOT NULL
  AND LTRIM(RTRIM(m.mroute1)) <> ''

UNION ALL

SELECT mp.MemberParticipationKey, 2, LTRIM(RTRIM(m.mroute2))
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE m.mroute2 IS NOT NULL
  AND LTRIM(RTRIM(m.mroute2)) <> ''

UNION ALL

SELECT mp.MemberParticipationKey, 3, LTRIM(RTRIM(m.mroute3))
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE m.mroute3 IS NOT NULL
  AND LTRIM(RTRIM(m.mroute3)) <> '';
GO

/* =========================================================
   4) MEMBER SUMMITS
   One row per summit attempt slot
   date/time/ascent moved out of members
   ========================================================= */
IF OBJECT_ID('dbo.member_summits', 'U') IS NOT NULL
    DROP TABLE dbo.member_summits;
GO

CREATE TABLE dbo.member_summits (
    MemberSummitKey INT IDENTITY(1,1) NOT NULL,
    MemberParticipationKey INT NOT NULL,
    SummitNumber INT NOT NULL,
    SummitDate NVARCHAR(255) NULL,
    SummitTime NVARCHAR(255) NULL,
    AscentDescription NVARCHAR(MAX) NULL,
    CONSTRAINT PK_member_summits PRIMARY KEY (MemberSummitKey),
    CONSTRAINT UQ_member_summits UNIQUE (MemberParticipationKey, SummitNumber),
    CONSTRAINT FK_member_summits_participation
        FOREIGN KEY (MemberParticipationKey)
        REFERENCES dbo.member_participation(MemberParticipationKey)
);
GO

INSERT INTO dbo.member_summits (
    MemberParticipationKey,
    SummitNumber,
    SummitDate,
    SummitTime,
    AscentDescription
)
SELECT
    mp.MemberParticipationKey,
    1,
    m.msmtdate1,
    m.msmttime1,
    m.mascent1
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE (m.msmtdate1 IS NOT NULL AND LTRIM(RTRIM(m.msmtdate1)) <> '')
   OR (m.msmttime1 IS NOT NULL AND LTRIM(RTRIM(m.msmttime1)) <> '')
   OR (m.mascent1 IS NOT NULL AND LTRIM(RTRIM(m.mascent1)) <> '')

UNION ALL

SELECT
    mp.MemberParticipationKey,
    2,
    m.msmtdate2,
    m.msmttime2,
    m.mascent2
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE (m.msmtdate2 IS NOT NULL AND LTRIM(RTRIM(m.msmtdate2)) <> '')
   OR (m.msmttime2 IS NOT NULL AND LTRIM(RTRIM(m.msmttime2)) <> '')
   OR (m.mascent2 IS NOT NULL AND LTRIM(RTRIM(m.mascent2)) <> '')

UNION ALL

SELECT
    mp.MemberParticipationKey,
    3,
    m.msmtdate3,
    m.msmttime3,
    m.mascent3
FROM dbo.members m
JOIN dbo.member_participation mp
    ON m.MemberKey = mp.LegacyMemberKey
WHERE (m.msmtdate3 IS NOT NULL AND LTRIM(RTRIM(m.msmtdate3)) <> '')
   OR (m.msmttime3 IS NOT NULL AND LTRIM(RTRIM(m.msmttime3)) <> '')
   OR (m.mascent3 IS NOT NULL AND LTRIM(RTRIM(m.mascent3)) <> '');
GO

/* =========================================================
   5) VALIDATION
   ========================================================= */
SELECT 'member_person' AS table_name, COUNT(*) AS row_count
FROM dbo.member_person
UNION ALL
SELECT 'member_participation', COUNT(*)
FROM dbo.member_participation
UNION ALL
SELECT 'member_routes', COUNT(*)
FROM dbo.member_routes
UNION ALL
SELECT 'member_summits', COUNT(*)
FROM dbo.member_summits;
GO

SELECT COUNT(*) AS missing_person_links
FROM dbo.member_participation mp
LEFT JOIN dbo.member_person p
    ON mp.PersonKey = p.PersonKey
WHERE p.PersonKey IS NULL;
GO

SELECT COUNT(*) AS missing_expedition_links
FROM dbo.member_participation mp
LEFT JOIN dbo.exped e
    ON mp.ExpeditionKey = e.ExpeditionKey
WHERE mp.ExpeditionKey IS NOT NULL
  AND e.ExpeditionKey IS NULL;
GO

SELECT TOP 20
    mp.MemberParticipationKey,
    mp.LegacyMemberKey,
    p.membid,
    p.fname,
    p.lname,
    mp.ExpeditionKey,
    mp.expid,
    mp.myear
FROM dbo.member_participation mp
JOIN dbo.member_person p
    ON mp.PersonKey = p.PersonKey
ORDER BY mp.MemberParticipationKey;
GO

/* =========================================================
   6) Run only after you verify everything above
   ========================================================= */

-- Drop old columns from dbo.members that now belong in member_person,
-- member_participation, member_routes, and member_summits.

ALTER TABLE dbo.members DROP COLUMN
    fname,
    lname,
    sex,
    yob,
    residence,
    occupation,
    hcn,

    [status],
    leader,
    deputy,
    bconly,
    nottobc,
    support,
    disabled,
    hired,
    sherpa,
    tibetan,
    msuccess,
    mclaimed,
    mdisputed,
    msolo,
    mtraverse,
    mski,
    mparapente,
    mspeed,
    mhighpt,
    mperhighpt,
    mo2used,
    mo2none,
    mo2climb,
    mo2descent,
    mo2sleep,
    mo2medical,
    mo2note,
    death,
    deathdate,
    deathtime,
    deathtype,
    deathhgtm,
    deathclass,
    msmtbid,
    msmtterm,
    mchksum,

    mroute1,
    mroute2,
    mroute3,
    msmtdate1,
    msmtdate2,
    msmtdate3,
    msmttime1,
    msmttime2,
    msmttime3,
    mascent1,
    mascent2,
    mascent3;
GO

COMMIT TRANSACTION;
GO

--7. Checking for possible transitative dependencies in peaks
--a. Does region consistently map to one himal?

SELECT 
    LTRIM(RTRIM(region)) AS region,
    COUNT(DISTINCT LTRIM(RTRIM(himal))) AS distinct_himal_count
FROM dbo.peaks
WHERE region IS NOT NULL
  AND LTRIM(RTRIM(region)) <> ''
  AND himal IS NOT NULL
  AND LTRIM(RTRIM(himal)) <> ''
GROUP BY LTRIM(RTRIM(region))
HAVING COUNT(DISTINCT LTRIM(RTRIM(himal))) > 1
ORDER BY distinct_himal_count DESC, region;
-- Not a functional dependency

--b. Does pcountry consistently map to one region?

SELECT 
    LTRIM(RTRIM(pcountry)) AS pcountry,
    COUNT(DISTINCT LTRIM(RTRIM(region))) AS distinct_region_count
FROM dbo.peaks
WHERE pcountry IS NOT NULL
  AND LTRIM(RTRIM(pcountry)) <> ''
  AND region IS NOT NULL
  AND LTRIM(RTRIM(region)) <> ''
GROUP BY LTRIM(RTRIM(pcountry))
HAVING COUNT(DISTINCT LTRIM(RTRIM(region))) > 1
ORDER BY distinct_region_count DESC, pcountry;
--not a functional dependency

--c. Does pexpid determine the peak-history fields?

SELECT 
    LTRIM(RTRIM(pexpid)) AS pexpid,
    COUNT(DISTINCT CONCAT(
        COALESCE(LTRIM(RTRIM(pyear)), ''), '|',
        COALESCE(LTRIM(RTRIM(pseason)), ''), '|',
        COALESCE(LTRIM(RTRIM(pmonth)), ''), '|',
        COALESCE(LTRIM(RTRIM(pday)), ''), '|',
        COALESCE(LTRIM(RTRIM(psummiters)), ''), '|',
        COALESCE(LTRIM(RTRIM(psmtnote)), '')
    )) AS distinct_profile_count
FROM dbo.peaks
WHERE pexpid IS NOT NULL
  AND LTRIM(RTRIM(pexpid)) <> ''
GROUP BY LTRIM(RTRIM(pexpid))
HAVING COUNT(DISTINCT CONCAT(
        COALESCE(LTRIM(RTRIM(pyear)), ''), '|',
        COALESCE(LTRIM(RTRIM(pseason)), ''), '|',
        COALESCE(LTRIM(RTRIM(pmonth)), ''), '|',
        COALESCE(LTRIM(RTRIM(pday)), ''), '|',
        COALESCE(LTRIM(RTRIM(psummiters)), ''), '|',
        COALESCE(LTRIM(RTRIM(psmtnote)), '')
    )) > 1
ORDER BY distinct_profile_count DESC, pexpid;
--This is a functional dependency

--d.How many unique peak-history profiles exist per peakid?

SELECT 
    peakid,
    COUNT(DISTINCT CONCAT(
        COALESCE(LTRIM(RTRIM(pexpid)), ''), '|',
        COALESCE(LTRIM(RTRIM(pyear)), ''), '|',
        COALESCE(LTRIM(RTRIM(pseason)), ''), '|',
        COALESCE(LTRIM(RTRIM(pmonth)), ''), '|',
        COALESCE(LTRIM(RTRIM(pday)), ''), '|',
        COALESCE(LTRIM(RTRIM(psummiters)), ''), '|',
        COALESCE(LTRIM(RTRIM(psmtnote)), '')
    )) AS distinct_peak_history_profiles
FROM dbo.peaks
GROUP BY peakid
HAVING COUNT(DISTINCT CONCAT(
        COALESCE(LTRIM(RTRIM(pexpid)), ''), '|',
        COALESCE(LTRIM(RTRIM(pyear)), ''), '|',
        COALESCE(LTRIM(RTRIM(pseason)), ''), '|',
        COALESCE(LTRIM(RTRIM(pmonth)), ''), '|',
        COALESCE(LTRIM(RTRIM(pday)), ''), '|',
        COALESCE(LTRIM(RTRIM(psummiters)), ''), '|',
        COALESCE(LTRIM(RTRIM(psmtnote)), '')
    )) > 1
ORDER BY distinct_peak_history_profiles DESC, peakid;
--This is a transative dependency

/*non-key attributes depend on another non-key (pexpid), but the pexpid-related fields form a 1-to-1 relationship with each peak,
so they do not introduce duplication or multi-valued dependencies. 
Splitting them into a separate table would add complexity without improving data integrity or normalization in practice.*/

--Final dictionary update after complete 3NF normalization

BEGIN TRANSACTION;

-- =========================================================
-- Remove old member-related dictionary entries
-- =========================================================
DELETE FROM dbo.himalayan_data_dictionary
WHERE Column1 IN (
    'member_person',
    'member_participation',
    'member_routes',
    'member_summits'
);

-- =========================================================
-- Insert updated dictionary rows for normalized member structure
-- =========================================================
INSERT INTO dbo.himalayan_data_dictionary (Column1, Column2, Column3)
VALUES

-- =========================================================
-- member_person
-- =========================================================
('member_person', NULL, 'Person master table. One row represents one unique individual across all expeditions.'),
('member_person', 'PersonKey', 'Primary key of member_person. Surrogate identifier for each individual.'),
('member_person', 'membid', 'Business identifier from the original dataset representing the individual.'),
('member_person', 'CitizenshipKey', 'Foreign key to citizenship_lookup. Standardized citizenship classification.'),
('member_person', 'fname', 'First name of the individual.'),
('member_person', 'lname', 'Last name of the individual.'),
('member_person', 'sex', 'Sex or gender of the individual.'),
('member_person', 'yob', 'Year of birth.'),
('member_person', 'residence', 'Place of residence.'),
('member_person', 'occupation', 'Occupation of the individual.'),
('member_person', 'hcn', 'Source field retained for traceability.'),

-- =========================================================
-- member_participation
-- =========================================================
('member_participation', NULL, 'Participation table. One row represents one individual participating in one expedition.'),
('member_participation', 'MemberParticipationKey', 'Primary key of member_participation. Surrogate identifier for each participation record.'),
('member_participation', 'LegacyMemberKey', 'Original MemberKey from dbo.members retained for traceability.'),
('member_participation', 'PersonKey', 'Foreign key to member_person. Identifies the individual.'),
('member_participation', 'ExpeditionKey', 'Foreign key to exped. Links participation to an expedition.'),
('member_participation', 'expid', 'Original expedition identifier from source data.'),
('member_participation', 'peakid', 'Foreign key to peaks. Identifies the associated peak.'),
('member_participation', 'myear', 'Year of participation from the original dataset.'),
('member_participation', 'mseason', 'Season of participation.'),
('member_participation', 'status', 'Status of the participant.'),
('member_participation', 'leader', 'Indicates leadership role.'),
('member_participation', 'deputy', 'Indicates deputy leadership role.'),
('member_participation', 'bconly', 'Indicates base-camp-only participation.'),
('member_participation', 'nottobc', 'Indicates no base camp participation.'),
('member_participation', 'support', 'Indicates support role.'),
('member_participation', 'disabled', 'Indicates disability-related field.'),
('member_participation', 'hired', 'Indicates hired staff.'),
('member_participation', 'sherpa', 'Indicates Sherpa role.'),
('member_participation', 'tibetan', 'Indicates Tibetan role.'),
('member_participation', 'msuccess', 'Indicates summit success.'),
('member_participation', 'mclaimed', 'Indicates claimed success.'),
('member_participation', 'mdisputed', 'Indicates disputed success.'),
('member_participation', 'msolo', 'Indicates solo climb.'),
('member_participation', 'mtraverse', 'Indicates traverse.'),
('member_participation', 'mski', 'Indicates ski usage.'),
('member_participation', 'mparapente', 'Indicates parapente usage.'),
('member_participation', 'mspeed', 'Speed-related attribute.'),
('member_participation', 'mhighpt', 'Highest point reached.'),
('member_participation', 'mperhighpt', 'Performance metric related to high point.'),
('member_participation', 'mo2used', 'Indicates oxygen usage.'),
('member_participation', 'mo2none', 'Indicates no oxygen usage.'),
('member_participation', 'mo2climb', 'Oxygen used during climb.'),
('member_participation', 'mo2descent', 'Oxygen used during descent.'),
('member_participation', 'mo2sleep', 'Oxygen used during sleep.'),
('member_participation', 'mo2medical', 'Oxygen used for medical purposes.'),
('member_participation', 'mo2note', 'Oxygen-related notes.'),
('member_participation', 'death', 'Indicates death occurrence.'),
('member_participation', 'deathdate', 'Date of death.'),
('member_participation', 'deathtime', 'Time of death.'),
('member_participation', 'deathtype', 'Type of death.'),
('member_participation', 'deathhgtm', 'Height at which death occurred.'),
('member_participation', 'deathclass', 'Classification of death.'),
('member_participation', 'msmtbid', 'Summit bid identifier.'),
('member_participation', 'msmtterm', 'Summit termination notes.'),
('member_participation', 'mchksum', 'Checksum field for traceability.'),

-- =========================================================
-- member_routes
-- =========================================================
('member_routes', NULL, 'Child table of member_participation. One row represents one route taken by a participant.'),
('member_routes', 'MemberRouteKey', 'Primary key of member_routes.'),
('member_routes', 'MemberParticipationKey', 'Foreign key to member_participation.'),
('member_routes', 'RouteNumber', 'Sequence number of the route.'),
('member_routes', 'RouteDescription', 'Route description.'),

-- =========================================================
-- member_summits
-- =========================================================
('member_summits', NULL, 'Child table of member_participation. One row represents one summit attempt or record.'),
('member_summits', 'MemberSummitKey', 'Primary key of member_summits.'),
('member_summits', 'MemberParticipationKey', 'Foreign key to member_participation.'),
('member_summits', 'SummitNumber', 'Sequence number of the summit entry.'),
('member_summits', 'SummitDate', 'Date of summit attempt.'),
('member_summits', 'SummitTime', 'Time of summit attempt.'),
('member_summits', 'AscentDescription', 'Description of ascent.');

COMMIT TRANSACTION;
--Database ready for querying. 