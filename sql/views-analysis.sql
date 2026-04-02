-- ═══════════════════════════════════════════════════════════════════════════════
-- VIEW: Unified Member-Expedition Analysis
-- ═══════════════════════════════════════════════════════════════════════════════
-- PURPOSE: Reusable normalized view combining member and expedition data
-- USAGE: SELECT * FROM vw_MemberExpeditionAnalysis WHERE MortalityRate > 0.05
-- DEMONSTRATES: Complex JOIN logic, calculated columns, and data normalization
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

CREATE OR ALTER VIEW vw_MemberExpeditionAnalysis
AS
    -- This view integrates member-level data with expedition context for analysis
    SELECT 
        -- MEMBER IDENTIFIERS
        m.memberid AS MemberId,
        m.experid AS ExperienceId,
        m.expid AS ExpeditionId,
        CONCAT(m.fname, ' ', m.lname) AS 'Climber Name',
        
        -- MEMBER DEMOGRAPHICS
        m.citizen AS Citizenship,
        YEAR(GETDATE()) - m.yob AS Age,
        m.sex AS Gender,
        
        -- MEMBER CLASSIFICATION
        CASE 
            WHEN m.sherpa = 'T' THEN 'Sherpa'
            WHEN m.tibetan = 'T' THEN 'Tibetan'
            WHEN m.hired = 'T' THEN 'Hired Guide'
            ELSE 'Paying Climber'
        END AS ParticipantType,
        
        -- MEMBER OUTCOMES
        m.msuccess AS MemberSummitAchieved,
        m.death AS Died,
        m.deathtype AS CauseOfDeath,
        CAST(CASE WHEN m.death = 'T' THEN 1 ELSE 0 END AS FLOAT) * 100 AS MortalityFlag,
        
        -- OXYGEN USAGE
        m.mo2used AS MemberUsedOxygen,
        
        -- EXPEDITION CONTEXT
        e.year AS ExpeditionYear,
        e.season AS Season,
        e.totmembers AS TotalExpeditionMembers,
        e.smtmembers AS ExpeditionSummits,
        e.mdeaths AS ExpeditionDeaths,
        e.tothired AS TotalHiredStaff,
        
        -- EXPEDITION OUTCOMES
        e.success1 AS FirstRoute_Summits,
        e.success2 AS SecondRoute_Summits,
        e.o2used AS ExpeditionUsedOxygen,
        e.traverse AS ExpeditionTraverse,
        e.ski AS ExpeditionSki,
        
        -- PEAK INFORMATION
        p.peakid AS PeakId,
        p.pkname AS PeakName,
        p.heightm AS PeakHeight,
        p.pstatus AS PeakStatus,
        
        -- CALCULATED METRICS
        CAST(CASE WHEN e.success1 > 0 THEN 1 ELSE 0 END AS FLOAT) / 
            NULLIF(e.totmembers, 0) * 100 AS ExpeditionSuccessRate_Percent,
        
        CAST(e.mdeaths AS FLOAT) / NULLIF(e.totmembers, 0) * 100 AS ExpeditionMortalityRate_Percent,
        
        CAST(e.tothired AS FLOAT) / NULLIF(e.totmembers, 0) * 100 AS HiredStaffRatio_Percent,
        
        -- RISK ASSESSMENT
        CASE 
            WHEN CAST(e.mdeaths AS FLOAT) / NULLIF(COUNT(*) OVER (PARTITION BY e.expid), 0) >= 0.2 
                THEN 'High Risk'
            WHEN CAST(e.mdeaths AS FLOAT) / NULLIF(COUNT(*) OVER (PARTITION BY e.expid), 0) >= 0.05
                THEN 'Moderate Risk'
            ELSE 'Lower Risk'
        END AS ExpeditionRiskLevel,
        
        -- TEMPORAL CONTEXT (for time-series analysis)
        CAST(e.year AS NVARCHAR(4)) + ' ' + e.season AS ExpeditionPhase,
        
        CASE 
            WHEN e.year < 1970 THEN 'Pre-1970 (Early Era)'
            WHEN e.year BETWEEN 1970 AND 1989 THEN '1970-1989 (Growth Era)'
            WHEN e.year BETWEEN 1990 AND 2009 THEN '1990-2009 (Expansion Era)'
            WHEN e.year >= 2010 THEN '2010+ (Modern Era)'
        END AS EraClassification

    FROM members m
        INNER JOIN exped e ON m.expid = e.expid
        INNER JOIN peaks p ON e.peakid = p.peakid

GO

-- ═══════════════════════════════════════════════════════════════════════════════
-- VIEW: Peak Statistics Summary (Materialized View for Performance)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR ALTER VIEW vw_PeakStatisticsSummary
AS
    SELECT 
        p.peakid AS PeakId,
        p.pkname AS PeakName,
        p.heightm AS PeakHeight_m,
        p.pstatus AS PeakStatus,
        
        COUNT(DISTINCT e.expid) AS TotalExpeditions,
        SUM(e.totmembers) AS TotalParticipants,
        SUM(e.smtmembers) AS TotalSuccessfulSummits,
        SUM(e.mdeaths) AS TotalDeaths,
        
        -- Calculate rates
        CAST(SUM(e.smtmembers) AS FLOAT) / NULLIF(SUM(e.totmembers), 0) * 100 AS SummitSuccessRate_Percent,
        CAST(SUM(e.mdeaths) AS FLOAT) / NULLIF(SUM(e.totmembers), 0) * 100 AS MortalityRate_Percent,
        CAST(SUM(e.mdeaths) AS FLOAT) / NULLIF(COUNT(DISTINCT e.expid), 0) AS DeathsPerExpedition,
        
        -- Commercialization metric
        CAST(SUM(e.tothired) AS FLOAT) / NULLIF(SUM(e.totmembers), 0) * 100 AS HiredStaffPercentage,
        
        -- Historical span
        MIN(e.year) AS FirstExpeditionYear,
        MAX(e.year) AS MostRecentExpeditionYear,
        COUNT(DISTINCT e.year) AS YearsActive,
        
        -- Member composition
        SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) AS SherpaCount,
        SUM(CASE WHEN m.hired = 'T' THEN 1 ELSE 0 END) AS HiredGuideCount,
        COUNT(DISTINCT m.citizen) AS UniqNationalitiesAttempted,
        
        -- Risk classification
        CASE 
            WHEN CAST(SUM(e.mdeaths) AS FLOAT) / NULLIF(COUNT(DISTINCT e.expid), 0) >= 0.3 
                THEN 'EXTREMELY DANGEROUS'
            WHEN CAST(SUM(e.mdeaths) AS FLOAT) / NULLIF(COUNT(DISTINCT e.expid), 0) >= 0.15
                THEN 'VERY DANGEROUS'
            WHEN CAST(SUM(e.mdeaths) AS FLOAT) / NULLIF(COUNT(DISTINCT e.expid), 0) >= 0.05
                THEN 'DANGEROUS'
            ELSE 'MODERATE'
        END AS DangerClassification

    FROM peaks p
        LEFT JOIN exped e ON p.peakid = e.peakid
        LEFT JOIN members m ON e.expid = m.expid
    GROUP BY p.peakid, p.pkname, p.heightm, p.pstatus

GO

-- ═══════════════════════════════════════════════════════════════════════════════
-- USAGE EXAMPLES FOR VIEWS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example 1: Find all Sherpa participants and their outcomes
-- SELECT * FROM vw_MemberExpeditionAnalysis 
-- WHERE ParticipantType = 'Sherpa' AND ExpeditionYear >= 2010
-- ORDER BY MortalityFlag DESC;

-- Example 2: Compare mortality across participant types
-- SELECT ParticipantType, COUNT(*) AS Total, SUM(MortalityFlag) AS Deaths
-- FROM vw_MemberExpeditionAnalysis 
-- GROUP BY ParticipantType;

-- Example 3: Find the most dangerous peaks
-- SELECT TOP 10 PeakName, DangerClassification, MortalityRate_Percent
-- FROM vw_PeakStatisticsSummary 
-- WHERE TotalExpeditions >= 10
-- ORDER BY MortalityRate_Percent DESC;

-- Example 4: Analyze commercialization trends
-- SELECT EraClassification, AVG(HiredStaffPercentage) AS AvgCommercializationLevel
-- FROM vw_MemberExpeditionAnalysis 
-- GROUP BY EraClassification
-- ORDER BY EraClassification;
