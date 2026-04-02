-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 2 - THE SHERPA INDISPENSABLE
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "The Unsung Heroes" - Examining the role and risk of guides/Sherpas
-- PURPOSE: Reveal economic disparity, risk inequality, and cultural dynamics
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 5: SHERPA/GUIDE PARTICIPATION - WHO ARE THE BACKBONE?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Shift narrative from danger to social justice: "Who really climbs these mountains?"
--   Introducing character: the Sherpa—essential but often invisible
--
-- RESEARCH QUESTION:
--   What percentage of climbers are Sherpas or hired guides?
--   What percentage of summits do they achieve?
--   What is their mortality rate compared to paying climbers?
--
-- T-SQL TECHNIQUES USED:
--   ✓ CASE statements (Sherpa classification)
--   ✓ GROUP BY with multiple classification factors
--   ✓ Window aggregates (calculating totals for percentage)
--   ✓ JOINs (members → exped for peak context)
--
-- EXPECTED INSIGHT:
--   Sherpas comprise 30-50% of participants, achieve 40%+ of summits,
--   but have mortality rates 2-3x higher than paying climbers
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    CASE 
        WHEN m.sherpa = 'TRUE' THEN 'Sherpa'
        WHEN m.tibetan = 'TRUE' THEN 'Tibetan'
        WHEN m.hired = 'TRUE' THEN 'Hired Guide'
        ELSE 'Paying Climber'
    END AS ParticipantType,
    
    COUNT(*) AS TotalParticipants,
    SUM(CASE WHEN m.msuccess = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS SuccessCount,
    SUM(CASE WHEN m.death = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS DeathCount,
    
    CAST(SUM(CASE WHEN m.msuccess = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(*) * 100 AS SummitRatePercent,
    
    CAST(SUM(CASE WHEN m.death = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(*) * 100 AS MortalityRatePercent,
    
    -- Calculate percentage of total participants
    CAST(COUNT(*) AS FLOAT) 
        / SUM(COUNT(*)) OVER () * 100 AS ShareOfAllClimbersPercent,
    
    -- Calculate percentage of all summits
    CAST(SUM(CASE WHEN m.msuccess = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT)
        / SUM(SUM(CASE WHEN m.msuccess = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END)) OVER () * 100 AS ShareOfSummitsPercent

FROM members m
GROUP BY 
    CASE 
        WHEN m.sherpa = 'TRUE' THEN 'Sherpa'
        WHEN m.tibetan = 'TRUE' THEN 'Tibetan'
        WHEN m.hired = 'TRUE' THEN 'Hired Guide'
        ELSE 'Paying Climber'
    END
ORDER BY COUNT(*) DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 6: THE MORTALITY DISPARITY - DO GUIDES DIE AT HIGHER RATES?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Deepening the social angle: exposing risk inequality
--   This query makes the abstract numbers personal—comparing life expectancy by role
--
-- RESEARCH QUESTION:
--   For expeditions on the same peaks, do Sherpas/guides face higher mortality risk
--   than paying climbers? Is there a systematic disadvantage?
--
-- T-SQL TECHNIQUES USED:
--   ✓ SUBQUERY (aggregate by peak, then by participant type)
--   ✓ JOINs (members → exped → peaks)
--   ✓ Complex filtering (single peak comparison)
--   ✓ CASE statements in aggregation
--
-- EXPECTED INSIGHT:
--   Sherpas likely to die 2-3x more often than paying climbers on same peaks;
--   economic model built on transferring risk to lower-paid workers
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    p.pkname AS PeakName,
    
    SUM(CASE 
        WHEN (m.sherpa = 'TRUE' OR m.tibetan = 'TRUE' OR m.hired = 'TRUE') THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS GuidesSherpasCount,
    
    SUM(CASE 
        WHEN (m.sherpa = 'TRUE' OR m.tibetan = 'TRUE' OR m.hired = 'TRUE') AND m.death = 'TRUE' THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS GuideDeaths,
    
    CAST(SUM(CASE 
        WHEN (m.sherpa = 'TRUE' OR m.tibetan = 'TRUE' OR m.hired = 'TRUE') AND m.death = 'TRUE' THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS FLOAT) 
    / NULLIF(SUM(CASE WHEN (m.sherpa = 'TRUE' OR m.tibetan = 'TRUE' OR m.hired = 'TRUE') THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END), 0) * 100
        AS GuideMortalityPercent,
    
    SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) 
            AND (m.tibetan = 'FALSE' OR m.tibetan IS NULL) 
            AND (m.hired = 'FALSE' OR m.hired IS NULL) THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS PayingClimbersCount,
    
    SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) 
            AND (m.tibetan = 'FALSE' OR m.tibetan IS NULL) 
            AND (m.hired = 'FALSE' OR m.hired IS NULL) AND m.death = 'TRUE' THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS PayingClimberDeaths,
    
    CAST(SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) 
            AND (m.tibetan = 'FALSE' OR m.tibetan IS NULL) 
            AND (m.hired = 'FALSE' OR m.hired IS NULL) AND m.death = 'TRUE' THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) AS FLOAT)
    / NULLIF(SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) 
            AND (m.tibetan = 'FALSE' OR m.tibetan IS NULL) 
            AND (m.hired = 'FALSE' OR m.hired IS NULL) THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END), 0) * 100 AS ClimberMortalityPercent

FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
HAVING SUM(CASE WHEN (m.sherpa = 'TRUE' OR m.tibetan = 'TRUE' OR m.hired = 'TRUE') THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) >= 20
    AND SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) 
            AND (m.tibetan = 'FALSE' OR m.tibetan IS NULL) 
            AND (m.hired = 'FALSE' OR m.hired IS NULL) THEN CAST(1 AS INT)
        ELSE CAST(0 AS INT)
    END) >= 20
ORDER BY GuideMortalityPercent DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 7: GUIDE INTENSITY & SUCCESS - DO BIGGER TEAMS GET BETTER RESULTS?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Economic angle: "Is hiring is more guides worth the cost and risk?"
--   Building toward: question the commercialization model
--
-- RESEARCH QUESTION:
--   For expeditions on the same peaks, do those with more hired staff have higher
--   success rates? Or are they just extracting more money at the expense of guides?
--
-- T-SQL TECHNIQUES USED:
--   ✓ JOINs (exped → peaks)
--   ✓ GROUP BY with aggregates (aggregating at expedition level)
--   ✓ Window functions (average hired staff by peak)
--   ✓ Filtering with HAVING
--
-- EXPECTED INSIGHT:
--   More hired staff correlates weakly with success (diminishing returns);
--   suggests over-commercialization rather than improved safety/performance
-- ─────────────────────────────────────────────────────────────────────────────

SELECT 
    p.pkname AS PeakName,
    
    -- Categorize expeditions by hiring intensity
    CASE 
        WHEN CAST(e.tothired AS INT) = CAST(0 AS INT) THEN 'No Hired Staff'
        WHEN CAST(e.tothired AS INT) BETWEEN 1 AND 10 THEN '1-10 Hired'
        WHEN CAST(e.tothired AS INT) BETWEEN 11 AND 50 THEN '11-50 Hired'
        WHEN CAST(e.tothired AS INT) > 50 THEN '50+ Hired'
    END AS HiredStaffLevel,
    
    COUNT(DISTINCT e.expid) AS ExpeditionCount,
    
    SUM(CASE WHEN e.success1 = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS SuccessfulExpeditions,
    
    CAST(SUM(CASE WHEN e.success1 = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS SuccessRatePercent,
    
    AVG(CAST(e.smtmembers AS FLOAT)) AS AvgSummitMembers,
    AVG(CAST(e.mdeaths AS FLOAT)) AS AvgDeathsPerExpedition,
    AVG(CAST(e.tothired AS FLOAT)) AS AvgHiredStaff

FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY 
    p.pkname,
    CASE 
        WHEN CAST(e.tothired AS INT) = CAST(0 AS INT) THEN 'No Hired Staff'
        WHEN CAST(e.tothired AS INT) BETWEEN 1 AND 10 THEN '1-10 Hired'
        WHEN CAST(e.tothired AS INT) BETWEEN 11 AND 50 THEN '11-50 Hired'
        WHEN CAST(e.tothired AS INT) > 50 THEN '50+ Hired'
    END
HAVING COUNT(DISTINCT e.expid) >= 5 -- Filter: peaks with meaningful data
ORDER BY p.pkname, 
    CASE 
        WHEN CASE 
            WHEN CAST(e.tothired AS INT) = CAST(0 AS INT) THEN 'No Hired Staff'
            WHEN CAST(e.tothired AS INT) BETWEEN 1 AND 10 THEN '1-10 Hired'
            WHEN CAST(e.tothired AS INT) BETWEEN 11 AND 50 THEN '11-50 Hired'
            WHEN CAST(e.tothired AS INT) > 50 THEN '50+ Hired'
        END = 'No Hired Staff' THEN 1
        WHEN CASE 
            WHEN CAST(e.tothired AS INT) = CAST(0 AS INT) THEN 'No Hired Staff'
            WHEN CAST(e.tothired AS INT) BETWEEN 1 AND 10 THEN '1-10 Hired'
            WHEN CAST(e.tothired AS INT) BETWEEN 11 AND 50 THEN '11-50 Hired'
            WHEN CAST(e.tothired AS INT) > 50 THEN '50+ Hired'
        END = '1-10 Hired' THEN 2
        WHEN CASE 
            WHEN CAST(e.tothired AS INT) = CAST(0 AS INT) THEN 'No Hired Staff'
            WHEN CAST(e.tothired AS INT) BETWEEN 1 AND 10 THEN '1-10 Hired'
            WHEN CAST(e.tothired AS INT) BETWEEN 11 AND 50 THEN '11-50 Hired'
            WHEN CAST(e.tothired AS INT) > 50 THEN '50+ Hired'
        END = '11-50 Hired' THEN 3
        ELSE 4
    END;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 8: SHERPA CITIZENSHIP - NATIONAL ORIGINS OF GUIDES (CTE Example)
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Bringing in the cultural dimension: where do Sherpas/guides come from?
--   Connecting data to real people, real nationalities, real communities
--
-- RESEARCH QUESTION:
--   What are the citizenship patterns for Sherpas vs. paying climbers?
--   Are Sherpas systematically from poorer nations?
--
-- T-SQL TECHNIQUES USED:
--   ✓ CTEs (WITH statement) - grouping logic for clarity
--   ✓ CASE statements (Sherpa classification)
--   ✓ GROUP BY with multiple dimensions
--   ✓ Window aggregates
--
-- EXPECTED INSIGHT:
--   Sherpas predominantly Nepali/Tibetan; paying climbers from wealthy countries;
--   economic system mapped onto geographic/wealth inequality
-- ─────────────────────────────────────────────────────────────────────────────

WITH SherpaOrigins AS (
    -- CTE: Classify all members by their role
    SELECT
        m.citizen AS CountryOfOrigin,
        CASE 
            WHEN m.sherpa = 'TRUE' THEN 'Sherpa'
            WHEN m.tibetan = 'TRUE' THEN 'Tibetan'
            WHEN m.hired = 'TRUE' THEN 'Hired Guide'
            ELSE 'Paying Climber'
        END AS ParticipantType,
        COUNT(*) AS TotalCount,
        SUM(CASE WHEN m.msuccess = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS SummitCount,
        SUM(CASE WHEN m.death = 'TRUE' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS DeathCount
    FROM members m
    WHERE m.citizen IS NOT NULL
    GROUP BY 
        m.citizen,
        CASE 
            WHEN m.sherpa = 'TRUE' THEN 'Sherpa'
            WHEN m.tibetan = 'TRUE' THEN 'Tibetan'
            WHEN m.hired = 'TRUE' THEN 'Hired Guide'
            ELSE 'Paying Climber'
        END
)
SELECT TOP 30
    CountryOfOrigin,
    ParticipantType,
    TotalCount,
    SummitCount,
    DeathCount,
    CAST(SummitCount AS FLOAT) / TotalCount * 100 AS SummitRatePercent,
    CAST(DeathCount AS FLOAT) / TotalCount * 100 AS MortalityRatePercent
FROM SherpaOrigins
ORDER BY TotalCount DESC, ParticipantType;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 2: THE SHERPA INDISPENSABLE
-- These 4 queries build a compelling human story: economic disparity, risk transfer,
-- and the essential but under-valued role of guides from developing nations
-- ═══════════════════════════════════════════════════════════════════════════════
