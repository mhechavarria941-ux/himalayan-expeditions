-- ========================================================================
-- COMPLETE DATABASE SCHEMA EXPORT
-- Himalayan Expeditions - Final_Project Database
-- Exports ALL tables with complete CREATE TABLE statements
-- ========================================================================

-- Get list of all tables and their schemas
SELECT 
    'Database: ' + DB_NAME() AS DatabaseInfo,
    COUNT(*) AS TotalTableCount
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE';

PRINT '';
PRINT '========================================================================';
PRINT 'ALL TABLES IN DATABASE:';
PRINT '========================================================================';
PRINT '';

-- List all tables with row counts
SELECT 
    TABLE_NAME,
    'Columns: ' + CAST(
        (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS c WHERE c.TABLE_NAME = t.TABLE_NAME) 
        AS VARCHAR(10)) AS ColumnCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '========================================================================';
PRINT 'GENERATING CREATE TABLE SCRIPTS FOR ALL TABLES';
PRINT '========================================================================';
PRINT '';

-- Generate CREATE TABLE for each table
DECLARE @TableName NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);
DECLARE TableCursor CURSOR FOR 
    SELECT TABLE_NAME 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
    ORDER BY TABLE_NAME;

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '-- ============================================================';
    PRINT '-- TABLE: ' + @TableName;
    PRINT '-- ============================================================';
    
    -- Get column definitions
    SELECT 
        CASE WHEN ORDINAL_POSITION = 1 THEN 'CREATE TABLE dbo.' + @TableName + ' ('
             ELSE ',' END +
        CHAR(10) + '    ' + 
        COLUMN_NAME + ' ' + 
        DATA_TYPE +
        CASE 
            WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
            THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
            WHEN NUMERIC_PRECISION IS NOT NULL 
            THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(NUMERIC_SCALE AS VARCHAR(10)) + ')'
            ELSE '' 
        END +
        CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @TableName
    ORDER BY ORDINAL_POSITION;
    
    PRINT ');';
    PRINT 'GO';
    PRINT '';
    
    FETCH NEXT FROM TableCursor INTO @TableName;
END;

CLOSE TableCursor;
DEALLOCATE TableCursor;

PRINT '========================================================================';
PRINT 'EXPORT COMPLETE';
PRINT '========================================================================';
