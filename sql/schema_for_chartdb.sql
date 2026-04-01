-- ================================
-- HIMALAYAN EXPEDITIONS DATABASE
-- Updated Schema - Matches CSV Structure
-- All Columns from Source Data (CSV dump)
-- Updated: March 30, 2026
-- ================================

-- Drop foreign key constraints first
BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) = '';
    SELECT @sql += 'ALTER TABLE ' + QUOTENAME(t.name) + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + '; '
    FROM sys.foreign_keys AS fk
    INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
    WHERE fk.referenced_object_id IN (
        SELECT object_id FROM sys.tables WHERE name IN ('peaks', 'exped', 'members', 'refer')
    );
    
    IF @sql <> ''
    BEGIN
        EXEC sp_executesql @sql;
    END;
END TRY
BEGIN CATCH
    PRINT 'No foreign keys to drop.';
END CATCH;

-- Drop existing tables if they exist to ensure clean schema
-- Drop in dependency order (dependent tables first)
DROP TABLE IF EXISTS dbo.himalayan_data_dictionary;
DROP TABLE IF EXISTS dbo.audit_deleted_references;
DROP TABLE IF EXISTS dbo.refer;
DROP TABLE IF EXISTS dbo.members;
DROP TABLE IF EXISTS dbo.exped;
DROP TABLE IF EXISTS dbo.peaks;
GO

-- =========================================================
-- PEAKS TABLE (23 columns from peaks.csv)
-- =========================================================
CREATE TABLE dbo.peaks (
    peakid NVARCHAR(255) PRIMARY KEY NOT NULL,
    pkname NVARCHAR(255) NULL,
    pkname2 NVARCHAR(255) NULL,
    location NVARCHAR(255) NULL,
    heightm NVARCHAR(255) NULL,
    heightf NVARCHAR(255) NULL,
    himal NVARCHAR(255) NULL,
    region NVARCHAR(255) NULL,
    [open] NVARCHAR(255) NULL,
    unlisted NVARCHAR(255) NULL,
    trekking NVARCHAR(255) NULL,
    trekyear NVARCHAR(255) NULL,
    [restrict] NVARCHAR(255) NULL,
    phost NVARCHAR(255) NULL,
    pstatus NVARCHAR(255) NULL,
    pyear NVARCHAR(255) NULL,
    pseason NVARCHAR(255) NULL,
    pmonth NVARCHAR(255) NULL,
    pday NVARCHAR(255) NULL,
    pexpid NVARCHAR(255) NULL,
    pcountry NVARCHAR(255) NULL,
    psummiters NVARCHAR(255) NULL,
    psmtnote NVARCHAR(255) NULL
);
GO

-- =========================================================
-- EXPED TABLE (65 columns from exped.csv)
-- =========================================================
CREATE TABLE dbo.exped (
    ExpeditionKey INT PRIMARY KEY IDENTITY(1,1),
    expid NVARCHAR(255) NULL,
    peakid NVARCHAR(255) NULL,
    [year] NVARCHAR(255) NULL,
    season NVARCHAR(255) NULL,
    host NVARCHAR(255) NULL,
    route1 NVARCHAR(MAX) NULL,
    route2 NVARCHAR(MAX) NULL,
    route3 NVARCHAR(MAX) NULL,
    route4 NVARCHAR(MAX) NULL,
    nation NVARCHAR(255) NULL,
    leaders NVARCHAR(255) NULL,
    sponsor NVARCHAR(255) NULL,
    success1 NVARCHAR(255) NULL,
    success2 NVARCHAR(255) NULL,
    success3 NVARCHAR(255) NULL,
    success4 NVARCHAR(255) NULL,
    ascent1 NVARCHAR(MAX) NULL,
    ascent2 NVARCHAR(MAX) NULL,
    ascent3 NVARCHAR(MAX) NULL,
    ascent4 NVARCHAR(MAX) NULL,
    claimed NVARCHAR(255) NULL,
    disputed NVARCHAR(255) NULL,
    countries NVARCHAR(255) NULL,
    approach NVARCHAR(MAX) NULL,
    bcdate NVARCHAR(255) NULL,
    smtdate NVARCHAR(255) NULL,
    smttime NVARCHAR(255) NULL,
    smtdays NVARCHAR(255) NULL,
    totdays NVARCHAR(255) NULL,
    termdate NVARCHAR(255) NULL,
    termreason NVARCHAR(MAX) NULL,
    termnote NVARCHAR(MAX) NULL,
    highpoint NVARCHAR(255) NULL,
    traverse NVARCHAR(255) NULL,
    ski NVARCHAR(255) NULL,
    parapente NVARCHAR(255) NULL,
    camps NVARCHAR(255) NULL,
    rope NVARCHAR(255) NULL,
    totmembers NVARCHAR(255) NULL,
    smtmembers NVARCHAR(255) NULL,
    mdeaths NVARCHAR(255) NULL,
    tothired NVARCHAR(255) NULL,
    smthired NVARCHAR(255) NULL,
    hdeaths NVARCHAR(255) NULL,
    nohired NVARCHAR(255) NULL,
    o2used NVARCHAR(255) NULL,
    o2none NVARCHAR(255) NULL,
    o2climb NVARCHAR(255) NULL,
    o2descent NVARCHAR(255) NULL,
    o2sleep NVARCHAR(255) NULL,
    o2medical NVARCHAR(255) NULL,
    o2taken NVARCHAR(255) NULL,
    o2unkwn NVARCHAR(255) NULL,
    othersmts NVARCHAR(255) NULL,
    campsites NVARCHAR(255) NULL,
    accidents NVARCHAR(MAX) NULL,
    achievment NVARCHAR(255) NULL,
    agency NVARCHAR(255) NULL,
    comrte NVARCHAR(255) NULL,
    stdrte NVARCHAR(255) NULL,
    primrte NVARCHAR(255) NULL,
    primmem NVARCHAR(255) NULL,
    primref NVARCHAR(255) NULL,
    primid NVARCHAR(255) NULL,
    chksum NVARCHAR(255) NULL,
    UNIQUE(expid)
);
GO

-- =========================================================
-- MEMBERS TABLE (61 columns from members.csv)
-- =========================================================
CREATE TABLE dbo.members (
    MemberKey INT PRIMARY KEY IDENTITY(1,1),
    membid NVARCHAR(255) NULL,
    expid NVARCHAR(255) NULL,
    peakid NVARCHAR(255) NULL,
    myear NVARCHAR(50) NULL,
    mseason NVARCHAR(100) NULL,
    fname NVARCHAR(255) NULL,
    lname NVARCHAR(255) NULL,
    sex NVARCHAR(50) NULL,
    yob NVARCHAR(50) NULL,
    citizen NVARCHAR(255) NULL,
    [status] NVARCHAR(255) NULL,
    residence NVARCHAR(255) NULL,
    occupation NVARCHAR(255) NULL,
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
    msmtdate1 NVARCHAR(255) NULL,
    msmtdate2 NVARCHAR(255) NULL,
    msmtdate3 NVARCHAR(255) NULL,
    msmttime1 NVARCHAR(255) NULL,
    msmttime2 NVARCHAR(255) NULL,
    msmttime3 NVARCHAR(255) NULL,
    mroute1 NVARCHAR(MAX) NULL,
    mroute2 NVARCHAR(MAX) NULL,
    mroute3 NVARCHAR(MAX) NULL,
    mascent1 NVARCHAR(MAX) NULL,
    mascent2 NVARCHAR(MAX) NULL,
    mascent3 NVARCHAR(MAX) NULL,
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
    hcn NVARCHAR(255) NULL,
    mchksum NVARCHAR(255) NULL,
    UNIQUE(membid, expid, myear)
);
GO

-- =========================================================
-- REFER TABLE (12 columns from refer.csv)
-- =========================================================
CREATE TABLE dbo.refer (
    ReferenceKey INT PRIMARY KEY IDENTITY(1,1),
    expid NVARCHAR(255) NULL,
    refid NVARCHAR(255) NULL,
    ryear NVARCHAR(50) NULL,
    rtype NVARCHAR(255) NULL,
    rjrnl NVARCHAR(255) NULL,
    rauthor NVARCHAR(255) NULL,
    rtitle NVARCHAR(MAX) NULL,
    rpublisher NVARCHAR(255) NULL,
    rpubdate NVARCHAR(255) NULL,
    rlanguage NVARCHAR(255) NULL,
    rcitation NVARCHAR(MAX) NULL,
    ryak94 NVARCHAR(255) NULL,
    UNIQUE(refid, expid, ryear)
);
GO

-- =========================================================
-- DATA DICTIONARY TABLE
-- =========================================================
CREATE TABLE dbo.himalayan_data_dictionary (
    DictionaryKey INT PRIMARY KEY IDENTITY(1,1),
    TableName NVARCHAR(255) NOT NULL,
    ColumnName NVARCHAR(255) NOT NULL,
    DataType NVARCHAR(100) NULL,
    SourceCSV NVARCHAR(255) NULL,
    UNIQUE(TableName, ColumnName)
);
GO

PRINT 'Schema creation completed successfully.';
PRINT '4 core tables created: peaks, exped, members, refer';
PRINT 'Schema matches CSV structure with all columns populated.';


-- =========================================================
-- AUDIT TABLES
-- =========================================================

CREATE TABLE audit_deleted_references (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    ReferenceKey INT NULL,
    refid NVARCHAR(255) NULL,
    expid NVARCHAR(255) NULL,
    ryear NVARCHAR(50) NULL,
    rtype NVARCHAR(255) NULL,
    rtitle NVARCHAR(MAX) NULL,
    DeletedDate DATETIME DEFAULT GETDATE(),
    DeleteReason NVARCHAR(MAX) NULL
);

-- =========================================================
-- SUMMARY: 21 TABLES TOTAL
-- =========================================================
-- CORE: exped, peaks, members, refer (4)
-- LOOKUP: season_lookup, citizenship_lookup (2)
-- EXPEDITION: expedition_timeline, expedition_routes, expedition_outcomes,
--            expedition_statistics, expedition_style, expedition_oxygen,
--            expedition_camps, expedition_incidents, expedition_reference_summary,
--            expedition_admin (10)
-- MEMBER: member_person, member_participation, member_routes, member_summits (4)
-- AUDIT: audit_deleted_references (1)
