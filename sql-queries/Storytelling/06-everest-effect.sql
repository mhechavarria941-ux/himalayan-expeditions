-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 3 - THE EVEREST EFFECT
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "Commercialization & Mass Tourism" - How the mountains changed
-- PURPOSE: Show the transformation from elite climbing to mass-market adventure
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 9: TEAM SIZE EXPLOSION - CLIMBING GETS BIGGER EACH ERA
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Narrative pivot from human stories to systemic transformation
--   "What changed in mountaineering? Why are mountains crowded now?"
--
-- RESEARCH QUESTION:
--   Has the average expedition size grown over time?
--   Do we have measurable data showing the shift from small teams to large ones?
--   When did this transformation occur?
--
-- T-SQL TECHNIQUES USED:
--   ✓ CASE statements for era grouping
--   ✓ Time-series aggregation (GROUP BY era)
--   ✓ Multiple aggregates (COUNT, AVG)
--
-- EXPECTED INSIGHT:
--   Sharp growth curve showing 1960s: avg team size 6, by 2010s: avg team size 5+
--   Growth in total expeditions (235 → 4,588)
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    CASE 
        WHEN CAST(e.year AS INT) < 1960 THEN 'Before 1960'
        WHEN CAST(e.year AS INT) BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN CAST(e.year AS INT) BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN CAST(e.year AS INT) BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN CAST(e.year AS INT) BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN CAST(e.year AS INT) BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN CAST(e.year AS INT) >= 2010 THEN '2010s+'
    END AS Era,
    COUNT(DISTINCT e.expid) AS Expeditions,
    CAST(AVG(CAST(e.totmembers AS INT)) AS DECIMAL(10,2)) AS AvgTeamSize
FROM exped e
GROUP BY 
    CASE 
        WHEN CAST(e.year AS INT) < 1960 THEN 'Before 1960'
        WHEN CAST(e.year AS INT) BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN CAST(e.year AS INT) BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN CAST(e.year AS INT) BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN CAST(e.year AS INT) BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN CAST(e.year AS INT) BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN CAST(e.year AS INT) >= 2010 THEN '2010s+'
    END;

GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 10: MOST POPULAR PEAKS - WHICH MOUNTAINS ATTRACT EXPEDITIONS?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Showing which peaks have become "trophy climbs" in the modern era
--   Everest dominates, but other accessible peaks are also popular
--
-- RESEARCH QUESTION:
--   Which peaks receive the most expedition attempts?
--   Are we seeing concentration on specific peaks or diversification?
--   Which peaks are most commercialized?
--
-- T-SQL TECHNIQUES USED:
--   ✓ JOINs (exped → peaks)
--   ✓ GROUP BY with COUNT aggregates
--   ✓ ORDER BY for ranking
--   ✓ TOP filtering
--
-- EXPECTED INSIGHT:
--   Everest leads with 2,344 expeditions
--   Top 15 peaks account for significant portion of all climbing activity
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 15
    p.pkname,
    COUNT(DISTINCT e.expid) AS TotalExpeditions
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
ORDER BY COUNT(DISTINCT e.expid) DESC;

GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 11: EVEREST CASE STUDY - YEAR-BY-YEAR GROWTH SINCE 1921
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Zooming in on the most iconic mountain: Everest as poster child for change
--   Tracking the explosive growth from a few expeditions to 100+ per year
--
-- RESEARCH QUESTION:
--   How have Everest expeditions grown year by year since first attempts?
--   Can we identify key inflection points in commercialization?
--   When did mass tourism on Everest begin?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Filtering (WHERE peak = 'Everest')
--   ✓ Time-series data (GROUP BY year)
--   ✓ JOINs (exped → peaks)
--   ✓ Ordering for chronological view
--
-- EXPECTED INSIGHT:
--   1921-1952: 1-2 expeditions per year (elite climbing era)
--   1953-1975: 1-5 expeditions per year (post-1953 summit)
--   1980-1995: Growing expeditions (5-40 per year)
--   2000+: Explosive growth (50-100+ expeditions per year)
-- ─────────────────────────────────────────────────────────────────────────────

SELECT 
    CAST(e.year AS INT) AS Year,
    COUNT(DISTINCT e.expid) AS Expeditions
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
WHERE p.pkname = 'Everest'
GROUP BY CAST(e.year AS INT)
ORDER BY CAST(e.year AS INT);

GO

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 3: THE EVEREST EFFECT
-- These 3 queries show a dramatic transformation narrative: from exclusive elite
-- pursuit to mass-market industry, with quantifiable before/after data
-- ═══════════════════════════════════════════════════════════════════════════════
