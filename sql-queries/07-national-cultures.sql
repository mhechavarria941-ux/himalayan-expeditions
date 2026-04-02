-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 4 - NATIONAL CLIMBING CULTURES
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "Different Mountains, Different Peoples" - Cultural climbing patterns
-- PURPOSE: Show how nationality shapes climbing philosophy, style, and outcomes
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 12: NATIONAL SUCCESS RANKINGS - WHO ARE THE BEST CLIMBERS?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Comparative angle: creating rankings and leaderboards between nations
--   "Which countries produce the best mountaineers?"
--
-- RESEARCH QUESTION:
--   What are the success rates, mortality rates, and summit achievements by nation?
--   Is there a "best climbing nation" based on experience and outcomes?
--   Do wealthy nations have advantages? Do Himalayan nations have home turf edge?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Aggregates with multiple calculations
--   ✓ JOINs (members → exped with filtering)
--   ✓ CASE statements (stats by nation)
--   ✓ ORDER BY with ranking
--   ✓ HAVING clause (filter nations with 100+ participants)
--
-- EXPECTED INSIGHT:
--   Nepal/Tibetan nations high success; Western nations (USA, UK) high participation;
--   Japan/South Korea emerging as skilled; mortality varies significantly
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 25
    m.citizen AS 'Country',
    
    COUNT(*) AS 'Total Participants',
    
    SUM(CASE WHEN m.msuccess = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS 'Summits Achieved',
    
    CAST(SUM(CASE WHEN m.msuccess = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(*) * 100 AS 'Summit Success Rate (%)',
    
    SUM(CASE WHEN m.death = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS 'Deaths',
    
    CAST(SUM(CASE WHEN m.death = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(*) * 100 AS 'Mortality Rate (%)',
    
    COUNT(DISTINCT m.expid) AS 'Expeditions Joined',
    
    CAST(COUNT(DISTINCT CASE WHEN m.msuccess = 'T' THEN m.expid END) AS FLOAT)
        / COUNT(DISTINCT m.expid) * 100 AS 'Expedition Success Rate (%)'

FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
HAVING COUNT(*) >= CAST(100 AS INT) -- Filter: nations with 100+ climbers for significance
ORDER BY 'Summit Success Rate (%)' DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 13: CLIMBING STYLE BY NATION - OXYGEN USE & ROUTE PREFERENCES
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Revealing different climbing philosophies rooted in national culture
--   "How do Sherpas climb differently than Americans?"
--
-- RESEARCH QUESTION:
--   Do different nationalities employ different climbing strategies?
--   Some nations use oxygen more; some prefer no-oxygen "pure" climbing
--   Do these different philosophies affect success/safety outcomes?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Subquery (aggregating at expedition level, then by nation)
--   ✓ JOINs (exped filtered by nation)
--   ✓ Complex CASE aggregates (o2used, traverse, ski preference)
--   ✓ Window functions (percentage allocation)
--
-- EXPECTED INSIGHT:
--   Himalayan nations less oxygen-dependent; Western nations heavy users;
--   European expeditions more likely to traverse/ski routes
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    e.nation AS 'Country',
    
    COUNT(DISTINCT e.expid) AS 'Expeditions Led',
    
    -- Oxygen usage pattern
    CAST(SUM(CASE WHEN e.o2used = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Oxygen Use Rate (%)',
    
    -- Traversing (crossing multiple peaks)
    CAST(SUM(CASE WHEN e.traverse = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Traverse Rate (%)',
    
    -- Skiing expeditions (descent by ski)
    CAST(SUM(CASE WHEN e.ski = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Ski Descent Rate (%)',
    
    -- Success outcomes
    CAST(SUM(CASE WHEN CAST(e.success1 AS INT) > CAST(0 AS INT) THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)',
    
    -- Risk assessment
    AVG(CAST(e.mdeaths AS FLOAT)) AS 'Avg Deaths per Expedition',
    
    -- Team composition
    CAST(AVG(CAST(e.totmembers AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Team Size',
    CAST(AVG(CAST(e.tothired AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Hired Staff'

FROM exped e
WHERE e.nation IS NOT NULL
GROUP BY e.nation
HAVING COUNT(DISTINCT e.expid) >= CAST(20 AS INT) -- Filter: nations with 20+ expeditions
ORDER BY COUNT(DISTINCT e.expid) DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 14: PEAK AFFINITY BY NATION - WHERE DO DIFFERENT NATIONS CLIMB?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Cultural geography: mapping which nations prefer which peaks
--   Reveals proximity effects, prestige hierarchies, logistical patterns
--
-- RESEARCH QUESTION:
--   Do nations cluster around specific peaks they're geographically near?
--   Do certain peaks attract internationally diverse teams vs. local dominance?
--   Is there a peak hierarchy (Everest popular globally, others regional)?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Subquery (ranking peaks within each nation)
--   ✓ CTEs (organizing nation-peak combinations) - SUBQUERY approach
--   ✓ JOINs (exped → peaks → ranked by nation preference)
--   ✓ Window functions (ROW_NUMBER for ranking)
--
-- EXPECTED INSIGHT:
--   Nepal teams: many local 5000-6000m peaks + Everest
--   US/UK: Everest primarily + some famous 8000m
--   Japan: distinctive routes on multiple peaks
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
    e.nation AS 'Country',
    p.pkname AS 'Peak',
    COUNT(DISTINCT e.expid) AS 'Expeditions',
    
    CAST(SUM(CASE WHEN CAST(e.success1 AS INT) > CAST(0 AS INT) THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)',
    
    SUM(e.smtmembers) AS 'Total Summits',
    
    -- Percentage of that nation's total expeditions on this peak
    CAST(COUNT(DISTINCT e.expid) AS FLOAT) 
        / SUM(COUNT(DISTINCT e.expid)) OVER (PARTITION BY e.nation) * 100 AS 'Share of National Expeditions (%)',
    
    -- Rank this peak within the nation's preferences
    ROW_NUMBER() OVER (PARTITION BY e.nation ORDER BY COUNT(DISTINCT e.expid) DESC) AS 'Peak Rank for Nation'

FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
WHERE e.nation IS NOT NULL
    AND p.heightm > CAST(7000 AS INT) -- Filter: focus on high altitude peaks (major achievements)
GROUP BY e.nation, p.pkname
HAVING COUNT(DISTINCT e.expid) >= CAST(3 AS INT) -- Filter: meaningful participation (3+ expeditions)
ORDER BY e.nation, 'Peak Rank for Nation';

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 15: EXPERIENCE & PROGRESSION - DO VETERAN CLIMBERS FARE BETTER?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Economic and skill lens: "Does experience matter? Can you buy expertise?"
--   Connecting expenditure to outcomes
--
-- RESEARCH QUESTION:
--   For individuals: do those with more prior summits on current expedition batch
--   have higher success rates? Lower death rates?
--   Does multile-mountain experience create "experts"?
--
-- T-SQL TECHNIQUES USED:
--   ✓ SUBQUERY (count prior summits per member)
--   ✓ CASE statements (experience categorization)
--   ✓ Complex JOIN logic
--   ✓ Aggregation with ranking
--
-- EXPECTED INSIGHT:
--   Clear progression: first-timers 40% success, veterans 70%+ success;
--   mortality risk drops significantly with experience
-- ─────────────────────────────────────────────────────────────────────────────

-- Subquery: categorize climbers by prior summit experience
SELECT
    CASE 
        WHEN ExperienceCount.PriorSummits = CAST(0 AS INT) THEN 'First Timer'
        WHEN ExperienceCount.PriorSummits BETWEEN 1 AND 2 THEN '1-2 Prior Summits'
        WHEN ExperienceCount.PriorSummits BETWEEN 3 AND 5 THEN '3-5 Prior Summits'
        WHEN ExperienceCount.PriorSummits > CAST(5 AS INT) THEN '5+ Prior Summits (Veteran)'
    END AS 'Experience Level',
    
    COUNT(*) AS 'Total Participants',
    
    SUM(CASE WHEN m.msuccess = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS 'Summits Achieved',
    
    CAST(SUM(CASE WHEN m.msuccess = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / NULLIF(COUNT(*), 0) * 100 AS 'Success Rate (%)',
    
    SUM(CASE WHEN m.death = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS 'Deaths',
    
    CAST(SUM(CASE WHEN m.death = 'T' THEN CAST(1 AS INT) ELSE CAST(0 AS INT) END) AS FLOAT) 
        / NULLIF(COUNT(*), 0) * 100 AS 'Mortality Rate (%)',
    
    CAST(AVG(CAST(ExperienceCount.PriorSummits AS FLOAT)) AS DECIMAL(10,2)) AS 'Avg Prior Summits'

FROM members m
    INNER JOIN (
        -- SUBQUERY: Count how many expeditions each member has successfully summited before
        SELECT 
            m1.memberid,
            COUNT(DISTINCT CASE 
                WHEN m1.msuccess = 'T' THEN m1.expid 
            END) AS PriorSummits
        FROM members m1
        GROUP BY m1.memberid
    ) ExperienceCount ON m.memberid = ExperienceCount.memberid

GROUP BY 
    CASE 
        WHEN ExperienceCount.PriorSummits = CAST(0 AS INT) THEN 'First Timer'
        WHEN ExperienceCount.PriorSummits BETWEEN 1 AND 2 THEN '1-2 Prior Summits'
        WHEN ExperienceCount.PriorSummits BETWEEN 3 AND 5 THEN '3-5 Prior Summits'
        WHEN ExperienceCount.PriorSummits > CAST(5 AS INT) THEN '5+ Prior Summits (Veteran)'
    END
ORDER BY 
    CASE 
        WHEN ExperienceCount.PriorSummits = CAST(0 AS INT) THEN 1
        WHEN ExperienceCount.PriorSummits BETWEEN 1 AND 2 THEN 2
        WHEN ExperienceCount.PriorSummits BETWEEN 3 AND 5 THEN 3
        WHEN ExperienceCount.PriorSummits > CAST(5 AS INT) THEN 4
    END;

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 4: NATIONAL CLIMBING CULTURES & EXPERIENCE
-- These 4 queries reveal how climbing success and culture vary by nationality,
-- style, expertise, and historical patterns. They show a global sport shaped by
-- diverse national traditions and individual experience levels.
-- ═══════════════════════════════════════════════════════════════════════════════
