-- =========================================================
-- BULK LOAD: Himalayan Expeditions Data from CSV Files
-- Loads all data from peaks, exped, members, refer CSVs
-- =========================================================

-- First, clear existing data to avoid duplicates
TRUNCATE TABLE dbo.himalayan_data_dictionary;
TRUNCATE TABLE dbo.refer;
TRUNCATE TABLE dbo.members;
TRUNCATE TABLE dbo.exped;
TRUNCATE TABLE dbo.peaks;

-- =========================================================
-- Load PEAKS data (480 rows)
-- =========================================================
PRINT 'Loading peaks.csv...';
GO

BULK INSERT dbo.peaks
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\Documents\GitHub\himalayan-expeditions\data\himalayan_sources\peaks.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 10
);

PRINT 'peaks.csv loaded.';
DECLARE @peaks_count INT = (SELECT COUNT(*) FROM dbo.peaks);
PRINT 'Peaks rows: ' + CAST(@peaks_count AS VARCHAR(10));
GO

-- =========================================================
-- Load EXPED data (11,478 rows)
-- =========================================================
PRINT 'Loading exped.csv...';
GO

BULK INSERT dbo.exped
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\Documents\GitHub\himalayan-expeditions\data\himalayan_sources\exped.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 10
);

PRINT 'exped.csv loaded.';
DECLARE @exped_count INT = (SELECT COUNT(*) FROM dbo.exped);
PRINT 'Expedition rows: ' + CAST(@exped_count AS VARCHAR(10));
GO

-- =========================================================
-- Load MEMBERS data (89,050 rows)
-- =========================================================
PRINT 'Loading members.csv...';
GO

BULK INSERT dbo.members
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\Documents\GitHub\himalayan-expeditions\data\himalayan_sources\members.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 10
);

PRINT 'members.csv loaded.';
DECLARE @members_count INT = (SELECT COUNT(*) FROM dbo.members);
PRINT 'Members rows: ' + CAST(@members_count AS VARCHAR(10));
GO

-- =========================================================
-- Load REFER data (15,586 rows)
-- =========================================================
PRINT 'Loading refer.csv...';
GO

BULK INSERT dbo.refer
FROM 'C:\Users\Ricar\OneDrive - Miami Dade College\Documents\GitHub\himalayan-expeditions\data\himalayan_sources\refer.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    MAXERRORS = 10
);

PRINT 'refer.csv loaded.';
DECLARE @refer_count INT = (SELECT COUNT(*) FROM dbo.refer);
PRINT 'Reference rows: ' + CAST(@refer_count AS VARCHAR(10));
GO

-- =========================================================
-- VERIFY: Print final row counts
-- =========================================================
PRINT '';
PRINT '===================================';
PRINT 'BULK LOAD COMPLETE - FINAL COUNTS';
PRINT '===================================';

SELECT 
    'peaks' AS TableName, 
    COUNT(*) AS RowCount 
FROM dbo.peaks

UNION ALL

SELECT 
    'exped', 
    COUNT(*) 
FROM dbo.exped

UNION ALL

SELECT 
    'members', 
    COUNT(*) 
FROM dbo.members

UNION ALL

SELECT 
    'refer', 
    COUNT(*) 
FROM dbo.refer;

GO
