-- ═══════════════════════════════════════════════════════════════════════════════
-- STORYTELLING PHASE: BLOCK 4 - NATIONAL CLIMBING CULTURES
-- ═══════════════════════════════════════════════════════════════════════════════
-- Show how nationality shapes climbing philosophy, style, and outcomes
-- ═══════════════════════════════════════════════════════════════════════════════

USE HimalayanExpeditions;
GO

-- ─────────────────────────────────────────────────────────────────────────────
-- QUERY 12: NATIONAL PARTICIPATION & SUCCESS - TOP CLIMBING NATIONS
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
