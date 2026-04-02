USE Final_Project;
GO

SELECT 
    p.pkname AS 'Peak Name',
    COUNT(DISTINCT e.expid) AS 'Total Expeditions',
    SUM(CASE WHEN CAST(e.success1 AS INT) > 0 THEN 1 ELSE 0 END) AS 'Successful Climbs',
    COUNT(DISTINCT e.expid) - SUM(CASE WHEN CAST(e.success1 AS INT) > 0 THEN 1 ELSE 0 END) AS 'Failed Climbs',
    CAST(SUM(CASE WHEN CAST(e.success1 AS INT) > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)'
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
HAVING COUNT(DISTINCT e.expid) >= 5
ORDER BY p.pkname;
