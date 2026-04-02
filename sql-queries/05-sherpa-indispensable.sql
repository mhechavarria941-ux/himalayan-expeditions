USE Final_Project;
GO

SELECT
    SUM(CASE 
        WHEN m.sherpa = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'FALSE' OR m.sherpa IS NULL THEN 1 
        ELSE 0 
    END) AS 'Paying Climber Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'TRUE' AND m.msuccess = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Summits',
    
    SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) AND m.msuccess = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Climber Summits',
    
    SUM(CASE 
        WHEN m.sherpa = 'TRUE' AND m.death = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Deaths',
    
    SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) AND m.death = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Climber Deaths'

FROM members m;
GO

SELECT TOP 20
    p.pkname AS 'Peak Name',
    
    SUM(CASE 
        WHEN m.sherpa = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Guide Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'TRUE' AND m.death = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Guide Deaths',
    
    SUM(CASE 
        WHEN m.sherpa = 'FALSE' OR m.sherpa IS NULL THEN 1 
        ELSE 0 
    END) AS 'Climber Count',
    
    SUM(CASE 
        WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) AND m.death = 'TRUE' THEN 1 
        ELSE 0 
    END) AS 'Climber Deaths'

FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
HAVING SUM(CASE WHEN m.sherpa = 'TRUE' THEN 1 ELSE 0 END) >= 20
    AND SUM(CASE WHEN m.sherpa = 'FALSE' OR m.sherpa IS NULL THEN 1 ELSE 0 END) >= 20
ORDER BY p.pkname;
GO

SELECT 
    p.pkname AS 'Peak Name',
    COUNT(DISTINCT e.expid) AS 'Total Expeditions',
    SUM(CASE WHEN e.success1 = 'TRUE' THEN 1 ELSE 0 END) AS 'Successful Climbs',
    COUNT(DISTINCT e.expid) - SUM(CASE WHEN e.success1 = 'TRUE' THEN 1 ELSE 0 END) AS 'Failed Climbs',
    CAST(SUM(CASE WHEN e.success1 = 'TRUE' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(DISTINCT e.expid) * 100 AS 'Success Rate (%)'
FROM exped e
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
HAVING COUNT(DISTINCT e.expid) >= 5
ORDER BY p.pkname;
GO

SELECT TOP 30
    m.citizen AS 'Country of Origin',
    SUM(CASE WHEN m.sherpa = 'TRUE' THEN 1 ELSE 0 END) AS 'Sherpa Count',
    SUM(CASE WHEN m.sherpa = 'FALSE' OR m.sherpa IS NULL THEN 1 ELSE 0 END) AS 'Climber Count',
    SUM(CASE WHEN m.sherpa = 'TRUE' AND m.msuccess = 'TRUE' THEN 1 ELSE 0 END) AS 'Sherpa Summits',
    SUM(CASE WHEN (m.sherpa = 'FALSE' OR m.sherpa IS NULL) AND m.msuccess = 'TRUE' THEN 1 ELSE 0 END) AS 'Climber Summits'
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY (SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) + SUM(CASE WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 ELSE 0 END)) DESC;
