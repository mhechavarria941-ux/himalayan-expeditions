-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 3 - THE EVEREST EFFECT
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "Commercialization & Mass Tourism" - How the mountains changed
-- PURPOSE: Show the transformation from elite climbing to mass-market adventure
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 9: TEAM SIZE EXPLOSION - CLIMBING GETS BIGGER EACH YEAR
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Narrative pivot from human stories to systemic transformation
--   "What changed in mountaineering? Why are mountains crowded now?"
--
-- RESEARCH QUESTION:
--   Has the average expedition size grown over time on major peaks?
--   Do we have measurable data showing the shift from small teams to large ones?
--   When did this transformation occur?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Time-series aggregation (GROUP BY year)
--   ✓ JOINs (exped → peaks)
--   ✓ Window functions (running averages over time)
--   ✓ Filtering (major peaks only)
--
-- EXPECTED INSIGHT:
--   Sharp growth curve showing 1960s: teams of 10-20, by 2010s: teams of 100+
--   Particularly dramatic on Everest (EVER)
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    e.year AS 'Expedition Year',
    p.pkname AS 'Peak Name',
    
    COUNT(DISTINCT e.expid) AS 'Expeditions',
    
    CAST(AVG(CAST(e.totmembers AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Team Size',
    
    MIN(e.totmembers) AS 'Smallest Team',
    MAX(e.totmembers) AS 'Largest Team',
    
    CAST(AVG(CAST(e.smtmembers AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Summiteers',
    
    CAST(AVG(CAST(e.tothired AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Hired Staff',
    
    -- Running average over last 5 years (window function concept)
    CAST(AVG(AVG(CAST(e.totmembers AS FLOAT))) 
        OVER (PARTITION BY p.pkname ORDER BY e.year ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) 
        AS DECIMAL(10,2)) AS '5-Year Avg Team Size'

FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
WHERE p.heightm > CAST(8000 AS INT) -- Focus on 8000m+ "trophy" peaks
GROUP BY e.year, p.pkname
ORDER BY p.pkname, e.year;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 10: COMMERCIALIZATION TIMELINE - WHEN DID GUIDES BECOME STANDARD?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Pinpointing the inflection point: "When did climbing become a business?"
--   Showing the trend line of hired staff as proxy for commercialization
--
-- RESEARCH QUESTION:
--   What is the trend in the ratio of hired guides to paying climbers over decades?
--   Can we identify a specific era when commercialization accelerated?
--   Does this correlate with team size growth?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Aggregation with calculated ratios
--   ✓ TIME-SERIES (GROUP BY decade)
--   ✓ CASE statements (decade categorization)
--   ✓ Multiple aggregates (SUM, AVG, COUNT)
--
-- EXPECTED INSIGHT:
--   Pre-1980: guides rare (< 5% of teams)
--   1980-2000: gradual increase (5-20%)
--   Post-2000: explosive growth (30-50%+)
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    CASE 
        WHEN e.year < 1960 THEN 'Before 1960'
        WHEN e.year BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN e.year BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN e.year BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN e.year BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN e.year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN e.year >= 2010 THEN '2010s+'
    END AS 'Era',
    
    COUNT(DISTINCT e.expid) AS 'Total Expeditions',
    
    CAST(SUM(CAST(e.totmembers AS FLOAT)) AS DECIMAL(10,2)) AS 'Total Climbers',
    CAST(SUM(CAST(e.tothired AS FLOAT)) AS DECIMAL(10,2)) AS 'Total Hired Staff',
    
    -- Key metric: hiring ratio over time
    CAST(SUM(CAST(e.tothired AS FLOAT)) AS FLOAT) 
        / NULLIF(SUM(CAST(e.totmembers AS FLOAT)), 0) * 100 AS 'Hired % of Total',
    
    -- Average hired per expedition
    CAST(AVG(CAST(e.tothired AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Hired per Exp',
    
    -- Success rate trend
    CAST(SUM(CASE WHEN CAST(e.success1 AS INT) > CAST(0 AS INT) THEN 1 ELSE 0 END) AS FLOAT) 
        / NULLIF(COUNT(DISTINCT e.expid), 0) * 100 AS 'Success Rate (%)',
    
    -- Death rate trend
    CAST(SUM(CAST(e.mdeaths AS FLOAT)) AS DECIMAL(10,2)) AS 'Total Deaths',
    CAST(SUM(CAST(e.mdeaths AS FLOAT)) / NULLIF(COUNT(DISTINCT e.expid), 0) AS DECIMAL(10,2)) AS 'Deaths per Exp'

FROM exped e
GROUP BY 
    CASE 
        WHEN e.year < 1960 THEN 'Before 1960'
        WHEN e.year BETWEEN 1960 AND 1969 THEN '1960s'
        WHEN e.year BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN e.year BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN e.year BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN e.year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN e.year >= 2010 THEN '2010s+'
    END
ORDER BY 
    CASE 
        WHEN e.year < 1960 THEN 1
        WHEN e.year BETWEEN 1960 AND 1969 THEN 2
        WHEN e.year BETWEEN 1970 AND 1979 THEN 3
        WHEN e.year BETWEEN 1980 AND 1989 THEN 4
        WHEN e.year BETWEEN 1990 AND 1999 THEN 5
        WHEN e.year BETWEEN 2000 AND 2009 THEN 6
        WHEN e.year >= 2010 THEN 7
    END;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 11: EVEREST CASE STUDY - THE ULTIMATE COMMERCIALIZATION STORY
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Zooming in on the most iconic mountain: Everest as poster child for change
--   Personal angle: track individual expeditions and their composition
--
-- RESEARCH QUESTION:
--   Focusing specifically on Mount Everest: how have expeditions changed since 1953?
--   What is the correlation between team size, hired staff, and success rates?
--   Has climbing Everest become easier (more summits) or deadlier (more deaths)?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Filtering (WHERE peak = 'EVER')
--   ✓ Subquery (to find Everest's peakid efficiently)
--   ✓ Complex aggregates
--   ✓ CASE statements for era grouping
--
-- EXPECTED INSIGHT:
--   1953: 1 team, 11 climbers, 2 summits
--   2000s: 100+ teams, 3000+ climbers, 1500+ summits
--   More people, more success, yet still significant deaths (volume factor)
-- ─────────────────────────────────────────────────────────────────────────────

DECLARE @EverestPeakID INT;
SET @EverestPeakID = (SELECT TOP 1 peakid FROM peaks WHERE pkname LIKE '%EVER%');

SELECT
    e.year AS 'Year',
    
    COUNT(DISTINCT e.expid) AS 'Expeditions',
    COUNT(DISTINCT 
        CASE WHEN e.nation IS NOT NULL THEN CONCAT(e.nation, '-', e.year) 
        END) AS 'National Teams',
    
    SUM(e.totmembers) AS 'Total Climbers',
    CAST(AVG(CAST(e.totmembers AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Team Size',
    
    SUM(e.tothired) AS 'Total Hired',
    CAST(AVG(CAST(e.tothired AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Hired per Team',
    
    SUM(e.smtmembers) AS 'Total Summits',
    SUM(e.mdeaths) AS 'Total Deaths',
    
    CAST(SUM(CASE WHEN CAST(e.success1 AS INT) > CAST(0 AS INT) THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)',
    
    CAST(SUM(CAST(e.mdeaths AS FLOAT)) / COUNT(DISTINCT e.expid) AS DECIMAL(10,2)) AS 'Deaths per Expedition'

FROM exped e
WHERE e.peakid = @EverestPeakID
    AND e.year >= CAST(1950 AS INT) -- Since first successful ascent
GROUP BY e.year
ORDER BY e.year;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 3: THE EVEREST EFFECT
-- These 3 queries show a dramatic transformation narrative: from exclusive elite
-- pursuit to democratic mass-market industry, with quantifiable before/after data
-- ═══════════════════════════════════════════════════════════════════════════════
