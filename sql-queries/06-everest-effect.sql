USE Final_Project;
GO

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

SELECT TOP 15
    p.pkname,
    COUNT(DISTINCT e.expid) AS TotalExpeditions
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
ORDER BY COUNT(DISTINCT e.expid) DESC;
GO

SELECT 
    CAST(e.year AS INT) AS Year,
    COUNT(DISTINCT e.expid) AS Expeditions
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
WHERE p.pkname = 'Everest'
GROUP BY CAST(e.year AS INT)
ORDER BY CAST(e.year AS INT);
