-- Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'UseAStrongPassword123!';
GO

-- Database Scoped Credential
IF EXISTS (SELECT * FROM sys.database_scoped_credentials WHERE name = 'AzureStorageCredential')
    DROP DATABASE SCOPED CREDENTIAL [AzureStorageCredential];
GO

CREATE DATABASE SCOPED CREDENTIAL [AzureStorageCredential]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sv=2025-11-05&ss=bfqt&srt=c&sp=rwdlacupiytfx&se=2026-03-26T12:24:59Z&st=2026-03-26T04:09:59Z&spr=https&sig=fS85t7%2FIGWhFBP2KpRzdeJwk9%2F5InriWoMzdmO8E9zI%3D';
GO

-- External Data Source
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'AzureBlobStorage')
    DROP EXTERNAL DATA SOURCE [AzureBlobStorage];
GO

CREATE EXTERNAL DATA SOURCE [AzureBlobStorage]
WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://cap2761cstoragerm.blob.core.windows.net/data-upload',
    CREDENTIAL = [AzureStorageCredential]
);
GO

-- Create tables and load data
PRINT '====================================';
PRINT 'Creating base tables...';
PRINT '====================================';

-- peaks
IF OBJECT_ID('dbo.peaks', 'U') IS NOT NULL
    DROP TABLE dbo.peaks;

CREATE TABLE dbo.peaks (
    peakid NVARCHAR(100), pkname NVARCHAR(255), pkname2 NVARCHAR(255), location NVARCHAR(MAX), heightm NVARCHAR(100), heightf NVARCHAR(100),
    himal NVARCHAR(255), region NVARCHAR(255), [open] NVARCHAR(50), unlisted NVARCHAR(50), trekking NVARCHAR(50), trekyear NVARCHAR(100),
    [restrict] NVARCHAR(255), phost NVARCHAR(255), pstatus NVARCHAR(255), pyear NVARCHAR(100), pseason NVARCHAR(100), pmonth NVARCHAR(100),
    pday NVARCHAR(100), pexpid NVARCHAR(100), pcountry NVARCHAR(255), psummiters NVARCHAR(100), psmtnote NVARCHAR(MAX)
);
PRINT 'peaks table created';

-- exped
IF OBJECT_ID('dbo.exped', 'U') IS NOT NULL
    DROP TABLE dbo.exped;

CREATE TABLE dbo.exped (
    expid NVARCHAR(100), peakid NVARCHAR(100), [year] NVARCHAR(100), season NVARCHAR(100), host NVARCHAR(255), route1 NVARCHAR(MAX), route2 NVARCHAR(MAX),
    route3 NVARCHAR(MAX), route4 NVARCHAR(MAX), nation NVARCHAR(255), leaders NVARCHAR(MAX), sponsor NVARCHAR(MAX), success1 NVARCHAR(100),
    success2 NVARCHAR(100), success3 NVARCHAR(100), success4 NVARCHAR(100), ascent1 NVARCHAR(MAX), ascent2 NVARCHAR(MAX), ascent3 NVARCHAR(MAX),
    ascent4 NVARCHAR(MAX), claimed NVARCHAR(100), disputed NVARCHAR(100), countries NVARCHAR(MAX), approach NVARCHAR(MAX), bcdate NVARCHAR(100),
    smtdate NVARCHAR(100), smttime NVARCHAR(100), smtdays NVARCHAR(100), totdays NVARCHAR(100), termdate NVARCHAR(100), termreason NVARCHAR(MAX),
    termnote NVARCHAR(MAX), highpoint NVARCHAR(100), traverse NVARCHAR(100), ski NVARCHAR(100), parapente NVARCHAR(100), camps NVARCHAR(MAX),
    rope NVARCHAR(100), totmembers NVARCHAR(100), smtmembers NVARCHAR(100), mdeaths NVARCHAR(100), tothired NVARCHAR(100), smthired NVARCHAR(100),
    hdeaths NVARCHAR(100), nohired NVARCHAR(100), o2used NVARCHAR(100), o2none NVARCHAR(100), o2climb NVARCHAR(100), o2descent NVARCHAR(100),
    o2sleep NVARCHAR(100), o2medical NVARCHAR(100), o2taken NVARCHAR(100), o2unkwn NVARCHAR(100), othersmts NVARCHAR(MAX), campsites NVARCHAR(MAX),
    accidents NVARCHAR(MAX), achievment NVARCHAR(MAX), agency NVARCHAR(MAX), comrte NVARCHAR(MAX), stdrte NVARCHAR(MAX), primrte NVARCHAR(MAX),
    primmem NVARCHAR(MAX), primref NVARCHAR(MAX), primid NVARCHAR(255), chksum NVARCHAR(255)
);
PRINT 'exped table created';

-- members
IF OBJECT_ID('dbo.members', 'U') IS NOT NULL
    DROP TABLE dbo.members;

CREATE TABLE dbo.members (
    expid NVARCHAR(100), membid NVARCHAR(100), peakid NVARCHAR(100), myear NVARCHAR(100), mseason NVARCHAR(100), fname NVARCHAR(255),
    lname NVARCHAR(255), sex NVARCHAR(10), yob NVARCHAR(100), citizen NVARCHAR(255), [status] NVARCHAR(255), residence NVARCHAR(255),
    occupation NVARCHAR(255), leader NVARCHAR(10), deputy NVARCHAR(10), bconly NVARCHAR(10), nottobc NVARCHAR(10), support NVARCHAR(10),
    disabled NVARCHAR(10), hired NVARCHAR(10), sherpa NVARCHAR(10), tibetan NVARCHAR(10), msuccess NVARCHAR(100), mclaimed NVARCHAR(100),
    mdisputed NVARCHAR(100), msolo NVARCHAR(10), mtraverse NVARCHAR(10), mski NVARCHAR(10), mparapente NVARCHAR(10), mspeed NVARCHAR(10),
    mhighpt NVARCHAR(100), mperhighpt NVARCHAR(100), msmtdate1 NVARCHAR(100), msmtdate2 NVARCHAR(100), msmtdate3 NVARCHAR(100),
    msmttime1 NVARCHAR(100), msmttime2 NVARCHAR(100), msmttime3 NVARCHAR(100), mroute1 NVARCHAR(MAX), mroute2 NVARCHAR(MAX),
    mroute3 NVARCHAR(MAX), mascent1 NVARCHAR(MAX), mascent2 NVARCHAR(MAX), mascent3 NVARCHAR(MAX), mo2used NVARCHAR(100),
    mo2none NVARCHAR(100), mo2climb NVARCHAR(100), mo2descent NVARCHAR(100), mo2sleep NVARCHAR(100), mo2medical NVARCHAR(100),
    mo2note NVARCHAR(MAX), death NVARCHAR(10), deathdate NVARCHAR(100), deathtime NVARCHAR(100), deathtype NVARCHAR(255),
    deathhgtm NVARCHAR(100), deathclass NVARCHAR(255), msmtbid NVARCHAR(100), msmtterm NVARCHAR(100), hcn NVARCHAR(100), mchksum NVARCHAR(255)
);
PRINT 'members table created';

-- refer
IF OBJECT_ID('dbo.refer', 'U') IS NOT NULL
    DROP TABLE dbo.refer;

CREATE TABLE dbo.refer (
    expid NVARCHAR(100), refid NVARCHAR(100), ryear NVARCHAR(100), rtype NVARCHAR(255), rjrnl NVARCHAR(MAX), rauthor NVARCHAR(MAX),
    rtitle NVARCHAR(MAX), rpublisher NVARCHAR(MAX), rpubdate NVARCHAR(100), rlanguage NVARCHAR(255), rcitation NVARCHAR(MAX), ryak94 NVARCHAR(255)
);
PRINT 'refer table created';

-- himalayan_data_dictionary
IF OBJECT_ID('dbo.himalayan_data_dictionary', 'U') IS NOT NULL
    DROP TABLE dbo.himalayan_data_dictionary;

CREATE TABLE dbo.himalayan_data_dictionary (
    Column1 NVARCHAR(255), Column2 NVARCHAR(255), Column3 NVARCHAR(MAX)
);
PRINT 'himalayan_data_dictionary table created';

PRINT '';
PRINT '====================================';
PRINT 'Loading data from Azure Storage...';
PRINT '====================================';

-- Load peaks
BULK INSERT dbo.peaks FROM 'peaks.csv'
WITH (DATA_SOURCE = 'AzureBlobStorage', FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
SELECT 'peaks' AS table_name, COUNT(*) AS rows FROM dbo.peaks;

-- Load exped
BULK INSERT dbo.exped FROM 'exped.csv'
WITH (DATA_SOURCE = 'AzureBlobStorage', FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
SELECT 'exped' AS table_name, COUNT(*) AS rows FROM dbo.exped;

-- Load members
BULK INSERT dbo.members FROM 'members.csv'
WITH (DATA_SOURCE = 'AzureBlobStorage', FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
SELECT 'members' AS table_name, COUNT(*) AS rows FROM dbo.members;

-- Load refer
BULK INSERT dbo.refer FROM 'refer.csv'
WITH (DATA_SOURCE = 'AzureBlobStorage', FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
SELECT 'refer' AS table_name, COUNT(*) AS rows FROM dbo.refer;

-- Load himalayan_data_dictionary
BULK INSERT dbo.himalayan_data_dictionary FROM 'himalayan_data_dictionary.csv'
WITH (DATA_SOURCE = 'AzureBlobStorage', FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
SELECT 'himalayan_data_dictionary' AS table_name, COUNT(*) AS rows FROM dbo.himalayan_data_dictionary;

PRINT '';
PRINT '====================================';
PRINT 'Import Complete!';
PRINT '====================================';
PRINT 'Next: Run himalayan_expedition_cleaning.sql';
