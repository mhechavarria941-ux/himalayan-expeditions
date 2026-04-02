USE Final_Project;
GO

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
HAVING SUM(e.mdeaths) >= 5
ORDER BY SUM(e.mdeaths) DESC;
