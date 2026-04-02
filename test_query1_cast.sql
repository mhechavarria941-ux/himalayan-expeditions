USE Final_Project;
GO

SELECT TOP 15
    p.pkname,
    p.heightm,
    COUNT(DISTINCT e.expid) AS TotalExpeditions,
    SUM(CAST(e.mdeaths AS INT)) AS TotalDeaths,
    CAST(SUM(CAST(e.mdeaths AS INT)) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathsPerExpedition,
    CAST(COUNT(DISTINCT CASE WHEN e.success1 > 0 THEN e.expid END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS SuccessRate
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname, p.heightm
HAVING SUM(CAST(e.mdeaths AS INT)) >= 5
ORDER BY SUM(CAST(e.mdeaths AS INT)) DESC;
