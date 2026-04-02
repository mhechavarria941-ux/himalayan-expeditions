USE Final_Project;
GO

-- Query 12
SELECT TOP 20
    m.citizen,
    COUNT(*) AS TotalMembers,
    SUM(CASE WHEN m.msuccess = 'T' THEN 1 ELSE 0 END) AS Summits
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(*) DESC;
GO

-- Query 13
SELECT TOP 20
    m.citizen,
    SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) AS SherpaMembership
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) DESC;
GO

-- Query 14
SELECT TOP 20
    m.citizen,
    COUNT(DISTINCT e.peakid) AS UniquePeaksCovered
FROM members m
    INNER JOIN exped e ON m.expid = e.expid
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(DISTINCT e.peakid) DESC;
GO

-- Query 15
SELECT TOP 20
    m.citizen,
    COUNT(DISTINCT m.expid) AS TotalExpeditions
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY COUNT(DISTINCT m.expid) DESC;
