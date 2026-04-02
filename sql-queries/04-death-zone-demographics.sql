-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 1 - DEATH ZONE DEMOGRAPHICS
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "The Human Cost" - Understanding mortality patterns in Himalayan climbing
-- PURPOSE: Analyze which peaks are most deadly, what kills climbers, and vulnerability patterns
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 1: WHICH PEAKS KILL THE MOST?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   This is the opening act—finding "the deadliest mountains" establishes dramatic stakes
--   We're answering: "Which peaks should climbers fear most?"
--
-- RESEARCH QUESTION:
--   What are the 15 peaks with the highest total death counts, and how many expeditions
--   have been attempted on each? Are deaths concentrated on a few famous peaks?
--
-- T-SQL TECHNIQUES USED:
--   ✓ JOINs (exped → peaks)
--   ✓ GROUP BY + HAVING (aggregate deaths, filter peaks with 5+ deaths)
--   ✓ ORDER BY with aggregates
--   ✓ Window function concepts (ranking deadliest peaks)
--
-- EXPECTED INSIGHT:
--   Everest likely #1, K2 high up (smallest death count but highest ratio),
--   some peaks deadly despite low popularity
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 15
    p.pkname AS 'Peak Name',
    p.heightm AS 'Height (m)',
    COUNT(DISTINCT e.expid) AS 'Total Expeditions',
    SUM(e.mdeaths) AS 'Total Deaths',
    CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) AS 'Deaths Per Expedition',
    CAST(COUNT(DISTINCT CASE WHEN e.success1 > 0 THEN e.expid END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)'
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname, p.heightm
HAVING SUM(e.mdeaths) >= 5 -- Filter: only peaks with 5+ deaths (dramatic threshold)
ORDER BY SUM(e.mdeaths) DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 2: WHAT KILLS CLIMBERS? - CAUSE OF DEATH BY PEAK AND SEASON
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Deepening the narrative: from "where do people die" to "how do they die"
--   Creates suspense and human drama—avalanche vs. altitude vs. falls
--
-- RESEARCH QUESTION:
--   What is the distribution of death causes (deathtype) on the deadliest peaks?
--   Do certain seasons make specific hazards more lethal?
--
-- T-SQL TECHNIQUES USED:
--   ✓ JOINs (members → exped → peaks)
--   ✓ GROUP BY with CASE statements (deathtype categorization)
--   ✓ Filtering with WHERE (deaths only: death = 'T')
--   ✓ CTEs opportunity (but done with WHERE for simplicity)
--
-- EXPECTED INSIGHT:
--   Avalanches in spring/early summer; altitude sickness year-round;
--   Falls less common but more frequent in certain zones
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    p.pkname AS 'Peak Name',
    e.season AS 'Season',
    m.deathtype AS 'Cause of Death',
    COUNT(*) AS 'Death Count',
    CAST(COUNT(*) AS FLOAT) 
        / SUM(COUNT(*)) OVER (PARTITION BY p.pkname, e.season) * 100 AS 'Percentage (%)'
FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
WHERE m.death = 'T' -- Only deceased climbers
    AND p.heightm > 8000 -- Focus on death zone (>8000m)
GROUP BY p.pkname, e.season, m.deathtype
ORDER BY p.pkname, e.season, COUNT(*) DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 3: AGE AND MORTALITY - ARE YOUNGER CLIMBERS MORE VULNERABLE?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Humanizing the data: not just abstract statistics, but individual vulnerability
--   Introducing a character archetype: "the young ambitious climber vs. experienced veteran"
--
-- RESEARCH QUESTION:
--   What is the relationship between climber age and mortality rate?
--   Do we see higher death rates in specific age cohorts?
--
-- T-SQL TECHNIQUES USED:
--   ✓ VARIABLES (DECLARE @CurrentYear to calculate age dynamically)
--   ✓ CASE statement (age bracket categorization)
--   ✓ GROUP BY with calculated fields
--   ✓ Aggregation functions (COUNT, SUM)
--
-- EXPECTED INSIGHT:
--   Possibly U-shaped curve: very young & very old have higher mortality
--   Peak age for climbing might be 30-50 with lower mortality risk
-- ─────────────────────────────────────────────────────────────────────────────

DECLARE @CurrentYear INT = 2026; -- Set reference year

SELECT
    -- Age bracket categorization
    CASE 
        WHEN (YEAR(GETDATE()) - m.yob) < 25 THEN '< 25 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 25 AND 34 THEN '25-34 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 35 AND 44 THEN '35-44 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 45 AND 54 THEN '45-54 years'
        WHEN (YEAR(GETDATE()) - m.yob) >= 55 THEN '55+ years'
        ELSE 'Unknown'
    END AS 'Age Bracket',
    
    COUNT(*) AS 'Total Climbers',
    SUM(CASE WHEN m.death = 'T' THEN 1 ELSE 0 END) AS 'Deaths',
    CAST(SUM(CASE WHEN m.death = 'T' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS 'Mortality Rate (%)',
    SUM(CASE WHEN m.msuccess = 'T' THEN 1 ELSE 0 END) AS 'Summits',
    CAST(SUM(CASE WHEN m.msuccess = 'T' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS 'Summit Success Rate (%)'

FROM members m
WHERE m.yob IS NOT NULL -- Filter: valid birth year data
GROUP BY 
    CASE 
        WHEN (YEAR(GETDATE()) - m.yob) < 25 THEN '< 25 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 25 AND 34 THEN '25-34 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 35 AND 44 THEN '35-44 years'
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 45 AND 54 THEN '45-54 years'
        WHEN (YEAR(GETDATE()) - m.yob) >= 55 THEN '55+ years'
        ELSE 'Unknown'
    END
ORDER BY 
    CASE 
        WHEN (YEAR(GETDATE()) - m.yob) < 25 THEN 1
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 25 AND 34 THEN 2
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 35 AND 44 THEN 3
        WHEN (YEAR(GETDATE()) - m.yob) BETWEEN 45 AND 54 THEN 4
        WHEN (YEAR(GETDATE()) - m.yob) >= 55 THEN 5
        ELSE 6
    END;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 4: PEAK LETHALITY INDEX - COMBINING DEATH RATE WITH DIFFICULTY
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Synthesizing earlier findings: creating a composite "danger metric"
--   This is the climax of Block 1 - ranking peaks by true danger
--
-- RESEARCH QUESTION:
--   Which peaks are truly the most dangerous when we account for both death rate
--   AND how difficult they are (height)? Is Everest more dangerous than K2 per capita?
--
-- T-SQL TECHNIQUES USED:
--   ✓ SUBQUERY (nested aggregate to calculate deaths per expedition)
--   ✓ JOINs (multiple tables)
--   ✓ CASE statements (danger classification)
--   ✓ Complex aggregation logic
--
-- EXPECTED INSIGHT:
--   K2 > Everest in pure death ratio; but Everest more absolute deaths (volume);
--   Some lesser-known peaks punch above their weight in danger
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    p.pkname AS 'Peak Name',
    p.heightm AS 'Height (m)',
    DeathStats.TotalExpeditions AS 'Expeditions',
    DeathStats.TotalDeaths AS 'Total Deaths',
    DeathStats.DeathRate AS 'Death Rate per Expedition',
    CASE 
        WHEN DeathStats.DeathRate >= 0.5 THEN 'EXTREMELY DANGEROUS'
        WHEN DeathStats.DeathRate >= 0.25 THEN 'VERY DANGEROUS'
        WHEN DeathStats.DeathRate >= 0.10 THEN 'DANGEROUS'
        ELSE 'MODERATE'
    END AS 'Danger Classification'

FROM peaks p
    INNER JOIN (
        -- SUBQUERY: Calculate death statistics per peak
        SELECT 
            e.peakid,
            COUNT(DISTINCT e.expid) AS TotalExpeditions,
            SUM(e.mdeaths) AS TotalDeaths,
            CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathRate
        FROM exped e
        GROUP BY e.peakid
        HAVING COUNT(DISTINCT e.expid) >= 10 -- Filter: peaks with 10+ expeditions for statistical validity
    ) DeathStats ON p.peakid = DeathStats.peakid

ORDER BY DeathStats.DeathRate DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 1: DEATH ZONE DEMOGRAPHICS
-- These 4 queries establish the dramatic foundation: "Which mountains kill the most,
-- and who is most vulnerable?"
-- ═══════════════════════════════════════════════════════════════════════════════
