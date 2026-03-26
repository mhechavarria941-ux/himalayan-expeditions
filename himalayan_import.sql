/* =========================================================
   HIMALAYAN EXPEDITIONS - CSV DATA IMPORT SCRIPT
   Imports raw CSV data into base tables
   ========================================================= */

-- =========================================================
-- 1) CREATE BASE TABLES
-- =========================================================

-- peaks table
IF OBJECT_ID('dbo.peaks', 'U') IS NOT NULL
    DROP TABLE dbo.peaks;
GO

CREATE TABLE dbo.peaks (
    peakid NVARCHAR(100) NOT NULL,
    pkname NVARCHAR(255) NOT NULL,
    pkname2 NVARCHAR(255) NULL,
    location NVARCHAR(MAX) NULL,
    heightm NVARCHAR(100) NULL,
    heightf NVARCHAR(100) NULL,
    himal NVARCHAR(255) NULL,
    region NVARCHAR(255) NULL,
    [open] NVARCHAR(50) NULL,
    unlisted NVARCHAR(50) NULL,
    trekking NVARCHAR(50) NULL,
    trekyear NVARCHAR(100) NULL,
    [restrict] NVARCHAR(255) NULL,
    phost NVARCHAR(255) NULL,
    pstatus NVARCHAR(255) NULL,
    pyear NVARCHAR(100) NULL,
    pseason NVARCHAR(100) NULL,
    pmonth NVARCHAR(100) NULL,
    pday NVARCHAR(100) NULL,
    pexpid NVARCHAR(100) NULL,
    pcountry NVARCHAR(255) NULL,
    psummiters NVARCHAR(100) NULL,
    psmtnote NVARCHAR(MAX) NULL
);
GO

-- exped table
IF OBJECT_ID('dbo.exped', 'U') IS NOT NULL
    DROP TABLE dbo.exped;
GO

CREATE TABLE dbo.exped (
    expid NVARCHAR(100) NOT NULL,
    peakid NVARCHAR(100) NOT NULL,
    [year] NVARCHAR(100) NOT NULL,
    season NVARCHAR(100) NULL,
    host NVARCHAR(255) NULL,
    route1 NVARCHAR(MAX) NULL,
    route2 NVARCHAR(MAX) NULL,
    route3 NVARCHAR(MAX) NULL,
    route4 NVARCHAR(MAX) NULL,
    nation NVARCHAR(255) NULL,
    leaders NVARCHAR(MAX) NULL,
    sponsor NVARCHAR(MAX) NULL,
    success1 NVARCHAR(100) NULL,
    success2 NVARCHAR(100) NULL,
    success3 NVARCHAR(100) NULL,
    success4 NVARCHAR(100) NULL,
    ascent1 NVARCHAR(MAX) NULL,
    ascent2 NVARCHAR(MAX) NULL,
    ascent3 NVARCHAR(MAX) NULL,
    ascent4 NVARCHAR(MAX) NULL,
    claimed NVARCHAR(100) NULL,
    disputed NVARCHAR(100) NULL,
    countries NVARCHAR(MAX) NULL,
    approach NVARCHAR(MAX) NULL,
    bcdate NVARCHAR(100) NULL,
    smtdate NVARCHAR(100) NULL,
    smttime NVARCHAR(100) NULL,
    smtdays NVARCHAR(100) NULL,
    totdays NVARCHAR(100) NULL,
    termdate NVARCHAR(100) NULL,
    termreason NVARCHAR(MAX) NULL,
    termnote NVARCHAR(MAX) NULL,
    highpoint NVARCHAR(100) NULL,
    traverse NVARCHAR(100) NULL,
    ski NVARCHAR(100) NULL,
    parapente NVARCHAR(100) NULL,
    camps NVARCHAR(MAX) NULL,
    rope NVARCHAR(100) NULL,
    totmembers NVARCHAR(100) NULL,
    smtmembers NVARCHAR(100) NULL,
    mdeaths NVARCHAR(100) NULL,
    tothired NVARCHAR(100) NULL,
    smthired NVARCHAR(100) NULL,
    hdeaths NVARCHAR(100) NULL,
    nohired NVARCHAR(100) NULL,
    o2used NVARCHAR(100) NULL,
    o2none NVARCHAR(100) NULL,
    o2climb NVARCHAR(100) NULL,
    o2descent NVARCHAR(100) NULL,
    o2sleep NVARCHAR(100) NULL,
    o2medical NVARCHAR(100) NULL,
    o2taken NVARCHAR(100) NULL,
    o2unkwn NVARCHAR(100) NULL,
    othersmts NVARCHAR(MAX) NULL,
    campsites NVARCHAR(MAX) NULL,
    accidents NVARCHAR(MAX) NULL,
    achievment NVARCHAR(MAX) NULL,
    agency NVARCHAR(MAX) NULL,
    comrte NVARCHAR(MAX) NULL,
    stdrte NVARCHAR(MAX) NULL,
    primrte NVARCHAR(MAX) NULL,
    primmem NVARCHAR(MAX) NULL,
    primref NVARCHAR(MAX) NULL,
    primid NVARCHAR(255) NULL,
    chksum NVARCHAR(255) NULL
);
GO

-- members table
IF OBJECT_ID('dbo.members', 'U') IS NOT NULL
    DROP TABLE dbo.members;
GO

CREATE TABLE dbo.members (
    expid NVARCHAR(100) NOT NULL,
    membid NVARCHAR(100) NOT NULL,
    peakid NVARCHAR(100) NULL,
    myear NVARCHAR(100) NOT NULL,
    mseason NVARCHAR(100) NULL,
    fname NVARCHAR(255) NULL,
    lname NVARCHAR(255) NULL,
    sex NVARCHAR(10) NULL,
    yob NVARCHAR(100) NULL,
    citizen NVARCHAR(255) NULL,
    [status] NVARCHAR(255) NULL,
    residence NVARCHAR(255) NULL,
    occupation NVARCHAR(255) NULL,
    leader NVARCHAR(10) NULL,
    deputy NVARCHAR(10) NULL,
    bconly NVARCHAR(10) NULL,
    nottobc NVARCHAR(10) NULL,
    support NVARCHAR(10) NULL,
    disabled NVARCHAR(10) NULL,
    hired NVARCHAR(10) NULL,
    sherpa NVARCHAR(10) NULL,
    tibetan NVARCHAR(10) NULL,
    msuccess NVARCHAR(100) NULL,
    mclaimed NVARCHAR(100) NULL,
    mdisputed NVARCHAR(100) NULL,
    msolo NVARCHAR(10) NULL,
    mtraverse NVARCHAR(10) NULL,
    mski NVARCHAR(10) NULL,
    mparapente NVARCHAR(10) NULL,
    mspeed NVARCHAR(10) NULL,
    mhighpt NVARCHAR(100) NULL,
    mperhighpt NVARCHAR(100) NULL,
    msmtdate1 NVARCHAR(100) NULL,
    msmtdate2 NVARCHAR(100) NULL,
    msmtdate3 NVARCHAR(100) NULL,
    msmttime1 NVARCHAR(100) NULL,
    msmttime2 NVARCHAR(100) NULL,
    msmttime3 NVARCHAR(100) NULL,
    mroute1 NVARCHAR(MAX) NULL,
    mroute2 NVARCHAR(MAX) NULL,
    mroute3 NVARCHAR(MAX) NULL,
    mascent1 NVARCHAR(MAX) NULL,
    mascent2 NVARCHAR(MAX) NULL,
    mascent3 NVARCHAR(MAX) NULL,
    mo2used NVARCHAR(100) NULL,
    mo2none NVARCHAR(100) NULL,
    mo2climb NVARCHAR(100) NULL,
    mo2descent NVARCHAR(100) NULL,
    mo2sleep NVARCHAR(100) NULL,
    mo2medical NVARCHAR(100) NULL,
    mo2note NVARCHAR(MAX) NULL,
    death NVARCHAR(10) NULL,
    deathdate NVARCHAR(100) NULL,
    deathtime NVARCHAR(100) NULL,
    deathtype NVARCHAR(255) NULL,
    deathhgtm NVARCHAR(100) NULL,
    deathclass NVARCHAR(255) NULL,
    msmtbid NVARCHAR(100) NULL,
    msmtterm NVARCHAR(100) NULL,
    hcn NVARCHAR(100) NULL,
    mchksum NVARCHAR(255) NULL
);
GO

-- refer table
IF OBJECT_ID('dbo.refer', 'U') IS NOT NULL
    DROP TABLE dbo.refer;
GO

CREATE TABLE dbo.refer (
    expid NVARCHAR(100) NOT NULL,
    refid NVARCHAR(100) NOT NULL,
    ryear NVARCHAR(100) NOT NULL,
    rtype NVARCHAR(255) NULL,
    rjrnl NVARCHAR(MAX) NULL,
    rauthor NVARCHAR(MAX) NULL,
    rtitle NVARCHAR(MAX) NULL,
    rpublisher NVARCHAR(MAX) NULL,
    rpubdate NVARCHAR(100) NULL,
    rlanguage NVARCHAR(255) NULL,
    rcitation NVARCHAR(MAX) NULL,
    ryak94 NVARCHAR(255) NULL
);
GO

-- himalayan_data_dictionary table
IF OBJECT_ID('dbo.himalayan_data_dictionary', 'U') IS NOT NULL
    DROP TABLE dbo.himalayan_data_dictionary;
GO

CREATE TABLE dbo.himalayan_data_dictionary (
    Column1 NVARCHAR(255) NULL,
    Column2 NVARCHAR(255) NULL,
    Column3 NVARCHAR(MAX) NULL
);
GO

-- =========================================================
-- 2) BULK INSERT DATA FROM CSV FILES
-- =========================================================

BULK INSERT dbo.peaks
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions\peaks.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 0
);
GO

PRINT 'peaks table loaded';

BULK INSERT dbo.exped
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions\exped.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 0
);
GO

PRINT 'exped table loaded';

BULK INSERT dbo.members
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions\members.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 0
);
GO

PRINT 'members table loaded';

BULK INSERT dbo.refer
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions\refer.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 0
);
GO

PRINT 'refer table loaded';

BULK INSERT dbo.himalayan_data_dictionary
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions\himalayan_data_dictionary.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 0
);
GO

PRINT 'himalayan_data_dictionary table loaded';

-- =========================================================
-- 3) VERIFY IMPORT
-- =========================================================

SELECT 'exped' AS table_name, COUNT(*) AS row_count FROM dbo.exped
UNION ALL
SELECT 'peaks', COUNT(*) FROM dbo.peaks
UNION ALL
SELECT 'members', COUNT(*) FROM dbo.members
UNION ALL
SELECT 'refer', COUNT(*) FROM dbo.refer
UNION ALL
SELECT 'himalayan_data_dictionary', COUNT(*) FROM dbo.himalayan_data_dictionary;
GO

PRINT 'Import complete!';
