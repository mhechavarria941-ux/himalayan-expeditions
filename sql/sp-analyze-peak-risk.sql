-- ═══════════════════════════════════════════════════════════════════════════════
-- STORED PROCEDURE: Peak Mortality Analysis with Risk Classification
-- ═══════════════════════════════════════════════════════════════════════════════
-- PURPOSE: Dynamically analyze peak danger levels and generate risk reports
-- DEMONSTRATES: IF/ELSE logic, parameters, and conditional output generation
-- USAGE: EXEC sp_AnalyzePeakRisk @MinHeight = 7000, @MinExpeditions = 5
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

CREATE OR ALTER PROCEDURE sp_AnalyzePeakRisk
    @MinHeight INT = 7000,           -- Minimum peak height to analyze (meters)
    @MinExpeditions INT = 5,          -- Minimum expeditions for statistical validity
    @RiskThreshold FLOAT = 0.25,      -- Death rate threshold for "high risk" classification
    @DetailLevel NVARCHAR(10) = 'SUMMARY' -- SUMMARY or DETAILED output
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalPeaksAnalyzed INT;
    DECLARE @HighRiskPeaks INT;
    DECLARE @AvgDeathRate FLOAT;
    DECLARE @AnalysisDate NVARCHAR(20) = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss');
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- INFORMATION-GATHERING PHASE: Calculate metrics
    -- ═══════════════════════════════════════════════════════════════════════════
    
    -- Calculate summary statistics
    SELECT 
        @TotalPeaksAnalyzed = COUNT(*),
        @AvgDeathRate = AVG(DeathRate),
        @HighRiskPeaks = SUM(CASE WHEN DeathRate >= @RiskThreshold THEN 1 ELSE 0 END)
    FROM (
        SELECT 
            e.peakid,
            CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathRate
        FROM exped e
            INNER JOIN peaks p ON e.peakid = p.peakid
        WHERE p.heightm >= @MinHeight
        GROUP BY e.peakid
        HAVING COUNT(DISTINCT e.expid) >= @MinExpeditions
    ) PeakStats;
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- DECISION LOGIC: IF/ELSE based on analysis results
    -- ═══════════════════════════════════════════════════════════════════════════
    
    PRINT '';
    PRINT '╔════════════════════════════════════════════════════════════════════════════════╗';
    PRINT '║                    HIMALAYAN PEAK RISK ANALYSIS REPORT                        ║';
    PRINT '╚════════════════════════════════════════════════════════════════════════════════╝';
    PRINT '';
    PRINT 'Analysis Parameters:';
    PRINT '  • Minimum Peak Height: ' + CAST(@MinHeight AS NVARCHAR) + ' meters';
    PRINT '  • Minimum Expeditions: ' + CAST(@MinExpeditions AS NVARCHAR);
    PRINT '  • High-Risk Threshold: ' + CAST(@RiskThreshold AS NVARCHAR) + ' (death rate)';
    PRINT '  • Report Generated: ' + @AnalysisDate;
    PRINT '';
    
    -- IF-ELSE: Decision on what output to provide
    IF @DetailLevel = 'DETAILED'
    BEGIN
        PRINT '┌─ Providing DETAILED ANALYSIS ─────────────────────────────────────────────┐';
        
        -- DETAILED OUTPUT: Full peak-by-peak breakdown
        SELECT 
            p.pkname AS 'Peak Name',
            p.heightm AS 'Height (m)',
            COUNT(DISTINCT e.expid) AS 'Expeditions',
            SUM(e.mdeaths) AS 'Deaths',
            CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) AS 'Death Rate',
            CAST(SUM(CASE WHEN e.success1 > 0 THEN 1 ELSE 0 END) AS FLOAT) 
                / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)',
            CASE 
                WHEN CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) >= @RiskThreshold 
                    THEN '🔴 EXTREMELY DANGEROUS'
                WHEN CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) >= @RiskThreshold * 0.5
                    THEN '🟠 HIGH RISK'
                WHEN CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) >= @RiskThreshold * 0.2
                    THEN '🟡 MODERATE RISK'
                ELSE '🟢 LOWER RISK'
            END AS 'Risk Level'
        FROM exped e
            INNER JOIN peaks p ON e.peakid = p.peakid
        WHERE p.heightm >= @MinHeight
        GROUP BY p.pkname, p.heightm
        HAVING COUNT(DISTINCT e.expid) >= @MinExpeditions
        ORDER BY CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) DESC;
        
        PRINT '';
        PRINT '└───────────────────────────────────────────────────────────────────────────┘';
    END
    
    ELSE IF @DetailLevel = 'SUMMARY'
    BEGIN
        PRINT '┌─ Providing SUMMARY ANALYSIS ──────────────────────────────────────────────┐';
        
        -- CONDITIONAL SUMMARY: Narrative dependent on findings
        IF @HighRiskPeaks > 0
        BEGIN
            PRINT '';
            PRINT '⚠️  WARNING: Analysis Findings';
            PRINT '  • Extremely dangerous peaks identified: ' + CAST(@HighRiskPeaks AS NVARCHAR);
            PRINT '  • Average death rate across all analyzed peaks: ' 
                + FORMAT(@AvgDeathRate, '0.0000') + ' per expedition';
            PRINT '  • Total peaks analyzed: ' + CAST(@TotalPeaksAnalyzed AS NVARCHAR);
        END
        ELSE
        BEGIN
            PRINT '';
            PRINT '✓ POSITIVE FINDING: Analysis shows manageable risk levels';
            PRINT '  • No peaks exceed high-risk threshold (' + CAST(@RiskThreshold AS NVARCHAR) + ')';
            PRINT '  • Average death rate: ' + FORMAT(@AvgDeathRate, '0.0000') + ' per expedition';
            PRINT '  • Peaks evaluated: ' + CAST(@TotalPeaksAnalyzed AS NVARCHAR);
        END;
        
        -- Summary statistics table
        SELECT 
            'High-Risk Peaks (> ' + CAST(@RiskThreshold AS NVARCHAR) + ')' AS 'Metric',
            CAST(@HighRiskPeaks AS NVARCHAR) AS 'Count'
        UNION ALL 
        SELECT 'Total Analyzed Peaks', CAST(@TotalPeaksAnalyzed AS NVARCHAR)
        UNION ALL
        SELECT 'Average Death Rate', FORMAT(@AvgDeathRate, '0.00000')
        UNION ALL
        SELECT 'Lowest-Risk Height Category', 
            CASE 
                WHEN @MinHeight <= 6000 THEN '< 6,000m'
                WHEN @MinHeight <= 7000 THEN '6,000-7,000m'
                WHEN @MinHeight <= 8000 THEN '7,000-8,000m'
                ELSE '> 8,000m'
            END;
        
        PRINT '';
        PRINT '└───────────────────────────────────────────────────────────────────────────┘';
    END
    
    ELSE
    BEGIN
        PRINT '';
        PRINT '❌ ERROR: Invalid DetailLevel parameter. Use ''SUMMARY'' or ''DETAILED''';
    END;
    
    PRINT '';
    PRINT 'Analysis complete.';
    PRINT '';
END;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TEST EXECUTION EXAMPLES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example 1: Summary analysis of peaks > 7000m
-- EXEC sp_AnalyzePeakRisk @MinHeight = 7000, @MinExpeditions = 5, @DetailLevel = 'SUMMARY';

-- Example 2: Detailed analysis of death zone peaks (8000m+)
-- EXEC sp_AnalyzePeakRisk @MinHeight = 8000, @MinExpeditions = 10, @RiskThreshold = 0.3, @DetailLevel = 'DETAILED';

-- Example 3: High-threshold analysis (only most dangerous classification)
-- EXEC sp_AnalyzePeakRisk @MinHeight = 8000, @MinExpeditions = 15, @RiskThreshold = 0.5, @DetailLevel = 'DETAILED';
