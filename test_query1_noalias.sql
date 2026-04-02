USE Final_Project;
GO

SELECT TOP 15
    p.pkname,
    p.heightm,
    COUNT(DISTINCT e.expid) AS TotalExpeditions,
    SUM(e.mdeaths) AS TotalDeaths,
    CAST(SUM(e.mdeaths) AS FLOAT) / COUNT(DISTINCT e.expid) AS DeathsPerExpedition,
    CAST(COUNT(DISTINCT CASE WHEN e.success1 > 0 THEN e.expid END) AS FLOAT) 
        / COUNT(DISTINCT e.expid) * 100 AS SuccessRate
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname, p.heightm
HAVING SUM(e.mdeaths) >= 5
ORDER BY SUM(e.mdeaths) DESC;
