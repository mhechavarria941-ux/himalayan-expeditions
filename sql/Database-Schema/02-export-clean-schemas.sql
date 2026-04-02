-- ========================================================================
-- COMPLETE SCHEMA EXPORT - CleanFormat for ChartDB
-- Himalayan Expeditions Database - Final_Project
-- Run this query and copy the results to use in ChartDB
-- ========================================================================

-- Display all tables first
PRINT '=== ALL TABLES IN DATABASE ===';
SELECT 
    ROW_NUMBER() OVER (ORDER BY TABLE_NAME) AS [#],
    TABLE_NAME,
    'TABLE' AS [Type]
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '=== TOTAL TABLE COUNT ===';
SELECT COUNT(*) AS TotalTables FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE';

PRINT '';
PRINT '=== TABLE DETAILS WITH COLUMN COUNTS ===';
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS c WHERE c.TABLE_NAME = t.TABLE_NAME) AS Columns,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS c WHERE c.TABLE_NAME = t.TABLE_NAME AND IS_NULLABLE = 'NO') AS NonNullableColumns
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '=== COPY SCHEMA DETAILS BELOW ===';
PRINT '';

-- Generate formatted CREATE TABLE for each table
DECLARE @TableName NVARCHAR(255);
DECLARE @ColumnName NVARCHAR(255);
DECLARE @DataType NVARCHAR(255);
DECLARE @IsNullable NVARCHAR(10);
DECLARE @CharMax INT;
DECLARE @NumPrecision INT;
DECLARE @NumScale INT;

DECLARE TableList CURSOR FOR
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

OPEN TableList;
FETCH NEXT FROM TableList INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '-- ' + REPLICATE('=', 70);
    PRINT '-- TABLE: ' + @TableName;
    PRINT '-- ' + REPLICATE('=', 70);
    PRINT 'CREATE TABLE dbo.' + @TableName + ' (';
    
    DECLARE ColumnList CURSOR FOR
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH,
        NUMERIC_PRECISION,
        NUMERIC_SCALE,
        ROW_NUMBER() OVER (PARTITION BY TABLE_NAME ORDER BY ORDINAL_POSITION) as RowNum,
        COUNT(*) OVER (PARTITION BY TABLE_NAME) as TotalCols
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @TableName
    ORDER BY ORDINAL_POSITION;
    
    OPEN ColumnList;
    FETCH NEXT FROM ColumnList INTO @ColumnName, @DataType, @IsNullable, @CharMax, @NumPrecision, @NumScale;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '    ' + @ColumnName + ' ' + @DataType + 
              CASE 
                  WHEN @DataType IN ('VARCHAR', 'CHAR', 'NVARCHAR', 'NCHAR') AND @CharMax IS NOT NULL
                  THEN '(' + CAST(@CharMax AS VARCHAR(10)) + ')'
                  WHEN @DataType IN ('DECIMAL', 'NUMERIC') AND @NumPrecision IS NOT NULL
                  THEN '(' + CAST(@NumPrecision AS VARCHAR(10)) + ',' + CAST(@NumScale AS VARCHAR(10)) + ')'
                  ELSE ''
              END +
              CASE WHEN @IsNullable = 'NO' THEN ' NOT NULL' ELSE '' END + ',';
        
        FETCH NEXT FROM ColumnList INTO @ColumnName, @DataType, @IsNullable, @CharMax, @NumPrecision, @NumScale;
    END;
    
    CLOSE ColumnList;
    DEALLOCATE ColumnList;
    
    PRINT ');';
    PRINT 'GO';
    PRINT '';
    
    FETCH NEXT FROM TableList INTO @TableName;
END;

CLOSE TableList;
DEALLOCATE TableList;

PRINT '-- ========================================================================';
PRINT '-- EXPORT COMPLETE';
PRINT '-- Copy all CREATE TABLE statements above to use with ChartDB';
PRINT '-- ========================================================================';
