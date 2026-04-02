-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 4 - NATIONAL CLIMBING CULTURES
-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME: "Different Mountains, Different Peoples" - Cultural climbing patterns
-- PURPOSE: Show how nationality shapes climbing philosophy, style, and outcomes
-- ═══════════════════════════════════════════════════════════════════════════════

USE Final_Project;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 12: NATIONAL PARTICIPATION & SUCCESS - TOP CLIMBING NATIONS
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Comparative angle: ranking nations by climbing activity and achievement
--   "Which countries have the most climbers and summits?"
--
-- RESEARCH QUESTION:
--   Which nations have the most members attempting Himalayan peaks?
--   What are the basic success metrics by nationality?
--   Are large participant numbers correlated with summit success?
--
-- T-SQL TECHNIQUES USED:
--   ✓ GROUP BY citizenship
--   ✓ Aggregates (COUNT, SUM with CASE)
--   ✓ Boolean comparisons ('TRUE'/'FALSE' values)
--   ✓ ORDER BY ranking
--
-- EXPECTED INSIGHT:
--   Nepal leads in members (20,000+); Western nations (USA, UK, France) follow
--   Nepal and nearby nations achieve high summit rates due to experience
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    m.citizen,
    COUNT(*) AS TotalMembers,
    SUM(CASE WHEN m.msuccess = 'TRUE' THEN 1 ELSE 0 END) AS Summits
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(*) DESC;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 13: SHERPA ORIGINS - WHERE DO GUIDES COME FROM?
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Economic perspective: tracing the supply of guides and hired staff
--   "Where is the climbing labor force concentrated?"
--
-- RESEARCH QUESTION:
--   Which nations produce the most Sherpas and hired guides?
--   Is Sherpa climbing concentrated in Nepal/Tibet or globally dispersed?
--   Does this correlate with geographic proximity to high mountains?
--
-- T-SQL TECHNIQUES USED:
--   ✓ Boolean filtering (WHERE m.sherpa = 'TRUE')
--   ✓ GROUP BY nationality
--   ✓ SUM aggregation with CASE statements
--   ✓ Ordering by calculated field
--
-- EXPECTED INSIGHT:
--   Overwhelmingly Nepali Sherpas; secondary concentrations in Tibet/India
--   Shows how guiding is a regional labor market
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    m.citizen,
    SUM(CASE WHEN m.sherpa = 'TRUE' THEN 1 ELSE 0 END) AS SherpaMembership
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY SUM(CASE WHEN m.sherpa = 'TRUE' THEN 1 ELSE 0 END) DESC;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 14: PEAK DIVERSITY BY NATION - GEOGRAPHIC CLIMBING REACH
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Adventure portfolio: showing which nations climb globally diverse peaks
--   "Do nations tend to climb local peaks or venture globally?"
--
-- RESEARCH QUESTION:
--   How many different peaks do climbers from each nation attempt?
--   Do some nations specialize in specific peaks while others diversify?
--   Is there a "global explorer" vs. "local specialist" pattern?
--
-- T-SQL TECHNIQUES USED:
--   ✓ JOINs (members → exped → peaks implicitly)
--   ✓ DISTINCT counts (peak diversity metric)
--   ✓ GROUP BY citizenship
--   ✓ Order by climbing reach/diversity
--
-- EXPECTED INSIGHT:
--   Nepal/UK/USA: diverse (100+ peaks); developing nations: concentrated (10-20 peaks)
--   Shows resource levels and international climbing accessibility
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    m.citizen,
    COUNT(DISTINCT e.peakid) AS UniquePeaksCovered
FROM members m
    INNER JOIN exped e ON m.expid = e.expid
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(DISTINCT e.peakid) DESC;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 15: EXPEDITION PARTICIPATION - EXPEDITION FREQUENCY BY NATION
-- ─────────────────────────────────────────────────────────────────────────────
-- STORYTELLING CONTEXT:
--   Institutional strength: showing which nations organize/sponsor expeditions
--   "Who organizes climbing expeditions?"
--
-- RESEARCH QUESTION:
--   Which nations' members participate in the most expeditions?
--   Is expedition participation concentrated or distributed?
--   Does this correlate with wealth, geography, or climbing culture?
--
-- T-SQL TECHNIQUES USED:
--   ✓ DISTINCT expedition counting (e.expid)
--   ✓ GROUP BY citizenship
--   ✓ Aggregation at expedition level (not individual level)
--   ✓ TOP filtering for summary view
--
-- EXPECTED INSIGHT:
--   Nepal: highest expedition count (20,000+ because of guides in many teams)
--   USA/UK: concentrated expeditions (organized climbing culture)
--   Shows how expedition participation patterns differ globally
-- ─────────────────────────────────────────────────────────────────────────────

SELECT TOP 20
    m.citizen,
    COUNT(DISTINCT m.expid) AS TotalExpeditions
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(DISTINCT m.expid) DESC;

GO

-- ═══════════════════════════════════════════════════════════════════════════════
-- END BLOCK 4: NATIONAL CLIMBING CULTURES
-- These 4 queries reveal patterns of participation, expertise, and climbing culture
-- across different nations, showing how geography and resources shape mountaineering
-- ═══════════════════════════════════════════════════════════════════════════════
