USE Final_Project;
GO

SELECT TOP 20
    p.pkname AS 'Peak Name',
    
    SUM(CASE 
        WHEN m.sherpa = 'T' THEN 1 
        ELSE 0 
    END) AS 'Guide Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'T' AND m.death = 'T' THEN 1 
        ELSE 0 
    END) AS 'Guide Deaths',
    
    SUM(CASE 
        WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 
        ELSE 0 
    END) AS 'Climber Count',
    
    SUM(CASE 
        WHEN (m.sherpa = 'F' OR m.sherpa IS NULL) AND m.death = 'T' THEN 1 
        ELSE 0 
    END) AS 'Climber Deaths'

FROM members m
    INNER JOIN exped e ON m.expid = e.expid
    INNER JOIN peaks p ON e.peakid = p.peakid
GROUP BY p.pkname
HAVING SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) >= 20
    AND SUM(CASE WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 ELSE 0 END) >= 20
ORDER BY p.pkname;
