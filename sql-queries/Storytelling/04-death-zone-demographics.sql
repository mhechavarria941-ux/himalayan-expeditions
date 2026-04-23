-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 1 - DEATH ZONE DEMOGRAPHICS
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "The Human Cost" - Understanding mortality patterns in Himalayan climbing
-- PURPOSE: Analyze which peaks are most deadly, what kills climbers, and vulnerability patterns
-- ═══════════════════════════════════════════════════════════════════════════════


-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 1: WHICH PEAKS KILL THE MOST?
-- ─────────────────────────────────────────────────────────────────────────────

USE HimalayanExpeditions;
GO

SELECT TOP 15
    p.pkname AS PeakName,
    p.heightm AS HeightM,
    COUNT(DISTINCT e.expid) AS TotalExpeditions,
    SUM(CAST(e.mdeaths AS INT)) AS TotalDeaths,
    CAST(SUM(CAST(e.mdeaths AS INT)) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathsPerExpedition,
    CAST(
        COUNT(DISTINCT CASE WHEN CAST(e.success1 AS BIT) = 1 THEN e.expid END) AS FLOAT
    ) / COUNT(DISTINCT e.expid) * 100 AS SuccessRatePct
FROM exped e
INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname, p.heightm
HAVING SUM(CAST(e.mdeaths AS INT)) >= 5
ORDER BY SUM(CAST(e.mdeaths AS INT)) DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 2: WHAT KILLS CLIMBERS? - CAUSE OF DEATH BY PEAK AND SEASON
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    dc.pkname AS PeakName,
    dc.season AS Season,
    dc.deathtype AS CauseOfDeath,
    dc.CountPerCause AS DeathCount,
    CAST(dc.CountPerCause AS FLOAT) / NULLIF(pt.TotalPerPartition, 0) * 100 AS PercentagePct
FROM (
    SELECT
        p.pkname,
        e.season,
        m.deathtype,
        COUNT(*) AS CountPerCause
    FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
    WHERE m.death = 'TRUE'
      AND p.heightm > 8000
    GROUP BY p.pkname, e.season, m.deathtype
) dc
CROSS APPLY (
    SELECT COUNT(*) AS TotalPerPartition
    FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
    WHERE m.death = 'TRUE'
      AND p.heightm > 8000
      AND p.pkname = dc.pkname
      AND e.season = dc.season
) pt
ORDER BY dc.pkname, dc.season, dc.CountPerCause DESC;
-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 3: AGE AND MORTALITY - ARE YOUNGER CLIMBERS MORE VULNERABLE?
-- ─────────────────────────────────────────────────────────────────────────────

WITH AgeGroups AS (
    SELECT
        CASE 
            WHEN (e.year - CAST(m.yob AS INT)) < 25 THEN '< 25 years'
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 25 AND 34 THEN '25-34 years'
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 35 AND 44 THEN '35-44 years'
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 45 AND 54 THEN '45-54 years'
            WHEN (e.year - CAST(m.yob AS INT)) >= 55 THEN '55+ years'
            ELSE 'Unknown'
        END AS AgeBracket,
        CASE 
            WHEN (e.year - CAST(m.yob AS INT)) < 25 THEN 1
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 25 AND 34 THEN 2
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 35 AND 44 THEN 3
            WHEN (e.year - CAST(m.yob AS INT)) BETWEEN 45 AND 54 THEN 4
            WHEN (e.year - CAST(m.yob AS INT)) >= 55 THEN 5
            ELSE 6
        END AS SortOrder,
        m.death,
        m.msuccess
    FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    WHERE m.yob IS NOT NULL
)
SELECT
    AgeBracket,
    COUNT(*) AS TotalClimbers,
    SUM(CASE WHEN death = 'TRUE' THEN 1 ELSE 0 END) AS Deaths,
    CAST(SUM(CASE WHEN death = 'TRUE' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS MortalityRatePct,
    SUM(CASE WHEN msuccess = 'TRUE' THEN 1 ELSE 0 END) AS Summits,
    CAST(SUM(CASE WHEN msuccess = 'TRUE' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS SummitSuccessRatePct
FROM AgeGroups
GROUP BY AgeBracket, SortOrder
ORDER BY SortOrder;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 4: PEAK LETHALITY INDEX - COMBINING DEATH RATE WITH DIFFICULTY
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    p.pkname AS PeakName,
    p.heightm AS HeightM,
    DeathStats.TotalExpeditions AS Expeditions,
    DeathStats.TotalDeaths AS TotalDeaths,
    DeathStats.DeathRate AS DeathRatePerExpedition,
    CASE 
        WHEN DeathStats.DeathRate >= 0.5 THEN 'EXTREMELY DANGEROUS'
        WHEN DeathStats.DeathRate >= 0.25 THEN 'VERY DANGEROUS'
        WHEN DeathStats.DeathRate >= 0.10 THEN 'DANGEROUS'
        ELSE 'MODERATE'
    END AS DangerClassification

FROM peaks p
    INNER JOIN (
        SELECT 
            e.peakid,
            COUNT(DISTINCT e.expid) AS TotalExpeditions,
            SUM(CAST(e.mdeaths AS INT)) AS TotalDeaths,
            CAST(SUM(CAST(e.mdeaths AS INT)) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathRate
        FROM exped e
        GROUP BY e.peakid
        HAVING COUNT(DISTINCT e.expid) >= 10
    ) DeathStats ON p.peakid = DeathStats.peakid

ORDER BY DeathStats.DeathRate DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 1: DEATH ZONE DEMOGRAPHICS
-- ═══════════════════════════════════════════════════════════════════════════════
